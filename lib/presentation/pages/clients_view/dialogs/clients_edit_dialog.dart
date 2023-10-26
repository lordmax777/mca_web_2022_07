import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';

class ClientsEditDialog extends StatefulWidget {
  final ClientMd? client;
  const ClientsEditDialog({super.key, this.client});

  @override
  State<ClientsEditDialog> createState() => _ClientsEditDialogState();
}

class _ClientsEditDialogState extends State<ClientsEditDialog> {
  ClientMd? get client => widget.client;
  bool get isNew => client == null;

  //name
  String name = "";
  //company
  String company = "";
  //email
  String email = "";
  //phone
  String phone = "";
  //fax
  String fax = "";

  //address1
  String address1 = "";
  //address2
  String address2 = "";
  //city
  String city = "";
  //county
  String county = "";
  CountryMd? country;
  //postcode
  String postcode = "";

  //Currency
  CurrencyMd? currency;
  //payment method
  PaymentMethodMd? paymentMethod;
  //payment due
  String paymentDue = "";
  //Invoice Period
  InvoicePeriod? invoicePeriod;
  //Invoice Day
  String invoiceDay = "";
  //combine invoice
  bool isCombineInvoices = false;
  //send invoices
  bool isSendInvoices = false;
  //comment
  String comment = "";
  //isActive
  bool isActive = true;

