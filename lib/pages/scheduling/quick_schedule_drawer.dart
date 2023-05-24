import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart' as GET;
import 'package:mca_web_2022_07/comps/autocomplete_input_field.dart';
import 'package:mca_web_2022_07/comps/button_widget.dart';
import 'package:mca_web_2022_07/comps/title_container.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';
import 'package:mca_web_2022_07/theme/colors.dart';
import '../../comps/custom_loading_widget.dart';
import '../../comps/modals/custom_time_picker.dart';
import '../../comps/spaced_column.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/text_style.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/log_tester.dart';
import 'create_shift_popup.dart';
import 'models/allocation_model.dart';
import 'models/timing_model.dart';
import 'popup_forms/team.dart';

enum QuickScheduleDrawerResponse {
  emptyQuote;

  String get message {
    switch (this) {
      case QuickScheduleDrawerResponse.emptyQuote:
        return "No ${Constants.propertyName.capitalize} found.\nPlease add ${Constants.propertyName} first.";
    }
  }
}

class QuickScheduleDrawer extends StatefulWidget {
  JobModel? data;
  QuickScheduleDrawer({Key? key, this.data}) : super(key: key) {
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

  void _publish() async {}
  void _additionalSettings() async {}

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
            showError(QuickScheduleDrawerResponse.emptyQuote.message);
          }
          return;
        }
        if (data.allocation != null || data.quote?.id != null) {
          try {
            setLoading(LoadingHelper.loading, 'Getting details!');
            final quoteRes = await restClient()
                .getQuoteBy(
                  data.quote?.id ?? 0,
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
        List<ListCountry> countries = [...state.generalState.countries];
        List<ListPaymentMethods> paymentMethods = [
          ...state.generalState.paymentMethods
        ];

        return Drawer(
          width: CalendarConstants.quickScheduleDrawerWidth,
          child: stack(
            Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Quick Schedule",
                  // " ${data.allocation?.propertyDetails.toJson()}",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Divider(height: 30, color: Colors.black54, thickness: 2),
                Flexible(
                  child: ListView(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    children: [
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
                    ],
                  ),
                ),
                const Divider(height: 30, color: Colors.black54, thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ButtonLarge(
                          paddingWithoutIcon: true,
                          text: "Publish ${Constants.propertyName.capitalize}",
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
    return SizedBox(
        width: 200,
        child: Tooltip(
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
        ));
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
            title: Text(p0.name),
            subtitle: Text(p0.addressModel.line1),
            style: ListTileStyle.drawer,
          ),
          onSelected: (quote) {
            setState(() {
              data.quote = quote;
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
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Payment Terms:",
                null,
                customLabel: _textField(data.client.payingDays.toString()),
              ),
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Currency:",
                null,
                customLabel: _textField(currencies
                    .firstWhere((element) =>
                        int.parse(data.client.currencyId) == element.id)
                    .title),
              ),
              const Divider(),
              labelWithField(
                  labelWidth: 160,
                  "Payment method:",
                  null,
                  customLabel: _textField(paymentMethods
                      .firstWhereOrNull((element) =>
                          int.tryParse(data.client.paymentMethodId ?? "") ==
                          element.id)
                      ?.name)),
              const Divider(),
              labelWithField(
                labelWidth: 160,
                "Client Notes:",
                null,
                customLabel: _textField(data.client.notes),
              ),
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
    return Container();
  }

  Widget _timing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  CustomSliverPersistentHeaderDelegate(
      {required this.child, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
