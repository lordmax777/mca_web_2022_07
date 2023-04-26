import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';
import 'package:mca_web_2022_07/pages/properties/new_prop_tabs/shift_details_tab.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../comps/custom_gmaps_widget.dart';
import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';
import '../scheduling_page.dart';
import 'client_form.dart';

// Shift details form
class ShiftDetailsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CreateShiftData data;

  const ShiftDetailsForm(this.formKey, this.data, {Key? key}) : super(key: key);

  @override
  State<ShiftDetailsForm> createState() => ShiftDetailsFormState();
}

class ShiftDetailsFormState extends State<ShiftDetailsForm> {
  CreateShiftData get data => widget.data;

  bool get isCreate => data.property == null;

  ScheduleCreatePopupMenus get type => data.type;

  UnavailableUserLoad get unavUsers => data.unavailableUsers;
  CompanyMd get company => GeneralController.to.companyInfo;

  //Ephemeral state
  final TextEditingController title = TextEditingController();
  int? get selectedClientId => data.selectedClientId;
  set selectedClientId(int? id) => data.selectedClientId = id;

  int? get selectedLocationId => data.selectedLocationId;
  set selectedLocationId(int? id) => data.selectedLocationId = id;

  int? get tempAllowedLocationId => data.tempAllowedLocationId;
  set tempAllowedLocationId(int? id) => data.tempAllowedLocationId = id;

  bool get isActive => data.isActive;
  set isActive(bool value) => data.isActive = value;

  DateTime? get startDate => data.startDate;
  set startDate(DateTime? value) => data.startDate = value;

  DateTime? get endDate => data.endDate;
  set endDate(DateTime? value) => data.endDate = value;

  bool get isAllDay => data.isAllDay;
  set isAllDay(bool value) => data.isAllDay = value;

  TimeOfDay? get startTime => data.startTime;
  set startTime(TimeOfDay? value) => data.startTime = value;

  TimeOfDay? get endTime => data.endTime;
  set endTime(TimeOfDay? value) => data.endTime = value;

  int get isScheduleLater => data.isScheduleLater;
  set isScheduleLater(int value) => data.isScheduleLater = value;

  bool get isRepeat => isScheduleLater == 1;

  int? get repeatTypeIndex => data.repeatTypeIndex;
  set repeatTypeIndex(int? value) => data.repeatTypeIndex = value;
  List<int> get repeatDays => data.repeatDays;
  set repeatDays(List<int> value) => data.repeatDays = value;

  // NO NEED !
  int? selectedWarehouseId;
  int? selectedChecklistTemplateId;

  TextEditingController paidHoursHour = TextEditingController(text: "0");
  TextEditingController paidHoursMinute = TextEditingController(text: "0");
  bool get isSplitTime => data.isSplitTime;
  set isSplitTime(bool value) => data.isSplitTime = value;

  List<UserRes> get addedChildren => data.addedChildren;
  set addedChildren(List<UserRes> value) => data.addedChildren = value;
  Map<int, double> get addedChildrenRates => data.addedChildrenRates;
  set addedChildrenRates(Map<int, double> value) =>
      data.addedChildrenRates = value;

  PlutoGridStateManager get gridStateManager => data.gridStateManager;
  set gridStateManager(PlutoGridStateManager value) =>
      data.gridStateManager = value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      title.addListener(() {
        data.title = title.text;
      });
      paidHoursHour.addListener(() {
        data.paidHour = int.tryParse(paidHoursHour.text) ?? 0;
      });
      paidHoursMinute.addListener(() {
        data.paidMinute = int.tryParse(paidHoursMinute.text) ?? 0;
      });
      //TODO: Remove this
      if (kDebugMode) {
        await onClientChanged(0,
            clients: appStore.state.generalState.clientInfos);
      }

