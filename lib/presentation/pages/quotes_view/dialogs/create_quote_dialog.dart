import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../scheduling_view/data/week_days_m.dart';

class CreateQuoteDialog extends StatefulWidget {
  final UserMd? userResource;
  final PropertyMd? propertyResource;
  final DateTime? selectedDate;
  final AllocationMd? allocation;

  const CreateQuoteDialog(
      {super.key,
      this.selectedDate,
      this.propertyResource,
      this.userResource,
      this.allocation});

  @override
  State<CreateQuoteDialog> createState() => _CreateQuoteDialogState();
}

class _CreateQuoteDialogState extends State<CreateQuoteDialog> {
  final _dependencies = DependencyManager.instance;

  UserMd? get userResource => widget.userResource;
  PropertyMd? get propertyResource => widget.propertyResource;
  DateTime? get selectedDate => widget.selectedDate;
  AllocationMd? get allocation => widget.allocation;

  bool get isCreate => allocation == null;

  // //Getters
  // PersonalData get personalData => shiftData.personalData;
  //
  // AddressData get addressData => shiftData.addressData;
  //
  // AddressData? get workAddressData => shiftData.workAddressData;
  //
  // TimeData get timingData => shiftData.timeData;
  //
  // TeamData get teamData => shiftData.teamData;
  //
  // GuestData get guestData => shiftData.guestData;
  //
  // QuoteData get quoteData => shiftData.quoteData;
  //
  // ProductData get productData => shiftData.productData;

  //Variables
  // late ShiftData shiftData;
  // late final bool isQuote;
  // late final PlutoGridStateManager productStateManager;
  final List<UserMd> unavailableUsers = [];

  void updateUI(VoidCallback? callback) {
    if (mounted) {
      setState(callback ?? () {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          //todo: init
        }
      },
    );
  }

