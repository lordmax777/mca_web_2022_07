import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/calendar_constants.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/quick_shift_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_helper.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleState extends Equatable {
  //Create singleton
  static final ScheduleState _singleton = ScheduleState._internal();
  factory ScheduleState() => _singleton;
  ScheduleState._internal();

  final ValueNotifier<bool> isUserResource = ValueNotifier<bool>(true);
  final ValueNotifier<List<DefaultMenuItem>> selectedResources =
      ValueNotifier<List<DefaultMenuItem>>([]);
  final ValueNotifier<bool> showEmptySlots = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showResourceFilter = ValueNotifier<bool>(true);
  final ValueNotifier<CalendarView> calendarView =
      ValueNotifier<CalendarView>(CalendarView.timelineWeek);

  final ValueNotifier<ShiftData?> copyValue = ValueNotifier<ShiftData?>(null);

  void changeResourceType([bool? isUser]) {
    showResourceFilter.value = false;
    selectedResources.value = [];
    // Future.delayed(const Duration(milliseconds: 100), () {s
    isUserResource.value = isUser ?? !isUserResource.value;
    showResourceFilter.value = true;
    // });
  }

  @override
  List<Object> get props => [
        isUserResource.value,
        selectedResources.value,
        showEmptySlots.value,
        showResourceFilter.value,
      ];

  void dispose() {
    isUserResource.value = true;
    selectedResources.value = [];
    showEmptySlots.value = false;
    showResourceFilter.value = true;
    copyValue.value = null;
    calendarView.value = CalendarView.timelineWeek;
  }
}

