import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/address_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/team_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/timing_popup.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/guest_widget.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/team_member_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../schedule_widgets/prducts_table.dart';
import 'personal_info_popup.dart';
import 'product_popup.dart';

class CreateSchedulePopup extends StatefulWidget {
  final ShiftData? shiftData;

  const CreateSchedulePopup({super.key, this.shiftData});

  @override
  State<CreateSchedulePopup> createState() => _CreateSchedulePopupState();
}

class _CreateSchedulePopupState extends State<CreateSchedulePopup> {
  final _dependencies = DependencyManager.instance;

  //Getters
  PersonalData get personalData => shiftData.personalData;

  AddressData get addressData => shiftData.addressData;

  AddressData? get workAddressData => shiftData.workAddressData;

  TimeData get timingData => shiftData.timeData;

  TeamData get teamData => shiftData.teamData;

  GuestData get guestData => shiftData.guestData;

  QuoteData get quoteData => shiftData.quoteData;

  ProductData get productData => shiftData.productData;

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
      if (!isCreate) {
        final quotes = await dispatch<List<QuoteMd>>(GetQuotesAction(
          id: quoteData.id,
          date: timingData.start!,
          locationId: addressData.locationId,
          shiftId: personalData.shiftId,
        ));
        if (quotes.isLeft && quotes.left.length == 1) {
          final quote = quotes.left.first;

          final lists = appStore.state.generalState.lists;

          shiftData = shiftData.copyWith(
              quoteData: quoteData.copyFromQuote(quote),
              personalData: personalData.copyFromQuote(quote,
                  paymentMethods: lists.paymentMethods,
                  currencies: lists.currencies),
              addressData:
                  addressData.copyFromQuote(quote, countries: lists.countries),
              workAddressData: isQuote
                  ? addressData.copyFromQuote(quote,
                      countries: lists.countries, isWorkAddress: true)
                  : null,
              timeData:
                  timingData.copyFromQuote(quote, repeats: lists.workRepeats));

          //Add products
          for (final product in quote.items) {
            final storageItem = appStore.state.generalState.storageItems
                .firstWhereOrNull((element) => element.id == product.itemId)
                ?.copyWith(
                  outgoingPrice: product.price,
                  auto: product.auto,
                  quantity: product.quantity,
                );
            if (storageItem != null) {
              onAddProduct(storageItem);
            }
          }

          //Add users
          teamData.users.clear();
          for (final user in quote.userIds) {
            final userMd = appStore.state.generalState.users
                .firstWhereOrNull((element) => element.id == user.userId)
                ?.copyWith();
            if (userMd != null) {
              userMd.specialPrice = user.specialRate?.toDouble();
              userMd.specialTime = user.specialStartTimeDt;
              teamData.users.add(userMd);
            }
          }

          //Add guests
          await fetchGuests();

          success = true;
        } else {
          context.pop();
          context.showError(
              quotes.isRight ? quotes.right.message : "Unable to edit");
        }
      } else {
        success = true;
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
      if (users.isLeft) {
        // can use users from store
        unavailableUsers.clear();
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

  Future<void> fetchGuests() async {
    if (personalData.shiftId == null) return;
    final guestsSuccess = await dispatch<PropertyDetailMd>(
        GetPropertyDetailsAction(personalData.shiftId!));
    if (guestsSuccess.isLeft) {
      shiftData = shiftData.copyWith(
          guestData: guestData.copyFromProperty(guestsSuccess.left));
      updateUI(() {});
      return;
    }
    // else if (guestsSuccess.isRight) {
    //   context.showError(guestsSuccess.right.message);
    // } else {
    //   context.showError("Unable to get guests");
    // }
    shiftData = shiftData.copyWith(
        guestData: guestData.copyWith(
            max: 0, min: 0, bathrooms: 0, bedrooms: 0, notes: ""));
    updateUI(() {});
  }

  Future<void> onEditTiming() async {
    final res = await _dependencies.navigation.showCustomDialog<TimeData?>(
        context: context,
        builder: (context) {
          return TimingPopup(data: timingData);
        });
    if (res != null) {
      bool isSame = true;
      //if res.start is different than timeData.start, then await fetchUnavailableUsers
      if (res.start != timingData.start) {
        isSame = false;
      }
      shiftData = shiftData.copyWith(timeData: res);

      if (!isSame) {
        await fetchUnavailableUsers();
      }
      updateUI(() {});
    }
  }

  Future<void> onAddAddress(
      {bool isWorkAddress = false, bool isEditOnly = false}) async {
    final res = await _dependencies.navigation.showCustomDialog<AddressData?>(
        context: context,
        builder: (context) {
          return AddressPopup(
            isEditOnly: isEditOnly,
            data: isWorkAddress ? workAddressData : null,
          );
        });
    if (res != null) {
      if (isWorkAddress) {
        shiftData = shiftData.copyWith(workAddressData: res);
      } else {
        shiftData = shiftData.copyWith(addressData: res);
      }
      updateUI(() {});
    }
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

  Future<void> onCreateProduct() async {
    final res = await _dependencies.navigation.showCustomDialog<StorageItemMd?>(
        context: context,
        builder: (context) {
          return const ProductPopup();
        });
    if (res != null) {
      onAddProduct(res);
      updateUI(() {});
    }
  }

  Future<void> onAddClient() async {
    final res =
        await _dependencies.navigation.showCustomDialog<Map<String, dynamic>?>(
            context: context,
            builder: (context) {
              return const PersonalInfoPopup();
            });
    if (res != null) {
      final address = res['address'];
      final personal = res['personal'];

      if (address != null) {
        shiftData = shiftData.copyWith(addressData: address);
      }
      if (personal != null) {
        shiftData = shiftData.copyWith(personalData: personal);
      }
      updateUI(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
      converter: (store) => store.state.generalState,
      onInit: (store) {
        if (store.state.generalState.storageItems.isEmpty) {
          store.dispatch(const GetStorageItemsAction());
        }
      },
      builder: (context, vm) {
        final List<ClientShortMd> clients =
            [...vm.lists.clients].where((element) => element.active).toList();
        final List<LocationMd> locations = [
          ...vm.clientBasedFullLocations(personalData.clientId)
        ];
        final List<StorageItemMd> storageItems = [...vm.storageItems]
          ..sort((a, b) {
            //Sort if service is true to top, else bottom
            if (a.service == b.service) {
              return a.name.compareTo(b.name);
            } else {
              return a.service ? -1 : 1;
            }
          });
        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SpacedColumn(
                  verticalSpace: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Personal Data
                    ShiftCard(
                        dropdown: ShiftCardDropdown(
                            label: "Clients",
                            items: clients.map((e) => DefaultMenuItem(
                                  id: e.id,
                                  title: e.name,
                                  subtitle: e.company,
                                )),
                            valueId: personalData.clientId,
                            onChanged: (value) {
                              updateUI(() {
                                final client = vm.clients.firstWhereOrNull(
                                    (element) => element.id == value.id);
                                if (client != null) {
                                  personalData.name = client.name;
                                  personalData.companyName =
                                      client.company ?? "";
                                  personalData.email = client.email ?? "";
                                  personalData.phone = client.phone ?? "";
                                  personalData.paymentDays = client.payingDays;
                                  personalData.currency =
                                      client.getCurrencyMd(vm.lists.currencies);
                                  personalData.paymentMethod =
                                      client.getPaymentMethodMd(
                                          vm.lists.paymentMethods);
                                  personalData.notes = client.notes;
                                }
                                personalData.clientId = value.id;
                                shiftData = shiftData.copyWith(
                                  addressData: AddressData(),
                                  workAddressData:
                                      !shiftData.isQuote ? null : AddressData(),
                                );
                              });
                            }),
                        items: [
                          ShiftCardItem(
                              title: "Name",
                              simpleText: personalData.name,
                              onChanged: isQuote
                                  ? (value) {
                                      personalData.name = value;
                                    }
                                  : null),
                          ShiftCardItem(
                              title: "Company",
                              simpleText: personalData.companyName),
                          ShiftCardItem(
                              title: "Email",
                              simpleText: personalData.email,
                              onChanged: (value) {
                                personalData.email = value;
                              }),
                          ShiftCardItem(
                              title: "Phone",
                              simpleText: personalData.phone,
                              onChanged: (value) {
                                personalData.phone = value;
                              }),
                          ShiftCardItem(
                              title: "Payment Terms",
                              onChanged: (value) {
                                final number = int.tryParse(value) ?? 0;
                                personalData.paymentDays = number;
                              },
                              simpleText: personalData.paymentDays.toString()),
                          ShiftCardItem(
                              title: "Currency",
                              dropdown: ShiftCardDropdown(
                                items: [
                                  for (int i = 0;
                                      i <
                                          appStore.state.generalState.lists
                                              .currencies.length;
                                      i++)
                                    DefaultMenuItem(
                                        id: i,
                                        title: appStore.state.generalState.lists
                                            .currencies[i].code)
                                ],
                                valueId: personalData.currency != null
                                    ? appStore
                                        .state.generalState.lists.currencies
                                        .indexOf(personalData.currency!)
                                    : null,
                                onChanged: (value) {
                                  updateUI(() {
                                    personalData.currency = appStore
                                        .state
                                        .generalState
                                        .lists
                                        .currencies[value.id];
                                  });
                                },
                              ),
                              simpleText: personalData.currency != null
                                  ? "${personalData.currency!.code} (${personalData.currency!.sign})"
                                  : null),
                          ShiftCardItem(
                              title: "Payment Method",
                              dropdown: ShiftCardDropdown(
                                items: [
                                  for (int i = 0;
                                      i <
                                          appStore.state.generalState.lists
                                              .paymentMethods.length;
                                      i++)
                                    DefaultMenuItem(
                                        id: i,
                                        title: appStore.state.generalState.lists
                                            .paymentMethods[i].name)
                                ],
                                valueId: personalData.paymentMethod != null
                                    ? appStore
                                        .state.generalState.lists.paymentMethods
                                        .indexOf(personalData.paymentMethod!)
                                    : null,
                                onChanged: (value) {
                                  updateUI(() {
                                    personalData.paymentMethod = appStore
                                        .state
                                        .generalState
                                        .lists
                                        .paymentMethods[value.id];
                                  });
                                },
                              ),
                              simpleText: personalData.paymentMethod?.name),
                          ShiftCardItem(
                              title: "Client Notes",
                              maxLines: 3,
                              simpleText: personalData.notes,
                              onChanged: (value) {
                                personalData.notes = value;
                              }),
                        ],
                        title: "Personal Info",
                        trailing: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onAddClient,
                            tooltip: "Add Client",
                            color: context.colorScheme.primary,
                            icon: const Icon(Icons.person_add_rounded))),

                    //Quote Data
                    if (isQuote)
                      ShiftCard(title: "Quote", items: [
                        ShiftCardItem(
                            title: "Quote Comment",
                            maxLines: 3,
                            simpleText: quoteData.quoteComment,
                            onChanged: (value) {
                              quoteData.quoteComment = value;
                            })
                      ]),
                  ],
                ),

                SpacedColumn(
                  verticalSpace: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Address Data
                    ShiftCard(
                      title: "Address",
                      trailing: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => onAddAddress(isEditOnly: isQuote),
                          tooltip: "${isQuote ? "Edit" : "Add"} Address",
                          color: context.colorScheme.primary,
                          icon: Icon(isQuote
                              ? Icons.edit_location_alt_rounded
                              : Icons.add_location_alt_rounded)),
                      dropdown: personalData.clientId == null
                          ? null
                          : ShiftCardDropdown(
                              label: "Locations",
                              items: locations.map((e) => DefaultMenuItem(
                                    id: e.id,
                                    title: e.name,
                                    subtitle: e.address.toAddressStr(),
                                  )),
                              valueId: addressData.locationId,
                              onChanged: (value) {
                                updateUI(() {
                                  final location = vm.locations
                                      .firstWhereOrNull(
                                          (element) => element.id == value.id);
                                  if (location != null) {
                                    addressData.line1 = location.address.line1;
                                    addressData.line2 = location.address.line2;
                                    addressData.city = location.address.city;
                                    addressData.county =
                                        location.address.county;
                                    addressData.country = location.address
                                        .getCountryMd(vm.lists.countries);
                                    addressData.postcode =
                                        location.address.postcode;
                                    addressData.email = location.email;
                                    addressData.phoneNumber =
                                        location.phone.mobile;
                                    addressData.longitude =
                                        location.address.longitude?.toDouble();
                                    addressData.latitude =
                                        location.address.latitude?.toDouble();
                                  }
                                  addressData.locationId = value.id;
                                });
                              }),
                      items: [
                        ShiftCardItem(
                            title: "Address Line 1",
                            simpleText: addressData.line1),
                        ShiftCardItem(
                            title: "Address Line 2",
                            simpleText: addressData.line2),
                        ShiftCardItem(
                            title: "City", simpleText: addressData.city),
                        ShiftCardItem(
                            title: "County", simpleText: addressData.county),
                        ShiftCardItem(
                            title: "Country",
                            simpleText: addressData.country?.name),
                        ShiftCardItem(
                            title: "Postcode",
                            simpleText: addressData.postcode),
                      ],
                    ),

                    //Work Address Data
                    if (workAddressData != null)
                      ShiftCard(
                        title: "Work Address",
                        trailing: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => onAddAddress(
                                isWorkAddress: true, isEditOnly: true),
                            tooltip: "Edit Address",
                            color: context.colorScheme.primary,
                            icon: const Icon(Icons.edit_location_alt_rounded)),
                        dropdown: personalData.clientId == null
                            ? null
                            : ShiftCardDropdown(
                                label: "Locations",
                                items: locations.map((e) => DefaultMenuItem(
                                      id: e.id,
                                      title: e.name,
                                      subtitle: e.address.toAddressStr(),
                                    )),
                                valueId: workAddressData!.locationId,
                                onChanged: (value) {
                                  updateUI(() {
                                    final location = vm.locations
                                        .firstWhereOrNull((element) =>
                                            element.id == value.id);
                                    if (location != null) {
                                      workAddressData!.line1 =
                                          location.address.line1;
                                      workAddressData!.line2 =
                                          location.address.line2;
                                      workAddressData!.city =
                                          location.address.city;
                                      workAddressData!.county =
                                          location.address.county;
                                      workAddressData!.country = location
                                          .address
                                          .getCountryMd(vm.lists.countries);
                                      workAddressData!.postcode =
                                          location.address.postcode;
                                      workAddressData!.email = location.email;
                                      workAddressData!.phoneNumber =
                                          location.phone.mobile;
                                      workAddressData!.longitude = location
                                          .address.longitude
                                          ?.toDouble();
                                      workAddressData!.latitude =
                                          location.address.latitude?.toDouble();
                                    }
                                    workAddressData!.locationId = value.id;
                                  });
                                }),
                        items: [
                          ShiftCardItem(
                              title: "Address Line 1",
                              simpleText: workAddressData!.line1),
                          ShiftCardItem(
                              title: "Address Line 2",
                              simpleText: workAddressData!.line2),
                          ShiftCardItem(
                              title: "City", simpleText: workAddressData!.city),
                          ShiftCardItem(
                              title: "County",
                              simpleText: workAddressData!.county),
                          ShiftCardItem(
                              title: "Country",
                              simpleText: workAddressData!.country?.name),
                          ShiftCardItem(
                              title: "Postcode",
                              simpleText: workAddressData!.postcode),
                        ],
                      ),
                  ],
                ),

                //Timing and Quote
                SpacedColumn(
                  verticalSpace: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Timing Data
                    ShiftCard(
                      title: "Timing",
                      trailing: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onEditTiming,
                          tooltip: "Edit Timing",
                          color: context.colorScheme.primary,
                          icon: const Icon(Icons.edit_calendar_rounded)),
                      items: [
                        ShiftCardItem(
                          title: "Start Date",
                          simpleText: timingData.start?.companyFormatDateTime(),
                        ),
                        if (timingData.showAltDate)
                          ShiftCardItem(
                            title: "Alt Start Date",
                            simpleText: timingData.altStartDate
                                ?.companyFormatDateTime(),
                          ),
                        ShiftCardItem(
                            title: "Start Time",
                            simpleText: timingData.startTime?.format(context)),
                        ShiftCardItem(
                            title: "End Time",
                            simpleText: timingData.endTime?.format(context)),
                        ShiftCardItem(
                            title: "Repeat",
                            simpleText: timingData.repeat?.name),
                        if (timingData.showRepeatDays)
                          ShiftCardItem(
                              title: "Week 1",
                              simpleText: timingData.week1.toString()),
                        if (timingData.showWeek2)
                          ShiftCardItem(
                              title: "Week 2",
                              simpleText: timingData.week2.toString()),
                        ShiftCardItem(
                          title: "Active",
                          checked: timingData.active,
                          onChecked: (value) {
                            updateUI(() {
                              timingData.active = value;
                            });
                          },
                        ),
                      ],
                    ),

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
                              });
                            },
                            onRemoved: () {
                              updateUI(() {
                                //cannot be less than 0
                                if (guestData.min > 0) {
                                  guestData.min--;
                                }
                              });
                            },
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
                            onRemoved: () {
                              updateUI(() {
                                //cannot be less than min
                                if (guestData.max > guestData.min) {
                                  guestData.max--;
                                }
                              });
                            },
                          ),
                        ),
                        ShiftCardItem(
                          customWidget: GuestWidget(
                            title: "Current",
                            value: guestData.current,
                            onAdded: () {
                              updateUI(() {
                                //cannot be more than max
                                if (guestData.current < guestData.max) {
                                  guestData.current++;
                                }
                              });
                            },
                            onRemoved: () {
                              updateUI(() {
                                //cannot be less than min
                                if (guestData.current > guestData.min) {
                                  guestData.current--;
                                }
                              });
                            },
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
                            onRemoved: () {
                              updateUI(() {
                                //cannot be less than min
                                if (guestData.bedrooms > 0) {
                                  guestData.bedrooms--;
                                }
                              });
                            },
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
                            onRemoved: () {
                              updateUI(() {
                                //cannot be less than min
                                if (guestData.bathrooms > 0) {
                                  guestData.bathrooms--;
                                }
                              });
                            },
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
                  ],
                ),

                //Team and Guest
                ShiftCard(
                  title: "Team",
                  trailing: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onAddTeamMember,
                      tooltip: "Add Member",
                      color: context.colorScheme.primary,
                      icon: const Icon(Icons.people_alt_rounded)),
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

                //Products data
                ShiftCard(
                  isExpanded: true,
                  title: "Products and services",
                  trailing: SpacedRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefaultDropdown(
                        hasSearchBox: true,
                        items: storageItems
                            .map((e) => DefaultMenuItem(
                                  id: e.id,
                                  title: e.name,
                                  subtitle: e.service ? "Service" : "Product",
                                ))
                            .toList(),
                        onChanged: (value) => onAddProduct(
                            storageItems.firstWhereOrNull(
                                (element) => element.id == value.id)),
                        width: 300,
                        label:
                            'Selected Products: 0', //todo: productData.items.length
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onCreateProduct,
                          tooltip: "Create products and services",
                          color: context.colorScheme.primary,
                          icon: const Icon(Icons.add_shopping_cart_rounded)),
                    ],
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
                          title: "Title",
                          type: PlutoColumnType.text(),
                          field: "title",
                          enableAutoEditing: false,
                          enableEditingMode: false,
                        ),
                        PlutoColumn(
                          title: "Customer's price",
                          type: PlutoColumnType.currency(
                            symbol: appStore
                                .state.generalState.companyInfo.currency.sign,
                          ),
                          field: "price",
                          enableAutoEditing: true,
                          enableEditingMode: true,
                          footerRenderer: (context) {
                            final double total = context.stateManager.rows
                                .where((element) => element.checked ?? false)
                                .map((e) =>
                                    (e.cells["price"]?.value ?? 0) *
                                    (e.cells["quantity"]?.value ?? 0))
                                .fold(0, (a, b) {
                              return a + b;
                            });

                            return Tooltip(
                              message: total.getPriceMap(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                          title: "Quantity",
                          type: PlutoColumnType.number(),
                          field: "quantity",
                          enableAutoEditing: true,
                          enableEditingMode: true,
                        ),
                        //included in service checkbox
                        PlutoColumn(
                          width: 80,
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
                          width: 40,
                          title: "",
                          field: "deleteBtn",
                          enableAutoEditing: false,
                          enableEditingMode: false,
                          type: PlutoColumnType.text(),
                          renderer: (rendererContext) {
                            return Center(
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                color: Theme.of(context).colorScheme.error,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  rendererContext.stateManager
                                      .removeRows([rendererContext.row]);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            );
                          },
                        )
                      ],
                      rows: widget.shiftData?.productData.stateManager?.rows,
                      onLoaded: (event) async {
                        if (productData.stateManager != null) {
                          productStateManager = productData.stateManager!;
                        } else {
                          productStateManager = event.stateManager;
                        }

                        productStateManager.addListener(() {
                          updateUI(() {});
                        });
                      },
                    ))
                  ],
                ),

                //Buttons
                SpacedRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  horizontalSpace: 8,
                  children: [
                    ElevatedButton(
                        onPressed: context.pop, child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: onSave, child: const Text("Save")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PlutoRow buildStorageRow(StorageItemMd storageItem, {bool checked = false}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: storageItem.id),
        "title": PlutoCell(value: storageItem.name),
        "price": PlutoCell(value: storageItem.outgoingPrice),
        "quantity": PlutoCell(value: storageItem.quantity),
        "auto": PlutoCell(value: "Included in service"),
        "deleteBtn": PlutoCell(value: ""),
      },
    );
  }

  Future<void> onSave() async {
    productData.stateManager = productStateManager;
    final int? shiftId = appStore.state.generalState.lists.shifts
        .firstWhereOrNull((element) =>
            element.locationId == addressData.locationId &&
            element.clientId == personalData.clientId)
        ?.id;
    if (shiftId != null) {
      personalData.shiftId = shiftId;
    }

    if (!personalData.isValid(context)) {
      return;
    }
    if (!addressData.isValid(context)) {
      return;
    }
    if (!timingData.isValid(context)) {
      return;
    }
    // if (!productData.isValid(context)) {
    //   return;
    // }
    if (!guestData.isValid(context)) {
      return;
    }

    Future<void> handleJob() async {
      //Check if create
      if (isCreate) {
        //Create Quote
        final quoteId = await dispatch<int>(PostQuoteAction(
            personalData: personalData,
            addressData: addressData,
            timingData: timingData,
            teamData: teamData,
            guestData: guestData,
            quoteData: quoteData,
            productData: productData,
            workAddressData: workAddressData));
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
          context.showError('Failed to create job. ${quoteId.right.message}');
          return;
        }
        //Update
      } else {
        //Update quote status to pending using quoteData.id
        final status = await dispatch<bool>(
            ChangeQuoteStatusAction(id: quoteData.id!, status: "pending"));
        if (status.isLeft) {
          //Success
          //Update quote using quoteData.id
          final quoteId = await dispatch<int>(PostQuoteAction(
              personalData: personalData,
              addressData: addressData,
              timingData: timingData,
              teamData: teamData,
              guestData: guestData,
              quoteData: quoteData,
              productData: productData,
              workAddressData: workAddressData));
          if (quoteId.isLeft && !quoteId.left.isNegative) {
            //Success
            //Change quote status to accept
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
                  context.showError(propertyDetailsUpdated.right.message,
                      onClose: () {
                    context.pop(true);
                  });

                  return;
                }
              }

              context.pop(true);
            } else {
              //Fail
              context.showError('Failed to update job');
              return;
            }
          } else {
            //Fail
            context.showError('Failed to update job');
            return;
          }
        } else {
          //Fail
          context.showError('Failed to update job');
          return;
        }
      }
    }

    Future<void> handleQuote() async {
      //Check if create
      if (isCreate) {
        //Create Quote
        final quoteId = await dispatch<int>(PostQuoteAction(
            personalData: personalData,
            addressData: addressData,
            timingData: timingData,
            teamData: teamData,
            guestData: guestData,
            quoteData: quoteData,
            productData: productData,
            workAddressData: workAddressData));
        //Check response
        if (quoteId.isLeft && !quoteId.left.isNegative) {
          //Success
          context.pop(true);
        } else {
          //Fail
          context.showError('Failed to create quote');
          return;
        }
      } else {
        //Update quote using quoteData.id
        final quoteId = await dispatch<int>(PostQuoteAction(
            personalData: personalData,
            addressData: addressData,
            timingData: timingData,
            teamData: teamData,
            guestData: guestData,
            quoteData: quoteData,
            productData: productData,
            workAddressData: workAddressData));
        if (quoteId.isLeft && !quoteId.left.isNegative) {
          //Success
          context.pop(true);
        } else {
          //Fail
          context.showError('Failed to update quote');
          return;
        }
      }
    }

    ///Steps to create job
    //1. Create quote
    //2. Update quote status to accept
    ///JOB is created

    ///Steps to update job
    //1. Update quote status to pending using quoteData.id
    //2. Update quote using quoteData.id
    //3. Update quote status to accept
    ///JOB is updated

    ///Steps to create quote
    //1. Create quote
    ///QUOTE is created

    ///Steps to update quote
    //1. Update quote using quoteData.id
    ///QUOTE is updated

    //1. Job
    //2. Quote

    await context.futureLoading<void>(() async {
      //Handle Jobs
      if (!isQuote) {
        await handleJob();
        return;
      }

      //Handle Quote
      await handleQuote();
    });
  }
}

Widget label(String text, {bool isRequired = false}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (isRequired)
          const TextSpan(
            text: " *",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
      ]),
    ),
  );
}
