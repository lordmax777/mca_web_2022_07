import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/team_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/guest_widget.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/prducts_table.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/team_member_widget.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'create_schedule_popup.dart';

const double kSidebarWidth = 450.0;

class QuickShiftPopup extends StatefulWidget {
  final ShiftData? shiftData;

  const QuickShiftPopup({super.key, this.shiftData});

  @override
  State<QuickShiftPopup> createState() => _QuickShiftPopupState();
}

class _QuickShiftPopupState extends State<QuickShiftPopup> {
  final _dependencies = DependencyManager.instance;

  //Getters
  PersonalData get personalData => shiftData.personalData;

  TeamData get teamData => shiftData.teamData;

  GuestData get guestData => shiftData.guestData;

  ProductData get productData => shiftData.productData;

  TimeData get timingData => shiftData.timeData;

  //Variables
  late ShiftData shiftData;
  bool isCreate = true;
  late final bool isQuote;
  late final PlutoGridStateManager productStateManager;
  final List<UserMd> unavailableUsers = [];

  void updateUI(VoidCallback? callback) {
    if (mounted) {
      setState(callback ?? () {});
    }
  }

  @override
  void initState() {
    shiftData = widget.shiftData?.copyWith() ?? ShiftData.init();
    isQuote = shiftData.isQuote;
    isCreate = shiftData.isCreate;

    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          final initialized = await _initJob();
          if (initialized) fetchUnavailableUsers();
        }
      },
    );
  }

  Future<bool> _initJob() async {
    final success = await context.futureLoading<bool>(() async {
      bool success = false;

      //1. if personal.shiftId!=null && personal.clientId!=null
      //2. fetch client contract items API
      //3. add result to product table
      if (personalData.clientId != null && personalData.shiftId != null) {
        final items = await dispatch<List<StorageItemMd>>(
            GetClientContractItemsAction(
                clientId: personalData.clientId!,
                shiftId: personalData.shiftId!,
                date: timingData.start!));
        if (items.isLeft) {
          //Success
          for (var element in items.left) {
            onAddProduct(element);
          }

          //Add guests
          await fetchGuests();

          success = true;
        } else if (items.isRight) {
          //Failed
          context.showError(items.right.message);
        } else {
          //Error
          context.showError('Failed to fetch client contract items');
        }
      }

      return success;
    });

    return success;
  }

  Future<void> fetchUnavailableUsers() async {
    if (timingData.start == null) return;
    _dependencies.navigation.futureLoading(() async {
      final users = await dispatch<List<UserMd>>(
          //2023, 04, 23 => can use for testing, that has unav users
          GetUnavailableUserListAction(
              // DateTime(2023, 04, 23),
              timingData.start!));
      unavailableUsers.clear();
      logger('unavailable users: ${unavailableUsers.length}');
      if (users.isLeft) {
        // can use users from store
        unavailableUsers.addAll(users.left);

        //removing initially added members if they are unavailable
        for (final user in users.left) {
          if (user.unavailability.isUnavailable) {
            teamData.users.removeWhere((element) => element.id == user.id);
          }
        }
      } else {
        updateUI(() {
          _dependencies.navigation.showFail(
              'Failed to fetch unavailable users. ${users.right.message}');
        });
      }
    });
  }

  Future<void> fetchGuests({bool showError = true}) async {
    final guestsSuccess = await dispatch<PropertyDetailMd>(
        GetPropertyDetailsAction(personalData.shiftId!));
    if (guestsSuccess.isLeft) {
      shiftData = shiftData.copyWith(
          guestData: guestData.copyFromProperty(guestsSuccess.left));
      updateUI(() {});
      return;
    } else if (guestsSuccess.isRight) {
      if (showError) context.showError(guestsSuccess.right.message);
    } else {
      if (showError) context.showError("Unable to get guests");
    }
    shiftData = shiftData.copyWith(
        guestData: guestData.copyWith(
            max: 0, min: 0, bathrooms: 0, bedrooms: 0, notes: ""));
    updateUI(() {});
  }

  Future<void> onAddTeamMember() async {
    final res = await _dependencies.navigation.showCustomDialog<TeamData?>(
        context: context,
        builder: (context) {
          return TeamPopup(
            data: teamData,
            unavailableUsers: unavailableUsers,
          );
        });
    if (res != null) {
      shiftData = shiftData.copyWith(teamData: res);
      updateUI(() {});
    }
  }

  void onAddProduct([StorageItemMd? storageItem]) {
    if (storageItem != null) {
      //Add to table
      if (productStateManager.rows
          .any((element) => element.cells['id']!.value == storageItem.id)) {
        final rowIdx = productStateManager.rows.indexWhere(
            (element) => element.cells['id']!.value == storageItem.id);
        final row = productStateManager.rows[rowIdx];
        final qty = row.cells['quantity']!.value as int;
        productStateManager.rows[rowIdx].cells['quantity']!.value = qty + 1;
        updateUI(() {});
      } else {
        productStateManager.insertRows(
            0, [buildStorageRow(storageItem, checked: storageItem.auto)]);
      }
    }
  }

  PlutoRow buildStorageRow(StorageItemMd storageItem, {bool checked = false}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: storageItem.id),
        "title": PlutoCell(value: storageItem.name),
        "price": PlutoCell(value: storageItem.outgoingPrice),
        "quantity": PlutoCell(value: storageItem.quantity),
        "auto": PlutoCell(value: storageItem.auto),
        "deleteBtn": PlutoCell(value: ""),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: AlertDialog(
            surfaceTintColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quick Add Shift'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: context.pop,
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(0),
            content: StoreConnector<AppState, ListMd>(
                converter: (store) => store.state.generalState.lists,
                builder: (context, vm) {
                  final shifts = [...vm.shifts]
                      .where((element) => element.clientId != null);
                  final clients =
                      [...vm.clients].where((element) => element.active);
                  final locations = [...vm.locations];

                  final storageItems = [
                    ...appStore.state.generalState.storageItems
                  ]..sort((a, b) {
                      //Sort if service is true to top, else bottom
                      if (a.service == b.service) {
                        return a.name.compareTo(b.name);
                      } else {
                        return a.service ? -1 : 1;
                      }
                    });
                  return SizedBox(
                    width: kSidebarWidth,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SpacedColumn(
                        mainAxisSize: MainAxisSize.min,
                        verticalSpace: 14,
                        children: [
                          //Personal Data
                          ShiftCard(
                            title: "Select Job",
                            dropdown: ShiftCardDropdown(
                              valueId: personalData.shiftId,
                              items: [
                                ...shifts.map(
                                  (e) => DefaultMenuItem(
                                    id: e.id,
                                    title:
                                        "${e.name} - ${clients.firstWhereOrNull((element) => element.id == e.clientId)?.name ?? ""}",
                                    subtitle: locations
                                        .firstWhereOrNull((element) =>
                                            element.id == e.locationId)
                                        ?.name,
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                final shift = shifts.firstWhereOrNull(
                                    (element) => element.id == value.id);
                                if (shift != null) {
                                  final client = shift.getClientMd(
                                      appStore.state.generalState.clients);
                                  final location = shift.getLocationMd(
                                      appStore.state.generalState.locations);
                                  if (client != null) {
                                    shiftData = shiftData.copyWith(
                                      personalData: personalData
                                          .copyWith(shiftId: value.id)
                                          .copyFromClient(client,
                                              currencies: vm.currencies,
                                              paymentMethods:
                                                  vm.paymentMethods),
                                    );
                                  }
                                  if (location != null) {
                                    shiftData = shiftData.copyWith(
                                        addressData: shiftData.addressData
                                            .copyFromAddress(location.address,
                                                countries: vm.countries));
                                  }
                                  fetchGuests(showError: false);
                                  updateUI(() {});
                                }
                              },
                              label: "Job",
                            ),
                            items: [
                              ShiftCardItem(
                                title: "Name",
                                simpleText: personalData.name,
                              ),
                              ShiftCardItem(
                                  title: "Company",
                                  simpleText: personalData.companyName),
                              ShiftCardItem(
                                  title: "Email",
                                  simpleText: personalData.email,
                                  maxLines: 2,
                                  onChanged: (value) {
                                    personalData.email = value;
                                  }),
                              ShiftCardItem(
                                  title: "Phone",
                                  simpleText: personalData.phone,
                                  onChanged: (value) {
                                    personalData.phone = value;
                                  }),
                            ],
                          ),

                          const Divider(color: Colors.grey),

                          //Team Data
                          ShiftCard(
                            title: "Team",
                            trailing: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: onAddTeamMember,
                                tooltip: "Add member",
                                color: context.colorScheme.primary,
                                icon: const Icon(Icons.add_circle_rounded)),
                            items: [
                              if (teamData.users.isEmpty)
                                ShiftCardItem(
                                  title: "No Team Members",
                                  simpleText: "Add Team Members",
                                  onSimpleTextTapped: onAddTeamMember,
                                )
                              else
                                ...teamData.users
                                    .map(
                                      (e) => ShiftCardItem(
                                        customWidget: TeamMemberWidget(
                                          name:
                                              "${GlobalConstants.enableDebugCodes ? "[${e.id}] - " : ""}${e.fullname}",
                                          specialRate: e.specialPrice,
                                          specialStartTime: e.specialTime,
                                          onDeleted: () {
                                            teamData.users.remove(e);
                                            updateUI(() {});
                                          },
                                          onSpecialRateChanged: (rate) {
                                            e.specialPrice = rate;
                                          },
                                          onSpecialStartTimeChanged: (time) {
                                            e.specialTime = time;
                                            updateUI(() {});
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                            ],
                          ),

                          const Divider(color: Colors.grey),

                          //Guests Data
                          ShiftCard(
                            title: "Guests",
                            items: [
                              ShiftCardItem(
                                customWidget: GuestWidget(
                                  title: "Min Sleeps",
                                  value: guestData.min,
                                  onAdded: () {
                                    updateUI(() {
                                      guestData.min++;
                                      if (guestData.max < guestData.min) {
                                        guestData.max = guestData.min;
                                      }
                                      if (guestData.current < guestData.min) {
                                        guestData.current = guestData.min;
                                      }
                                    });
                                  },
                                  onRemoved: guestData.min > 0
                                      ? () {
                                          //cannot be less than 0
                                          updateUI(() {
                                            guestData.min--;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              ShiftCardItem(
                                customWidget: GuestWidget(
                                  title: "Max Sleeps",
                                  value: guestData.max,
                                  onAdded: () {
                                    updateUI(() {
                                      //cannot be less than min
                                      guestData.max++;
                                    });
                                  },
                                  onRemoved: guestData.max > guestData.min
                                      ? () {
                                          updateUI(() {
                                            //cannot be less than min
                                            guestData.max--;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              ShiftCardItem(
                                customWidget: GuestWidget(
                                  title: "Current",
                                  value: guestData.current,
                                  onAdded: guestData.current < guestData.max
                                      ? () async {
                                          //cannot be more than max
                                          // final currentSuccess =
                                          //     await dispatch<int>(
                                          //         PostAllocationAction(
                                          //   locationId: shiftData
                                          //       .addressData.locationId,
                                          //   shiftId: personalData.shiftId,
                                          //   date: timingData.start!,
                                          //   action: AllocationPostType.more,
                                          // ));
                                          // if (currentSuccess.isLeft) {
                                          updateUI(() {
                                            guestData.current++;
                                          });
                                          // }
                                        }
                                      : null,
                                  onRemoved: guestData.current > guestData.min
                                      ? () async {
                                          //cannot be less than min
                                          // final currentSuccess =
                                          //     await dispatch<int>(
                                          //         PostAllocationAction(
                                          //   locationId: shiftData
                                          //       .addressData.locationId,
                                          //   shiftId: personalData.shiftId,
                                          //   date: timingData.start!,
                                          //   action: AllocationPostType.less,
                                          // ));
                                          // if (currentSuccess.isLeft) {
                                          updateUI(() {
                                            guestData.current--;
                                          });
                                          // }
                                        }
                                      : null,
                                ),
                              ),
                              ShiftCardItem(
                                customWidget: GuestWidget(
                                  title: "Bedrooms",
                                  value: guestData.bedrooms,
                                  onAdded: () {
                                    updateUI(() {
                                      //cannot be more than max
                                      guestData.bedrooms++;
                                    });
                                  },
                                  onRemoved: guestData.bedrooms > 0
                                      ? () {
                                          updateUI(() {
                                            //cannot be less than min
                                            guestData.bedrooms--;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              ShiftCardItem(
                                customWidget: GuestWidget(
                                  title: "Bathrooms",
                                  value: guestData.bathrooms,
                                  onAdded: () {
                                    updateUI(() {
                                      //cannot be more than max
                                      guestData.bathrooms++;
                                    });
                                  },
                                  onRemoved: guestData.bathrooms > 0
                                      ? () {
                                          updateUI(() {
                                            //cannot be less than min
                                            guestData.bathrooms--;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              ShiftCardItem(
                                title: "Notes",
                                simpleText: guestData.notes,
                                onChanged: (value) {
                                  guestData.notes = value;
                                },
                              ),
                            ],
                          ),

                          //Timing Data
                          ShiftCard(
                            title: "Timing",
                            items: [
                              ShiftCardItem(
                                title: "Start Date",
                                simpleText:
                                    timingData.start?.companyFormatDateTime(),
                                onSimpleTextTapped: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: kDebugMode
                                        ? DateTime(2020)
                                        : DateTime.now(),
                                    initialDate: timingData.start!,
                                    lastDate: DateTime(2030),
                                  ).then((value) {
                                    if (value != null) {
                                      bool isSame = true;
                                      if (value != timingData.start) {
                                        isSame = false;
                                      }
                                      updateUI(() {
                                        timingData.start = value;
                                      });
                                      if (!isSame) fetchUnavailableUsers();
                                    }
                                  });
                                },
                              ),
                              ShiftCardItem(
                                title: "Start Time",
                                simpleText:
                                    timingData.startTime?.format(context) ??
                                        "Select Time",
                                onSimpleTextTapped: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime:
                                        timingData.startTime ?? TimeOfDay.now(),
                                  ).then((value) {
                                    if (value != null) {
                                      updateUI(() {
                                        timingData.startTime = value;
                                      });
                                    }
                                  });
                                },
                              ),
                              ShiftCardItem(
                                title: "End Time",
                                simpleText:
                                    timingData.endTime?.format(context) ??
                                        "Select Time",
                                onSimpleTextTapped: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime:
                                        timingData.endTime ?? TimeOfDay.now(),
                                  ).then((value) {
                                    if (value != null) {
                                      updateUI(() {
                                        timingData.endTime = value;
                                      });
                                    }
                                  });
                                },
                              ),
                              // ShiftCardItem(
                              //   customWidget: DefaultDropdown(
                              //     label: "Repeats",
                              //     valueId: timingData.repeat?.id,
                              //     width: double.infinity,
                              //     items: [
                              //       for (var item in vm.workRepeats)
                              //         DefaultMenuItem(
                              //           id: item.id,
                              //           title: item.name,
                              //           subtitle: "${item.days} day(s)",
                              //         ),
                              //     ],
                              //     onChanged: (value) {
                              //       updateUI(() {
                              //         timingData.repeat = vm.workRepeats
                              //             .firstWhereOrNull(
                              //                 (e) => e.id == value.id);
                              //       });
                              //     },
                              //   ),
                              // ),
                              // if (timingData.showRepeatDays)
                              //   ShiftCardItem(
                              //     customWidget: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         label('Week 1', isRequired: true),
                              //         for (var item
                              //             in timingData.week1.asMap.entries)
                              //           DefaultCheckbox(
                              //             label: item.key,
                              //             value: item.value,
                              //             onChanged: (value) {
                              //               updateUI(() {
                              //                 timingData.week1
                              //                     .updateValueByKey(item.key);
                              //               });
                              //             },
                              //           ),
                              //         if (timingData.showWeek2)
                              //           const SizedBox(height: 8),
                              //         if (timingData.showWeek2)
                              //           label('Week 2', isRequired: true),
                              //         if (timingData.showWeek2)
                              //           for (var item
                              //               in timingData.week2.asMap.entries)
                              //             DefaultCheckbox(
                              //               label: item.key,
                              //               value: item.value,
                              //               onChanged: (value) {
                              //                 updateUI(() {
                              //                   timingData.week2
                              //                       .updateValueByKey(item.key);
                              //                 });
                              //               },
                              //             ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),

                          //Products data
                          ShiftCard(
                            isExpanded: true,
                            title: "Products\n& Services",
                            trailing: DefaultDropdown(
                              hasSearchBox: true,
                              items: storageItems
                                  .map((e) => DefaultMenuItem(
                                        id: e.id,
                                        title: e.name,
                                        subtitle:
                                            e.service ? "Service" : "Product",
                                      ))
                                  .toList(),
                              onChanged: (value) => onAddProduct(
                                  storageItems.firstWhereOrNull(
                                      (element) => element.id == value.id)),
                              width: kSidebarWidth / 2,

                              label:
                                  'Selected Products: 0', //todo: productData.items.length
                            ),
                            items: [
                              ShiftCardItem(
                                  customWidget: ProductsTable(
                                columns: [
                                  PlutoColumn(
                                    title: "id",
                                    type: PlutoColumnType.text(),
                                    field: "id",
                                    hide: true,
                                  ),
                                  PlutoColumn(
                                    width: 100,
                                    title: "Title",
                                    type: PlutoColumnType.text(),
                                    field: "title",
                                    enableAutoEditing: false,
                                    enableEditingMode: false,
                                  ),
                                  PlutoColumn(
                                    width: 100,
                                    title: "Customer's price",
                                    type: PlutoColumnType.currency(
                                      symbol: appStore.state.generalState
                                          .companyInfo.currency.sign,
                                    ),
                                    field: "price",
                                    enableAutoEditing: true,
                                    enableEditingMode: true,
                                    footerRenderer: (context) {
                                      final double total = context
                                          .stateManager.rows
                                          .where((element) =>
                                              element.checked ?? false)
                                          .map((e) =>
                                              (e.cells["price"]?.value ?? 0) *
                                              (e.cells["quantity"]?.value ?? 0))
                                          .fold(0, (a, b) {
                                        return a + b;
                                      });

                                      return Tooltip(
                                        message: total.getPriceMap(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            total.getPriceMap(),
                                            maxLines: 2,
                                            textAlign: TextAlign.end,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  PlutoColumn(
                                    width: 60,
                                    title: "Quantity",
                                    type: PlutoColumnType.number(),
                                    field: "quantity",
                                    enableAutoEditing: true,
                                    enableEditingMode: true,
                                  ),
                                  PlutoColumn(
                                    width: 80,
                                    hide: true,
                                    title: "Included in service (All)",
                                    type: PlutoColumnType.text(),
                                    enableRowChecked: true,
                                    enableSorting: false,
                                    enableFilterMenuItem: false,
                                    enableAutoEditing: false,
                                    enableEditingMode: false,
                                    field: "auto",
                                  ),
                                  PlutoColumn(
                                    width: 30,
                                    title: "",
                                    field: "deleteBtn",
                                    enableAutoEditing: false,
                                    enableEditingMode: false,
                                    type: PlutoColumnType.text(),
                                    renderer: (rendererContext) {
                                      return Center(
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            rendererContext.stateManager
                                                .removeRows(
                                                    [rendererContext.row]);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      );
                                    },
                                  )
                                ],
                                onLoaded: (event) async {
                                  productStateManager = event.stateManager;
                                  productStateManager.addListener(() {
                                    updateUI(() {});
                                  });
                                },
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actionsOverflowButtonSpacing: 8,
            actions: [
              //Publish button
              ElevatedButton(
                onPressed: onPublish,
                //Make size of button as big as possible
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: const Size(kSidebarWidth / 2, 48),
                ),

                child: const Text("Publish Shift"),
              ),

              //Additional Settings button
              ElevatedButton(
                onPressed: onAdditionalSettings,
                //Make size of button as big as possible
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.grey,
                    width: .5,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: const Size(kSidebarWidth / 2, 48),
                ),
                child: const Text("Additional Settings"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onPublish() async {
    productData.stateManager = productStateManager;

    if (!personalData.isValid(context)) {
      return;
    }
    if (!timingData.isValid(context)) {
      return;
    }
    if (!productData.isValid(context)) {
      return;
    }
    if (!guestData.isValid(context)) {
      return;
    }

    await context.futureLoading<void>(() async {
      //Create Quote
      final quoteId = await dispatch<int>(
        PostQuoteAction(
            personalData: personalData,
            addressData: shiftData.addressData,
            timingData: timingData,
            teamData: teamData,
            guestData: guestData,
            quoteData: shiftData.quoteData,
            productData: productData,
            workAddressData: shiftData.workAddressData),
      );

      //Check response
      if (quoteId.isLeft && !quoteId.left.isNegative) {
        //Success
        //Change quote status
        final status = await dispatch<bool>(
            ChangeQuoteStatusAction(id: quoteId.left, status: "accept"));
        if (status.isLeft) {
          //Success

          // Update Property Details
          if (guestData.mustFetch()) {
            final propertyDetailsUpdated = await dispatch<bool>(
                PostPropertyDetailsAction(
                    shiftId: personalData.shiftId!,
                    bedrooms: guestData.bedrooms,
                    bathrooms: guestData.bathrooms,
                    minSleeps: guestData.min,
                    maxSleeps: guestData.max,
                    notes: guestData.notes));
            if (propertyDetailsUpdated.isRight) {
              //Error
              context.showError("Failed to update guests data.", onClose: () {
                context.pop(true);
              });

              return;
            } else if (propertyDetailsUpdated.isLeft &&
                propertyDetailsUpdated.left) {
              // bool isCurrentNumberOfGuestUpdated = true;
              // //Steps to update the current number of guests
              // //1. Find the minimum number of guests
              // final min = guestData.min;
              // //2. Find the current number of guests
              // final current = guestData.current;
              // //3. Find the difference
              // final difference = min - current;
              // //4. Loop over the difference and add a guest
              // for (var i = 0; i < difference; i++) {
              //   final currentSuccess = await dispatch<int>(PostAllocationAction(
              //     locationId: shiftData.addressData.locationId,
              //     shiftId: personalData.shiftId,
              //     date: timingData.start!,
              //     action: AllocationPostType.more,
              //   ));
              //   if (currentSuccess.isRight && isCurrentNumberOfGuestUpdated) {
              //     //Failed at least one of them
              //     isCurrentNumberOfGuestUpdated = false;
              //   }
              // }
            }
          }

          context.pop(true);
        } else {
          //Fail
          context.showError('Failed to create job. ${status.right.message}');
          return;
        }
      } else {
        //Fail
        context.showError('Failed to create job.');
        return;
      }
    });
  }

  void onAdditionalSettings() async {
    productData.stateManager = productStateManager;

    bool success = false;
    success = await _dependencies.navigation.showCustomDialog<bool>(
            context: context,
            builder: (context) {
              return DefaultDialog(
                  title: "Add Shift",
                  builder: (context) =>
                      CreateSchedulePopup(shiftData: shiftData));
            }) ??
        false;

    context.pop(success);
  }
}
