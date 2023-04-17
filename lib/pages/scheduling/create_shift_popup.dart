import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/shift_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/staff_form.dart';
import '../../../theme/theme.dart';
import '../../manager/model_exporter.dart';

class UnavailableUserLoad {
  bool isLoaded = false;
  List<UnavailableUserMd> _users = [];
  List<UnavailableUserMd> get users => _users;
  set users(List<UnavailableUserMd> users) {
    _users = users;
    isLoaded = true;
  }
}

class CreateShiftData {
  final String type;
  final DateTime date;
  final PropertyMd? property;
  final UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  CreateShiftData({required this.type, required this.date, this.property});
}

Future<T?> showCreateShiftPopup<T>(BuildContext context, CreateShiftData data) {
  return showDialog<T>(
    context: context,
    builder: (_) {
      switch (data.type) {
        case "job":
          return _CreateJob(data);
        default:
          return const Center(child: Text("Invalid type"));
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

class _CreateJob extends StatefulWidget {
  final CreateShiftData data;
  const _CreateJob(this.data, {Key? key}) : super(key: key);

  @override
  State<_CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<_CreateJob>
    with SingleTickerProviderStateMixin {
  CreateShiftData get data => widget.data;
  DateTime get date => data.date;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //GetUnavailableUsersAction
      final unavUsers =
          await appStore.dispatch(GetUnavailableUsersAction(date));
      setState(() {
        widget.data.unavailableUsers.users = unavUsers;
      });
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
                    'Create Job',
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
        return ShiftDetailsForm(state, _shiftDetailsFormKey, data);
      case 1:
        return StaffAndTimingForm(state, _staffTimingFormKey);
      default:
        return const SizedBox();
    }
  }
}
