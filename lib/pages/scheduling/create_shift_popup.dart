import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../theme/theme.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/models/storage_item_md.dart';
import '../../utils/global_functions.dart';

Widget labelWithField(String label, Widget? child,
    {Widget? customLabel,
    Widget? childHelperWidget,
    TextStyle? labelStyle,
    double? labelWidth}) {
  return SpacedColumn(
    verticalSpace: 0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SpacedRow(
        horizontalSpace: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: labelStyle ?? ThemeText.md1,
            ),
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

  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.job;

  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: "Shift details"),
    // Tab(text: "Staff & Timing"),
    // Tab(text: "Site details"),
  ];

  final _shiftDetailsFormKey = GlobalKey<FormState>();

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
          // width: MediaQuery.of(context).size.width * 0.95,
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
    final workRepeats = [...state.generalState.workRepeats];
    ApiResponse? quoteCreated = await appStore.dispatch(CreateQuoteAction(
      id: quote.id,
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
      altWorkStartDate: quote.altWorkStartDate,
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
      workStartDate: quote.workStartDate,
      workRepeatId: workRepeats
              .firstWhereOrNull((element) => quote.workRepeat == element.days)
              ?.id ??
          1,
      workStartTime: quote.workStartTime,
      workFinishTime: quote.workFinishTime,
      workDays: quote.workDays,
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
        showError("Quote ${quote.id == 0 ? "created" : "updated"} successfully",
            titleMsg: "Success");
      });
    }
  }

  Widget _getTabChild(AppState state) {
    switch (_tabController.index) {
      default:
        return const SizedBox();
    }
  }
}
