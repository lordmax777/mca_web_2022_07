import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/timing_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../comps/custom_scrollbar.dart';
import '../../../comps/title_container.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../theme/theme.dart';
import '../../scheduling/create_shift_popup.dart';
import '../../scheduling/popup_forms/storage_item_form.dart';
import 'client_form.dart';

class JobEditForm extends StatefulWidget {
  final CreateShiftData data;
  const JobEditForm({Key? key, required this.data}) : super(key: key);

  @override
  State<JobEditForm> createState() => _JobEditFormState();
}

class _JobEditFormState extends State<JobEditForm> {
  //Getters
  late final CreateShiftData data = widget.data;
  bool get isCreate => data.isCreate;
  ScheduleCreatePopupMenus get type => data.type;
  CompanyMd get company => GeneralController.to.companyInfo;
  PlutoGridStateManager get gridStateManager => data.gridStateManager;
  bool get isClientSelected => data.client != null;
  List<UserRes> get addedChildren => data.addedChildren;
  Map<int, double> get addedChildrenRates => data.addedChildrenRates;
  UnavailableUserLoad get unavUsers => data.unavailableUsers;
  CreatedTimingReturnValue get timing => data.timingInfo;

  //Setters
  set addedChildrenRates(Map<int, double> value) =>
      data.addedChildrenRates = value;
  set gridStateManager(PlutoGridStateManager value) =>
      data.gridStateManager = value;
  set addedChildren(List<UserRes> value) => data.addedChildren = value;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
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
                  isCreate ? 'Create ${type.label}' : 'Edit ${type.label}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () {
                    onWillPop(context).then((value) {
                      if (value) {
                        context.popRoute();
                      }
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ButtonLarge(
              text: 'Cancel',
              onPressed: () {
                onWillPop(context).then((value) {
                  if (value) {
                    context.popRoute();
                  }
                });
              }),
          ButtonLarge(text: 'Publish', onPressed: () => _save(state)),
        ],
        content: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                  color: ThemeColors.gray6,
                  width: 2,
                  strokeAlign: StrokeAlign.outside),
            ),
            child: _Form(state)),
      ),
    );
  }

  //Functions
  void _save(AppState state) async {
    //TODO: Save
  }

  void _onCreateNewClient() async {
    final CreatedClientReturnValue? res = await appStore.dispatch(
        OnCreateNewClientTap(context,
            type: ClientFormType.client,
            clientInfo: ClientInfoMd.init(id: data.client?.id)));
    if (res == null) return;
    setState(() {
      if (res.clientId != null) {
        data.client = appStore.state.generalState.clientInfos
            .firstWhereOrNull((element) => element.id == res.clientId);
      }
      if (res.locationId != null) {
        data.tempAllowedLocationId = res.locationId;
        data.selectedLocationId = res.locationId;
        data.location = appStore.state.generalState.locations
            .firstWhereOrNull((element) => element.id == res.locationId);
      }
    });
  }

  void _editInvoiceAddress() async {
    final CreatedClientReturnValue? res = await appStore.dispatch(
        OnCreateNewClientTap(context,
            type: ClientFormType.location,
            clientInfo: ClientInfoMd.init(id: data.client?.id)));
    if (res == null) return;
    setState(() {
      if (res.locationId != null) {
        data.tempAllowedLocationId = res.locationId;
        data.selectedLocationId = res.locationId;
        data.location = appStore.state.generalState.locations
            .firstWhereOrNull((element) => element.id == res.locationId);
      }
    });
  }

  void _editTiming() async {
    timing.hasAltTime = false;
    final CreatedTimingReturnValue? res = await appStore.dispatch(
      OnCreateNewClientTap(context,
          type: ClientFormType.timing, timingInfo: timing),
    );
    if (res == null) return;
    logger(res.repeatDays);
    data.timingInfo = res;
    setState(() {
      data.unavailableUsers.isLoaded = false;
    });
    final unavUsrs =
        await appStore.dispatch(GetUnavailableUsersAction(res.startDate!));
    if (mounted) {
      data.unavailableUsers.users = unavUsrs;
      for (int i = 0; i < data.unavailableUsers.users.length; i++) {
        try {
          final user = addedChildren[i];
          if (data.unavailableUsers.users
              .any((element) => element.userId == user.id)) {
            addedChildren.remove(user);
            addedChildrenRates.remove(user.id);
          }
        } catch (e) {
          logger(e);
        }
      }
      data.unavailableUsers.isLoaded = true;
      setState(() {});
    }
  }

  void onEditTeamMember(List<UserRes> users) {
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
                        filteredUsers.retainWhere((element) => element.fullname
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
                                                        element.id == user.id);
                                                addedUsers.removeWhere(
                                                    (element) =>
                                                        element.id == user.id);
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

//Widget
  Widget _Form(AppState state) {
    List<UserRes> users = [...(state.usersState.usersList.data ?? [])];

    final List<ListWorkRepeats> workRepeats = [
      ...state.generalState.workRepeats
    ];
    List<ListCurrency> currencies = [...state.generalState.currencies];
    List<ListCountry> countries = [...state.generalState.countries];
    List<ListPaymentMethods> paymentMethods = [
      ...state.generalState.paymentMethods
    ];

    String week1 = "* Week 1\n";
    String week2 = "* Week 2\n";
    String week = "";

    for (var day in timing.repeatDays) {
      if (timing.repeatTypeIndex == 2) {
        //Week
        week1 += "${Constants.daysOfTheWeek[day]}\n";
        week2 = "";
      }
      if (timing.repeatTypeIndex == 3) {
        //Fortnightly
        if (day > 7) {
          week2 += "${Constants.daysOfTheWeek[day]}\n";
        } else {
          week1 += "${Constants.daysOfTheWeek[day]}\n";
        }
      }
    }

    // final w1l = week1.split(" ");
    // final w2l = week2.split(" ");
    // week1 = w1l.sorted((a, b) => a.compareTo(b)).join("");
    // week2 = w2l.sorted((a, b) => a.compareTo(b)).join("");

    if (week1 == "* Week 1\n" && week2 == "* Week 2\n") {
      week = "";
    } else {
      week = "$week1\n$week2";
    }

    List<LocationAddress> locations = [];

    // using this we find the locations which can be used by the selected client
    List<ListShift> selectedClientShifts = [];
    if (type == ScheduleCreatePopupMenus.job) {
      if (data.client?.id == null) {
        selectedClientShifts = [];
      }
      selectedClientShifts = [
        ...(state.generalState.shifts
            .where((element) =>
                element.client_id != null &&
                element.client_id == data.client?.id)
            .toList())
      ];

      if (data.client?.id == null) {
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
                element.id == data.tempAllowedLocationId &&
                !locations.contains(element))
            .toList())
      ];
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomScrollbar(
        child: Container(
          padding:
              const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: 64,
            children: [
              SpacedRow(
                horizontalSpace: 32,
                children: [
                  SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 16,
                    children: [
                      TitleContainer(
                        titleOverride: "Create New Client",
                        titleIcon: HeroIcons.add,
                        onEdit: _onCreateNewClient,
                        title: "Personal Information",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutocompleteTextField<ClientInfoMd>(
                                width: 400,
                                height: 50,
                                hintText: "Select Client",
                                listItemWidget: (p0) => Text(p0.name),
                                onSelected: (p0) {
                                  data.client = p0;
                                  data.selectedClientId = p0.id;
                                  data.location = null;
                                  data.tempAllowedLocationId = null;
                                  setState(() {});
                                },
                                displayStringForOption: (option) {
                                  return option.name;
                                },
                                options: (p0) => state.generalState.clientInfos
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(p0.text.toLowerCase()))),
                            const SizedBox(height: 16),
                            SpacedColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelWithField(
                                  labelWidth: 160,
                                  "Name:",
                                  null,
                                  customLabel: _textField(data.client?.name),
                                ),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Company:",
                                  null,
                                  customLabel: _textField(data.client?.company),
                                ),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Email:",
                                  null,
                                  customLabel: _textField(data.client?.email),
                                ),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Phone:",
                                  null,
                                  customLabel: _textField(data.client?.phone),
                                ),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Payment Terms:",
                                  null,
                                  customLabel: _textField(
                                      data.client?.payingDays.toString()),
                                ),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Currency:",
                                  null,
                                  customLabel: _textField(currencies
                                      .firstWhereOrNull((element) =>
                                          int.tryParse(
                                              data.client?.currencyId ?? "") ==
                                          element.id)
                                      ?.sign),
                                ),
                                const Divider(),
                                labelWithField(
                                    labelWidth: 160,
                                    "Payment method:",
                                    null,
                                    customLabel: _textField(paymentMethods
                                        .firstWhereOrNull((element) =>
                                            int.tryParse(
                                                data.client?.paymentMethodId ??
                                                    "") ==
                                            element.id)
                                        ?.name)),
                                const Divider(),
                                labelWithField(
                                  labelWidth: 160,
                                  "Client Notes:",
                                  null,
                                  customLabel: _textField(data.client?.notes),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SpacedColumn(
                    verticalSpace: 16,
                    children: [
                      TitleContainer(
                        onEdit: !isClientSelected ? null : _editInvoiceAddress,
                        titleOverride: "Create New Location",
                        titleIcon: HeroIcons.add,
                        title: "Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isClientSelected)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    isClientSelected
                                        ? ""
                                        : "Select Client First!",
                                    style: ThemeText.bold14,
                                  ),
                                ),
                              ),
                            if (isClientSelected)
                              CustomAutocompleteTextField<LocationAddress>(
                                  width: 400,
                                  height: 50,
                                  hintText: "Select Location",
                                  listItemWidget: (p0) => Text(p0.name ?? ""),
                                  onSelected: (p0) {
                                    setState(() {
                                      data.location = p0;
                                      data.selectedLocationId = p0.id;
                                    });
                                  },
                                  displayStringForOption: (option) {
                                    return option.name ?? "";
                                  },
                                  options: (p0) => locations.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(p0.text.toLowerCase()))),
                            const SizedBox(height: 16),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 1:",
                              null,
                              customLabel:
                                  _textField(data.location?.address?.line1),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 2:",
                              null,
                              customLabel:
                                  _textField(data.location?.address?.line2),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "City:",
                              null,
                              customLabel:
                                  _textField(data.location?.address?.city),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "County:",
                              null,
                              customLabel:
                                  _textField(data.location?.address?.county),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Country:",
                              null,
                              customLabel: _textField(countries
                                  .firstWhereOrNull((element) =>
                                      element.code ==
                                      data.location?.address?.country)
                                  ?.name),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Postcode:",
                              null,
                              customLabel:
                                  _textField(data.location?.address?.country),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TitleContainer(
                    onEdit: _editTiming,
                    title: "Timing",
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithField(
                          labelWidth: 160,
                          "Start Date:",
                          null,
                          customLabel:
                              _textField(timing.startDate?.formattedDate),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Start Time:",
                          null,
                          customLabel:
                              _textField(timing.startTime?.format(context)),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Finish Time:",
                          null,
                          customLabel:
                              _textField(timing.endTime?.format(context)),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Repeat:",
                          null,
                          customLabel: _textField(timing.repeatTypeIndex != null
                              ? workRepeats[timing.repeatTypeIndex!].name
                              : null),
                        ),
                        if (timing.repeatTypeIndex != null &&
                            (timing.repeatTypeIndex != 0 ||
                                timing.repeatTypeIndex != 1))
                          const Divider(),
                        if (timing.repeatTypeIndex != null &&
                            (timing.repeatTypeIndex != 0 ||
                                timing.repeatTypeIndex != 1))
                          labelWithField(
                              labelWidth: 160,
                              "Days:",
                              null,
                              customLabel: _textField(week)),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Active:",
                          null,
                          customLabel:
                              checkbox(data.client?.active ?? false, (p0) {
                            setState(() {
                              data.client?.active = p0;
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  TitleContainer(
                    titleIcon: HeroIcons.add,
                    onEdit: unavUsers.isLoaded
                        ? () {
                            onEditTeamMember(users);
                          }
                        : null,
                    title: "Team",
                    child: _team(users),
                  ),
                ],
              ),
              _products(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _team(List<UserRes> users) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.vertical,
      spacing: 8,
      runSpacing: 8,
      children: [
        if (!unavUsers.isLoaded)
          const Center(child: Text("Please wait loading..."))
        else if (addedChildren.isEmpty)
          TextButton(
            onPressed: () {
              onEditTeamMember(users);
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          constraints: BoxConstraints(
                            maxWidth: 120,
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
    );
  }

  Widget _textField(String? text) {
    return SizedBox(
        width: 200,
        child: Text(
          text == null ? "-" : (text.isEmpty ? "-" : text),
          style: ThemeText.tabTextStyle,
        ));
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

  PlutoRow _buildRow(StorageItemMd contractShiftItem,
      {bool checked = false, int? qty}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: contractShiftItem.id),
        "title": PlutoCell(value: contractShiftItem.name),
        "customer_price": PlutoCell(value: contractShiftItem.outgoingPrice),
        "quantity": PlutoCell(value: qty ?? 1),
        "delete_action": PlutoCell(value: ""),
        "include_in_service": PlutoCell(value: "Included in service"),
      },
    );
  }

  Widget _products(AppState state) {
    return labelWithField(
        labelWidth: 160,
        "Products and services",
        SizedBox(
          width: MediaQuery.of(context).size.width * .95,
          height: 300,
          child: UsersListTable(
              enableEditing: true,
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
        customLabel: Row(
          children: [
            addIcon(
                tooltip: "Create service/product",
                onPressed: () async {
                  final resId = await showDialog<int>(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => StorageItemForm(state: state));
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

  void onTableChangeDone() {
    setState(() {});
  }
}
