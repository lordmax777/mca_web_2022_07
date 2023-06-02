export './models/create_shift_type.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/custom_multi_select_dropdown.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/job_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/table_views/full_calendar.dart';
import 'package:mca_web_2022_07/utils/global_functions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../comps/simple_popup_menu.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/general_state.dart';
import '../../manager/redux/states/schedule_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../theme/theme.dart';
import 'models/job_model.dart';
import 'quick_schedule_drawer.dart';
import 'package:get/get.dart';

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

extension ResourceExt on CalendarResource {
  bool get isUser => id.toString().startsWith("US");
  bool get isPr => id.toString().startsWith("PR");
  bool get isOpen => id.toString().contains("OPEN");

  int? get findId => int.tryParse(id.toString().replaceRange(0, 3, ""));

  Object? findType(List<UserRes> users, List<PropertiesMd> properties) {
    if (isUser) {
      return users.firstWhereOrNull((user) => user.id == findId);
    }
    if (isPr) {
      return properties.firstWhereOrNull((pr) => pr.id == findId);
    }
    return null;
  }
}

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  //Variables
  bool isUserResource = true;
  final List<int> selectedResources = [];
  bool showResourceFilter = true;
  bool showEmptySlots = true;

  //Functions
  void _changeResourceType() {
    setState(() {
      showResourceFilter = false;
    });
    selectedResources.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isUserResource = !isUserResource;
        showResourceFilter = true;
      });
    });
  }

  void showResources(CalendarView view) {
    showResourceFilter = view == CalendarConstants.conf.allowedViews[0] ||
        view == CalendarConstants.conf.allowedViews[1];
    setState(() {});
  }

  void _onAddQuoteTap() async {
    final JobModel data = JobModel(type: ScheduleCreatePopupMenus.quote);
    final quoteCreated = await showDialog<bool>(
      context: context,
      barrierDismissible: kDebugMode,
      builder: (context) => JobEditForm(data: data, showSuccessDialog: false),
    );
    if (quoteCreated == null) return;
    if (quoteCreated) {
      await McaLoading.futureLoading<void>(
          () async => await appStore.dispatch(GetQuotesAction()));
      McaLoading.showSuccess("Quote Created Successfully");
    } else {
      McaLoading.showFail("Quote Creation Failed");
    }
  }

  void onShowResourcesWithAppointment(bool value) {
    showEmptySlots = value;
    setState(() {});
  }

  //Getters
  AppState get appState => StoreProvider.of<AppState>(context).state;
  List<UserRes> get users => [...appState.usersState.users];
  List<PropertiesMd> get properties =>
      [...appState.generalState.allSortedProperties];
  bool get isAllSelected => selectedResources.isEmpty;

  @override
  Widget build(BuildContext context) {
    final List<MultiSelectGroup> items = [
      MultiSelectGroup(items: [
        if (isUserResource)
          for (var user in users)
            MultiSelectItem(
              label: user.fulltitle,
              id: user.id.toString(),
            )
        else
          for (var pr in properties)
            MultiSelectItem(
              label: pr.fulltitle,
              id: pr.id.toString(),
            )
      ], label: isUserResource ? "Users" : "Properties")
    ];

    return PageWrapper(
      child: TableWrapperWidget(
        child: SizedBox(
          width: double.infinity,
          height: CalendarConstants.fullHeight(context),
          child: SpacedColumn(
            verticalSpace: 16.0,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                child: PagesTitleWidget(
                  title: "Scheduling",
                  titleButton: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Visibility(
                      visible: showResourceFilter,
                      child: CustomMultiSelectDropdown(
                        isMultiSelect: true,
                        hasSearchBox: true,
                        width: 300,
                        items: items,
                        onChange: (res) {
                          switch (res.action) {
                            case RetAction.empty:
                              setState(() {
                                selectedResources.clear();
                              });
                              break;
                            case RetAction.add:
                              setState(() {
                                selectedResources.add(users.indexWhere(
                                    (element) =>
                                        element.id == int.parse(res.addId!)));
                                selectedResources.sort();
                              });
                              break;
                            case RetAction.remove:
                              setState(() {
                                selectedResources.remove(users.indexWhere(
                                    (element) =>
                                        element.id ==
                                        int.parse(res.removeId!)));
                              });
                              break;
                          }
                        },
                      ),
                    ),
                  ),
                  onRightBtnClick: _onAddQuoteTap,
                  btnIcon: HeroIcons.plusCircle,
                  buttons: [
                    if (showResourceFilter)
                      GestureDetector(
                        onTap: () {
                          onShowResourcesWithAppointment(!showEmptySlots);
                        },
                        child: SpacedRow(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          horizontalSpace: 8.0,
                          children: [
                            Text(
                              kDebugMode
                                  ? "Show Resources\nwith appointment"
                                  : "Show Empty Slots",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            ToggleCheckboxWidget(
                              onToggle: (checked) {
                                onShowResourcesWithAppointment(checked);
                              },
                              inactiveColor: Colors.grey,
                              value: showEmptySlots,
                              width: 45,
                              height: 25,
                              toggleSize: 15,
                            ),
                          ],
                        ),
                      ),
                    if (showResourceFilter)
                      ButtonMedium(
                        text:
                            "Change to ${isUserResource ? Constants.propertyName.strCapitalize.toPlural : "Users"} View",
                        icon: HeroIcon(
                          isUserResource ? HeroIcons.home : HeroIcons.user,
                          size: 20,
                        ),
                        onPressed: _changeResourceType,
                      ),
                  ],
                  btnText: "Create Quote",
                ),
              ),
              SizedBox(
                  height: CalendarConstants.tableHeight(context),
                  child: FullCalendar(
                    isUserResource: isUserResource,
                    onShowResources: showResources,
                    selectedResources: selectedResources,
                    users: users,
                    properties: properties,
                    showResourcesWithAppointment: !showEmptySlots,
                    onShowResourcesWithAppointment:
                        onShowResourcesWithAppointment,
                  )),
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
  quickSchedule,
  quote,
  delete;

  String get label {
    switch (this) {
      case ScheduleCreatePopupMenus.jobNew:
      case ScheduleCreatePopupMenus.jobUpdate:
        return Constants.propertyName;
      case ScheduleCreatePopupMenus.quote:
        return "Quote";
      case ScheduleCreatePopupMenus.quickSchedule:
        return "Schedule Existing ${Constants.propertyName.strCapitalize}";
      case ScheduleCreatePopupMenus.delete:
        return "Remove ${Constants.propertyName.strCapitalize}";
      default:
        return "";
    }
  }
}

List<PopupMenuEntry<ScheduleCreatePopupMenus>> getPopupCreateMenus(
    {bool hasEditJob = false}) {
  return [
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
          Text("New ${Constants.propertyName.strCapitalize}"),
        ],
      ),
    ),
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
            Text("Edit ${Constants.propertyName.strCapitalize}"),
          ],
        ),
      ),
    // if (hasEditJob)
    PopupMenuItem(
      value: ScheduleCreatePopupMenus.quickSchedule,
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 8,
        children: [
          const HeroIcon(
            HeroIcons.calendar,
            color: ThemeColors.gray2,
            size: 18,
          ),
          Text(ScheduleCreatePopupMenus.quickSchedule.label),
        ],
      ),
    ),
    if (hasEditJob)
      PopupMenuItem(
        value: ScheduleCreatePopupMenus.delete,
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8,
          children: [
            const HeroIcon(
              HeroIcons.bin,
              color: ThemeColors.gray2,
              size: 18,
            ),
            Text(ScheduleCreatePopupMenus.delete.label),
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

Future<bool> showFormsMenus(
  BuildContext context, {
  required Offset globalPosition,
  required JobModel data,
  Future<List<Appointment>?> Function(JobModel? createdjob)? onJobCreateSuccess,
  Future<void> Function()? onJobDeleteSuccess,
}) async {
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

  bool hasEditJob = false;
  if (data.allocation != null) {
    hasEditJob = true;
  }

  if (data.customResource != null) {
    if (data.customResource!.isOpen) {
      hasEditJob = false;
    }
  }

  //Shows the menu
  final createTapResult = await showMenu<ScheduleCreatePopupMenus>(
      context: context,
      elevation: 20,
      semanticLabel: "Create Menu",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: getPopupCreateMenus(hasEditJob: hasEditJob));

  if (createTapResult == null) return false;

  //Shows the form based on the menu selected
  switch (createTapResult) {
    case ScheduleCreatePopupMenus.jobNew:
      data.allocation = null;
      //Shows the form
      final bool? jobCreated = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              JobEditForm(data: data.copyWith(), showSuccessDialog: false));
      return jobCreated ?? false;
    case ScheduleCreatePopupMenus.jobUpdate:
      //Shows the form
      final bool? updatedJob = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => JobEditForm(
              data: data.copyWith(fetchQuote: true), showSuccessDialog: false));
      return updatedJob ?? false;
    case ScheduleCreatePopupMenus.quote:
      return false;
    case ScheduleCreatePopupMenus.quickSchedule:
      openEndDrawer(QuickScheduleDrawer(
          data: data.copyWith(), onJobCreateSuccess: onJobCreateSuccess));
      return false;
    case ScheduleCreatePopupMenus.delete:
      final bool? isDel = await showConfirmationDialog(context);
      if (isDel != null && isDel == true) {
        final ApiResponse? removedRes =
            await McaLoading.futureLoading<ApiResponse?>(() async {
          return await appStore
              .dispatch(SCRemoveAllocationAction(allocation: data.allocation!));
        });
        if (removedRes != null && removedRes.success) {
          onJobDeleteSuccess?.call();
        } else {
          McaLoading.showFail(
              "Failed to remove ${data.allocation?.property.title ?? ""}");
        }
      }
  }
  return false;
}
