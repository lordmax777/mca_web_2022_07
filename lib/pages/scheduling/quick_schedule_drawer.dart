import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart' show FirstWhereExt, Get;
import 'package:mca_web_2022_07/comps/autocomplete_input_field.dart';
import 'package:mca_web_2022_07/comps/custom_multi_select_dropdown.dart';
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
import 'widgets/storage_items_dropdown.dart';

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
  //Vars
  final double width = CalendarConstants.quickScheduleDrawerWidth - 32;

  //Getters
  JobModel get data => widget.data!;
  AllocationModel? get allocation => data.allocation;
  TimingModel get timing => data.timingInfo;
  DateTime? get startDate => timing.date;
  int get clientId => data.client.id;
  int? get shiftId => data.shiftId;

  //Functions

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

  Future<void> handleProducts(List<StorageItemMd> storageItems) async {
    //Handle errors
    if (!data.isClientSelected) {
      //TODO: show error
      return;
    }
    if (!data.client.isClientTrue) {
      //TODO: show error
      return;
    }
    if (data.shiftId == null) {
      //TODO: show error
      return;
    }
    data.gridStateManager.removeAllRows(notify: false);
    data.gridStateManager.setShowLoading(true);
    //Handle products
    final List<ClientContractItem> products = await appStore.dispatch(
        GetClientContractItemsAction(
            clientId: clientId, shiftId: shiftId!, date: startDate));
    if (products.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        final item = products[i];
        final storageItem = storageItems
            .firstWhereOrNull((element) => element.id == item.itemId);
        data.gridStateManager.insertRows(
            i,
            [
              data.buildStorageRow(
                StorageItemMd(
                  id: item.itemId,
                  active: storageItem == null ? false : storageItem.active,
                  name: item.itemName,
                  service: storageItem == null ? false : storageItem.service,
                  outgoingPrice: item.price,
                  incomingPrice: 0,
                  taxId: 1,
                ),
                qty: item.amount.toInt(),
                checked: item.auto,
              )
            ],
            notify: true);
      }
    }
    data.gridStateManager.setShowLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInitialBuild: (state) async {
        if (data.allocation != null) {
          try {
            setLoading(LoadingHelper.loading, 'Getting details!');

            //Handle guest information
            final propertyDetailsRes = await restClient()
                .getPropertyDetails(allocation!.shift.id)
                .nocodeErrorHandler();

            if (propertyDetailsRes.success) {
              if (propertyDetailsRes.data['details'] is Map<String, dynamic>) {
                data.allocation?.propertyDetails = PropertyDetailsMd.fromJson(
                    propertyDetailsRes.data['details']);
              }
            }
            data.allocation = allocation;
            data.setClient(allocation!.shift.client);
            handleProducts(state.generalState.storage_items);
            setLoading(LoadingHelper.idle);
          } catch (e) {
            setLoading(LoadingHelper.error, e.toString());
          }
        }
      },
      rebuildOnChange: false,
      builder: (context, state) {
        final allJobs = [...state.generalState.shifts]
            .where((element) => element.active)
            .toList();
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
                          child: _jobField(allJobs.map((e) => e).toList(),
                              currencies, paymentMethods, state)),
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
                        child: _timing(state),
                      ),
                      // if (!data.isGridInitialized)
                      const Divider(),
                      // if (data.isGridInitialized)
                      //   StorageItemsDropdown(
                      //       data: data.copyWith(),
                      //       state: state,
                      //       onChanged: (rows) {
                      //         data.gridStateManager
                      //             .removeAllRows(notify: false);
                      //         data.gridStateManager.insertRows(0, rows);
                      //       }),
                      TitleContainer(
                        width: width,
                        padding: 0,
                        title: "Products",
                        child: _products(state),
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
                          onPressed: shiftId == null ||
                                  !data.isClientSelected ||
                                  !data.isGridInitialized
                              ? null
                              : data.gridStateManager.rows.isEmpty
                                  ? null
                                  : _publish,
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

  Widget _products(AppState state) {
    return SizedBox(
      width: CalendarConstants.quickScheduleDrawerWidth - 50,
      height: 300,
      child: UsersListTable(
        enableEditing: true,
        rows: data.isGridInitialized ? data.gridStateManager.rows : [],
        mode: PlutoGridMode.normal,
        gridBorderColor: Colors.grey[300]!,
        noRowsText: "No product or service",
        onSmReady: (e) async {
          if (data.isGridInitialized) return;
          data.gridStateManager = e;
          data.isGridInitialized = true;
          data.gridStateManager.addListener(() {
            setState(() {});
          });
          //Handle products
          handleProducts(state.generalState.storage_items);
        },
        cols: data.cols(state, showAutoColumn: false),
      ),
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

  Widget _jobField(List<ListShift> shifts, List<ListCurrency> currencies,
      List<ListPaymentMethods> paymentMethods, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomMultiSelectDropdown(
          width: double.infinity,
          hasSearchBox: true,
          initiallySelected: shiftId != null
              ? [
                  MultiSelectItem(
                      label: data.allocation!.shift.name,
                      id: shiftId!.toString())
                ]
              : null,
          items: [
            MultiSelectGroup(
              items: [
                for (final shift in shifts)
                  MultiSelectItem(
                    label: shift.name,
                    id: shift.id.toString(),
                    extraInfo: shift.client?.name,
                  ),
              ],
            )
          ],
          onChange: (res) {
            switch (res.action) {
              case RetAction.empty:
                // TODO: Handle this case.
                break;
              case RetAction.single:
                final id = int.parse(res.addId!);
                final shift =
                    shifts.firstWhereOrNull((element) => element.id == id);
                if (shift == null) return;
                setState(() {
                  data.allocation = AllocationModel(
                    date: data.dateAsString ?? "",
                    id: 0,
                    shift: shift,
                    guests: 0,
                    published: false,
                  );
                  data.setClient(shift.client);
                  handleProducts(state.generalState.storage_items);
                });
                break;
              default:
                break;
            }
          },
        ),
        // CustomAutocompleteTextField<QuoteInfoMd>(
        //   hintText: "Select a Job",
        //   height: 50,
        //   width: double.infinity,
        //   options: (val) => shifts
        //       .where((element) =>
        //           element.name.toLowerCase().contains(val.text.toLowerCase()) ||
        //           element.addressModel.line1
        //               .toLowerCase()
        //               .contains(val.text.toLowerCase()))
        //       .toList(),
        //   initialValue: data.quote != null
        //       ? TextEditingValue(text: data.quote!.name)
        //       : null,
        //   displayStringForOption: (p0) =>
        //       "${p0.name} (${p0.addressModel.line1})",
        //   listItemWidget: (p0) => ListTile(
        //     title: Text("${p0.name} ${p0.createdOn}"),
        //     subtitle: Text(p0.addressModel.line1),
        //     style: ListTileStyle.drawer,
        //   ),
        //   onSelected: (quote) {
        //     setState(() {
        //       data.quote = quote;
        //       data.quote!.id = 0;
        //     });
        //   },
        // ),
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

  Widget _timing(AppState state) {
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
                //Handle products
                handleProducts(state.generalState.storage_items);
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
