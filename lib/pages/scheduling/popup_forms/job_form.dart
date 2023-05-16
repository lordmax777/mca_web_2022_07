import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/timing_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/timing_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../comps/custom_scrollbar.dart';
import '../../../comps/title_container.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../../utils/global_functions.dart';
import '../../scheduling/create_shift_popup.dart';
import '../models/job_model.dart';
import 'client_form.dart';

class JobEditForm extends StatefulWidget {
  final JobModel data;

  const JobEditForm({Key? key, required this.data}) : super(key: key);

  @override
  State<JobEditForm> createState() => _JobEditFormState();
}

class _JobEditFormState extends State<JobEditForm>
    with SingleTickerProviderStateMixin {
  CompanyMd get company => GeneralController.to.companyInfo;
  UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  //Data values
  bool get isCreate => data.isCreate;
  bool get isUpdate => !isCreate;
  ScheduleCreatePopupMenus get type => data.type;

  late final JobModel data = widget.data;
  bool get isClientSelected => data.isClientSelected;
  Map<UserRes, double> get addedChildren => data.addedChildren;
  TimingModel get timing => data.timingInfo;
  Address get address => data.address;
  Address get workAddress => data.workAddress;
  DateTime? get date => data.date;
  // AllocationModel? get allocation => data.allocation;

  //Temp vars
  bool resetLocation = true;
  LocationAddress? tempAddress;
  ClientInfoMd? tempClient;

  //Vars
  late final TabController _tabController;
  final List<Tab> _tabs = [
    Tab(text: "${Constants.propertyName.capitalizeFirst} details"),
    const Tab(text: "Staff Requirements"),
    const Tab(text: "Qualification Requirements"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.showOverlay(
        asyncFunction: () async {
          _getUnavUsers(date ?? DateTime.now());
          if (isUpdate) {
            final res = await restClient()
                .getQuoteBy(
                  0,
                  date: data.dateAsString!,
                  location_id: data.allocation!.location.id,
                  shift_id: data.allocation!.shift.id,
                )
                .nocodeErrorHandler();
            if (res.success) {
              final q = res.data['quotes'][0];
              data.quote = QuoteInfoMd.fromJson(q);

              setState(() {});
            }
          }
        },
        loadingWidget: const CustomLoadingWidget(),
      );
    });
  }

  Future<void> _getUnavUsers(DateTime d) async {
    final unavUsers = await appStore.dispatch(GetUnavailableUsersAction(d));
    if (mounted) {
      setState(() {
        unavailableUsers.users = unavUsers;
        for (var u in unavailableUsers.users) {
          data.addedChildren.removeWhere((user, _) => user.id == u.userId);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            if (isUpdate)
              TabBar(
                controller: _tabController,
                tabs: _tabs,
                labelColor: ThemeColors.MAIN_COLOR,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ThemeColors.MAIN_COLOR.withOpacity(0.1),
                ),
                splashBorderRadius: BorderRadius.circular(30),
                unselectedLabelColor: ThemeColors.gray7,
                indicatorColor: ThemeColors.MAIN_COLOR,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: Theme.of(context).textTheme.headlineSmall,
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
          ButtonLarge(
            text: isCreate ? 'Publish' : (isUpdate ? "Update" : "Save"),
            onPressed: () => _save(state),
          ),
        ],
        content: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
                color: ThemeColors.gray6,
                width: 2,
                strokeAlign: StrokeAlign.outside),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _Form(state),
                SizedBox(),
                SizedBox(),
                // StaffRequirementForm(data: data),
                // QualificationReqForm(data: data),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetLocationDp(Function callback) async {
    setState(() {
      resetLocation = false;
    });
    await callback();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        resetLocation = true;
      });
    });
  }

  // //Functions
  void _save(AppState state) async {
    switch (type) {
      case ScheduleCreatePopupMenus.job:
        _saveJob(state);
        break;
      default:
    }
  }

  void _saveJob(AppState state) {
    Get.showOverlay(
        asyncFunction: () async {
          final ApiResponse? newJob =
              await appStore.dispatch(CreateJobAction(data));
          if (newJob?.success == true) {
            exit(context).then((value) {
              showError(
                  "Job ${data.isCreate ? "created" : "updated"} successfully",
                  titleMsg: "Success");
            });
          }
        },
        loadingWidget: const CustomLoadingWidget());
  }

  void _onCreateNewClient(AppState state) async {
    final CreatedClientReturnValue? res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ClientForm(
            state: state,
          );
        });
    if (res == null) return;
    resetLocationDp(() {
      if (res.clientId != null) {
        final foundClient = appStore.state.generalState.clientInfos
            .firstWhereOrNull((element) => element.id == res.clientId);
        if (foundClient != null) {
          setState(() {
            tempClient = foundClient;
            data.setClient(foundClient);
          });
        }
      }
      if (res.locationId != null) {
        final foundAddress = appStore.state.generalState.locations
            .firstWhereOrNull((element) => element.id == res.locationId);
        if (foundAddress != null) {
          setState(() {
            tempAddress = foundAddress;
            data.setAddress(foundAddress.address, foundAddress.id);
          });
        }
      }
    });
  }

  void _editInvoiceAddress(AppState state) async {
    final CreatedClientReturnValue? res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ClientForm(
            state: state,
            type: ClientFormType.location,
          );
        });
    if (res == null) return;
    resetLocationDp(() {
      if (res.locationId != null) {
        final foundAddress = appStore.state.generalState.locations
            .firstWhereOrNull((element) => element.id == res.locationId);
        if (foundAddress != null) {
          setState(() {
            tempAddress = foundAddress;
            data.setAddress(foundAddress.address, foundAddress.id);
          });
        }
      }
    });
  }

  // void _editWorkAddress() async {
  //   final CreatedClientReturnValue? res = await appStore.dispatch(
  //       OnCreateNewClientTap(context,
  //           type: ClientFormType.location, clientInfo: data.client));
  //   if (res == null) return;
  //   setState(() {
  //     if (res.locationId != null) {
  //       data.tempAllowedLocIdWorkAddress = res.locationId;
  //       final loc = appStore.state.generalState.locations
  //           .firstWhereOrNull((element) => element.id == res.locationId);
  //       if (loc != null) {
  //         data.workAddress = Address.fromLocationAddress(appStore
  //             .state.generalState.locations
  //             .firstWhereOrNull((element) => element.id == res.locationId)!);
  //       }
  //     }
  //   });
  // }
  //

  void _editTiming(AppState state) async {
    final TimingModel? res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return TimingForm(
            state: state,
            timingInfo: timing,
          );
        });
    if (res == null) return;
    bool fetchUnavUsers = res.date!.compareTo(data.timingInfo.date!) != 0;
    data.timingInfo = res;
    logger(res);
    setState(() {
      if (fetchUnavUsers) {
        unavailableUsers.isLoaded = false;
      }
    });
    if (fetchUnavUsers) {
      final unavUsrs =
          await appStore.dispatch(GetUnavailableUsersAction(res.date!));
      if (mounted) {
        unavailableUsers.users = unavUsrs;
        for (int i = 0; i < unavailableUsers.users.length; i++) {
          if (addedChildren.isEmpty) break;
          try {
            final user = addedChildren.entries.toList()[i].key;
            if (unavailableUsers.users
                .any((element) => element.userId == user.id)) {
              addedChildren.remove(user);
            }
          } catch (e) {
            logger("Error in removing unavailable users. $e");
          }
        }
        unavailableUsers.isLoaded = true;
      }
    }

    setState(() {});
  }

  void onEditTeamMember(List<UserRes> users) {
    //Show a dialog which will allow the user to select team members from users list.
    // The content must contain a search box and a list of users.
    showDialog(
      context: context,
      builder: (context) {
        final filteredUsers = [...users];
        final addedUsers = <UserRes>[...addedChildren.keys.toList()];
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
                                  unavailableUsers.users.firstWhereOrNull(
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
                                                    (user, rate) =>
                                                        user.id == user.id);
                                                addedUsers.removeWhere(
                                                    (element) =>
                                                        element.id == user.id);
                                              } else {
                                                addedChildren.addAll({user: 0});
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
    if (timing.repeat != null) {
      for (var day in timing.days.entries) {
        //Weekly
        if (timing.repeat!.isWeekly) {
          week1 += "${Constants.daysOfTheWeek[day.key]}\n";
          week2 = "";
        }
        //Fortnightly
        if (timing.repeat!.isFortnightly) {
          if (day.key > 7) {
            week2 += "${Constants.daysOfTheWeek[day.key]}\n";
          } else {
            week1 += "${Constants.daysOfTheWeek[day.key]}\n";
          }
        }
      }
    }
    if (week1 == "* Week 1\n" && week2 == "* Week 2\n") {
      week = "";
    } else {
      week = "$week1\n$week2";
    }

    List<LocationAddress> locations = [
      ...state.generalState.clientBasedLocations(data.client.id),
    ];
    //find and add the location which is equal to tempAllowedLocationId
    if (tempAddress != null) {
      locations.add(tempAddress!);
    }
    // locations.addAll(
    //   state.generalState.locations
    //       .where((element) =>
    //           element.id == data.tempAllowedLocIdWorkAddress &&
    //           !locations.contains(element))
    //       .toList(),
    // );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomScrollbar(
        child: Container(
          padding:
              const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: 32,
            children: [
              SpacedRow(
                horizontalSpace: 32,
                children: [
                  SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 16,
                    children: [
                      SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalSpace: 16,
                        children: [
                          TitleContainer(
                            titleOverride: "Create New Client",
                            titleIcon: HeroIcons.add,
                            onEdit: isUpdate
                                ? null
                                : () => _onCreateNewClient(state),
                            title: "Personal Information",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isCreate)
                                  Visibility(
                                    visible: resetLocation,
                                    child: CustomAutocompleteTextField<
                                            ClientInfoMd>(
                                        width: 400,
                                        height: 50,
                                        hintText: "Select Client",
                                        listItemWidget: (p0) => Text(p0.name),
                                        onSelected: (p0) {
                                          resetLocationDp(() {
                                            setState(() {
                                              data.setClient(p0);
                                              tempAddress = null;
                                            });
                                          });
                                        },
                                        displayStringForOption: (option) {
                                          return option.name;
                                        },
                                        initialValue: tempClient == null
                                            ? null
                                            : TextEditingValue(
                                                text: tempClient!.name),
                                        options: (p0) => state
                                            .generalState.clientInfos
                                            .where((element) => element.name
                                                .toLowerCase()
                                                .contains(
                                                    p0.text.toLowerCase()))),
                                  ),
                                const SizedBox(height: 16),
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelWithField(
                                      labelWidth: 160,
                                      "Name:",
                                      null,
                                      customLabel: _textField(data.client.name),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Company:",
                                      null,
                                      customLabel:
                                          _textField(data.client.company),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Email:",
                                      null,
                                      customLabel:
                                          _textField(data.client.email),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Phone:",
                                      null,
                                      customLabel:
                                          _textField(data.client.phone),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Payment Terms:",
                                      null,
                                      customLabel: _textField(
                                          data.client.payingDays.toString()),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Currency:",
                                      null,
                                      customLabel: _textField(currencies
                                          .firstWhere((element) =>
                                              int.parse(
                                                  data.client.currencyId) ==
                                              element.id)
                                          .title),
                                    ),
                                    const Divider(),
                                    labelWithField(
                                        labelWidth: 160,
                                        "Payment method:",
                                        null,
                                        customLabel: _textField(paymentMethods
                                            .firstWhereOrNull((element) =>
                                                int.tryParse(data.client
                                                        .paymentMethodId ??
                                                    "") ==
                                                element.id)
                                            ?.name)),
                                    const Divider(),
                                    labelWithField(
                                      labelWidth: 160,
                                      "Client Notes:",
                                      null,
                                      customLabel:
                                          _textField(data.client.notes),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (data.type == ScheduleCreatePopupMenus.quote)
                            labelWithField(
                              labelWidth: 160,
                              "Quote Comments",
                              TextInputWidget(
                                width: 400,
                                maxLines: 4,
                                hintText: "Add quote comments",
                                controller: TextEditingController(
                                    text: data.quote?.quoteComments ?? ""),
                                onChanged: (value) {
                                  data.quote?.quoteComments = value;
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  SpacedColumn(
                    verticalSpace: 16,
                    children: [
                      TitleContainer(
                        onEdit: !isClientSelected
                            ? null
                            : isUpdate
                                ? null
                                : () => _editInvoiceAddress(state),
                        titleOverride: "Create New Location",
                        titleIcon: HeroIcons.add,
                        title: "Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isClientSelected)
                              if (isCreate)
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
                              if (isCreate)
                                Visibility(
                                  visible: resetLocation,
                                  child: CustomAutocompleteTextField<
                                          LocationAddress>(
                                      width: 400,
                                      height: 50,
                                      hintText: "Select Location",
                                      listItemWidget: (p0) => Text(p0.name),
                                      initialValue: tempAddress == null
                                          ? null
                                          : TextEditingValue(
                                              text: tempAddress!.name),
                                      onSelected: (p0) {
                                        setState(() {
                                          data.setAddress(p0.address, p0.id);
                                        });
                                      },
                                      displayStringForOption: (option) {
                                        return option.name ?? "";
                                      },
                                      options: (p0) => locations.where(
                                          (element) => (element.name ?? "")
                                              .toLowerCase()
                                              .contains(
                                                  p0.text.toLowerCase()))),
                                ),
                            const SizedBox(height: 16),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 1:",
                              null,
                              customLabel: _textField(data.address.line1),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 2:",
                              null,
                              customLabel: _textField(data.address.line2),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "City:",
                              null,
                              customLabel: _textField(data.address.city),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "County:",
                              null,
                              customLabel: _textField(data.address.county),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Country:",
                              null,
                              customLabel: _textField(countries
                                  .firstWhereOrNull((element) =>
                                      element.code == data.address.country)
                                  ?.name),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Postcode:",
                              null,
                              customLabel: _textField(data.address.postcode),
                            ),
                          ],
                        ),
                      ),
                      if (data.hasWorkAddress)
                        TitleContainer(
                          // onEdit: !isClientSelected ? null : _editWorkAddress,
                          titleOverride: "Create New Location",
                          titleIcon: HeroIcons.add,
                          title: "Work Address",
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
                                    listItemWidget: (p0) => Text(p0.name),
                                    onCleared: () {
                                      setState(() {
                                        data.setWorkAddress(null);
                                      });
                                    },
                                    onSelected: (p0) {
                                      setState(() {
                                        data.setWorkAddress(p0.address);
                                      });
                                    },
                                    displayStringForOption: (option) {
                                      return option.name;
                                    },
                                    options: (p0) => locations.where(
                                        (element) => (element.name)
                                            .toLowerCase()
                                            .contains(p0.text.toLowerCase()))),
                              const SizedBox(height: 16),
                              labelWithField(
                                labelWidth: 160,
                                "Address Line 1:",
                                null,
                                customLabel: _textField(workAddress.line1),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Address Line 2:",
                                null,
                                customLabel: _textField(workAddress.line2),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "City:",
                                null,
                                customLabel: _textField(workAddress.city),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "County:",
                                null,
                                customLabel: _textField(workAddress.county),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Country:",
                                null,
                                customLabel: _textField(countries
                                    .firstWhereOrNull((element) =>
                                        element.code == workAddress.country)
                                    ?.name),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Postcode:",
                                null,
                                customLabel: _textField(workAddress.postcode),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  TitleContainer(
                    onEdit: () => _editTiming(state),
                    title: "Timing",
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithField(
                          labelWidth: 160,
                          "Start Date:",
                          null,
                          customLabel: _textField(timing.date?.formattedDate),
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
                          customLabel: _textField(timing.repeat?.name),
                        ),
                        if (timing.repeat != null &&
                            (timing.repeat!.isWeekly ||
                                timing.repeat!.isFortnightly))
                          const Divider(),
                        if (timing.repeat != null &&
                            (timing.repeat!.isWeekly ||
                                timing.repeat!.isFortnightly))
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
                          customLabel: checkbox(data.active, (p0) {
                            setState(() {
                              data.active = p0;
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  TitleContainer(
                    titleIcon: HeroIcons.add,
                    onEdit: unavailableUsers.isLoaded
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
        if (!unavailableUsers.isLoaded)
          const Center(child: Text("Please wait loading..."))
        else if (addedChildren.isEmpty)
          TextButton(
            onPressed: () {
              onEditTeamMember(users);
            },
            child: const Text("Add team member"),
          ),
        ...addedChildren.entries.map((e) {
          final user = e.key;
          final rate = e.value;
          bool isRateAdded = rate > 0;
          return Container(
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
                  tooltip: "${!isRateAdded ? "Add" : "Remove"} Special Rate",
                  onPressed: () {
                    setState(() {
                      if (isRateAdded) {
                        addedChildren[user] = -1;
                      } else {
                        addedChildren[user] = 1;
                      }
                    });
                  },
                  icon: !isRateAdded ? HeroIcons.dollar : HeroIcons.bin,
                ),
                if (isRateAdded)
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
                        addedChildren[user] = rate;
                      });
                    },
                  ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: InputChip(
                    label: Text(user.fullname),
                    labelStyle: TextStyle(color: user.foregroundColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    deleteButtonTooltipMessage: "Remove",
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    deleteIcon: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: user.foregroundColor.withOpacity(.2),
                        border: Border.all(
                          color: user.foregroundColor.withOpacity(.2),
                        ),
                      ),
                      child: const Icon(Icons.close),
                    ),
                    deleteIconColor: user.foregroundColor,
                    onDeleted: () {
                      setState(() {
                        addedChildren.remove(user);
                      });
                    },
                    backgroundColor: user.userRandomBgColor,
                  ),
                ),
              ],
            ),
          );
        }).toList()
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

  Widget _products(AppState state) {
    return labelWithField(
        labelWidth: 160,
        "Products and services",
        SizedBox(
          width: MediaQuery.of(context).size.width * .95,
          height: MediaQuery.of(context).size.height * .4,
          child: UsersListTable(
              enableEditing: true,
              rows: data.isGridInitialized ? data.gridStateManager.rows : [],
              mode: PlutoGridMode.normal,
              gridBorderColor: Colors.grey[300]!,
              noRowsText: "No product or service added yet",
              onSmReady: (e) {
                if (data.isGridInitialized) return;
                data.gridStateManager = e;
                data.isGridInitialized = true;
              },
              cols: data.cols(state)),
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
                  data.gridStateManager.insertRows(
                      0, [data.buildStorageRowRow(item, checked: true)]);
                },
                icon: HeroIcons.add),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomAutocompleteTextField<StorageItemMd>(
                  listItemWidget: (p0) => Text(p0.name),
                  onSelected: (p0) {
                    data.gridStateManager.insertRows(
                        0, [data.buildStorageRowRow(p0, checked: true)]);
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
