import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'controllers/new_location_controller.dart';

class NewLocationPage extends StatelessWidget {
  const NewLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NewLocationController());
    return GetBuilder<NewLocationController>(
      dispose: (state) => state.controller!.onPop(),
      builder: (controller) => PageWrapper(
          child: SpacedColumn(
        verticalSpace: 16.0,
        children: [
          PageGobackWidget(
              text: controller.isUpdate
                  ? controller.nameController.text
                  : "New Location"),
          const TableWrapperWidget(child: _GeneralWidget()),
        ],
      )),
    );
  }
}

class _GeneralWidget extends StatelessWidget {
  const _GeneralWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpandableTabBar(
      saveText: NewLocationController.to.isUpdate
          ? 'Update Location'
          : 'Create Location',
      onSave: NewLocationController.to.onSave,
      expandedWidgetList: [
        ExpandedWidgetType(
            title: _GeneralInfoWidget.title,
            child: const _GeneralInfoWidget(),
            initExpanded: true),
        ExpandedWidgetType(
            title: _ContactWidget.title, child: const _ContactWidget()),
        ExpandedWidgetType(
            title: _AddressWidget.title, child: const _AddressWidget()),
        ExpandedWidgetType(title: _GpsWidget.title, child: const _GpsWidget()),
      ],
    );
  }
}

class _GeneralInfoWidget extends StatelessWidget {
  static const String title = "General";

  const _GeneralInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double dpWidth = 344;

    return GBuilder<NewLocationController>(
      tag: _GeneralInfoWidget.title,
      autoRemove: false,
      child: (controller) {
        return Form(
            key: controller.generalFormKey,
            child: SpacedColumn(
                verticalSpace: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacedRow(
                    horizontalSpace: 40,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextInputWidget(
                        width: dpWidth,
                        controller: controller.nameController,
                        isRequired: true,
                        labelText: "Location Name",
                        validator: (p0) {
                          if (p0 != null && p0.isEmpty) {
                            return "Location Name is required";
                          }
                          return null;
                        },
                      ),
                      DropdownWidget1<MapEntry<bool, String>>(
                        hintText: "Status",
                        dropdownBtnWidth: dpWidth,
                        isRequired: true,
                        value: controller.status.name,
                        dropdownOptionsWidth: dpWidth,
                        objItems:
                            Constants.userAccountStatusTypes.entries.toList(),
                        onChangedWithObj: controller.onStatusChange,
                        items: Constants.userAccountStatusTypes.entries
                            .map((e) => e.value)
                            .toList(),
                      ),
                    ],
                  ),
                  _check(controller.isAnywhere, controller.onAnywhereChange,
                      "Anywhere"),
                  const SizedBox(height: 8.0),
                  KText(
                      fontWeight: FWeight.bold,
                      fontSize: 14.0,
                      textColor: ThemeColors.gray2,
                      text:
                          'Current IP Address: ${controller.ipAddress}'), //TODO: NEED TO FIND THE CURRENT IP ADDRESS
                  SpacedColumn(
                    verticalSpace: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputWidget(
                        width: dpWidth,
                        labelText: "IP Address(es)",
                        maxLines: 5,
                        isRequired: !controller.isAnywhere ||
                            controller.isFixedIpAddress,
                        controller: controller.ipAddressesController,
                      ),
                      KText(
                          fontWeight: FWeight.medium,
                          fontSize: 12.0,
                          textColor: ThemeColors.gray8,
                          isSelectable: false,
                          text:
                              'Multiple IP addresses can be separated by a comma(,)'),
                      _check(controller.isFixedIpAddress,
                          controller.onFixedIpChange, "Fixed IP Address"),
                    ],
                  ),
                ]));
      },
    );
  }

  Widget _check(bool value, ValueChanged<bool?> onChanged, String text) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      horizontalSpace: 8.0,
      children: [
        CheckboxWidget(
          value: value,
          onChanged: onChanged,
        ),
        KText(
          text: text,
          fontWeight: FWeight.bold,
          fontSize: 14.0,
          textColor: ThemeColors.gray2,
          isSelectable: false,
        )
      ],
    );
  }
}