class SchedulingView extends StatelessWidget {
  const SchedulingView({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = StoreProvider.of<AppState>(context).state;
    return SizedBox(
      width: double.infinity,
      // height: double.infinity,
      child: SpacedColumn(
        verticalSpace: 16.0,
        children: [
          _Header(),
          _Table(appState: appState),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ScheduleState state = ScheduleState();
  final DependencyManager _dependencyManager = DependencyManager();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        onInit: (store) async {
          bool fetchUsers = store.state.generalState.users.isEmpty;
          bool fetchProperties = store.state.generalState.properties.isEmpty;

          await Future.wait([
            if (fetchUsers)
              appStore.dispatch(const GetPropertiesAction()) as Future,
            if (fetchProperties)
              appStore.dispatch(const GetUsersAction()) as Future,
          ]);
        },
        builder: (context, vm) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Select Users dropdown
                //Select Property dropdown
                ValueListenableBuilder<bool>(
                  valueListenable: state.showResourceFilter,
                  builder: (context, showResource, child) {
                    return ValueListenableBuilder<List<DefaultMenuItem>>(
                      valueListenable: state.selectedResources,
                      builder: (context, addedItems, child) {
                        List<UserMd> users = [...vm.users];
                        List<PropertyMd> properties = [...vm.properties];
                        const all = DefaultMenuItem(id: -1, title: "All");
                        final List<DefaultMenuItem> items = [
                          if (state.isUserResource.value)
                            for (var user in users)
                              DefaultMenuItem(
                                id: user.id,
                                title: user.fullname,
                              )
                          else
                            for (var pr in properties)
                              DefaultMenuItem(
                                id: pr.id,
                                title: pr.fulltitle,
                                subtitle: pr.locationName,
                              )
                        ];
                        bool isAllSelected =
                            state.selectedResources.value.isEmpty;
                        return Visibility(
                          visible: showResource,
                          child: DefaultDropdown(
                            items: items
                              ..sort((a, b) => a.title.compareTo(b.title))
                              ..insert(0, all),
                            hasSearchBox: true,
                            label:
                                'Selected ${isAllSelected ? "All" : state.selectedResources.value.length} ${state.isUserResource.value ? "Users" : "Properties"}',
                            width: 300,
                            height: 70,
                            onChanged: (value) {
                              if (value.id == -1) {
                                state.selectedResources.value = [];
                                return;
                              }
                              if (state.selectedResources.value
                                  .contains(value)) {
                                state.selectedResources.value = [
                                  ...state.selectedResources.value
                                    ..remove(value)
                                ];
                                return;
                              }
                              state.selectedResources.value = [
                                ...state.selectedResources.value,
                                value
                              ];
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                //Show/Hide Empty Slots switch
                SpacedRow(
                  horizontalSpace: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: state.showEmptySlots,
                      builder: (context, value, child) {
                        return DefaultSwitch(
                            label: "Hide Empty Slots",
                            value: !value,
                            activeIcon: Icons.check,
                            onChanged: (value) {
                              state.showEmptySlots.value = !value;
                            });
                      },
                    ),
                    //Change resource type button,
                    ValueListenableBuilder<bool>(
                        valueListenable: state.isUserResource,
                        builder: (context, value, child) {
                          return DefaultSwitch(
                              label:
                                  "Resource Type: ${value ? "user" : appStore.state.generalState.propertyName}",
                              value: value,
                              activeIcon: Icons.person,
                              inactiveIcon: Icons.home,
                              onChanged: (value) {
                                state.changeResourceType(value);
                              });
                        }),
                    //Create quote button
                    ElevatedButton(
                      onPressed: () {
                        _dependencyManager.navigation.showCustomDialog(
                            context: context,
                            builder: (context) {
                              return DefaultDialog(
                                  builder: (context) {
                                    return CreateSchedulePopup(
                                      shiftData: ShiftData.init(isQuote: true),
                                    );
                                  },
                                  title: "Create Quote");
                            });
                      },
                      child: const Text("Create Quote"),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _Table extends StatefulWidget {
  final AppState appState;
  const _Table({required this.appState});

  @override
  State<_Table> createState() => _TableState();
}

class _TableState extends State<_Table> {
  final DependencyManager _dependencyManager = DependencyManager();
  late final AppointmentDataSource _events;
  final GlobalKey _globalKey = GlobalKey();
  final CalendarConf conf = CalendarConstants.conf;
  final CalendarController _calendarController = CalendarController();
  final ScheduleState state = ScheduleState();

  List<UserMd> get users => [...appState.generalState.users];
  List<PropertyMd> get properties => [...appState.generalState.properties];
  List<AllocationMd> get allocations => [...appState.generalState.allocations];

  AppState get appState => widget.appState;
  // bool get isDay => conf.isDay(_calendarController.view!);
  // bool get isWeek => conf.isWeek(_calendarController.view!);
  // bool get isMonth => conf.isMonth(_calendarController.view!);
  // bool get isSchedule => conf.isSchedule(_calendarController.view!);
  bool get isEmptyShift => _events.lastFetchedAppointments.isEmpty;
  //Functions
  @override
  void initState() {
    _calendarController.view = state.calendarView.value;
    _events = AppointmentDataSource(<Appointment>[], handleShowEmptySlots);
    _events.resources = [
      ...conf.resources(state.isUserResource.value, users, properties)
    ];
    // handleShowEmptySlots(state.showEmptySlots.value);

    _calendarController.addPropertyChangedListener((e) {
      if (e == 'calendarView') {
        _events.clearAppointments();
        state.calendarView.value = _calendarController.view!;
      }
      if (e == 'displayDate') {
        logger('DISPLAY DATE CHANGED');
      }
    });

    state.showEmptySlots.addListener(() {
      // Get show empty slots value
      bool showEmptySlots = state.showEmptySlots.value;
      handleShowEmptySlots(showEmptySlots);
    });

    state.isUserResource.addListener(() {
      // Get the resource type
      bool isUserResource = state.isUserResource.value;
      //Clear the resources and add the new ones from conf.resources
      _events.resources = [
        ...conf.resources(isUserResource, users, properties)
      ];
      handleShowEmptySlots(state.showEmptySlots.value);
      updateUI();
    });

    state.copyValue.addListener(() {
      debugPrint('COPY MODE CHANGED ${state.copyValue.value}');
      updateUI();
    });

    state.selectedResources.addListener(() {
      // Get the resource type
      bool isUserResource = state.isUserResource.value;
      // Get the selected resources
      List<DefaultMenuItem> selectedResources = state.selectedResources.value;
      final us = <UserMd>[];
      final ps = <PropertyMd>[];
      if (selectedResources.isNotEmpty) {
        if (isUserResource) {
          for (var item in selectedResources) {
            final user =
                users.firstWhereOrNull((element) => element.id == item.id);
            if (user != null) {
              us.add(user);
            }
          }
        } else {
          for (var item in selectedResources) {
            final property =
                properties.firstWhereOrNull((element) => element.id == item.id);
            if (property != null) {
              ps.add(property);
            }
          }
        }
      } else {
        if (isUserResource) {
          us.addAll(users);
        } else {
          ps.addAll(properties);
        }
      }
      //Update the _event.resources
      _events.resources = [...conf.resources(isUserResource, us, ps)];
      updateUI();
    });
    super.initState();
  }

  @override
  void dispose() {
    state.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void updateUI([VoidCallback? callback]) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        setState(() => callback?.call());
      }
    });
  }

  /// Handle the view changed and it used to update the UI on web platform
  /// whether the calendar view changed from month view or to month view.
  void _onViewChanged() {
    state.calendarView.value = _calendarController.view!;
    if (_calendarController.view! == CalendarView.day) {
      state.changeResourceType(true);
    }
    updateUI();
  }

  void handleShowEmptySlots(bool showEmptySlots) {
    if (showEmptySlots) {
      _events.resources = [
        ...conf.resources(state.isUserResource.value, users, properties)
      ];
    } else {
      final resourcesNotToRemove = _events.getResourcesWithAppointment();
      _events.resources!
        ..clear()
        ..addAll(
            [...conf.resources(state.isUserResource.value, users, properties)])
        ..removeWhere((resource1) =>
            !resourcesNotToRemove.any((element) => element == resource1.id));
      // _events.resources!.insert(0, CalendarConstants.openCalendarResource);
    }
    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
      data: ThemeData.light(),

      /// The key set here to maintain the state,
      ///  when we change the parent of the widget
      key: _globalKey,
      child: _getLoadMoreCalendar(
        _calendarController,
        (viewChangedDetails) => _onViewChanged(),
        _events,
      ),
    );

    return SizedBox(
      height: CalendarConstants.tableHeight(context),
      child: Stack(
        children: [
          calendar,
          if (isEmptyShift)
            const Align(alignment: Alignment.center, child: _Empty()),
          if (state.copyValue.value != null)
            _Copy(onExitCopyMode: () {
              state.copyValue.value = null;
            }),
        ],
      ),
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getLoadMoreCalendar(
      [CalendarController? calendarController,
      ViewChangedCallback? viewChangedCallback,
      CalendarDataSource? calendarDataSource]) {
    return SfCalendar(
      showDatePickerButton: true,
      showNavigationArrow: true,
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: conf.allowedViews,
      onViewChanged: viewChangedCallback,
      viewNavigationMode: ViewNavigationMode.none,
      timeSlotViewSettings:
          conf.getTimeSlotSettings(_calendarController.view!, context),
      todayHighlightColor: context.colorScheme.primary,
      viewHeaderHeight: conf.getViewHeaderHeight(_calendarController.view!),
      showCurrentTimeIndicator: false,
      firstDayOfWeek: 1,
      backgroundColor: state.copyValue.value != null
          ? Colors.blueAccent.withOpacity(.2)
          : null,
      resourceViewHeaderBuilder: (ctx, details) =>
          conf.resourceViewHeaderBuilder(ctx, details, users, properties),
      loadMoreWidgetBuilder:
          (BuildContext context, LoadMoreCallback loadMoreAppointments) {
        return FutureBuilder<void>(
          future: loadMoreAppointments(),
          builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
            return const SizedBox();
          },
        );
      },
      monthViewSettings: conf.getMonthViewSettings(),
      allowDragAndDrop: false,
      resourceViewSettings: conf.getResourceViewSettings(context),
      onTap: (calendarTapDetails, position) {
        switch (calendarTapDetails.targetElement) {
          case CalendarElement.calendarCell:
            debugPrint('calendarCell');
            _handleCalendarCellTap(calendarTapDetails, position);
            break;
          case CalendarElement.appointment:
            debugPrint('appointment');
            _handleAppointmentTap(calendarTapDetails, position);
            break;
          case CalendarElement.moreAppointmentRegion:
            debugPrint('moreAppointmentRegion');
            _handleMoreAppointmentRegionTap(calendarTapDetails, position);
            break;
          default:
            break;
        }
      },
    );
  }

  Future<CalendarTapMenus?> showCalendarTapMenus(Offset position,
      {bool isNew = true, bool isDelete = false}) async {
    final tappedMenuType = await showColumnMenu<CalendarTapMenus>(
        position: position,
        context: context,
        items: [
          const PopupMenuItem(
            value: CalendarTapMenus.add,
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 4),
                Text('Add Shift', softWrap: false),
              ],
            ),
          ),
          if (!isNew)
            const PopupMenuItem(
              value: CalendarTapMenus.edit,
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 4),
                  Text('Edit Shift', softWrap: false),
                ],
              ),
            ),
          if (!isNew && isDelete)
            const PopupMenuItem(
              value: CalendarTapMenus.delete,
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 4),
                  Text('Delete Shift', softWrap: false),
                ],
              ),
            ),
          if (!isNew)
            const PopupMenuItem(
              value: CalendarTapMenus.copy,
              child: Row(
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 4),
                  Text('Copy Shift', softWrap: false),
                ],
              ),
            ),
          const PopupMenuItem(
              value: CalendarTapMenus.quickAdd,
              child: Row(
                children: [
                  Icon(Icons.add_box_outlined),
                  SizedBox(width: 4),
                  Text('Quick Add Shift', softWrap: false),
                ],
              )),
        ]);
    return tappedMenuType;
  }

