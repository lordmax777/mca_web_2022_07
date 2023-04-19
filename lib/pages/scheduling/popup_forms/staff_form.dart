// Staff & Timing Form
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';

class StaffAndTimingForm extends StatefulWidget {
  final AppState appState;
  final GlobalKey<FormState> formKey;

  const StaffAndTimingForm(this.appState, this.formKey, {Key? key})
      : super(key: key);

  @override
  State<StaffAndTimingForm> createState() => StaffAndTimingFormState();
}

class StaffAndTimingFormState extends State<StaffAndTimingForm> {
  AppState get state => widget.appState;

  List<ListGroup> get departments =>
      state.generalState.paramList.data?.groups ?? [];
  List<ListQualification> get qualifications =>
      state.generalState.paramList.data?.qualifications ?? [];
  List<ListQualificationLevel> get qualificationLevels =>
      state.generalState.paramList.data?.qualification_levels ?? [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SpacedRow(
        horizontalSpace: MediaQuery.of(context).size.width * 0.05,
        children: [
          // SpacedColumn(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   verticalSpace: MediaQuery.of(context).size.height * 0.05,
          //   children: [
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * 0.05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Start Break Time",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //         labelWithField(
          //           "End Break Time",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * 0.05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Strict Break Time",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //         labelWithField(
          //           "Earliest Start Time",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * 0.05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Auto Logout Finish Time",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //         labelWithField(
          //           "Break Not Available After",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.clock,
          //             isReadOnly: true,
          //             hintText: "Select time",
          //             onTap: () async {
          //               final res = await showCustomTimePicker(context);
          //               logger("date: $res");
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * 0.05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Special Rate",
          //           TextInputWidget(
          //             width: 300,
          //             rightIcon: HeroIcons.pound,
          //             hintText: "Enter Amount",
          //           ),
          //         ),
          //         labelWithField(
          //           "Department",
          //           DropdownWidgetV2(
          //             dropdownBtnWidth: 300,
          //             dropdownOptionsWidth: 300,
          //             items: departments.map((e) => e.name),
          //             onChanged: (value) {},
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // SpacedColumn(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   verticalSpace: MediaQuery.of(context).size.height * 0.05,
          //   children: [
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * .05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Number of Staff",
          //           TextInputWidget(
          //             width: 300,
          //             keyboardType: TextInputType.number,
          //           ),
          //         ),
          //         labelWithField(
          //           "Maximum Staff",
          //           TextInputWidget(
          //             width: 300,
          //             keyboardType: TextInputType.number,
          //           ),
          //         ),
          //       ],
          //     ),
          //     SpacedRow(
          //       horizontalSpace: MediaQuery.of(context).size.width * .05,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         labelWithField(
          //           "Qualification",
          //           DropdownWidgetV2(
          //             hasSearchBox: true,
          //             dropdownBtnWidth: 300,
          //             dropdownOptionsWidth: 300,
          //             items: qualifications.map((e) => e.title),
          //             onChanged: (index) {},
          //           ),
          //         ),
          //         labelWithField(
          //           "Min Level",
          //           DropdownWidgetV2(
          //             hasSearchBox: true,
          //             dropdownBtnWidth: 300,
          //             dropdownOptionsWidth: 300,
          //             items: qualificationLevels.map((e) => e.level),
          //             onChanged: (index) {},
          //           ),
          //         ),
          // ],
          // ),
          // ],
          // ),
        ],
      ),
    );
  }
}
