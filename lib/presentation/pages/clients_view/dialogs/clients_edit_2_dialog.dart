import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';

class ClientsEdit2Dialog extends StatefulWidget {
  final ClientMd? client;
  const ClientsEdit2Dialog({super.key, this.client});

  @override
  State<ClientsEdit2Dialog> createState() => _ClientsEdit2DialogState();
}

class _ClientsEdit2DialogState extends State<ClientsEdit2Dialog> {
  ClientMd? get client => widget.client;
  bool get isNew => client == null;

  final lists = appStore.state.generalState.lists;

  final formVm = FormModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isNew) init();
    });
  }

  void init() {
    final c = client!;
    formVm.formKey.currentState?.patchValue({
      "name": c.name,
      "company": c.company,
      "email": c.email,
      "phone": c.phone,
      "fax": c.fax,
      "addressLine1": c.address.line1,
      "addressLine2": c.address.line2,
      "addressCity": c.address.city,
      "addressCounty": c.address.county,
      "addressPostcode": c.address.postcode,
      "country": c.address.country,
      "currencyId": c.currencyId,
      "paymentMethodId": c.paymentMethodId,
      "invoicePeriodId": c.invoicePeriodId,
      "paymentDays": c.payingDays.toString(),
      "invoiceDay": c.invoiceDay.toString(),
      "comment": c.notes,
      "active": c.active,
      "combineInvoices": c.combineInvoices,
      "sendInvoices": c.sendInvoices,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = context.width * .3;
    return AlertDialog(
        scrollable: true,
        content: SizedBox(
          height: context.height * 1.2,
          width: context.width * .7,
          child: DefaultForm(
            vm: formVm,
            child: FormWrap(
              children: [
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  verticalSpace: 20,
                  children: [
                    FormContainer(
                      width: containerWidth,
                      title: "Personal Info",
                      left: [
                        FormWithLabel(
                          labelVm:
                              const LabelModel(text: "Name", isRequired: true),
                          formBuilderField: FormInput(
                              vm: InputModel(
                            name: "name",
                            validators: [FormBuilderValidators.required()],
                          )),
                        ),
                      ],
                      hidden: [
                        const FormWithLabel(
                          labelVm: LabelModel(text: "Company"),
                          formBuilderField: FormInput(
                              vm: InputModel(
                            name: "company",
                          )),
                        ),
                        //email
                        FormWithLabel(
                          labelVm: const LabelModel(text: "Email"),
                          formBuilderField: FormInput(
                              vm: InputModel(
                            hintText: "example@mail.com",
                            name: "email",
                            validators: [FormBuilderValidators.email()],
                          )),
                        ),
                        //phone
                        FormWithLabel(
                          labelVm: const LabelModel(text: "Phone"),
                          formBuilderField: FormInput(
                              vm: InputModel(
                            name: "phone",
                            valueTransformer: (value) =>
                                num.tryParse(value ?? ""),
                            validators: [
                              FormBuilderValidators.numeric(
                                  errorText: "Phone must be a number")
                            ],
                            inputFormatters: [
                              GlobalConstants.numbersOnlyFormatter
                            ],
                          )),
                        ),
                        //fax
                        FormWithLabel(
                          labelVm: const LabelModel(text: "Fax"),
                          formBuilderField: FormInput(
                              vm: InputModel(
                            name: "fax",
                            valueTransformer: (value) =>
                                num.tryParse(value ?? ""),
                            validators: [
                              FormBuilderValidators.numeric(
                                  errorText: "Fax must be a number")
                            ],
                            inputFormatters: [
                              GlobalConstants.numbersOnlyFormatter
                            ],
                          )),
                        ),
                      ],
                    ),
                    FormContainer(
                      title: "Address",
                      width: containerWidth,
                      left: [
                        FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Line 1", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "addressLine1",
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                            ))),
                        FormWithLabel(
                            labelVm: const LabelModel(
                                text: "City", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "addressCity",
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                            ))),
                        FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Country", isRequired: true),
                            formBuilderField: FormDropdown(
                                vm: DropdownModel(
                                    name: "country",
                                    items: lists.countries
                                        .map((e) =>
                                            DpItem(id: e.code, title: e.name))
                                        .toList(),
                                    validator: FormBuilderValidators.required(),
                                    hasSearchBox: true,
                                    hintText: ""))),
                        FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Postcode", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "addressPostcode",
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                            ))),
                      ],
                      hidden: const [
                        FormWithLabel(
                            labelVm: LabelModel(text: "Line 2"),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "addressLine2",
                            ))),
                        FormWithLabel(
                            labelVm: LabelModel(text: "County"),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "addressCounty",
                            ))),
                      ],
                    )
                  ],
                ),
                FormContainer(
                  width: containerWidth,
                  title: "Payment Info",
                  left: [
                    FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Currency", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "currencyId",
                          items: lists.currencies
                              .map((e) => DpItem(
                                  id: e.id.toString(),
                                  title: e.code,
                                  subtitle: e.sign))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                        ))),
                    FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Payment Method", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "paymentMethodId",
                          items: lists.paymentMethods
                              .map((e) =>
                                  DpItem(id: e.id.toString(), title: e.name))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                        ))),
                    FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Invoice Period", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "invoicePeriodId",
                          items: lists.invoicePeriods
                              .map((e) =>
                                  DpItem(id: e.id.toString(), title: e.name))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                        ))),
                    FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Paying Days", isRequired: true),
                        formBuilderField: FormInput(
                            vm: InputModel(
                          name: "paymentDays",
                          valueTransformer: (value) =>
                              num.tryParse(value ?? ""),
                          hintText: "1",
                          validators: [FormBuilderValidators.required()],
                        ))),
                    FormWithLabel(
                        labelVm: const LabelModel(text: "Invoice Day"),
                        formBuilderField: FormInput(
                            vm: InputModel(
                          name: "invoiceDay",
                          valueTransformer: (value) =>
                              num.tryParse(value ?? ""),
                          validators: [
                            (value) {
                              if (formVm.value['invoicePeriodId'] == null) {
                                return null;
                              }
                              if (formVm.value['invoicePeriodId'] == "1" ||
                                  formVm.value['invoicePeriodId'] == "2") {
                                return null;
                              }
                              return "Invoice day is required";
                            }
                          ],
                        ))),
                  ],
                  hidden: const [
                    FormWithLabel(
                        labelVm: LabelModel(text: "Comment"),
                        formBuilderField: FormInput(
                            vm: InputModel(
                                name: "comment", hintText: "no comment"))),
                    FormSwitch(
                        vm: SwitchModel(name: "active", title: "Active")),
                    FormSwitch(
                        vm: SwitchModel(
                            name: "combineInvoices",
                            title: "Combine Invoices")),
                    FormSwitch(
                        vm: SwitchModel(
                            name: "sendInvoices", title: "Send Invoices")),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          //Cancel
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.secondary),
              onPressed: () {
                context.pop();
              },
              child: const Text("Cancel")),
          //Submit
          if (GlobalConstants.isDemoMode)
            ElevatedButton(
                onPressed: () => onSubmit(saveAsNew: true),
                child: const Text("Save as new")),
          ElevatedButton(onPressed: onSubmit, child: const Text("Submit")),
        ],
        title: Text("${isNew ? "Add" : "Edit"} Client"));
  }

  void onSubmit({bool saveAsNew = false}) async {
    formVm.saveAndValidate();
    if (!formVm.isValid) return;

    final res = await context.futureLoading(() async {
      final name = formVm.value['name'];
      final company = formVm.value['company'];
      final email = formVm.value['email'];
      final phone = formVm.value['phone'];
      final fax = formVm.value['fax'];
      final address1 = formVm.value['addressLine1'];
      final address2 = formVm.value['addressLine2'];
      final city = formVm.value['addressCity'];
      final county = formVm.value['addressCounty'];
      final postcode = formVm.value['addressPostcode'];
      final country = formVm.value['country'];
      final currency = formVm.value['currencyId'];
      final paymentMethod = formVm.value['paymentMethodId'];
      final invoicePeriod = formVm.value['invoicePeriodId'];
      final paymentDue = formVm.value['paymentDays'];
      final invoiceDay = formVm.value['invoiceDay'];
      final comment = formVm.value['comment'];
      final isSendInvoices = formVm.value['sendInvoices'] ?? false;
      final isCombineInvoices = formVm.value['combineInvoices'] ?? false;
      final isActive = formVm.value['active'] ?? false;
      print(invoiceDay.runtimeType);
      return await dispatch<int>(PostClientAction(
        PersonalData(
          clientId: saveAsNew ? null : client?.id,
          name: name,
          phone: phone.toString(),
          email: email,
          fax: fax?.toString(),
          invoicePeriod: lists.invoicePeriods.firstWhereOrNull(
              (element) => element.id == int.tryParse(invoicePeriod ?? "")),
          invoiceDay: invoiceDay,
          paymentDays: paymentDue,
          sendInvoices: isSendInvoices,
          combineInvoices: isCombineInvoices,
          companyName: company,
          currency: lists.currencies.firstWhereOrNull(
              (element) => element.id == int.tryParse(currency ?? "")),
          notes: comment,
          paymentMethod: lists.paymentMethods.firstWhereOrNull(
              (element) => element.id == int.tryParse(paymentMethod ?? "")),
          active: isActive,
        ),
        addressData: AddressData(
          line1: address1,
          line2: address2,
          city: city,
          county: county,
          country: lists.countries
              .firstWhereOrNull((element) => element.code == country),
          postcode: postcode,
        ),
      ));
    });
    if (res.isRight) {
      context.showError(res.right.message);
      return;
    }
    context.pop(res.isLeft);
  }
}