      startDate = data.date;
      if (isCreate) return;
      //   final property = data.property!;
      //   await onClientChanged(
      //       appStore.state.generalState.clientInfos
      //           .indexWhere((element) => element.id == property.clientId),
      //       clients: appStore.state.generalState.clientInfos);
      //   title.text = property.title ?? "";
      //   selectedLocationId = property.locationId;
      //   isActive = property.active ?? false;
      //   if (property.startTime != null) {
      //     startTime = property.startTime?.formattedTime;
      //   }
      //   if (property.finishTime != null) {
      //     endTime = property.finishTime?.formattedTime;
      //   }
      //   selectedWarehouseId = property.warehouseId;
      //   // selectedChecklistTemplateId = property.checklistTemplateId;
      //   paidHoursHour.text =
      //       property.minPaidTime?.inHours.toInt().toString() ?? "0";
      //   paidHoursMinute.text =
      //       property.minPaidTime?.inMinutes.toInt().toString() ?? "0";
      //   isSplitTime = property.splitTime ?? false;
    });
  }

  void onCreateNewClientTap(AppState state, ClientFormType type) async {
    final CreatedClientReturnValue? data = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ClientForm(
              state: state,
              type: type,
              selectedClientId: selectedClientId,
            ));
    if (data == null) return;
    setState(() {
      if (data.clientId != null) {
        selectedClientId = data.clientId;
      }
      if (data.locationId != null) {
        tempAllowedLocationId = data.locationId;
        selectedLocationId = data.locationId;
      }
    });
  }

  Future<void> onClientChanged(int index,
      {required List<ClientInfoMd> clients}) async {
    setState(() {
      selectedClientId = clients[index].id;
      selectedLocationId = null;
      tempAllowedLocationId = null;
    });
    if (selectedClientId == null) return;
    // final List<ClientContractMd> contracts = await getClientContracts();
    // gridStateManager.removeAllRows(notify: false);
    // gridStateManager.prependRows(
    //   contracts
    //       .expand((element) => element.shifts)
    //       .expand((element) => element.items)
    //       .map((e) {
    //     return _buildRow(e);
    //   }).toList(),
    // );
  }

  Future<List<ClientContractMd>> getClientContracts() async {
    return await Get.showOverlay<List<ClientContractMd>>(
        asyncFunction: () async {
          final res = await restClient()
              .getClientContracts(selectedClientId!, 0, 0)
              .nocodeErrorHandler();
          if (res.success) {
            final List<ClientContractMd> contracts = [];
            for (var item in res.data!) {
              contracts.add(ClientContractMd.fromJson(item));
            }
            return contracts;
          } else {
            return [];
          }
        },
        loadingWidget: const Center(child: CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<UserRes> users = [...(state.usersState.usersList.data ?? [])];

        List<ClientInfoMd> clients = [...(state.generalState.clientInfos)];

        // using this we find the locations which can be used by the selected client
        List<ListShift> selectedClientShifts = [];
        if (selectedClientId == null) {
          selectedClientShifts = [];
        }
        selectedClientShifts = [
          ...(state.generalState.shifts
              .where((element) =>
                  element.client_id != null &&
                  element.client_id == selectedClientId)
              .toList())
        ];

        List<ListLocation> locations = [];
        if (selectedClientId == null) {
          locations = [];
        }
        if (selectedClientShifts.isEmpty) locations = [];
        locations = [
          ...(state.generalState.locations
              .where((element) => selectedClientShifts
                  .any((shift) => shift.location_id == element.id))
              .toList()),
          //find and add the location which is equal to tempAllowedLocationId
          ...(state.generalState.locations
              .where((element) =>
                  element.id == tempAllowedLocationId &&
                  !locations.contains(element))
              .toList())
        ];

        final List<ListWorkRepeats> workRepeats = [
          ...state.generalState.workRepeats
        ];

        return CustomScrollbar(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
            child: Stack(
              children: [
                Form(
                  key: widget.formKey,
                  child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 48,
                    children: [
                      SpacedRow(
                        horizontalSpace: 64,
                        children: [
                          if (type == ScheduleCreatePopupMenus.job)
                            labelWithField(
                              "Title",
                              TextInputWidget(
                                width: 300,
                                controller: title,
                                hintText: "Enter title",
                              ),
                            ),
                          labelWithField(
                            "Client",
                            DropdownWidgetV2(
                              hasSearchBox: true,
                              hintText: "Select a client",
                              dropdownBtnWidth: 300,
                              dropdownOptionsWidth: 300,
                              items: clients
                                  .map((e) => CustomDropdownValue(name: e.name))
                                  .toList(),
                              value: CustomDropdownValue(
                                  name: clients
                                          .firstWhereOrNull((element) =>
                                              element.id == selectedClientId)
                                          ?.name ??
                                      ""),
                              onChanged: (index) {
                                onClientChanged(index, clients: clients);
                              },
                            ),
                            childHelperWidget: addIcon(
                              tooltip: "Create new client",
                              onPressed: () {
                                onCreateNewClientTap(
                                    state, ClientFormType.client);
                              },
                            ),
                          ),
                          labelWithField(
                            "Location",
                            DropdownWidgetV2(
                              hasSearchBox: true,
                              hintText: "Select a location",
                              tooltipWhileDisabled: "Select a client first",
                              disableAll: selectedClientId == null,
                              dropdownBtnWidth: 300,
                              dropdownOptionsWidth: 300,
                              items: locations
                                  .map((e) => CustomDropdownValue(name: e.name))
                                  .toList(),
                              value: CustomDropdownValue(
                                  name: locations
                                          .firstWhereOrNull((element) =>
                                              element.id == selectedLocationId)
                                          ?.name ??
                                      ""),
                              onChanged: (index) {
                                setState(() {
                                  selectedLocationId = locations[index].id;
                                });
                              },
                            ),
                            childHelperWidget: selectedClientId != null
                                ? Row(
                                    children: [
                                      addIcon(
                                        tooltip: "Create new location",
                                        onPressed: () {
                                          onCreateNewClientTap(
                                              state, ClientFormType.location);
                                        },
                                      ),
                                      if (selectedLocationId != null)
                                        addIcon(
                                          tooltip: "View on map",
                                          onPressed: () {
                                            final loc = state
                                                .generalState.locationAddresses
                                                .firstWhereOrNull((element) =>
                                                    element.id ==
                                                    selectedLocationId);
                                            if (loc == null) return;
                                            showMapPopup(location: loc);
                                          },
                                          icon: HeroIcons.location,
                                        )
                                    ],
                                  )
                                : null,
                          ),
                          labelWithField(
                            "Active",
                            toggle(isActive, (val) {
                              setState(() {
                                isActive = val;
                              });
                            }),
                          ),
                        ],
                      ),
                      SpacedRow(
                        horizontalSpace: 64,
                        children: [
                          labelWithField(
                            "Date",
                            TextInputWidget(
                              width: 300,
                              rightIcon: HeroIcons.calendar,
                              isReadOnly: true,
                              hintText: "Select date",
                              controller: TextEditingController(
                                text: startDate?.formattedDate ?? "",
                              ),
                              onTap: () async {
                                final date =
                                    await showCustomDatePicker(context);
                                //date cannot be before today only if we are creating a new
                                if (isCreate) {
                                  if (date != null &&
                                      date.isBefore(DateTime.now()
                                          .subtract(const Duration(days: 1)))) {
                                    showError("Date cannot be before today");
                                    return;
                                  }
                                }

                                if (date == null) return;

                                setState(() {
                                  startDate = date;
                                });
                              },
                            ),
                          ),
                          labelWithField(
                            "All day",
                            toggle(isAllDay, (val) {
                              setState(() {
                                isAllDay = val;
                                if (isAllDay) {
                                  startTime =
                                      const TimeOfDay(hour: 0, minute: 0);
                                  endTime =
                                      const TimeOfDay(hour: 23, minute: 59);
                                } else {
                                  startTime = null;
                                  endTime = null;
                                }
                              });
                            }),
                          ),
                          labelWithField(
                            "Start Time",
                            TextInputWidget(
                              width: 300,
                              rightIcon: HeroIcons.clock,
                              isReadOnly: true,
                              hintText: "Select start time",
                              controller: TextEditingController(
                                text: startTime?.format(context) ?? "",
                              ),
                              onTap: () async {
                                final res = await showCustomTimePicker(context,
                                    initialTime: startTime);
                                if (res == null) return;
                                setState(() {
                                  startTime = res;
                                  if (endTime ==
                                          const TimeOfDay(
                                              hour: 23, minute: 59) &&
                                      startTime ==
                                          const TimeOfDay(hour: 0, minute: 0)) {
                                    isAllDay = true;
                                  } else {
                                    isAllDay = false;
                                  }
                                });
                              },
                            ),
                          ),
                          labelWithField(
                            "End Time",
                            TextInputWidget(
                              width: 300,
                              rightIcon: HeroIcons.clock,
                              isReadOnly: true,
                              hintText: "Select end time",
                              controller: TextEditingController(
                                text: endTime?.format(context) ?? "",
                              ),
                              onTap: () async {
                                final res = await showCustomTimePicker(context,
                                    initialTime: endTime);
                                if (res == null) return;
                                setState(() {
                                  endTime = res;
                                  if (endTime ==
                                          const TimeOfDay(
                                              hour: 23, minute: 59) &&
                                      startTime ==
                                          const TimeOfDay(hour: 0, minute: 0)) {
                                    isAllDay = true;
                                  } else {
                                    isAllDay = false;
                                  }
                                });
                              },
                            ),
                          ),
                          labelWithField(
                            "Schedule Later",
                            radio(0, isScheduleLater, (val) {
                              setState(() {
                                isScheduleLater = val;
                                repeatTypeIndex = null;
                              });
                            }),
                          ),
                          labelWithField(
                            "Repeat",
                            radio(1, isScheduleLater, (val) {
                              setState(() {
                                isScheduleLater = val;
                                repeatTypeIndex = 0;
                              });
                            }),
                          ),
                        ],
                      ),
                      if (isRepeat)
                        SpacedRow(
                          horizontalSpace: 64,
                          children: [
                            labelWithField(
                              "Repeats",
                              DropdownWidgetV2(
                                hintText: "Select a repeat",
                                dropdownBtnWidth: 300,
                                dropdownOptionsWidth: 300,
                                isRequired: true,
                                items: workRepeats
                                    .map((e) =>
                                        CustomDropdownValue(name: e.name))
                                    .toList(),
                                value: repeatTypeIndex != null
                                    ? CustomDropdownValue(
                                        name:
                                            workRepeats[repeatTypeIndex!].name)
                                    : null,
                                onChanged: (index) {
                                  setState(() {
                                    repeatTypeIndex = index;
                                  });
                                },
                              ),
                            ),
                            if (repeatTypeIndex != null)
                              if (workRepeats[repeatTypeIndex!].id == 3)
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        KText(
                                            text: 'Days ',
                                            textColor: ThemeColors.gray2,
                                            fontSize: 14,
                                            fontWeight: FWeight.bold),
                                        KText(
                                            text: '*',
                                            textColor: ThemeColors.red3,
                                            fontSize: 14,
                                            fontWeight: FWeight.bold),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    for (var item
                                        in Constants.daysOfTheWeek.entries)
                                      chbx(repeatDays.contains(item.key),
                                          (value) {
                                        setState(() {
                                          if (value) {
                                            repeatDays.add(item.key);
                                          } else {
                                            repeatDays.remove(item.key);
                                          }
                                        });
                                      }, item.value),
                                  ],
                                )
                          ],
                        ),
                      SpacedRow(
                        horizontalSpace: 64,
                        children: [
                          labelWithField(
                            "Paid Hours",
                            Row(
                              children: [
                                TextInputWidget(
                                  width: 60,
                                  hintText: "Hour",
                                  labelText: "Hour",
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: true,
                                  ),
                                  controller: paidHoursHour,
                                  inputFormatters: <TextInputFormatter>[
                                    //allow numbers only
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.arrow_drop_up,
                                          size: 18.0,
                                        ),
                                        onTap: () {
                                          if (paidHoursHour.text.isEmpty) {
                                            paidHoursHour.text = "0";
                                          }
                                          int currentValue =
                                              int.parse(paidHoursHour.text);
                                          setState(() {
                                            currentValue++;
                                            paidHoursHour.text = (currentValue)
                                                .toString(); // incrementing value
                                          });
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 18.0,
                                      ),
                                      onTap: () {
                                        if (paidHoursHour.text.isEmpty) return;
                                        int currentValue =
                                            int.parse(paidHoursHour.text);
                                        setState(() {
                                          if (currentValue == 0) return;
                                          currentValue--;
                                          paidHoursHour.text = (currentValue > 0
                                                  ? currentValue
                                                  : 0)
                                              .toString(); // decrementing value
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                TextInputWidget(
                                  width: 70,
                                  labelText: "Minute",
                                  hintText: "Minute",
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  controller: paidHoursMinute,
                                  inputFormatters: <TextInputFormatter>[
                                    //allow numbers only and do not allow any character
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.arrow_drop_up,
                                          size: 18.0,
                                        ),
                                        onTap: () {
                                          if (paidHoursMinute.text.isEmpty) {
                                            paidHoursMinute.text = "0";
                                          }
                                          int currentValue =
                                              int.parse(paidHoursMinute.text);
                                          setState(() {
                                            currentValue++;
                                            paidHoursMinute.text = (currentValue)
                                                .toString(); // incrementing value
                                          });
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 18.0,
                                      ),
                                      onTap: () {
                                        if (paidHoursMinute.text.isEmpty)
                                          return;
                                        int currentValue =
                                            int.parse(paidHoursMinute.text);
                                        setState(() {
                                          if (currentValue == 0) return;
                                          currentValue--;
                                          paidHoursMinute.text = (currentValue >
                                                      0
                                                  ? currentValue
                                                  : 0)
                                              .toString(); // decrementing value
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          labelWithField(
                            "Split Time",
                            toggle(isSplitTime, (val) {
                              setState(() {
                                isSplitTime = val;
                              });
                            }),
                          ),
                        ],
                      ),
                      if (type == ScheduleCreatePopupMenus.job) _team(users),
                      if (selectedClientId != null) _products(state),
                    ],
                  ),
                ),
                if (!unavUsers.isLoaded)
                  Positioned.fill(
                    child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey.withOpacity(.4),
                        child: const CircularProgressIndicator()),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addIcon(
      {String? tooltip,
      VoidCallback? onPressed,
      HeroIcons? icon,
      Color? color}) {
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

  Widget _team(List<UserRes> users) {
    void onAddTeamMember() {
      //Show a dialog which will allow the user to select team members from users list.
      // The content must contain a search box and a list of users.
      showDialog(
        context: context,
        builder: (context) {
          final filteredUsers = [...users];
          final addedUsers = <UserRes>[...addedChildren];
          return StatefulBuilder(builder: (context, ss) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Select team members"),
              content: SizedBox(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) {
                        //Filter the users list based on the search term.
                        if (val.isEmpty) {
                          ss(() {
                            filteredUsers.clear();
                            filteredUsers.addAll(users);
                          });
                          return;
                        }
                        ss(() {
                          filteredUsers.retainWhere((element) => element
                              .fullname
                              .toLowerCase()
                              .contains(val.toLowerCase()));
                        });
                      },
                    ),
                    Expanded(
                      child: filteredUsers.isEmpty
                          ? const Center(child: Text("Not found"))
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                final bool isAdded = addedUsers
                                    .any((element) => element.id == user.id);
                                final UnavailableUserMd? unavUser =
                                    unavUsers.users.firstWhereOrNull(
                                        (element) => element.userId == user.id);
                                final bool isUnavailable = unavUser != null &&
                                    unavUser.userId == user.id;
                                return ListTile(
                                    onTap: null,
                                    leading: CircleAvatar(
                                      backgroundColor: user.userRandomBgColor,
                                      child: Text(user.first2LettersOfName,
                                          style: TextStyle(
                                              color: user.foregroundColor)),
                                    ),
                                    title: Text(user.fullname,
                                        style: TextStyle(
                                            color: isUnavailable
                                                ? Colors.grey
                                                : Colors.black)),
                                    subtitle: isUnavailable
                                        ? Text(
                                            unavUser.unavailable
                                                .map((e) => e.reason)
                                                .join(", "),
                                            style: const TextStyle(
                                                color: Colors.red))
                                        : null,
                                    trailing: isUnavailable
                                        ? const Chip(
                                            label: Text("Unavailable"),
                                            labelStyle:
                                                TextStyle(color: Colors.grey))
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (isAdded) {
                                                  addedChildren.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          user.id);
                                                  addedUsers.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          user.id);
                                                } else {
                                                  addedChildren.add(user);
                                                  addedUsers.add(user);
                                                }
                                                ss(() {});
                                              });
                                            },
                                            icon: isAdded
                                                ? const Icon(Icons.remove,
                                                    color: Colors.red)
                                                : const Icon(Icons.add,
                                                    color: Colors.green),
                                          ));
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    }

    return labelWithField(
      customLabel: addIcon(
          tooltip: "Create team members",
          onPressed: unavUsers.isLoaded
              ? () {
                  onAddTeamMember();
                }
              : null),
      "Team",
      Container(
        width: addedChildren.isEmpty
            ? 200
            : MediaQuery.of(context).size.width * .8,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!unavUsers.isLoaded)
              const Center(child: Text("Please wait loading..."))
            else if (addedChildren.isEmpty)
              TextButton(
                onPressed: () {
                  onAddTeamMember();
                },
                child: const Text("Add team member"),
              ),
            ...addedChildren
                .map(
                  (e) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        addIcon(
                          tooltip:
                              "${addedChildrenRates[e.id] == null ? "Add" : "Remove"} Special Rate",
                          onPressed: () {
                            setState(() {
                              if (addedChildrenRates[e.id] == null) {
                                addedChildrenRates[e.id] = 0;
                              } else {
                                addedChildrenRates.remove(e.id);
                              }
                            });
                          },
                          icon: addedChildrenRates[e.id] == null
                              ? HeroIcons.dollar
                              : HeroIcons.bin,
                        ),
                        if (addedChildrenRates[e.id] != null)
                          TextField(
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              labelText: "Rate",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              constraints: BoxConstraints(
                                maxWidth: 70,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              setState(() {
                                final rate = double.tryParse(value);
                                if (rate == null) return;
                                addedChildrenRates[e.id] = rate;
                              });
                            },
                          ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InputChip(
                            label: Text(e.fullname),
                            labelStyle: TextStyle(color: e.foregroundColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            deleteButtonTooltipMessage: "Remove",
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            deleteIcon: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: e.foregroundColor.withOpacity(.2),
                                border: Border.all(
                                  color: e.foregroundColor.withOpacity(.2),
                                ),
                              ),
                              child: const Icon(Icons.close),
                            ),
                            deleteIconColor: e.foregroundColor,
                            onDeleted: () {
                              setState(() {
                                if (addedChildrenRates[e.id] != null) {
                                  addedChildrenRates.remove(e.id);
                                }
                                addedChildren.remove(e);
                              });
                            },
                            backgroundColor: e.userRandomBgColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  List<PlutoColumn> cols(AppState state) => [
        PlutoColumn(
          title: "",
          field: "id",
          type: PlutoColumnType.text(),
          hide: true,
        ),
        // Items and description - String, ordered - double, rate - double, amount - double, Inc in fixed price - bool => Y/N
        PlutoColumn(
          title: "Title",
          field: "title",
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Customer's price (${company.currency.sign})",
          field: "customer_price",
          enableAutoEditing: true,
          type: PlutoColumnType.currency(),
          footerRenderer: (context) {
            final double total = context.stateManager.rows
                .where((element) => element.checked ?? false)
                .map((e) =>
                    (e.cells["customer_price"]?.value ?? 0) *
                    (e.cells["quantity"]?.value ?? 0))
                .fold(0, (a, b) {
              return a + b;
            });

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      total.getPriceMap().formattedVer,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        PlutoColumn(
          title: "Quantity",
          field: "quantity",
          enableAutoEditing: true,
          type: PlutoColumnType.number(),
        ),
        PlutoColumn(
          title: "Included in service (All)",
          field: "include_in_service",
          enableRowChecked: true,
          enableSorting: false,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "",
          field: "delete_action",
          enableEditingMode: false,
          enableSorting: false,
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return addIcon(
              tooltip: "Delete",
              onPressed: () {
                gridStateManager.removeRows([
                  rendererContext.row,
                ]);
              },
              icon: HeroIcons.bin,
              color: ThemeColors.red3,
            );
          },
        ),
      ];

  PlutoRow _buildRow(StorageItemMd contractShiftItem, {bool checked = false}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: contractShiftItem.id),
        "title": PlutoCell(value: contractShiftItem.name),
        "customer_price": PlutoCell(value: contractShiftItem.outgoingPrice),
        "quantity": PlutoCell(value: 1),
        "delete_action": PlutoCell(value: ""),
        "include_in_service": PlutoCell(value: "Included in service"),
      },
    );
  }

  Widget _products(AppState state) {
    return labelWithField(
        "Products and Services",
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 300,
          child: UsersListTable(
              enableEditing: true,
              onChanged: _handleOnChanged,
              rows: [],
              mode: PlutoGridMode.normal,
              gridBorderColor: Colors.grey[300]!,
              noRowsText: "No product or service added yet",
              onSmReady: (e) {
                gridStateManager = e;
                gridStateManager.addListener(() {
                  onTableChangeDone();
                });
              },
              cols: cols(state)),
        ),
        customLabel: selectedClientId == null
            ? null
            : Row(
                children: [
                  addIcon(
                      tooltip: "Create service/product",
                      onPressed: () async {
                        final resId = await showDialog<int>(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) =>
                                StorageItemForm(state: state));
                        if (resId == null) return;
                        final item = appStore.state.generalState.storage_items
                            .firstWhereOrNull((element) => element.id == resId);
                        if (item == null) return;
                        gridStateManager
                            .insertRows(0, [_buildRow(item, checked: true)]);
                      },
                      icon: HeroIcons.add),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomAutocompleteTextField<StorageItemMd>(
                        listItemWidget: (p0) => Text(p0.name),
                        onSelected: (p0) {
                          gridStateManager
                              .insertRows(0, [_buildRow(p0, checked: true)]);
                        },
                        displayStringForOption: (option) {
                          return option.name;
                        },
                        options: (p0) => state.generalState.storage_items
                            .where((element) => element.name
                                .toLowerCase()
                                .contains(p0.text.toLowerCase()))
                            .toList()),
                  ),
                ],
              ));
  }

  void _handleOnChanged(PlutoGridOnChangedEvent event) async {
    switch (event.column.field) {
      case "title":
        final item = appStore.state.generalState.storage_items.firstWhereOrNull(
            (element) => element.name == event.row.cells["title"]?.value);
        if (item != null) {
          gridStateManager.rows[event.rowIdx].cells["customer_price"]?.value =
              item.outgoingPrice;
        }
        break;
    }
  }

  void onTableChangeDone() {
    setState(() {});
  }
}
