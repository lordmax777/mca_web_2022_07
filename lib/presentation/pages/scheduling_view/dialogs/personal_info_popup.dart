import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/post_client_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';
import 'package:mca_dashboard/utils/utils.dart';

import 'address_popup.dart';

class PersonalInfoPopup extends StatefulWidget {
  final PersonalData? data;

  const PersonalInfoPopup({super.key, this.data});

  @override
  State<PersonalInfoPopup> createState() => _PersonalInfoPopupState();
}

class _PersonalInfoPopupState extends State<PersonalInfoPopup> {
  late PersonalData data;
  late AddressData addressData;
  final _formKey = GlobalKey<FormState>();
  bool deliverDifferentLocation = false;
  String? currentIpAddress;

  @override
  void initState() {
    data = widget.data?.copyWith() ??
        PersonalData(
          email: kDebugMode ? "komiljonovshohjahon@gmai.com" : "",
          phone: kDebugMode ? "998909090909" : "",
          notes: kDebugMode ? "NOTES 123" : "",
          name: kDebugMode ? "shohi" : "",
          companyName: kDebugMode ? "boqivoycorp" : "",
          paymentDays: kDebugMode ? 22 : 0,
        );
    addressData = AddressData(
      city: kDebugMode ? "Tashkent" : "",
      county: kDebugMode ? "Uzbekistan" : "",
      line1: kDebugMode ? "line1" : "",
      line2: kDebugMode ? "line2" : "",
      postcode: kDebugMode ? "100000" : "",
    )
      ..email = data.email
      ..phoneNumber = data.phone;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ipAddress = await getIpAddress();
      if (mounted) {
        setState(() {
          currentIpAddress = ipAddress;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListMd>(
      converter: (store) => store.state.generalState.lists,
      builder: (context, vm) {
        final currencies = [...vm.currencies];
        final paymentMethods = [...vm.paymentMethods];
        return AlertDialog(
          title: const Text('Add Address'),
          scrollable: true,
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                label("Contact Name", isRequired: true),
                DefaultTextField(
                    controller: TextEditingController(text: data.name),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Contact Name is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      data.name = value;
                    },
                    width: double.infinity),
                const SizedBox(height: 8),
                label("Company Name", isRequired: true),
                DefaultTextField(
                    controller: TextEditingController(text: data.companyName),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Company Name is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      data.companyName = value;
                    },
                    width: double.infinity),
                const SizedBox(height: 8),
                label("Phone Number", isRequired: true),
                DefaultTextField(
                    controller: TextEditingController(text: data.phone),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Phone Number is required";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      data.phone = value;
                    },
                    width: double.infinity),
                const SizedBox(height: 8),
                label("Email", isRequired: true),
                DefaultTextField(
                    controller: TextEditingController(text: data.email),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      data.email = value;
                    },
                    width: double.infinity),
                const SizedBox(height: 8),
                label("Payment terms", isRequired: true),
                DefaultTextField(
                    controller: TextEditingController(
                        text: data.paymentDays.toString()),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Payment terms is required";
                      }
                      final value = double.tryParse(p0);
                      if (value != null && value > 31) {
                        return "Payment terms must be less than 31";
                      }
                      if (value != null && value <= 0) {
                        return "Payment terms must be greater than 0";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      data.paymentDays = int.tryParse(value) ?? 0;
                    },
                    width: double.infinity),
                const SizedBox(height: 8),
                label("Currency", isRequired: true),
                DefaultDropdown(
                  width: double.infinity,
                  items: [
                    for (final item in currencies)
                      DefaultMenuItem(
                          id: item.id, title: item.code, subtitle: item.sign),
                  ],
                  onChanged: (value) {
                    final currency = currencies
                        .firstWhereOrNull((element) => element.id == value.id);
                    if (currency != null) {
                      data.currency = currency;
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  valueId: data.currency?.id,
                ),
                const SizedBox(height: 8),
                label("Payment Method", isRequired: true),
                DefaultDropdown(
                  width: double.infinity,
                  items: [
                    for (final item in paymentMethods)
                      DefaultMenuItem(id: item.id, title: item.name),
                  ],
                  onChanged: (value) {
                    final paymentMethod = paymentMethods
                        .firstWhereOrNull((element) => element.id == value.id);
                    if (paymentMethod != null) {
                      data.paymentMethod = paymentMethod;
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  valueId: data.paymentMethod?.id,
                ),
                const SizedBox(height: 8),
                label("Notes"),
                DefaultTextField(
                    controller: TextEditingController(text: data.notes),
                    onChanged: (value) {
                      data.notes = value;
                    },
                    maxLines: 3,
                    width: double.infinity),
                label('Address Search', isRequired: true),
                AddressAutocompleteWidget(
                  width: 400,
                  onSelected: (value) {
                    addressData = value;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 8),
                label('Address Line 1', isRequired: true),
                DefaultTextField(
                  width: 400,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter address line 1';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    addressData.line1 = value;
                  },
                  controller: TextEditingController(text: addressData.line1),
                ),
                const SizedBox(height: 8),
                label('Address Line 2'),
                DefaultTextField(
                  width: 400,
                  onChanged: (value) {
                    addressData.line2 = value;
                  },
                  controller: TextEditingController(text: addressData.line2),
                ),
                const SizedBox(height: 8),
                label('City', isRequired: true),
                DefaultTextField(
                  width: 400,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    addressData.city = value;
                  },
                  controller: TextEditingController(text: addressData.city),
                ),
                const SizedBox(height: 8),
                label('County'),
                DefaultTextField(
                  width: 400,
                  onChanged: (value) {
                    addressData.county = value;
                  },
                  controller: TextEditingController(text: addressData.county),
                ),
                const SizedBox(height: 8),
                label('Post Code', isRequired: true),
                DefaultTextField(
                  width: 400,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter postcode';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    addressData.postcode = value;
                  },
                  controller: TextEditingController(text: addressData.postcode),
                ),
                const SizedBox(height: 8),
                label('Country', isRequired: true),
                DefaultDropdown(
                  width: 400,
                  items: [
                    for (int i = 0; i < vm.countries.length; i++)
                      DefaultMenuItem(
                          id: i,
                          title: vm.countries[i].name,
                          additionalId: vm.countries[i].code)
                  ],
                  hasSearchBox: true,
                  valueAdditionalId: addressData.country?.code,
                  onChanged: (value) {
                    addressData.country = vm.countries[value.id];
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 8),
                label('Service delivered at a different address'),
                DefaultSwitch(
                    value: deliverDifferentLocation,
                    onChanged: (value) {
                      deliverDifferentLocation = value;
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                if (!deliverDifferentLocation) ...[
                  const SizedBox(height: 8),
                  label("Fixed IP Address"),
                  DefaultSwitch(
                      value: addressData.fixedIpAddress,
                      onChanged: (value) {
                        addressData.fixedIpAddress = value;
                        if (mounted) {
                          setState(() {});
                        }
                      }),
                  const SizedBox(height: 8),
                  if (currentIpAddress != null)
                    label('Current IP Address: $currentIpAddress'),
                  const SizedBox(height: 8),
                  if (currentIpAddress != null)
                    ElevatedButton(
                        onPressed: () {
                          addressData.ipAddress = currentIpAddress;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: const Text("Use Current IP Address")),
                  const SizedBox(height: 8),
                  label('IP Address', isRequired: addressData.fixedIpAddress),
                  DefaultTextField(
                    width: 400,
                    maxLines: 4,
                    validator: addressData.fixedIpAddress
                        ? (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter IP address';
                            }
                            return null;
                          }
                        : null,
                    onChanged: (value) {
                      addressData.ipAddress = value;
                    },
                    controller:
                        TextEditingController(text: addressData.ipAddress),
                  ),
                  Text(
                    'Multiple IP addresses can be separated by a comma(,)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                if (data.currency == null) {
                  context.showError('Please select currency');
                  return;
                }
                if (data.paymentMethod == null) {
                  context.showError('Please select payment method');
                  return;
                }
                if (deliverDifferentLocation) {
                  addressData.phoneNumber = data.phone;
                  addressData.email = data.email;

                  //Show address popup
                  final res = await DependencyManager.instance.navigation
                      .showCustomDialog<AddressData?>(
                          context: context,
                          builder: (context) {
                            return AddressPopup(data: addressData);
                          });
                  if (res != null) {
                    //todo: handle res as AddressData
                    final newClient =
                        await createClient(currencies, paymentMethods);
                    if (newClient != null) {
                      //success
                      //find new client
                      //assign to data
                      //close dialog using context.pop(data);
                      addressData = res;
                      data = data.copyFromClient(newClient,
                          currencies: currencies,
                          paymentMethods: paymentMethods);
                      context.pop({"personal": data, "address": addressData});
                    }
                  } else {
                    context.showError('Failed to create address');
                  }
                } else {
                  //todo:handle create client
                  final newClient =
                      await createClient(currencies, paymentMethods);
                  if (newClient != null) {
                    data = data.copyFromClient(newClient,
                        currencies: currencies, paymentMethods: paymentMethods);
                    context.pop({"personal": data});
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<ClientMd?> createClient(
      List<CurrencyMd> currencies, List<PaymentMethodMd> paymentMethods) async {
    final newClient =
        await context.futureLoading<Either<int, ErrorMd>>(() async {
      final newClient =
          await dispatch<int>(PostClientAction(data, addressData: addressData));
      return newClient;
    });
    if (newClient.isLeft) {
      //success
      //find new client
      //assign to data
      //close dialog using context.pop(data);
      final client = appStore.state.generalState.clients
          .firstWhereOrNull((element) => element.id == newClient.left);
      if (client != null) {
        return client;
      } else {
        context.showError('Failed to find new client');
      }
    } else {
      context.showError("Failed to create client ${newClient.right.message}");
    }
  }
}
