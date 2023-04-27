import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/quote_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/shift_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../theme/theme.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/models/storage_item_md.dart';

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

Future<bool> exit(BuildContext context) {
  return context.popRoute();
}

Future<bool> onWillPop(BuildContext context) async {
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

Widget titleWithDivider(String? title, Widget? child, {Widget? titleIcon}) {
  return SpacedColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (title != null)
      SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 6,
        children: [
          KText(
            text: title,
            fontSize: 24,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.bold,
          ),
          if (titleIcon != null) titleIcon,
        ],
      ),
    if (title != null)
      Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          width: MediaQuery.of(Get.context!).size.width * .22,
          height: 1,
          color: ThemeColors.gray2),
    if (child != null) child,
  ]);
}

Widget labelWithField(String label, Widget? child,
    {Widget? customLabel, Widget? childHelperWidget, TextStyle? labelStyle}) {
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
            style: labelStyle ?? ThemeText.md1,
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
    return StoreConnector<AppState, AppState>(
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
                        context.popRoute();
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
                    context.popRoute();
                  }
                });
              }),
          ButtonLarge(
              text: 'Publish',
              onPressed: () async {
                switch (type) {
                  case ScheduleCreatePopupMenus.job:
                    // TODO: Handle this case.
                    break;
                  case ScheduleCreatePopupMenus.quote:
                    _saveQuote(state);
                    break;
                }
              }),
        ],
      ),
    );
  }

  void _saveQuote(AppState state) async {
    final quote = (data as CreateShiftDataQuote).quote;
    final storageItems = [...state.generalState.storage_items];
    ApiResponse? quoteCreated = await appStore.dispatch(CreateQuoteAction(
      email: quote.email ?? "",
      name: quote.name,
      company: quote.company,
      phone: quote.phone,
      addressLine1: quote.addressLine1,
      addressLine2: quote.addressLine2,
      addressCounty: quote.addressCounty,
      addressCity: quote.addressCity,
      addressCountry: quote.addressCountry,
      addressPostcode: quote.addressPostcode,
      active: quote.active,
      altWorkStartDate: getDateFormat(
          (data as CreateShiftDataQuote).altStartDate,
          dateSeparatorSymbol: "/"),
      currencyId: quote.currencyId,
      payingDays: quote.payingDays,
      paymentMethodId: quote.paymentMethodId,
      quoteComments: (data as CreateShiftDataQuote).quote.quoteComments,
      workAddressLine1: quote.workAddressLine1,
      workAddressLine2: quote.workAddressLine2,
      workAddressCounty: quote.workAddressCounty,
      workAddressCity: quote.workAddressCity,
      workAddressCountry: quote.workAddressCountry,
      workAddressPostcode: quote.workAddressPostcode,
      notes: quote.notes,
      workStartDate: getDateFormat(data.date, dateSeparatorSymbol: "/"),
      workStartTime: data.startTime?.formattedTime,
      workRepeatId: state.generalState.workRepeats[data.repeatTypeIndex!].id,
      workFinishTime: data.endTime?.formattedTime,
      workDays: data.repeatDays,
      storageItems: data.gridStateManager.rows
          .map<StorageItemMd>((row) {
            final item = storageItems.firstWhereOrNull(
                (element) => element.id == row.cells['id']!.value);
            if (item != null) {
              item.quantity = row.cells['quantity']!.value;
              item.outgoingPrice = row.cells['customer_price']!.value;
              item.auto = row.checked ?? false;

              return item;
            }
            return StorageItemMd.init();
          })
          .where((element) => element.id != -1)
          .toList(),
    ));
    if (quoteCreated?.success == true) {
      exit(context).then((value) {
        showError("Quote created successfully", titleMsg: "Success");
      });
    }
  }

  Widget _getTabChild(AppState state) {
    switch (_tabController.index) {
      case 0:
        switch (type) {
          case ScheduleCreatePopupMenus.quote:
            return QuoteForm(
                _shiftDetailsFormKey, data as CreateShiftDataQuote);
          case ScheduleCreatePopupMenus.job:
            return ShiftDetailsForm(
                _shiftDetailsFormKey, data as CreateShiftData);
        }
      default:
        return const SizedBox();
    }
  }
}