  final lists = appStore.state.generalState.lists;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isNew) init();
    });
  }

  void init() {
    final c = client!;
    name = c.name;
    company = c.company ?? "";
    email = c.email ?? "";
    phone = c.phone ?? "";
    fax = c.fax ?? "";

    address1 = c.address.line1;
    address2 = c.address.line2;
    city = c.address.city;
    county = c.address.county;
    country = c.address.getCountryMd(lists.countries);
    postcode = c.address.postcode;

    currency = c.getCurrencyMd(lists.currencies);
    paymentMethod = c.getPaymentMethodMd(lists.paymentMethods);
    paymentDue = c.payingDays.toString();
    invoicePeriod = c.getInvoicePeriod(lists.invoicePeriods);
    invoiceDay = c.invoiceDay?.toString() ?? "";
    isActive = c.active;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ShiftCard(
                    title: "Personal Info",
                    width: context.width * 0.5,
                    items: [
                      ShiftCardItem(
                          isRequired: true,
                          title: "Name",
                          simpleText: name,
                          onChanged: (value) {
                            name = value;
                          }),
                      ShiftCardItem(
                          title: "Company",
                          simpleText: company,
                          onChanged: (value) {
                            company = value;
                          }),
                      ShiftCardItem(
                          title: "Email",
                          simpleText: email,
                          onChanged: (value) {
                            email = value;
                          }),
                      ShiftCardItem(
                          title: "Phone",
                          simpleText: phone,
                          onChanged: (value) {
                            phone = value;
                          }),
                      ShiftCardItem(
                          title: "Fax",
                          simpleText: fax,
                          onChanged: (value) {
                            fax = value;
                          }),
                    ]),
                const SizedBox(height: 20),
                ShiftCard(
                  title: "Address",
                  width: context.width * 0.5,
                  items: [
                    ShiftCardItem(
                      title: "Search Address",
                      customWidget: AddressAutocompleteWidget(
                        width: context.width * 0.43,
                        onSelected: (value) {
                          print(value);
                          address1 = value.line1;
                          address2 = value.line2;
                          city = value.city;
                          county = value.county;
                          country = value.country;
                          postcode = value.postcode;
                          setState(() {});
                        },
                      ),
                    ),
                    ShiftCardItem(
                        title: "Address Line 1",
                        isRequired: true,
                        simpleText: address1,
                        onChanged: (value) {
                          address1 = value;
                        }),
                    ShiftCardItem(
                        title: "Address Line 2",
                        simpleText: address2,
                        onChanged: (value) {
                          address2 = value;
                        }),
                    ShiftCardItem(
                        title: "City",
                        simpleText: city,
                        isRequired: true,
                        onChanged: (value) {
                          city = value;
                        }),
                    ShiftCardItem(
                        title: "County",
                        simpleText: county,
                        onChanged: (value) {
                          county = value;
                        }),
                    ShiftCardItem(
                        title: "Country",
                        // isRequired: true,
                        dropdown: ShiftCardDropdown(
                          additionalValueId: country?.code,
                          label: country?.name,
                          onChanged: (value) {
                            final index = lists.countries.indexWhere(
                                (e) => e.code == value.additionalId);
                            if (index != -1) {
                              country = lists.countries[index];
                              setState(() {});
                            }
                          },
                          items: [
                            for (int i = 0; i < lists.countries.length; i++)
                              DefaultMenuItem(
                                  id: i,
                                  title: lists.countries[i].name,
                                  additionalId: lists.countries[i].code),
                          ],
                        )),
                    ShiftCardItem(
                        title: "Postcode",
                        isRequired: true,
                        simpleText: postcode,
                        onChanged: (value) {
                          postcode = value;
                        }),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            ShiftCard(
              title: "Payment Information",
              width: context.width * 0.4,
              items: [
                ShiftCardItem(
                  title: "Currency",
                  isRequired: true,
                  dropdown: ShiftCardDropdown(
                    additionalValueId: currency?.code,
                    label: currency?.sign,
                    onChanged: (value) {
                      final index = lists.currencies
                          .indexWhere((e) => e.code == value.additionalId);
                      if (index != -1) {
                        currency = lists.currencies[index];
                        setState(() {});
                      }
                    },
                    items: [
                      for (int i = 0; i < lists.currencies.length; i++)
                        DefaultMenuItem(
                            id: i,
                            title:
                                "${lists.currencies[i].sign} - ${lists.currencies[i].code}",
                            additionalId: lists.currencies[i].code),
                    ],
                  ),
                ),
                ShiftCardItem(
                    title: "Payment method",
                    isRequired: true,
                    dropdown: ShiftCardDropdown(
                      valueId: paymentMethod?.id,
                      label: paymentMethod?.name,
                      items: lists.paymentMethods
                          .map((e) => DefaultMenuItem(id: e.id, title: e.name)),
                      onChanged: (value) {
                        final method = lists.paymentMethods.firstWhereOrNull(
                            (element) => element.id == value.id);
                        paymentMethod = method;
                        setState(() {});
                      },
                    )),
                ShiftCardItem(
                    title: "Invoice Period",
                    isRequired: true,
                    dropdown: ShiftCardDropdown(
                      valueId: invoicePeriod?.id,
                      label: invoicePeriod?.name,
                      items: lists.invoicePeriods
                          .map((e) => DefaultMenuItem(id: e.id, title: e.name)),
                      onChanged: (value) {
                        final method = lists.invoicePeriods.firstWhereOrNull(
                            (element) => element.id == value.id);
                        invoicePeriod = method;
                        setState(() {});
                      },
                    )),
                ShiftCardItem(
                  title: "Invoice Day",
                  isRequired: true,
                  simpleText: invoiceDay,
                  onChanged: (value) {
                    invoiceDay = value;
                  },
                ),
                ShiftCardItem(
                  title: "Paying Days",
                  isRequired: true,
                  simpleText: paymentDue,
                  onChanged: (value) {
                    paymentDue = value;
                  },
                ),
                ShiftCardItem(
                  title: "Comment",
                  simpleText: comment,
                  maxLines: 2,
                  onChanged: (value) {
                    comment = value;
                  },
                ),
                ShiftCardItem(
                  title: "Active",
                  checked: isActive,
                  onChecked: (value) {
                    isActive = value;
                    setState(() {});
                  },
                ),
                ShiftCardItem(
                  title: "Combine Invoices",
                  checked: isCombineInvoices,
                  onChecked: (value) {
                    isCombineInvoices = value;
                    setState(() {});
                  },
                ),
                ShiftCardItem(
                  title: "Send Invoices",
                  checked: isSendInvoices,
                  onChecked: (value) {
                    isSendInvoices = value;
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          //Cancel
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.secondary),
              onPressed: () {
                context.pop();
              },
              child: Text("Cancel")),
          //Submit
          ElevatedButton(
              onPressed: () => onSubmit(saveAsNew: true),
              child: const Text("Save as new")),
          ElevatedButton(onPressed: onSubmit, child: const Text("Submit")),
        ],
        title: Text("${isNew ? "Add" : "Edit"} Client"));
  }

  void onSubmit({bool saveAsNew = false}) async {
    if (name.isEmpty) {
      context.showError("Name is required");
      return;
    }
    if (address1.isEmpty) {
      context.showError("Address is required");
      return;
    }
    if (city.isEmpty) {
      context.showError("City is required");
      return;
    }
    if (country == null) {
      context.showError("Country is required");
      return;
    }
    if (postcode.isEmpty) {
      context.showError("Postcode is required");
      return;
    }
    if (currency == null) {
      context.showError("Currency is required");
      return;
    }
    if (paymentMethod == null) {
      context.showError("Payment method is required");
      return;
    }
    if (paymentDue.isEmpty) {
      context.showError("Payment due is required");
      return;
    }
    if (invoicePeriod == null) {
      context.showError("Invoice period is required");
      return;
    }
    if (invoiceDay.isEmpty) {
      context.showError("Invoice day is required");
      return;
    }
    if (int.tryParse(invoiceDay) == null) {
      context.showError("Invoice day must be a number");
      return;
    }
    if (int.tryParse(paymentDue) == null) {
      context.showError("Payment due must be a number");
      return;
    }
    if (int.tryParse(paymentDue)! < 0) {
      context.showError("Payment due must be a positive number");
      return;
    }
    if (int.tryParse(invoiceDay)! < 0) {
      context.showError("Invoice day must be a positive number");
      return;
    }

    final res = await context.futureLoading(() async {
      return await dispatch<int>(PostClientAction(
        PersonalData(
          clientId: saveAsNew ? null : client?.id,
          name: name,
          phone: phone,
          email: email,
          fax: fax,
          invoicePeriod: invoicePeriod,
          invoiceDay: int.parse(invoiceDay),
          paymentDays: int.parse(paymentDue),
          sendInvoices: isSendInvoices,
          combineInvoices: isCombineInvoices,
          companyName: company,
          currency: currency!,
          notes: comment,
          paymentMethod: paymentMethod!,
        ),
        addressData: AddressData(
          line1: address1,
          line2: address2,
          city: city,
          county: county,
          country: country!,
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
