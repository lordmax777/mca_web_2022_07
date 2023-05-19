export './models/create_shift_type.dart';

import 'package:flutter/foundation.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/job_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/table_views/full_calendar.dart';
import 'package:mca_web_2022_07/utils/global_functions.dart';
import '../../comps/simple_popup_menu.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../theme/theme.dart';
import 'models/job_model.dart';

extension TimeExtenstion on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get endOfWeek => add(Duration(days: 7 - weekday));

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(days: 1));

  operator -(Duration other) {
    return subtract(other);
  }

  operator +(Duration other) {
    return add(other);
  }
}

class SchedulingPage extends StatelessWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: TableWrapperWidget(
        child: SizedBox(
          width: double.infinity,
          height: CalendarConstants.fullHeight(context),
          child: SpacedColumn(
            verticalSpace: 16.0,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                child: PagesTitleWidget(title: "Scheduling"),
              ),
              SizedBox(
                  height: CalendarConstants.tableHeight(context),
                  child: const FullCalendar()),
            ],
          ),
        ),
      ),
    );
  }
}

List<SimplePopupMenu> getPopupAppointmentMenus({
  VoidCallback? onCopy,
  VoidCallback? onCopyAll,
  VoidCallback? onRemove,
  VoidCallback? onEdit,
  VoidCallback? onCreate,
  String? text,
}) {
  final menus = <SimplePopupMenu>[];
  if (onCreate != null) {
    menus.add(SimplePopupMenu(
      label: "Create${text == null ? "" : " $text"}",
      onTap: onCreate,
      icon: HeroIcons.add,
    ));
  }
  if (onEdit != null) {
    menus.add(SimplePopupMenu(
      label: "Edit${text == null ? "" : " $text"}",
      onTap: onEdit,
      icon: HeroIcons.edit,
    ));
  }

  if (onCopy != null) {
    menus.add(SimplePopupMenu(
      label: "Copy${text == null ? "" : " $text"}",
      onTap: onCopy,
      icon: HeroIcons.clipboard,
    ));
  }
  if (onCopyAll != null) {
    menus.add(SimplePopupMenu(
      label: "Copy All${text == null ? "" : " ${text.toPlural}"}",
      onTap: onCopyAll,
      icon: HeroIcons.clipboardTick,
    ));
  }
  if (onRemove != null) {
    menus.add(SimplePopupMenu(
      label: "Remove${text == null ? "" : " $text"}",
      onTap: onRemove,
      icon: HeroIcons.bin,
    ));
  }

  return menus;
}

enum ScheduleCreatePopupMenus {
  jobNew,
  jobUpdate,
  quote;

  String get label {
    switch (this) {
      case ScheduleCreatePopupMenus.jobNew:
      case ScheduleCreatePopupMenus.jobUpdate:
        return Constants.propertyName;
      case ScheduleCreatePopupMenus.quote:
        return "Quote";
      default:
        return "";
    }
  }
}

List<PopupMenuEntry<ScheduleCreatePopupMenus>> getPopupCreateMenus(
    {bool hasEditJob = false}) {
  return [
    if (hasEditJob)
      PopupMenuItem(
        value: ScheduleCreatePopupMenus.jobUpdate,
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8,
          children: [
            const HeroIcon(
              HeroIcons.edit,
              color: ThemeColors.gray2,
              size: 18,
            ),
            Text("Edit ${Constants.propertyName}"),
          ],
        ),
      ),
    PopupMenuItem(
      value: ScheduleCreatePopupMenus.jobNew,
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 8,
        children: [
          const HeroIcon(
            HeroIcons.briefcase,
            color: ThemeColors.gray2,
            size: 18,
          ),
          Text("New ${Constants.propertyName}"),
        ],
      ),
    ),
  ];
}

Widget addIcon(
    {String? tooltip, VoidCallback? onPressed, HeroIcons? icon, Color? color}) {
  return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (color ?? ThemeColors.MAIN_COLOR)
                  .withOpacity(.5), //Colors.grey[300]!,
            ),
          ),
          child: HeroIcon(
            icon ?? HeroIcons.add,
            color: (color ?? ThemeColors.MAIN_COLOR),
          )));
}

Future<ApiResponse?> showFormsMenus(BuildContext context,
    {required Offset globalPosition, required JobModel data}) async {
  //Positions the menu
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  Offset off;
  double left;
  double top;
  double right;
  double bottom;
  off = overlay.globalToLocal(globalPosition);
  left = off.dx;
  top = off.dy;
  right = MediaQuery.of(context).size.width - left;
  bottom = MediaQuery.of(context).size.height - top;

  final bool hasEditJob = data.allocation != null;

  //Shows the menu
  final createTapResult = await showMenu<ScheduleCreatePopupMenus>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: getPopupCreateMenus(hasEditJob: hasEditJob));

  logger(createTapResult, hint: "createTapResult");

  if (createTapResult == null) return null;

  //Shows the form based on the menu selected
  switch (createTapResult) {
    case ScheduleCreatePopupMenus.jobUpdate:
      //Shows the form
      final jobCreated = await showDialog<ApiResponse?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => JobEditForm(data: data));
      return jobCreated;
    case ScheduleCreatePopupMenus.jobNew:
      data.allocation = null;
      //Shows the form
      final jobCreated = await showDialog<ApiResponse?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => JobEditForm(data: data));
      return jobCreated;
    case ScheduleCreatePopupMenus.quote:
      return null;
  }
}
