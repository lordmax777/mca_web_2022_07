import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';
import 'package:redux/redux.dart';

import '../../comps/modals/custom_time_picker.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class QuickScheduleDrawer extends StatefulWidget {
  JobModel? data;
  QuickScheduleDrawer({Key? key, this.data}) : super(key: key) {
    data = data ?? JobModel();
  }

  @override
  State<QuickScheduleDrawer> createState() => _QuickScheduleDrawerState();
}

class _QuickScheduleDrawerState extends State<QuickScheduleDrawer> {
  JobModel get data => widget.data!;

  @override
  void initState() {
    // if (appStore.state.generalState.quotes.isEmpty) {

    // }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await appStore.dispatch(GetQuotesAction());
      //appStore.dispatch(GetQuotesAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    // return StoreConnector<AppState, AppState>(
    //   converter: (store) => store.state,
    //   onInit: (viewModel) {
    //     appStore.dispatch(GetQuotesAction());
    //   },
    //   rebuildOnChange: false,
    //   builder: (context, state) {
    // final allJobs = state.scheduleState.getWeekShifts;
    // logger('allJobs: ${allJobs.length}');
    return Drawer(
      width: CalendarConstants.quickScheduleDrawerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quick Schedule"),
          Flexible(
            child: ListView(
              children: [
                _date(),
              ],
            ),
          ),
        ],
      ),
      // );
      //   },
    );
  }

  Widget _date() {
    return TextInputWidget(
      rightIcon: HeroIcons.clock,
      isReadOnly: true,
      hintText: "Select start time",
      controller: TextEditingController(
          // text: returnVal.startTime?.format(context) ?? "",
          ),
      onTap: () async {
        final res = await showCustomTimePicker(
          context,
          // initialTime: returnVal.startTime
        );
        // if (res == null) return;
        // setState(() {
        //   returnVal.startTime = res;
        // });
      },
    );
  }
}
