import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart' show Get;
import 'package:mca_web_2022_07/comps/autocomplete_input_field.dart';
import 'package:mca_web_2022_07/comps/title_container.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/guests.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:mca_web_2022_07/utils/global_functions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../comps/modals/custom_date_picker.dart';
import '../../comps/modals/custom_time_picker.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/schedule_state.dart';
import '../../manager/rest/rest_client.dart';
import 'create_shift_popup.dart';
import 'models/allocation_model.dart';
import 'models/timing_model.dart';
import 'popup_forms/job_form.dart';
import 'popup_forms/team.dart';

class QuickScheduleDrawer extends StatefulWidget {
  JobModel? data;
  final Future<List<Appointment>?> Function(JobModel? createdjob)?
      onJobCreateSuccess;

  QuickScheduleDrawer({Key? key, this.data, this.onJobCreateSuccess})
      : super(key: key) {
    data = data ?? JobModel();
  }

  @override
  State<QuickScheduleDrawer> createState() => _QuickScheduleDrawerState();
}

class _QuickScheduleDrawerState extends State<QuickScheduleDrawer>
    with LoadingModel {
  JobModel get data => widget.data!;
  AllocationModel? get allocation => data.allocation;
  TimingModel get timing => data.timingInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //Do after widget is built
    });
  }

  void onTeamMemberAdded(List<UserRes> addedUsers) {
    if (addedUsers.isEmpty) {
      data.addedChildren.clear();
      setState(() {});
      return;
    }
    data.addedChildren.removeWhere((key, value) => !addedUsers.contains(key));
    data.addedChildren.addEntries(addedUsers.map((e) => MapEntry(e, 0)));
    setState(() {});
  }

  void _publish() async {
    McaLoading.futureLoading(() async {
      try {
        final ApiResponse? newJob = await appStore
            .dispatch(CreateJobAction(data, isQuote: data.isQuote));
        await _handleGuests(newJob?.success);
      } catch (e) {
        McaLoading.showFail("Something went wrong");
      }
    });
  }

  void _additionalSettings() async {
    data.isGridInitialized = false;
    final bool? newJob = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => JobEditForm(
              data: data.copyWith(),
              showSuccessDialog: false,
            ));
    McaLoading.futureLoading(() async => await _handleGuests(newJob));
  }

  Future<void> _handleGuests(bool? newJob) async {
    try {
      if (newJob == true) {
        if (widget.onJobCreateSuccess != null) {
          final List<Appointment>? newAddedAppointments =
              await widget.onJobCreateSuccess!(data);
          if (newAddedAppointments != null && newAddedAppointments.isNotEmpty) {
            for (final app in newAddedAppointments) {
              final am = app.id as AllocationModel;
              final pd = data.allocation!.propertyDetails;
              //change property details and guests
              if (pd.minSleeps > 0 && pd.maxSleeps > 0) {
                ApiResponse pdUpdated = await restClient()
                    .updatePropertyDetails(am.shift.id,
                        bedrooms: 1,
                        bathrooms: 1,
                        min_sleeps: pd.minSleeps,
                        max_sleeps: pd.maxSleeps,
                        notes: pd.notes)
                    .nocodeErrorHandler();
                logger(data.allocation!.guests, hint: 'total guests');
                //update guests
                for (int i = 0;
                    i < data.allocation!.guests - pd.minSleeps;
                    i++) {
                  await appStore.dispatch(SCShiftGuestAction(
                    action: AllocationActions.more,
                    locationId: am.location.id,
                    shiftId: am.shift.id,
                    date: am.dateAsDateTime,
                  ));
                }
              }
            }
          }
        }
        exit(context, data).then((value) async {
          McaLoading.showSuccess(
              "${data.type.label.strCapitalize} created successfully");
        });
      }
    } catch (e) {
      exit(context, newJob).then((value) async {
        McaLoading.showFail("Something went wrong");
      });
    }
  }

  final double width = CalendarConstants.quickScheduleDrawerWidth - 32;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInitialBuild: (state) async {
        if (state.generalState.quotes.isEmpty) {
          final List<QuoteInfoMd> quotes =
              await appStore.dispatch(GetQuotesAction());
          if (quotes.isEmpty) {
            if (mounted) {
              await Navigator.maybePop(context);
            }
            showError(
                "No ${Constants.propertyName.strCapitalize} found.\nPlease add ${Constants.propertyName} first.");
          }
          return;
        }
        if (data.allocation != null || data.quote?.id != null) {
          try {
            setLoading(LoadingHelper.loading, 'Getting details!');
            final quoteRes = await restClient()
                .getQuoteBy(
                  0,
                  date: data.dateAsString,
                  location_id: allocation!.location.id,
                  shift_id: allocation!.shift.id,
                )
                .nocodeErrorHandler();
            final propertyDetailsRes = await restClient()
                .getPropertyDetails(allocation!.shift.id)
                .nocodeErrorHandler();
            if (quoteRes.success) {
              setLoading(LoadingHelper.idle);
              if (quoteRes.data['quotes'].isNotEmpty) {
                final q = quoteRes.data['quotes'][0];
                data.quote = QuoteInfoMd.fromJson(q);
                data.quote!.id = 0;
                setState(() {});
                if (propertyDetailsRes.success) {
                  if (propertyDetailsRes.data['details']
                      is Map<String, dynamic>) {
                    data.allocation?.propertyDetails =
                        PropertyDetailsMd.fromJson(
                            propertyDetailsRes.data['details']);
                  }
                }
              }
            } else {
              setLoading(LoadingHelper.error,
                  ApiHelpers.getRawDataErrorMessages(quoteRes));
            }
          } catch (e) {
            setLoading(LoadingHelper.error, e.toString());
          }
        }
      },
      rebuildOnChange: false,
      builder: (context, state) {
        final allJobs = [...state.generalState.allJobs];
        final List<UserRes> users = [...state.usersState.users];
        List<ListCurrency> currencies = [...state.generalState.currencies];
        List<ListPaymentMethods> paymentMethods = [
          ...state.generalState.paymentMethods
        ];
        return Drawer(
          width: CalendarConstants.quickScheduleDrawerWidth,
          child: stack(
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      "Quick Schedule",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 1, color: Colors.black54, thickness: 2),
                Flexible(
                  child: ListView(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    children: [
                      const SizedBox(height: 20),
                      TitleContainer(
                          width: width,
                          title: "Select Job",
                          child: _jobField(
                              allJobs.map((e) => e.quote!).toList(),
                              currencies,
                              paymentMethods)),
                      const Divider(height: 30),
                      TitleContainer(
                        width: width,
                        title: "Select Team",
                        padding: 0,
                        child: _team(users),
                      ),
                      const Divider(height: 30),
                      TitleContainer(
                        width: width,
                        title: "Guests",
                        child: _guests(),
                      ),
                      const Divider(height: 30),
                      TitleContainer(
                        width: width,
                        title: "Timing",
                        child: _timing(),
                      ),
                      // if (!data.isGridInitialized)
                      const Divider(),
                      Visibility(
                        visible: !data.isGridInitialized,
                        child: SizedBox(
                          width:
                              CalendarConstants.quickScheduleDrawerWidth - 50,
                          height: 100,
                          child: UsersListTable(
                              rows: data.isGridInitialized
                                  ? data.gridStateManager.rows
                                  : [],
                              onSmReady: (e) {
                                if (data.isGridInitialized) return;
                                data.gridStateManager = e;
                                data.isGridInitialized = true;
                                setState(() {});
                              },
                              cols: []),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(color: Colors.black54, thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpacedRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    horizontalSpace: 8,
                    children: [
                      Expanded(
                        child: ButtonLarge(
                          paddingWithoutIcon: true,
                          text:
                              "Publish ${Constants.propertyName.strCapitalize}",
                          onPressed: _publish,
                        ),
                      ),
                      Expanded(
                        child: ButtonLargeSecondary(
                          paddingWithoutIcon: true,
                          text: "Additional Settings",
                          onPressed: _additionalSettings,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textField(String? text, {VoidCallback? onTap}) {
    return Tooltip(
      message: onTap == null ? "" : "Edit",
      child: InkWell(
        onTap: onTap,
        child: Text(
          text == null ? "-" : (text.isEmpty ? "-" : text),
          style: ThemeText.tabTextStyle.copyWith(
              color: onTap != null ? Colors.blueAccent : null,
              decoration: onTap != null ? TextDecoration.underline : null),
        ),
      ),
    );
  }

  Widget _jobField(List<QuoteInfoMd> quotes, List<ListCurrency> currencies,
      List<ListPaymentMethods> paymentMethods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAutocompleteTextField<QuoteInfoMd>(
          hintText: "Select a Job",
          height: 50,
          width: double.infinity,
          options: (val) => quotes
              .where((element) =>
                  element.name.toLowerCase().contains(val.text.toLowerCase()) ||
                  element.addressModel.line1
                      .toLowerCase()
                      .contains(val.text.toLowerCase()))
              .toList(),
          initialValue: data.quote != null
              ? TextEditingValue(text: data.quote!.name)
              : null,
          displayStringForOption: (p0) =>
              "${p0.name} (${p0.addressModel.line1})",
          listItemWidget: (p0) => ListTile(
            title: Text("${p0.name} ${p0.createdOn}"),
            subtitle: Text(p0.addressModel.line1),
            style: ListTileStyle.drawer,
          ),
          onSelected: (quote) {
            setState(() {
              data.quote = quote;
              data.quote!.id = 0;
            });
          },
        ),
        if (data.isClientSelected) const SizedBox(height: 16),
        if (data.isClientSelected)
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelWithField(
                labelWidth: 160,
                "Name:",
                null,
                customLabel: _textField(data.client.name),
              ),
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Company:",
                null,
                customLabel: _textField(data.client.company),
              ),
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Email:",
                null,
                customLabel: _textField(data.client.email),
              ),
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Phone:",
                null,
                customLabel: _textField(data.client.phone),
              ),
              // const Divider(),
              // labelWithField(
              //   labelWidth: 160,
              //   "Payment Terms:",
              //   null,
              //   customLabel: _textField(data.client.payingDays.toString()),
              // ),
              // const Divider(),
              // labelWithField(
              //   labelWidth: 160,
              //   "Currency:",
              //   null,
              //   customLabel: _textField(currencies
              //       .firstWhere((element) =>
              //           int.parse(data.client.currencyId) == element.id)
              //       .title),
              // ),
              // const Divider(),
              // labelWithField(
              //     labelWidth: 160,
              //     "Payment method:",
              //     null,
              //     customLabel: _textField(paymentMethods
              //         .firstWhereOrNull((element) =>
              //             int.tryParse(data.client.paymentMethodId ?? "") ==
              //             element.id)
              //         ?.name)),
              // const Divider(),
              // labelWithField(
              //   labelWidth: 160,
              //   "Client Notes:",
              //   null,
              //   customLabel: _textField(data.client.notes),
              // ),
            ],
          ),
      ],
    );
  }

  Widget _team(List<UserRes> users) {
    return JobTeam(
      addedChildren: data.addedChildren,
      date: data.timingInfo.date!,
      onTeamMemberAdded: onTeamMemberAdded,
      onUnavUserFetchComplete: (userId) {
        data.addedChildren.removeWhere((user, _) => user.id == userId);
      },
      users: users,
    );
  }

  Widget _guests() {
    return JobGuests(
      data: data,
      onMinSleepRemoveSuccess: () {
        setState(() {
          data.allocation!.propertyDetails.minSleeps =
              data.allocation!.propertyDetails.minSleeps - 1;
        });
      },
      onMinSleepAddSuccess: () {
        setState(() {
          data.allocation!.propertyDetails.minSleeps =
              data.allocation!.propertyDetails.minSleeps + 1;
        });
      },
      onMaxSleepRemoveSuccess: () {
        setState(() {
          data.allocation!.propertyDetails.maxSleeps =
              data.allocation!.propertyDetails.maxSleeps - 1;
        });
      },
      onMaxSleepAddSuccess: () {
        setState(() {
          data.allocation!.propertyDetails.maxSleeps =
              data.allocation!.propertyDetails.maxSleeps + 1;
        });
      },
      onCurrentRemoveSuccess: (_) {
        setState(() {
          data.allocation!.guests -= 1;
        });
      },
      onCurrentAddSuccess: (_) {
        setState(() {
          data.allocation!.guests += 1;
        });
      },
    );
  }

  Widget _timing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWithField(
          labelWidth: 160,
          "Date:",
          null,
          customLabel: _textField(
            data.timingInfo.date?.formattedDate,
            onTap: () async {
              final date = await showCustomDatePicker(context,
                  initialTime: data.timingInfo.date);
              if (date == null) return;

              setState(() {
                data.timingInfo.date = date;
              });
            },
          ),
        ),
        const Divider(),
        labelWithField(
          labelWidth: 160,
          "Start Time:",
          null,
          customLabel: _textField(
            timing.startTime?.format(context),
            onTap: () async {
              final res = await showCustomTimePicker(context,
                  initialTime: data.timingInfo.startTime);
              if (res == null) return;
              setState(() {
                data.timingInfo.startTime = res;
              });
            },
          ),
        ),
        const Divider(),
        labelWithField(
          labelWidth: 160,
          "Finish Time:",
          null,
          customLabel: _textField(
            timing.endTime?.format(context),
            onTap: () async {
              final res = await showCustomTimePicker(context,
                  initialTime: data.timingInfo.endTime);
              if (res == null) return;
              setState(() {
                data.timingInfo.endTime = res;
              });
            },
          ),
        ),
        // labelWithField(
        //   labelWidth: 160,
        //   "Split Time:",
        //   null,
        //   customLabel: toggle(data.timingInfo., (p0) => null),
        // ),
      ],
    );
  }
}
