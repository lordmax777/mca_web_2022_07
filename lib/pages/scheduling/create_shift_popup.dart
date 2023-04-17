import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/shift_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/staff_form.dart';
import '../../../theme/theme.dart';
import '../../comps/custom_scrollbar.dart';

Future<T?> showCreateShiftPopup<T>(BuildContext context, String type) {
  return showDialog<T>(
    context: context,
    builder: (_) {
      switch (type) {
        case "shift":
          return const _CreateShiftPopup();
        default:
          return const _CreateShiftPopup();
      }
    },
  );
}

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

Widget labelWithField(String label, Widget child, {Widget? customLabel}) {
  return SpacedColumn(
    verticalSpace: 0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: ThemeText.md1,
          ),
          if (customLabel != null) customLabel,
        ],
      ),
      child
    ],
  );
}

Widget toggle(bool value, Function(bool) onToggle) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ToggleCheckboxWidget(
        value: value,
        width: 64.0,
        height: 32.0,
        toggleSize: 26.0,
        padding: 1.0,
        inactiveColor: ThemeColors.gray11,
        onToggle: onToggle),
  );
}

Widget radio(bool value, Function(bool) onToggle) {
  return Radio(
    value: value,
    groupValue: value,
    onChanged: (bool? value) {
      onToggle(value!);
    },
  );
}

class _CreateShiftPopup extends StatefulWidget {
  const _CreateShiftPopup({Key? key}) : super(key: key);

  @override
  State<_CreateShiftPopup> createState() => _CreateShiftPopupState();
}

class _CreateShiftPopupState extends State<_CreateShiftPopup>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();

  final List<Tab> _tabs = const [
    Tab(text: "Shift details"),
    Tab(text: "Staff & Timing"),
    Tab(text: "Site details"),
  ];

  final _shiftDetailsFormKey = GlobalKey<FormState>();
  final _staffTimingFormKey = GlobalKey<FormState>();
  final _siteDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
                    'Create Shift',
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
            const Divider(
              height: 1,
            ),
            ButtonLarge(
                text: 'Cancel',
                onPressed: () {
                  onWillPop(context).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                }),
            ButtonLarge(text: 'Create/Save', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _getTabChild(AppState state) {
    switch (_tabController.index) {
      case 0:
        return ShiftDetailsForm(state, _shiftDetailsFormKey);
      case 1:
        return StaffAndTimingForm(state, _staffTimingFormKey);
      default:
        return SizedBox();
    }
  }
}
