import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';

import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';

// Shift details form
class ShiftDetailsForm extends StatefulWidget {
  final AppState state;
  final GlobalKey<FormState> formKey;

  const ShiftDetailsForm(this.state, this.formKey, {Key? key})
      : super(key: key);

  @override
  State<ShiftDetailsForm> createState() => ShiftDetailsFormState();
}

class ShiftDetailsFormState extends State<ShiftDetailsForm> {
  AppState get state => widget.state;

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

  //Ephemeral state
  final List<UserRes> addedChildren = [];

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
        child: Form(
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
                    ),
                  ),
                  labelWithField(
                    "Client",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: clients.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Location",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: locations.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Active",
                    toggle(false, (val) {}),
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
                      onTap: () async {
                        final date = await showCustomDatePicker(context);
                        logger("date: $date");
                      },
                    ),
                  ),
                  labelWithField(
                    "All day",
                    toggle(false, (val) {}),
                  ),
                  labelWithField(
                    "Start Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select start time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
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
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                  labelWithField(
                    "Schedule Later",
                    radio(false, (val) {}),
                  ),
                  labelWithField(
                    "Repeat",
                    radio(false, (val) {}),
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
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Checklist Template",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: checklistTemplates.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Paid Hours",
                    TextInputWidget(
                      width: 300,
                      hintText: "0.00",
                      rightIcon: HeroIcons.dollar,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  labelWithField(
                    "Split Time",
                    toggle(false, (val) {}),
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
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Checklist Template",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: checklistTemplates.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Paid Hours",
                    TextInputWidget(
                      width: 300,
                      hintText: "0.00",
                      rightIcon: HeroIcons.dollar,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  labelWithField(
                    "Split Time",
                    toggle(false, (val) {}),
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
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Checklist Template",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: checklistTemplates.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Paid Hours",
                    TextInputWidget(
                      width: 300,
                      hintText: "0.00",
                      rightIcon: HeroIcons.dollar,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  labelWithField(
                    "Split Time",
                    toggle(false, (val) {}),
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
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Checklist Template",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: checklistTemplates.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  labelWithField(
                    "Paid Hours",
                    TextInputWidget(
                      width: 300,
                      hintText: "0.00",
                      rightIcon: HeroIcons.dollar,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  labelWithField(
                    "Split Time",
                    toggle(false, (val) {}),
                  ),
                ],
              ),
              _team(),
            ],
          ),
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
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final bool isAdded = addedUsers
                              .any((element) => element.id == user.id);
                          return ListTile(
                              onTap: null,
                              leading: CircleAvatar(
                                backgroundColor: user.userRandomBgColor,
                                child: Text(user.first2LettersOfName,
                                    style:
                                        TextStyle(color: user.foregroundColor)),
                              ),
                              title: Text(user.fullname),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isAdded) {
                                      addedChildren.removeWhere(
                                          (element) => element.id == user.id);
                                      addedUsers.removeWhere(
                                          (element) => element.id == user.id);
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
          onPressed: () {
            onAddTeamMember();
          },
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
        width: addedChildren.isEmpty ? 300 : null,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            if (addedChildren.isEmpty)
              TextButton(
                child: const Text("Add team member"),
                onPressed: () {
                  onAddTeamMember();
                },
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
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