  ///CELL TAP
  void _handleCalendarCellTap(
      CalendarTapDetails details, Offset? position) async {
    final DateTime? date = details.date;
    UserMd? resource;
    PropertyMd? property;
    final resourceId = details.resource?.id.toString().substring(3);

    if (resourceId != null) {
      final int? resourceIdInt = int.tryParse(resourceId);
      if (resourceIdInt != null) {
        final user =
            users.firstWhereOrNull((element) => element.id == resourceIdInt);
        final pr = properties
            .firstWhereOrNull((element) => element.id == resourceIdInt);
        if (user != null) {
          resource = user;
        }
        if (pr != null) {
          property = pr;
        }
      }
    }

    if (state.copyValue.value != null) {
      _pasteAppointment(resourceId, details.date);
      return;
    }

    //Show list of available menus
    final tappedMenuType = await showCalendarTapMenus(position!);
    bool success = false;
    switch (tappedMenuType) {
      case CalendarTapMenus.add:
        success = await _dependencyManager.navigation.showCustomDialog<bool>(
                context: context,
                builder: (context) {
                  return DefaultDialog(
                      builder: (context) {
                        return CreateSchedulePopup(
                          shiftData: ShiftData.init(
                            teamData: TeamData(
                                users: [if (resource != null) resource]),
                            timeData: TimeData.init().copyWith(start: date),
                          ),
                        );
                      },
                      title: "Add Shift");
                }) ??
            false;
        break;
      case CalendarTapMenus.quickAdd:
        //Opens a drawer
        success = await showGeneralDialog<bool>(
                context: context,
                barrierLabel: 'Quick Add Shift',
                barrierDismissible: true,
                transitionBuilder: (ctx, a1, a2, child) {
                  //build a transition that slides from left to right
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: const Offset(0, 0),
                    ).animate(a1),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return QuickShiftPopup(
                    shiftData: ShiftData.init(
                      personalData: property != null
                          ? PersonalData().copyFromProperty(property,
                              paymentMethods:
                                  appState.generalState.lists.paymentMethods,
                              clients: appState.generalState.clients,
                              currencies:
                                  appState.generalState.lists.currencies,
                              shifts: appState.generalState.lists.shifts,
                              invoicePeriods:
                                  appState.generalState.lists.invoicePeriods)
                          : null,
                      addressData: property != null
                          ? AddressData().copyFromProperty(property,
                              locations: appState.generalState.locations,
                              shifts: appState.generalState.lists.shifts,
                              countries: appState.generalState.lists.countries)
                          : null,
                      teamData:
                          TeamData(users: [if (resource != null) resource]),
                      timeData: TimeData.init().copyWith(
                        start: date,
                        repeat: appStore
                            .state.generalState.lists.workRepeats.firstOrNull,
                      ),
                    ),
                  );
                }) ??
            false;
        break;
      default:
        break;
    }
    if (success == true) {
      _events.clearAndReloadMore();
    }
  }

  /// APPOINTMENT TAP
  void _handleAppointmentTap(
      CalendarTapDetails details, Offset? position) async {
    final generalState = appStore.state.generalState;
    final DateTime? date = details.date;
    UserMd? resource;
    final resourceId = details.resource?.id.toString().substring(3);
    if (resourceId != null) {
      final int? resourceIdInt = int.tryParse(resourceId);
      if (resourceIdInt != null) {
        final user =
            users.firstWhereOrNull((element) => element.id == resourceIdInt);
        if (user != null) {
          resource = user;
        }
      }
    }

    int? currentGuestsNumber;

    final allocation = generalState.allocations.firstWhereOrNull(
        (element) => element.id == details.appointments?.first?.id);
    if (allocation != null) {
      currentGuestsNumber = allocation.guests;
    }
    ShiftData data = ShiftData.init(
      isCreate: false,
      timeData: TimeData.init(withAltStartDate: false).copyWith(
          start: date,
          repeat: appStore.state.generalState.lists.workRepeats.firstOrNull),
      personalData: PersonalData(shiftId: allocation?.shiftId),
      addressData: AddressData(locationId: allocation?.locationId),
      guestData: GuestData(current: currentGuestsNumber ?? 0),
      teamData: TeamData(users: [if (resource != null) resource]),
    );

    if (state.copyValue.value != null) {
      _pasteAppointment(resourceId, details.date);
      return;
    }

    final tappedMenuType = await showCalendarTapMenus(position!,
        isNew: allocation == null, isDelete: resource != null);
    bool success = false;
    switch (tappedMenuType) {
      case CalendarTapMenus.edit:
        success = await _handleAppointmentEdit(data);
      case CalendarTapMenus.quickAdd:
        success = await _handleAppointmentQuickAdd(allocation, data, date);
        break;
      case CalendarTapMenus.delete:
        success = await _handleAppointmentDelete(
            data, details.appointments?.firstOrNull, resource);
        break;
      case CalendarTapMenus.copy:
        success = await _handleAppointmentCopy(data);
        break;
      default:
        break;
    }
    if (success == true) {
      _events.clearAndReloadMore();
    }
  }

  void _handleMoreAppointmentRegionTap(
      CalendarTapDetails details, Offset? position) async {
    if (position == null) return;
    logger(details.appointments?.length);
    final list = details.appointments ?? [];

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    Offset off;
    double left;
    double top;
    double right;
    double bottom;
    off = overlay.globalToLocal(position);
    left = off.dx;
    top = off.dy;
    right = MediaQuery.of(context).size.width - left;
    bottom = MediaQuery.of(context).size.height - top;
    final rect = RelativeRect.fromLTRB(left, top, right, bottom);

    final items = list
        .map((e) => PopupMenuItem(
              value: e,
              enabled: false,
              child: MaterialButton(
                onPressed: () {
                  final selectedAppointments = [
                    ...(details.appointments ?? [])
                  ];
                  selectedAppointments
                      .removeWhere((element) => element.id != e.id);
                  logger(selectedAppointments.firstOrNull);
                  if (selectedAppointments.firstOrNull == null) return;
                  final newDetails = CalendarTapDetails(selectedAppointments,
                      details.date, details.targetElement, details.resource);
                  final newPosition = Offset(position.dx, position.dy - 100);
                  _handleAppointmentTap(
                    newDetails,
                    newPosition,
                  );
                },
                child: Text(
                  e.subject ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ))
        .toList();
    showMenu(context: context, position: rect, items: items);
  }

  Future<bool> _handleAppointmentQuickAdd(
      AllocationMd? allocation, ShiftData data, DateTime? date) async {
    final generalState = appStore.state.generalState;

    ClientMd? client;
    LocationMd? location;
    PropertyMd? property;

    if (allocation != null) {
      client = generalState.clients
          .firstWhereOrNull((element) => element.id == allocation.clientId);
      location = generalState.locations
          .firstWhereOrNull((element) => element.id == allocation.locationId);
      property = generalState.properties
          .firstWhereOrNull((element) => element.id == allocation.shiftId);
    }

    if (client != null) {
      data = data.copyWith(
        personalData: data.personalData
            .copyWith(shiftId: property?.id)
            .copyFromClient(client,
                currencies: generalState.lists.currencies,
                paymentMethods: generalState.lists.paymentMethods,
                invoicePeriods: generalState.lists.invoicePeriods),
      );
    }

    if (location != null) {
      data = data.copyWith(
        addressData: data.addressData
            .copyFromAddress(location.address,
                countries: generalState.lists.countries)
            .copyWith(locationId: location.id),
      );
    }

    if (property != null) {
      data = data.copyWith(
        timeData: data.timeData.copyWith(
          start: date,
          startTime: property.startTimeOfDay,
          endTime: property.finishTimeOfDay,
          active: property.active,
          repeat: generalState.lists.workRepeats.firstOrNull,
        ),
      );
    }
    //Opens a drawer
    return await showGeneralDialog<bool>(
            context: context,
            barrierLabel: 'Quick Add Shift',
            barrierDismissible: true,
            transitionBuilder: (ctx, a1, a2, child) {
              //build a transition that slides from left to right
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                ).animate(a1),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                QuickShiftPopup(shiftData: data)) ??
        false;
  }

  Future<bool> _handleAppointmentEdit(ShiftData data) async {
    return await _dependencyManager.navigation.showCustomDialog<bool>(
            context: context,
            builder: (context) {
              return DefaultDialog(
                  builder: (context) {
                    return CreateSchedulePopup(shiftData: data);
                  },
                  title: "Edit Shift");
            }) ??
        false;
  }

  Future<bool> _handleAppointmentDelete(
      ShiftData data, Appointment? appointment, UserMd? resource) async {
    await context.futureLoading<void>(() async {
      final success = await dispatch<bool>(PostAllocationAction(
          shiftId: data.personalData.shiftId,
          userId: resource?.id,
          locationId: data.addressData.locationId,
          date: data.timeData.start!,
          action: AllocationPostType.remove));

      if (success.isLeft && success.left) {
        _events.removeAppointment(appointment);
      }
      if (success.isRight) {
        context.showError(success.right.message);
      }
    });
    return false;
  }

  Future<bool> _handleAppointmentCopy(ShiftData data) async {
    state.copyValue.value = data;
    return false;
  }

  Future<void> _pasteAppointment(
      String? resourceId, DateTime? targetDate) async {
    debugPrint("PASTE");

    final DateTime fromDate = state.copyValue.value!.timeData.start!;

    int? targetShiftId;
    int? targetUserId;

    // if (resourceId == null || targetDate == null) {
    //   context.showError("Resource or date is not found");
    //   state.copyValue.value = null;
    //   return;
    // }

    if (state.isUserResource.value) {
      targetUserId = resourceId == null ? null : int.tryParse(resourceId);
    } else {
      targetShiftId = resourceId == null ? null : int.tryParse(resourceId);
    }

    // if (targetUserId == null && targetShiftId == null) {
    //   context.showError("Something went wrong");
    //   state.copyValue.value = null;
    //   return;
    // }

    //0. Check if the copying date is after the current date
    if (targetDate?.isBefore(fromDate) == true) {
      context.showError(
          "Cannot copy to a date before the current date.\nPlease select a date after ${fromDate.toApiDateWithDash}");
      return;
    }

    //Steps to do
    //1. Use PostAllocationAction to copy using action with AllocationPostType.copy
    await context.futureLoading(() async {
      final success = await dispatch<bool>(PostAllocationAction(
        shiftId: state.copyValue.value?.personalData.shiftId,
        userId: state.copyValue.value?.teamData.users.firstOrNull?.id,
        locationId: state.copyValue.value?.addressData.locationId,
        date: state.copyValue.value!.timeData.start!,
        action: AllocationPostType.copy,
        target_user: targetUserId,
        target_shift: targetShiftId,
        target_date: targetDate,
      ));
      //2. If success, reload events and close copy mode
      if (success.isLeft && success.left) {
        await _events.loadMore();
        state.copyValue.value = null;
        BotToast.showText(text: 'Shift copied successfully');
        return;
      }
      //3. If error, show error and close copy mode
      if (success.isRight) {
        context.showError(success.right.message);
        state.copyValue.value = null;
      }
    });
  }
}

class _Empty extends StatelessWidget {
  const _Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Text('No shifts found\nfor selected date',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white))),
    );
  }
}

class _Copy extends StatelessWidget {
  final VoidCallback onExitCopyMode;
  const _Copy({Key? key, required this.onExitCopyMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: FloatingActionButton.extended(
        onPressed: () {
          //Exit copy mode
          onExitCopyMode();
        },
        icon: const Icon(Icons.close),
        label: const Text("Exit copy mode"),
      ),
    );
  }
}