  final formVm = FormModel();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
      converter: (store) => store.state.generalState,
      builder: (context, vm) {
        final List<ClientMd> clients =
            [...vm.clients].where((element) => element.active).toList();

        final ClientMd? client = clients.firstWhereOrNull(
            (element) => element.id.toString() == formVm.value['client']);

        final LocationMd? workLocation = vm.locations.firstWhereOrNull(
            (element) =>
                element.id.toString() == formVm.value['workLocationId']);

        final QuoteMd? quote = vm.quotes.firstWhereOrNull(
            (element) => element.id.toString() == formVm.value['quoteId']);

        final List<LocationMd> locations = [
          ...vm.clientBasedFullLocations(client?.id)
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
        final jobTemplates = [...vm.jobTemplates];

        final containerWidth = context.width * .2;

        return SizedBox(
          height: context.height * 1.2,
          width: context.width,
          child: SingleChildScrollView(
              child: DefaultForm(
            vm: formVm,
            child: FormWrap(
              children: [
                // Quote and Client
                SpacedColumn(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 20,
                  children: [
                    FormContainer(
                      title: "Quote Details",
                      width: containerWidth,
                      left: <Widget>[
                        FormWithLabel(
                            labelVm: const LabelModel(text: "Quote"),
                            formBuilderField: FormDropdown(
                              vm: DropdownModel(
                                  name: "quoteId",
                                  hasSearchBox: true,
                                  onChanged: (p0) {
                                    final quote = vm.quotes.firstWhereOrNull(
                                        (element) =>
                                            element.id.toString() == p0);
                                    formVm.formKey.currentState?.patchValue({
                                      "quoteName": quote?.name,
                                      "quoteComment": quote?.notes,
                                      "quoteStatus": quote?.processStatus,
                                      //todo: ask imre
                                      "quoteNextScheduledDate": null,
                                      "quoteRepeatId": quote
                                          ?.workRepeatMd(vm.lists.workRepeats)
                                          ?.id
                                          .toString(),
                                      "quoteJobTitle": quote?.name,
                                    });
                                    formVm.save();
                                    updateUI(() {});
                                  },
                                  items: vm.quotes
                                      .map((e) => DpItem(
                                          id: e.id.toString(),
                                          title: e.name,
                                          subtitle: e.company))
                                      .toList()),
                            )),
                        const FormWithLabel(
                            labelVm:
                                LabelModel(text: "Job Title", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                                    name: "quoteName",
                                    helperText:
                                        "Leave empty to use default name\nDefault name is used from company settings"))),

                        const FormWithLabel(
                            labelVm: LabelModel(text: "Status"),
                            formBuilderField: FormInput(
                                vm: InputModel(
                                    name: "quoteStatus", readOnly: true))),
                        //next scheduled date
                        // todo: ask imre
                        const FormWithLabel(
                            labelVm: LabelModel(text: 'Next Scheduled Date'),
                            formBuilderField: FormDatePicker(
                                vm: DatePickerModel(
                                    name: "quoteNextScheduledDate"))),
                        //repeat days
                        FormWithLabel(
                            labelVm: const LabelModel(text: "Repeat Days"),
                            formBuilderField: FormDropdown(
                              vm: DropdownModel(
                                name: "quoteRepeatId",
                                onChanged: (p0) {
                                  formVm.save();
                                  updateUI(() {});
                                },
                                items: vm.lists.workRepeats
                                    .map((e) => DpItem(
                                        id: e.id.toString(), title: e.name))
                                    .toList(),
                              ),
                            )),
                        if (formVm.value['quoteRepeatId'] == "1" ||
                            formVm.value['quoteRepeatId'] == "2" ||
                            formVm.value['quoteRepeatId'] == null)
                          const SizedBox()
                        else
                          FormWithLabel(
                              labelVm: const LabelModel(
                                  text: "Unavailable days", isRequired: true),
                              formBuilderField: FormCheckbox(
                                vm: CheckboxModel(
                                    name: "quoteUnavailableDays",
                                    onChanged: print,
                                    //at least 1 day is required
                                    validator: FormBuilderValidators.maxLength(
                                        6,
                                        errorText:
                                            "At least 1 day must be available"),
                                    helperText:
                                        "Select the days when the shift is unavailable",
                                    items: WeekDaysMd()
                                        .asMap
                                        .entries
                                        .map((e) => DpItem(
                                            id: e.key.toString(),
                                            title: e.key.toString()))
                                        .toList()),
                              )),
                        const FormSwitch(
                            vm: SwitchModel(
                                name: "quoteActive", title: "Active")),
                        const FormWithLabel(
                            labelVm: LabelModel(text: "Comment"),
                            formBuilderField: FormInput(
                                vm: InputModel(
                                    name: "quoteComment",
                                    helperText:
                                        "Press ENTER to add new line"))),
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable: formVm.isValidFormNotifier,
                        builder: (context, value, child) => FormContainer(
                              width: containerWidth,
                              title: "Client Details",
                              trailing: IconButton(
                                  onPressed: formVm.value['client'] == null
                                      ? null
                                      : () async {},
                                  icon: const Icon(Icons.edit)),
                              left: [
                                FormWithLabel(
                                    labelVm: const LabelModel(
                                        text: "Client", isRequired: true),
                                    formBuilderField: FormDropdown(
                                        vm: DropdownModel(
                                            name: "client",
                                            onChanged: (p0) {
                                              formVm.save();
                                              updateUI(() {});
                                            },
                                            hasSearchBox: true,
                                            items: clients
                                                .map((e) => DpItem(
                                                    id: e.id.toString(),
                                                    title: e.name,
                                                    subtitle: e.company))
                                                .toList()))),
                              ],
                              additionalText: "Show Client Details",
                              hidden: client != null
                                  ? [
                                      FormWithLabel(
                                        labelVm:
                                            const LabelModel(text: "Company"),
                                        formBuilderField:
                                            buildText(client.company ?? "-"),
                                      ),
                                      FormWithLabel(
                                        labelVm:
                                            const LabelModel(text: "Email"),
                                        formBuilderField:
                                            buildText(client.email ?? "-"),
                                      ),
                                      FormWithLabel(
                                        labelVm:
                                            const LabelModel(text: "Phone"),
                                        formBuilderField:
                                            buildText(client.phone ?? "-"),
                                      ),
                                    ]
                                  : [],
                            )),
                  ],
                ),
                //Invoice address
                FormContainer(
                    title: "Invoice Address",
                    width: containerWidth,
                    left: [
                      FormWithLabel(
                          labelVm: const LabelModel(text: "Line 1"),
                          formBuilderField:
                              buildText(client?.address.line1 ?? "-")),
                      FormWithLabel(
                          labelVm: const LabelModel(text: "Line 2"),
                          formBuilderField:
                              buildText(client?.address.line2 ?? "-")),
                      FormWithLabel(
                          labelVm: const LabelModel(text: "City"),
                          formBuilderField:
                              buildText(client?.address.city ?? "-")),
                      FormWithLabel(
                          labelVm: const LabelModel(text: "Postcode"),
                          formBuilderField:
                              buildText(client?.address.postcode ?? "-")),
                      FormWithLabel(
                          labelVm: const LabelModel(text: "Country"),
                          formBuilderField: buildText(client?.address
                                  .getCountryMd(vm.lists.countries)
                                  ?.name ??
                              "-")),
                    ]),
                //Work address
                FormContainer(
                    title: "Work Address",
                    width: containerWidth,
                    left: [
                      if (client != null && locations.isNotEmpty)
                        FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Locations", isRequired: true),
                            formBuilderField: FormDropdown(
                                vm: DropdownModel(
                                    onChanged: (p0) => updateUI(formVm.save),
                                    name: "workLocationId",
                                    items: locations
                                        .map((e) => DpItem(
                                            id: e.id.toString(), title: e.name))
                                        .toList())))
                      else
                        Text(
                            "No locations found. Please select client with location!",
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge),
                      const FormWithLabel(
                          labelVm: LabelModel(text: "Line 1"),
                          formBuilderField:
                              FormInput(vm: InputModel(name: "workLine1"))),
                      const FormWithLabel(
                          labelVm: LabelModel(text: "Line 2"),
                          formBuilderField:
                              FormInput(vm: InputModel(name: "workLine2"))),
                      const FormWithLabel(
                          labelVm: LabelModel(text: "City"),
                          formBuilderField:
                              FormInput(vm: InputModel(name: "workCity"))),
                      const FormWithLabel(
                          labelVm: LabelModel(text: "Postcode"),
                          formBuilderField:
                              FormInput(vm: InputModel(name: "workPostcode"))),
                      FormWithLabel(
                          labelVm: const LabelModel(
                              text: "Country", isRequired: true),
                          formBuilderField: FormDropdown(
                            vm: DropdownModel(
                              name: "workCountryId",
                              items: vm.lists.countries
                                  .map((e) => DpItem(id: e.code, title: e.name))
                                  .toList(),
                            ),
                          )),
                    ]),
                //Timing
                FormContainer(
                  title: "Timing",
                  width: containerWidth,
                  left: [
                    const FormWithLabel(
                        labelVm: LabelModel(text: "Start Time"),
                        formBuilderField: FormDatePicker(
                            vm: DatePickerModel(
                                name: "startTime", type: InputType.time))),
                    const FormWithLabel(
                        labelVm: LabelModel(text: "End Time"),
                        formBuilderField: FormDatePicker(
                            vm: DatePickerModel(
                                name: "endTime", type: InputType.time))),
                    FormSwitch(
                        vm: SwitchModel(
                      name: "allDay",
                      title: "All Day",
                      onChanged: (value) {
                        if (value == true) {
                          formVm.formKey.currentState?.patchValue({
                            "startTime": DateTime(2021, 1, 1, 0, 0),
                            "endTime": DateTime(2021, 1, 1, 23, 59),
                          });
                        } else {
                          formVm.formKey.currentState?.patchValue({
                            "startTime": null,
                            "endTime": null,
                          });
                        }
                      },
                    )),
                    //repeat days
                    FormWithLabel(
                        labelVm: const LabelModel(text: "Repeat Frequency"),
                        formBuilderField: FormDropdown(
                          vm: DropdownModel(
                            name: "timingRepeatId",
                            onChanged: (p0) {
                              formVm.save();
                              updateUI(() {});
                            },
                            items: vm.lists.workRepeats
                                .map((e) =>
                                    DpItem(id: e.id.toString(), title: e.name))
                                .toList(),
                          ),
                        )),
                    if (formVm.value['timingRepeatId'] == "1" ||
                        formVm.value['timingRepeatId'] == "2" ||
                        formVm.value['timingRepeatId'] == null)
                      const SizedBox()
                    else
                      FormWithLabel(
                          labelVm: const LabelModel(
                              text: "Unavailable days", isRequired: true),
                          formBuilderField: FormCheckbox(
                            vm: CheckboxModel(
                                name: "timingUnavailableDays",
                                onChanged: print,
                                //at least 1 day is required
                                validator: FormBuilderValidators.maxLength(6,
                                    errorText:
                                        "At least 1 day must be available"),
                                helperText:
                                    "Select the days when the shift is unavailable",
                                items: WeekDaysMd()
                                    .asMap
                                    .entries
                                    .map((e) => DpItem(
                                        id: e.key.toString(),
                                        title: e.key.toString()))
                                    .toList()),
                          )),
                  ],
                )
              ],
            ),
          )),
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

  Future<void> emailQuoteToClient(int quoteId) async {
    //Success
    bool sendEmail = false;
    final bool exitWithEmail = await context.showDialog(
        barrierDismissible: false,
        AlertDialog(
          title: const Text("Saved Successfully"),
          content: StatefulBuilder(builder: (context, ss) {
            return DefaultCheckbox(
              value: sendEmail,
              label: 'Email Quote to Client',
              onChanged: (value) {
                ss(() {
                  sendEmail = value;
                });
              },
            );
          }),
          actions: [
            TextButton(
                onPressed: () {
                  context.pop(sendEmail);
                },
                child: const Text("Ok"))
          ],
        ));
    if (exitWithEmail) {
      await context.futureLoading(() async {
        await dispatch<bool>(SendQuoteEmailAction(quoteId));
      });
    }
  }

  Widget buildText(String text) {
    return FormInput(
      vm: InputModel(
        name: "name$text",
        initialValue: text,
        readOnly: true,
      ),
    );
  }
}