class _ContactWidget extends StatelessWidget {
  static const String title = "Contact Details";
  const _ContactWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return GBuilder<NewLocationController>(
      tag: _ContactWidget.title,
      autoRemove: false,
      child: (controller) => Form(
          key: controller.contactFormKey,
          child: SpacedColumn(
              verticalSpace: 32.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0.1),
                TextInputWidget(
                  width: dpWidth,
                  controller: controller.emailController,
                  labelText: "Email Address",
                  isRequired: controller.isSendChecklist,
                  validator: (p0) {
                    if (p0 != null && p0.isEmpty) {
                      return "Email Address is required";
                    }
                    if (p0 != null && !p0.isEmail) {
                      return "Email Address is invalid";
                    }
                    return null;
                  },
                ),
                TextInputWidget(
                  width: dpWidth,
                  controller: controller.phoneController,
                  labelText: "Phone Number",
                  disableAll: controller.isAnywhere,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.setOneContactIsOpen = 0;
                      return;
                    }
                    controller.setOneContactIsOpen = 1;
                  },
                  isRequired: controller.oneContactIsOpen == 1 ||
                      controller.oneContactIsOpen == 0,
                  validator: (p0) {
                    if (p0 != null && p0.isEmpty) {
                      return "Phone Number is required";
                    }
                    if (p0 != null && !p0.isPhoneNumber) {
                      return "Phone Number is invalid";
                    }
                    return null;
                  },
                ),
                TextInputWidget(
                  width: dpWidth,
                  controller: controller.landlineController,
                  labelText: "Phone Landline",
                  disableAll: controller.isAnywhere,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.setOneContactIsOpen = 0;
                      return;
                    }
                    controller.setOneContactIsOpen = 2;
                  },
                  isRequired: controller.oneContactIsOpen == 2 ||
                      controller.oneContactIsOpen == 0,
                  validator: (p0) {
                    if (p0 != null && p0.isEmpty) {
                      return "Phone Landline is required";
                    }
                    if (p0 != null && !p0.isPhoneNumber) {
                      return "Phone Landline is invalid";
                    }
                    return null;
                  },
                ),
                TextInputWidget(
                  width: dpWidth,
                  controller: controller.faxController,
                  labelText: "Fax Number",
                  disableAll: controller.isAnywhere,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.setOneContactIsOpen = 0;
                      return;
                    }
                    controller.setOneContactIsOpen = 3;
                  },
                  isRequired: controller.oneContactIsOpen == 3 ||
                      controller.oneContactIsOpen == 0,
                  validator: (p0) {
                    if (p0 != null && p0.isEmpty) {
                      return "Fax Number is required";
                    }
                    return null;
                  },
                ),
                if (!controller.isUpdate)
                  _check(controller.isSendChecklist,
                      controller.onSendChecklistChange, "Send Checklist"),
              ])),
    );
  }

  Widget _check(bool value, ValueChanged<bool?> onChanged, String text) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      horizontalSpace: 8.0,
      children: [
        CheckboxWidget(
          value: value,
          onChanged: onChanged,
        ),
        KText(
          text: text,
          fontWeight: FWeight.bold,
          fontSize: 14.0,
          textColor: ThemeColors.gray2,
          isSelectable: false,
        )
      ],
    );
  }
}

class _AddressWidget extends StatelessWidget {
  static const String title = "Address Details";
  const _AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final general = state.generalState.paramList.data!;
          return GBuilder<NewLocationController>(
              autoRemove: false,
              tag: _AddressWidget.title,
              child: (controller) {
                return Form(
                  key: controller.addressFormKey,
                  child: SpacedRow(horizontalSpace: 24.0, children: [
                    SpacedColumn(
                        verticalSpace: 32.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 0.1),
                          SpacedRow(
                            horizontalSpace: dpWidth / 3.8,
                            children: [
                              TextInputWidget(
                                disableAll: controller.isAnywhere,
                                width: (dpWidth * 1.7),
                                labelText: "Street Address",
                                validator: (p0) {
                                  if (p0!.isEmpty) {
                                    return "Street Address is required";
                                  }
                                  return null;
                                },
                                isRequired: controller.isAnywhere,
                                controller: controller.streetController,
                              ),
                              TextInputWidget(
                                disableAll: controller.isAnywhere,
                                width: dpWidth / 1.5,
                                labelText: "Post Code",
                                isRequired: controller.isAnywhere,
                                validator: (p0) {
                                  if (p0!.isEmpty) {
                                    return "Post Code is required";
                                  }
                                },
                                controller: controller.postCodeController,
                              ),
                            ],
                          ),
                          SpacedRow(horizontalSpace: dpWidth / 3.8, children: [
                            TextInputWidget(
                              disableAll: controller.isAnywhere,
                              width: dpWidth / 1.4,
                              labelText: "City/Town",
                              isRequired: controller.isAnywhere,
                              validator: (p0) {
                                if (p0!.isEmpty) {
                                  return "City/Town is required";
                                }
                              },
                              controller: controller.cityController,
                            ),
                            TextInputWidget(
                              disableAll: controller.isAnywhere,
                              width: dpWidth / 1.4,
                              labelText: "County",
                              controller: controller.countyController,
                            ),
                          ]),
                          DropdownWidget1(
                            disableAll: controller.isAnywhere,
                            hintText: "Country",
                            dropdownMaxHeight: 400.0,
                            dropdownBtnWidth: (dpWidth * 1.7),
                            dropdownOptionsWidth: (dpWidth * 2) + 24.0,
                            value: controller.country.name,
                            hasSearchBox: true,
                            isRequired: controller.isAnywhere,
                            onChangedWithObj: controller.onCountryChange,
                            objItems: general.countries,
                            items:
                                general.countries.map((e) => e.name).toList(),
                          ),
                        ])
                  ]),
                );
              });
        });
  }
}

class _GpsWidget extends StatelessWidget {
  static const String title = "GPS Position";

  const _GpsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return GBuilder<NewLocationController>(
            autoRemove: false,
            tag: _GpsWidget.title,
            child: (controller) => Form(
                key: controller.gpsFormKey,
                child: SpacedColumn(
                    verticalSpace: 32.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalSpace: 8.0,
                        children: [
                          ButtonMedium(
                            text: "Lookup GPS Coordinates",
                            icon: const HeroIcon(
                              HeroIcons.location,
                              size: 20,
                            ),
                            onPressed: controller.onGpsLookupPress,
                          ),
                          SizedBox(
                              width: 250,
                              child: KText(
                                  fontWeight: FWeight.medium,
                                  isSelectable: false,
                                  fontSize: 12,
                                  textColor: controller.isPostCodeError
                                      ? ThemeColors.red3
                                      : ThemeColors.gray8,
                                  text:
                                      'In order to lookup GPS coordinates, you will need to provide a postcode.')),
                        ],
                      ),
                      TextInputWidget(
                        width: dpWidth,
                        controller: controller.radiusController,
                        labelText: "Radius (Metres)",
                      ),
                      TextInputWidget(
                        width: dpWidth,
                        controller: controller.latitudeController,
                        labelText: "Latitude",
                      ),
                      TextInputWidget(
                        width: dpWidth,
                        controller: controller.longitudeController,
                        labelText: "Longitude",
                      ),
                    ])),
          );
        });
  }
}
