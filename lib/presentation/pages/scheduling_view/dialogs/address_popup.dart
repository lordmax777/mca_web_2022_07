import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/utils/utils.dart';

import 'create_schedule_popup.dart';

class AddressPopup extends StatefulWidget {
  final AddressData? data;
  final bool isEditOnly;
  const AddressPopup({super.key, this.data, this.isEditOnly = false});

  @override
  State<AddressPopup> createState() => _AddressPopupState();
}

class _AddressPopupState extends State<AddressPopup> {
  late AddressData data;
  final _formKey = GlobalKey<FormState>();
  String? currentIpAddress;

  bool get isEditOnly => widget.isEditOnly;

  @override
  void initState() {
    data = widget.data?.copyWith(
            // latitude: GlobalConstants.enableLogger ? 1.10 : null,
            // longitude: GlobalConstants.enableLogger ? 1.20 : null,
            ) ??
        AddressData(
            // latitude: GlobalConstants.enableLogger ? 1.10 : null,
            // longitude: GlobalConstants.enableLogger ? 1.20 : null,
            );

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
      builder: (context, vm) => AlertDialog(
        title: Text('${!isEditOnly ? "Add" : "Edit"} Address'),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isEditOnly) ...[
                label('Phone Number'),
                DefaultTextField(
                  width: 400,
                  // validator: (p0) {
                  //   if (p0 == null || p0.isEmpty) {
                  //     return 'Please enter phone number';
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    data.phoneNumber = value;
                  },
                  controller: TextEditingController(text: data.phoneNumber),
                ),
                // Text("Leave blank to use client's phone number",
                //     style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                label('Email'),
                DefaultTextField(
                  width: 400,
                  // validator: (p0) {
                  //   if (p0 == null || p0.isEmpty) {
                  //     return 'Please enter email';
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    data.email = value;
                  },
                  controller: TextEditingController(text: data.email),
                ),
                // Text("Leave blank to use client's email",
                //     style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                label('Address Search', isRequired: true),
                AddressAutocompleteWidget(
                  width: 400,
                  onSelected: (value) {
                    data = value;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 8),
              ],
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
                  data.line1 = value;
                },
                controller: TextEditingController(text: data.line1),
              ),
              const SizedBox(height: 8),
              label('Address Line 2'),
              DefaultTextField(
                width: 400,
                onChanged: (value) {
                  data.line2 = value;
                },
                controller: TextEditingController(text: data.line2),
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
                  data.city = value;
                },
                controller: TextEditingController(text: data.city),
              ),
              const SizedBox(height: 8),
              label('County'),
              DefaultTextField(
                width: 400,
                onChanged: (value) {
                  data.county = value;
                },
                controller: TextEditingController(text: data.county),
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
                  data.postcode = value;
                },
                controller: TextEditingController(text: data.postcode),
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
                valueAdditionalId: data.country?.code,
                onChanged: (value) {
                  data.country = vm.countries[value.id];
                  setState(() {});
                },
              ),
              if (!isEditOnly) ...[
                const SizedBox(height: 8),
                label('Long/Lat', isRequired: true),
                if (data.longitude != null && data.latitude != null)
                  Text(
                    '${data.longitude}, ${data.latitude}',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Text(
                    'Not set. Please select address.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.red),
                  ),
                const SizedBox(height: 8),
                label("Fixed IP Address"),
                DefaultSwitch(
                    value: data.fixedIpAddress,
                    onChanged: (value) {
                      data.fixedIpAddress = value;
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
                        data.ipAddress = currentIpAddress;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: const Text("Use Current IP Address")),
                const SizedBox(height: 8),
                label('IP Address', isRequired: data.fixedIpAddress),
                DefaultTextField(
                  width: 400,
                  maxLines: 4,
                  validator: data.fixedIpAddress
                      ? (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter IP address';
                          }
                          return null;
                        }
                      : null,
                  onChanged: (value) {
                    data.ipAddress = value;
                  },
                  controller: TextEditingController(text: data.ipAddress),
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
            onPressed: isEditOnly
                ? () {
                    context.pop(data);
                  }
                : data.latitude == null || data.longitude == null
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (data.country == null) {
                          context.showError('Please select country');
                          return;
                        }

                        final id = await context.futureLoading(() async {
                          return await dispatch<int>(
                              PostLocationAction(addressData: data));
                        });
                        if (id.isLeft) {
                          final item = appStore.state.generalState.locations
                              .firstWhereOrNull(
                                  (element) => element.id == id.left);
                          if (item != null) {
                            data.line1 = item.address.line1;
                            data.line2 = item.address.line2;
                            data.city = item.address.city;
                            data.county = item.address.county;
                            data.country =
                                item.address.getCountryMd(vm.countries);
                            data.postcode = item.address.postcode;
                            data.email = item.email;
                            data.phoneNumber = item.phone.mobile;
                            data.longitude = item.address.longitude?.toDouble();
                            data.latitude = item.address.latitude?.toDouble();
                            data.locationId = item.id;
                            context.pop(data);
                          } else {
                            context.showError('Something went wrong');
                          }
                        } else {
                          if (id.right.code == 409) {
                            final item = appStore.state.generalState.locations
                                .firstWhereOrNull(
                                    (element) => element.id == id.right.data);
                            if (item != null) {
                              data.line1 = item.address.line1;
                              data.line2 = item.address.line2;
                              data.city = item.address.city;
                              data.county = item.address.county;
                              data.country =
                                  item.address.getCountryMd(vm.countries);
                              data.postcode = item.address.postcode;
                              data.email = item.email;
                              data.phoneNumber = item.phone.mobile;
                              data.longitude =
                                  item.address.longitude?.toDouble();
                              data.latitude = item.address.latitude?.toDouble();
                              data.locationId = item.id;
                              context.pop(data);
                            }
                          } else {
                            context.showError(
                                'Cannot create location! ${id.right.message}');
                          }
                        }
                      },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
