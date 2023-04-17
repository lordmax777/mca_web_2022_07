import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';

// Shift details form
class ShiftDetailsForm extends StatefulWidget {
  final AppState state;
  final GlobalKey<FormState> formKey;
  final CreateShiftData data;

  const ShiftDetailsForm(this.state, this.formKey, this.data, {Key? key})
      : super(key: key);

  @override
  State<ShiftDetailsForm> createState() => ShiftDetailsFormState();
}

class ShiftDetailsFormState extends State<ShiftDetailsForm> {
  AppState get state => widget.state;
  CreateShiftData get data => widget.data;
  bool get isCreate => data.property == null;

  List<ListClients> get clients =>
      state.generalState.paramList.data?.clients ?? [];
  List<ListLocation> get locations =>
      state.generalState.paramList.data?.locations ?? [];
  List<ListStorage> get warehouses =>
      state.generalState.paramList.data?.storages ?? [];
  List<ListStorageItem> get products =>
      state.generalState.paramList.data?.storage_items ?? [];
  List<ChecklistTemplateMd> get checklistTemplates =>
      state.generalState.checklistTemplates.data ?? [];
  List<UserRes> get users => state.usersState.usersList.data ?? [];
  UnavailableUserLoad get unavUsers => data.unavailableUsers;

  //Ephemeral state
  final TextEditingController title = TextEditingController();
  int? selectedClientId;
  int? selectedLocationId;
  bool isActive = false;

  DateTime? date;
  bool isAllDay = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int isScheduleLater = 0;

  int? selectedWarehouseId;
  int? selectedChecklistTemplateId;
  TextEditingController paidHours = TextEditingController(text: "0");
  bool isSplitTime = false;

  final List<UserRes> addedChildren = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isCreate) return;
      final property = data.property!;
      logger(property.toJson(), hint: "property");
      title.text = property.title ?? "";
      selectedClientId = property.clientId;
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
      paidHours.text = property.minPaidTime?.toString() ?? "0";
      isSplitTime = property.splitTime ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        ),
                      ),
                      labelWithField(
                        "Client",
                        DropdownWidgetV2(
                          hasSearchBox: true,
                          dropdownBtnWidth: 300,
                          dropdownOptionsWidth: 300,
                          items: clients.map((e) => e.name),
                          value: clients
                              .firstWhereOrNull(
                                  (element) => element.id == selectedClientId)
                              ?.name,
                          onChanged: (index) {
                            setState(() {
                              selectedClientId = clients[index].id;
                            });
                          },
                        ),
                      ),
                      labelWithField(
                        "Location",
                        DropdownWidgetV2(
                          hasSearchBox: true,
                          dropdownBtnWidth: 300,
                          dropdownOptionsWidth: 300,
                          items: locations.map((e) => e.name),
                          value: locations
                              .firstWhereOrNull(
                                  (element) => element.id == selectedLocationId)
                              ?.name,
                          onChanged: (index) {
                            setState(() {
                              selectedLocationId = locations[index].id;
                            });
                          },
                        ),
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
                            final date = await showCustomDatePicker(context);
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
                            final res = await showCustomTimePicker(context);
                            if (res == null) return;
                            setState(() {
                              startTime = res;
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
                            final res = await showCustomTimePicker(context);
                            if (res == null) return;
                            setState(() {
                              endTime = res;
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
                      labelWithField(
                        "Warehouse",
                        DropdownWidgetV2(
                          hasSearchBox: true,
                          dropdownBtnWidth: 300,
                          dropdownOptionsWidth: 300,
                          items: warehouses.map((e) => e.name),
                          value: warehouses
                              .firstWhereOrNull((element) =>
                                  element.id == selectedWarehouseId)
                              ?.name,
                          onChanged: (index) {
                            setState(() {
                              selectedWarehouseId = warehouses[index].id;
                            });
                          },
                        ),
                      ),
                      labelWithField(
                        "Checklist Template",
                        DropdownWidgetV2(
                          hasSearchBox: true,
                          dropdownBtnWidth: 300,
                          dropdownOptionsWidth: 300,
                          items: checklistTemplates.map((e) => e.name),
                          value: checklistTemplates
                              .firstWhereOrNull((element) =>
                                  element.id == selectedChecklistTemplateId)
                              ?.name,
                          onChanged: (index) {
                            setState(() {
                              selectedChecklistTemplateId =
                                  checklistTemplates[index].id;
                            });
                          },
                        ),
                      ),
                      labelWithField(
                        "Paid Hours",
                        TextInputWidget(
                          width: 300,
                          hintText: "0.00",
                          rightIcon: HeroIcons.dollar,
                          keyboardType: TextInputType.number,
                          controller: paidHours,
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
                  _team(),
                  _products(),
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
  }

  Widget _team() {
    void onAddTeamMember() {
      //Show a dialog which will allow the user to select a team member from users list.
      // The content must contain a search box and a list of users.
      showDialog(
        context: context,
        builder: (context) {
          final filteredUsers = [...users];
          final addedUsers = <UserRes>[...addedChildren];
          return StatefulBuilder(builder: (context, ss) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Select a team member"),
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
                                final bool isUnavailable = unavUsers.users.any(
                                    (element) => element.userId == user.id);
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
                                        ? const Text("Unavailable",
                                            style: TextStyle(color: Colors.red))
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
      customLabel: IconButton(
          tooltip: "Add team member",
          onPressed: unavUsers.isLoaded
              ? () {
                  onAddTeamMember();
                }
              : null,
          icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: const HeroIcon(HeroIcons.add))),
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
                        onPressed: () {
                          setState(() {
                            addedChildren.remove(e);
                          });
                        },
                        icon: const Icon(Icons.remove, color: Colors.red),
                      ),
                      Text(e.fullname),
                      if (addedChildren.last != e) const SizedBox(width: 10),
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

  PlutoRow _buildRow() {
    return PlutoRow(
      cells: {
        "items": PlutoCell(value: ""),
        "ordered": PlutoCell(value: 0),
        "rate": PlutoCell(value: 0),
        "amount": PlutoCell(value: 0),
        "inc_in_fixed_price": PlutoCell(value: ""),
      },
    );
  }

  Widget _products() {
    return labelWithField(
      "Products and Services",
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        child: UsersListTable(rows: [
          ...List.generate(10, (index) => _buildRow()),
        ], onSmReady: (e) {}, cols: cols),
      ),
    );
  }
}
