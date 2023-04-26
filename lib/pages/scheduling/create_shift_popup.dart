import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/shift_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../theme/theme.dart';
import '../../manager/model_exporter.dart';

Future<T?> showCreateShiftPopup<T>(
    BuildContext context, CreateShiftDataType data) {
  return showDialog<T>(
    context: context,
    barrierDismissible: kDebugMode ? true : false,
    builder: (_) {
      switch (data.type) {
        case ScheduleCreatePopupMenus.job:
        case ScheduleCreatePopupMenus.quote:
          return _CreateJob(data);
        default:
          return const Center(child: Text("Invalid type"));
      }
    },
  );
}

Future<bool> onWillPop(BuildContext context) async {
  if (kDebugMode) return true;
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.popRoute(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => context.popRoute(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

Widget labelWithField(String label, Widget? child,
    {Widget? customLabel, Widget? childHelperWidget}) {
  return SpacedColumn(
    verticalSpace: 0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SpacedRow(
        horizontalSpace: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: ThemeText.md1,
          ),
          if (customLabel != null) customLabel,
        ],
      ),
      if (child != null)
        SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8,
          children: [
            child,
            if (childHelperWidget != null) childHelperWidget,
          ],
        )
    ],
  );
}

Widget toggle(bool value, Function(bool) onToggle) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ToggleCheckboxWidget(
        value: value,
        width: 36.0,
        height: 18.0,
        toggleSize: 16.0,
        padding: 1.0,
        inactiveColor: ThemeColors.gray10,
        onToggle: onToggle),
  );
}

Widget radio(int value, int groupVal, Function(int) onToggle) {
  return Radio(
    value: value,
    groupValue: groupVal,
    onChanged: (int? value) {
      if (value == null) return;
      onToggle(value);
    },
  );
}

Widget checkbox(bool value, Function(bool) onToggle) {
  return CustomCheckboxWidget(
    isChecked: value,
    onChanged: onToggle,
  );
}

class _CreateJob extends StatefulWidget {
  final CreateShiftDataType data;
  const _CreateJob(this.data, {Key? key}) : super(key: key);

  @override
  State<_CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<_CreateJob>
    with SingleTickerProviderStateMixin {
  CreateShiftDataType get data => widget.data;

  DateTime get date => data.date ?? DateTime.now();
  bool get isCreate => data.isCreate;
  ScheduleCreatePopupMenus get type => data.type;

  late final TabController _tabController;

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();

  final List<Tab> _tabs = const [
    Tab(text: "Shift details"),
    // Tab(text: "Staff & Timing"),
    // Tab(text: "Site details"),
  ];

  final _shiftDetailsFormKey = GlobalKey<FormState>();
  final _staffTimingFormKey = GlobalKey<FormState>();
  final _siteDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //GetUnavailableUsersAction
      switch (type) {
        case ScheduleCreatePopupMenus.quote:
          break;
        default:
          final unavUsers =
              await appStore.dispatch(GetUnavailableUsersAction(date));
          if (mounted) {
            setState(() {
              (data as CreateShiftData).unavailableUsers.users = unavUsers;
            });
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isCreate ? 'Create ${type.label}' : 'Edit ${type.label}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () {
                      onWillPop(context).then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              if (type != ScheduleCreatePopupMenus.quote)
                TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  labelColor: ThemeColors.MAIN_COLOR,
                  unselectedLabelColor: ThemeColors.gray7,
                  indicatorColor: ThemeColors.MAIN_COLOR,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: Theme.of(context).textTheme.headlineSmall,
                ),
              const Divider(
                thickness: 1,
                height: 1,
                color: ThemeColors.gray10,
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: _getTabChild(state),
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            ButtonLarge(
                text: 'Cancel',
                onPressed: () {
                  onWillPop(context).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                }),
            ButtonLarge(
                text: 'Publish',
                onPressed: () async {
                  if (type == ScheduleCreatePopupMenus.quote) {
                    final client = state.generalState.clientInfos.firstWhere(
                        (element) => element.id == data.selectedClientId!);
                    final LocationAddress? location =
                        state.generalState.locations.firstWhereOrNull(
                            (element) => element.id == data.selectedLocationId);
                    final storageItems = [...state.generalState.storage_items];
                    ApiResponse? quoteCreated =
                        await appStore.dispatch(CreateQuoteAction(
                      email: client.email ?? "",
                      name: client.name,
                      company: client.company,
                      phone: client.phone,
                      addressLine1: client.address.line1,
                      addressLine2: client.address.line2,
                      addressCounty: client.address.county,
                      addressCity: client.address.city,
                      addressCountry: client.address.country,
                      addressPostcode: client.address.postcode,
                      active: data.isActive,
                      altWorkStartDate: getDateFormat(
                          (data as CreateShiftDataQuote).altStartDate,
                          dateSeparatorSymbol: "/"),
                      currencyId: int.parse(client.currencyId),
                      payingDays: client.payingDays,
                      paymentMethodId: int.parse(client.paymentMethodId!),
                      quoteComments: (data as CreateShiftDataQuote).comments,
                      workAddressCity: location?.address?.city,
                      workAddressCountry: location?.address?.country,
                      workAddressCounty: location?.address?.county,
                      workAddressLine1: location?.address?.line1,
                      workAddressLine2: location?.address?.line2,
                      workAddressPostcode: location?.address?.postcode,
                      notes: client.notes,
                      workStartDate:
                          getDateFormat(data.date, dateSeparatorSymbol: "/"),
                      workStartTime: data.startTime?.formattedTime,
                      workRepeatId: state
                          .generalState.workRepeats[data.repeatTypeIndex!].id,
                      workFinishTime: data.endTime?.formattedTime,
                      workDays: data.repeatDays,
                      storageItems: data.gridStateManager.rows
                          .map((row) {
                            final item = storageItems.firstWhereOrNull(
                                (element) =>
                                    element.id == row.cells['id']!.value);
                            if (item != null) {
                              item.quantity = row.cells['quantity']!.value;
                              item.outgoingPrice =
                                  row.cells['customer_price']!.value;
                              item.auto = row.checked ?? false;

                              return item;
                            }
                            return StorageItemMd.init();
                          })
                          .where((element) => element.id != -1)
                          .toList(),
                    ));
                    if (quoteCreated?.success == true) {
                      await context.popRoute(quoteCreated);
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _getTabChild(AppState state) {
    switch (_tabController.index) {
      case 0:
        return ShiftDetailsForm(_shiftDetailsFormKey, data);
      // case 1:
      //   return StaffAndTimingForm(state, _staffTimingFormKey);
      default:
        return const SizedBox();
    }
  }
}
