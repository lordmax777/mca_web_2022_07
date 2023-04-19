import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';
import '../../../comps/custom_gmaps_widget.dart';
import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';
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

  UnavailableUserLoad get unavUsers => data.unavailableUsers;

  //Ephemeral state
  final TextEditingController title = TextEditingController();
  int? selectedClientId;
  int? selectedLocationId;
  int? tempAllowedLocationId;
  bool isActive = true;

  DateTime? date;
  bool isAllDay = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int isScheduleLater = 0;

  int? selectedWarehouseId;
  int? selectedChecklistTemplateId;
  TextEditingController paidHoursHour = TextEditingController(text: "0");
  TextEditingController paidHoursMinute = TextEditingController(text: "0");
  bool isSplitTime = false;

  final List<UserRes> addedChildren = [];
  final Map<int, double> addedChildrenRates = {};

  late PlutoGridStateManager gridStateManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isCreate) return;
      final property = data.property!;
      await onClientChanged(
          appStore.state.generalState.clients
              .indexWhere((element) => element.id == property.clientId),
          clients: appStore.state.generalState.clients);
      title.text = property.title ?? "";
      // selectedClientId = property.clientId;
      selectedLocationId = property.locationId;
      isActive = property.active ?? false;
      date = data.date;
      //TODO: property.days
      if (property.startTime != null) {
        startTime = property.startTime?.formattedTime;
      }
      if (property.finishTime != null) {
        endTime = property.finishTime?.formattedTime;
      }
      selectedWarehouseId = property.warehouseId;
      // selectedChecklistTemplateId = property.checklistTemplateId;
      paidHoursHour.text =
          property.minPaidTime?.inHours.toInt().toString() ?? "0";
      paidHoursMinute.text =
          property.minPaidTime?.inMinutes.toInt().toString() ?? "0";
      isSplitTime = property.splitTime ?? false;
    });
  }

  void onCreateNewClientTap(AppState state, ClientFormType type) async {
    final CreatedClientReturnValue? data = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ClientForm(
              state: state,
              type: type,
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
      {required List<ListClients> clients}) async {
    setState(() {
      selectedClientId = clients[index].id;
      selectedLocationId = null;
      tempAllowedLocationId = null;
    });
    if (selectedClientId == null) return;
    final List<ClientContractMd> contracts = await getClientContracts();
    gridStateManager.removeAllRows(notify: false);
    gridStateManager.prependRows(
      contracts
          .expand((element) => element.shifts)
          .expand((element) => element.items)
          .map((e) {
        return _buildRow(e);
      }).toList(),
    );
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
        // List<ListStorage> warehouses = [
        //   ...(state.generalState.paramList.data?.storages ?? [])
        // ];
        // List<ListStorageItem> products = [
        //   ...(state.generalState.paramList.data?.storage_items ?? [])
        // ];
        // List<ChecklistTemplateMd> checklistTemplates = [
        //   ...(state.generalState.checklistTemplates.data ?? [])
        // ];
        //
        List<UserRes> users = [...(state.usersState.usersList.data ?? [])];

        List<ListClients> clients = [...(state.generalState.clients)];

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
                                text: date?.formattedDate ?? "",
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
                                  this.date = date;
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
                              });
                            }),
                          ),
                          labelWithField(
                            "Repeat",
                            radio(1, isScheduleLater, (val) {
                              setState(() {
                                isScheduleLater = val;
                              });
                            }),
                          ),
                        ],
                      ),
                      SpacedRow(
                        horizontalSpace: 64,
                        children: [
                          // labelWithField(
                          //   "Warehouse",
                          //   DropdownWidgetV2(
                          //     hasSearchBox: true,
                          //     dropdownBtnWidth: 300,
                          //     dropdownOptionsWidth: 300,
                          //     items: warehouses.map((e) => e.name),
                          //     value: warehouses
                          //         .firstWhereOrNull((element) =>
                          //             element.id == selectedWarehouseId)
                          //         ?.name,
                          //     onChanged: (index) {
                          //       setState(() {
                          //         selectedWarehouseId = warehouses[index].id;
                          //       });
                          //     },
                          //   ),
                          // ),
                          // labelWithField(
                          //   "Checklist Template",
                          //   DropdownWidgetV2(
                          //     hasSearchBox: true,
                          //     dropdownBtnWidth: 300,
                          //     dropdownOptionsWidth: 300,
                          //     items: checklistTemplates.map((e) => e.name),
                          //     value: checklistTemplates
                          //         .firstWhereOrNull((element) =>
                          //             element.id == selectedChecklistTemplateId)
                          //         ?.name,
                          //     onChanged: (index) {
                          //       setState(() {
                          //         selectedChecklistTemplateId =
                          //             checklistTemplates[index].id;
                          //       });
                          //     },
                          //   ),
                          // ),
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
                      _team(users),
                      if (selectedClientId != null) _products(),
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

  Widget addIcon({String? tooltip, VoidCallback? onPressed, HeroIcons? icon}) {
    return IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: HeroIcon(
              icon ?? HeroIcons.add,
              color: ThemeColors.MAIN_COLOR,
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
                                        ? null
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
          tooltip: "Add team members",
          onPressed: unavUsers.isLoaded
              ? () {
                  onAddTeamMember();
                }
              : null),
      "Team",
      Container(
        width: addedChildren.isEmpty ? 200 : null,
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Row(
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
                  (e) => Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(0),
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
                        icon: const HeroIcon(HeroIcons.dollar),
                      ),
                      if (addedChildrenRates[e.id] != null)
                        TextField(
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "Rate",
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
                      InputChip(
                        label: Text(e.fullname),
                        onSelected: (val) {},
                        deleteIcon: const Icon(Icons.remove),
                        labelStyle: TextStyle(color: e.foregroundColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        deleteButtonTooltipMessage: "Remove",
                        deleteIconColor: e.foregroundColor,
                        onDeleted: () {
                          setState(() {
                            addedChildren.remove(e);
                          });
                        },
                        backgroundColor: e.userRandomBgColor,
                      ),
                      if (addedChildren.last != e) const SizedBox(width: 16),
                      if (addedChildren.last != e)
                        Container(
                          width: 1,
                          height: 60,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  final List<PlutoColumn> cols = [
    PlutoColumn(
      title: "",
      field: "id",
      type: PlutoColumnType.text(),
      hide: true,
    ),
    // Items and description - String, ordered - double, rate - double, amount - double, Inc in fixed price - bool => Y/N
    PlutoColumn(
      title: "Items & Description",
      field: "items",
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Ordered",
      field: "ordered",
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Rate",
      field: "rate",
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Amount",
      field: "amount",
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Inc in fixed price",
      field: "inc_in_fixed_price",
      type: PlutoColumnType.text(),
    ),
  ];

  PlutoRow _buildRow(ClientContractShiftItem contractShiftItem) {
    return PlutoRow(
      cells: {
        "id": PlutoCell(value: contractShiftItem.itemId),
        "items": PlutoCell(value: contractShiftItem.itemName),
        "ordered": PlutoCell(value: 0),
        "rate": PlutoCell(value: contractShiftItem.price),
        "amount": PlutoCell(value: contractShiftItem.auto),
        "inc_in_fixed_price": PlutoCell(value: ""),
      },
    );
  }

  Widget _products() {
    return labelWithField(
      "Products and Services",
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 300,
        child: UsersListTable(
            rows: [],
            gridBorderColor: Colors.grey[300]!,
            onSmReady: (e) {
              gridStateManager = e;
            },
            cols: cols),
      ),
    );
  }
}
