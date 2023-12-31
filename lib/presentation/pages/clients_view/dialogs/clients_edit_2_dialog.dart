import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

///Once saved, returns the id of the client
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

  String? get getInvoicePeriod => formVm.getValue('invoicePeriodId');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    final c = client;
    if (c != null) {
      formVm.formKey.currentState?.patchValue({
        "name": c.name,
        "company": c.company ?? '',
        "email": c.email ?? '',
        "phone": c.phone ?? '',
        "fax": c.fax ?? '',
        "addressLine1": c.address.line1 ?? '',
        "addressLine2": c.address.line2 ?? '',
        "addressCity": c.address.city ?? '',
        "addressCounty": c.address.county ?? '',
        "addressPostcode": c.address.postcode ?? '',
        "country": c.address.country,
        "currencyId": c.currencyId,
        "paymentMethodId": c.paymentMethodId,
        "invoicePeriodId": c.invoicePeriodId,
        "paymentDays": c.payingDays.toString(),
        "invoiceDay": c.invoiceDay?.toString(),
        "comment": c.notes,
        "active": c.active,
        "combineInvoices": c.combineInvoices,
        "sendInvoices": c.sendInvoices,
      });
    } else {
      formVm.formKey.currentState?.patchValue({
        "currencyId": appStore.state.generalState.defaultCurrency.id.toString(),
        "paymentMethodId":
            appStore.state.generalState.defaultPaymentMethod?.id.toString(),
        // "invoicePeriodId": ,
        //todo: get default invoice period
        // "paymentDays": c.payingDays.toString(),
        //todo: get default payment days
        // "invoiceDay": c.invoiceDay.toString(),
        //todo: get default invoice day
        "active": true,
      });
    }
    formVm.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = context.width * .2;
    print(getInvoicePeriod);
    return AlertDialog(
        shape: const RoundedRectangleBorder(),
        scrollable: true,
        content: SizedBox(
          height: context.height * .6,
          width: context.width * .7,
          child: SingleChildScrollView(
            child: DefaultForm(
              vm: formVm,
              child: SpacedRow(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormContainer(
                    hiddenInitially: false,
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
                        labelVm: const LabelModel(text: "Search Address"),
                        formBuilderField: AddressAutocompleteWidget(
                            width: containerWidth * .95,
                            onSelected: (value) {
                              formVm.patchValue({
                                "addressLine1": value.line1,
                                "addressLine2": value.line2,
                                "addressCity": value.city,
                                "addressPostcode": value.postcode,
                                "country": value.country?.code,
                              });
                            }),
                      ),
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
                          labelVm:
                              const LabelModel(text: "City", isRequired: true),
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
                  ),
                  FormContainer(
                    width: containerWidth,
                    title: "Payment Info",
                    left: [
                      // FormWithLabel(
                      //     labelVm: const LabelModel(
                      //         text: "Currency", isRequired: true),
                      //     formBuilderField: FormDropdown(
                      //         vm: DropdownModel(
                      //       name: "currencyId",
                      //       items: lists.currencies
                      //           .map((e) => DpItem(
                      //               id: e.id.toString(),
                      //               title: e.code,
                      //               subtitle: e.sign))
                      //           .toList(),
                      //       validator: FormBuilderValidators.required(),
                      //     ))),
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
                            onChanged: (p0) {
                              setState(() {});
                            },
                            items: lists.invoicePeriods
                                .map((e) =>
                                    DpItem(id: e.id.toString(), title: e.name))
                                .toList(),
                            validator: FormBuilderValidators.required(),
                          ))),
                      Visibility(
                        maintainState: true,
                        visible:
                            getInvoicePeriod != null && getInvoicePeriod != "1",
                        child: FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Invoice Day", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                              name: "invoiceDay",
                              valueTransformer: (value) =>
                                  num.tryParse(value ?? ""),
                              validators: [
                                if (getInvoicePeriod != null &&
                                    getInvoicePeriod != "1")
                                  FormBuilderValidators.required(),
                                (value) {
                                  if (formVm.getValue('invoicePeriodId') ==
                                      null) {
                                    return null;
                                  }
                                  if (formVm.getValue('invoicePeriodId') ==
                                          "1" ||
                                      formVm.getValue('invoicePeriodId') ==
                                          "2") {
                                    return null;
                                  }
                                  return "Invoice day is required";
                                }
                              ],
                            ))),
                      ),
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
        ),
        actionsPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      final name = formVm.getValue('name');
      final company = formVm.getValue('company');
      final email = formVm.getValue('email');
      final phone = formVm.getValue('phone');
      final fax = formVm.getValue('fax');
      final address1 = formVm.getValue('addressLine1');
      final address2 = formVm.getValue('addressLine2');
      final city = formVm.getValue('addressCity');
      final county = formVm.getValue('addressCounty');
      final postcode = formVm.getValue('addressPostcode');
      final country = formVm.getValue('country');
      final paymentMethod = formVm.getValue('paymentMethodId');
      final invoicePeriod = formVm.getValue('invoicePeriodId');
      final paymentDue = formVm.getValue('paymentDays');
      final invoiceDay = formVm.getValue('invoiceDay');
      final comment = formVm.getValue('comment');
      final isSendInvoices = formVm.getValue('sendInvoices') ?? false;
      final isCombineInvoices = formVm.getValue('combineInvoices') ?? false;
      final isActive = formVm.getValue('active') ?? false;
      return await dispatch<int>(PostClientAction(
        PersonalData(
          clientId: saveAsNew ? null : client?.id,
          name: name,
          phone: phone?.toString() ?? "",
          email: email ?? "",
          fax: fax?.toString(),
          invoicePeriod: lists.invoicePeriods.firstWhere(
              (element) => element.id == int.tryParse(invoicePeriod ?? "")),
          invoiceDay: int.tryParse(invoiceDay ?? ""),
          paymentDays: int.parse(paymentDue),
          sendInvoices: isSendInvoices,
          combineInvoices: isCombineInvoices,
          companyName: company ?? '',
          notes: comment ?? '',
          paymentMethod: lists.paymentMethods.firstWhereOrNull(
              (element) => element.id == int.tryParse(paymentMethod ?? "")),
          active: isActive,
        ),
        addressData: AddressData(
          line1: address1,
          line2: address2,
          city: city,
          county: county ?? '',
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
    if (res.isLeft) {
      context.pop(res.left);
    } else {
      context.showError("Something went wrong");
    }
  }
}
