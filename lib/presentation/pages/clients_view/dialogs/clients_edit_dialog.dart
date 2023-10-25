import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dialog.dart';
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
  final TextEditingController companyController = TextEditingController();
  //email
  final TextEditingController emailController = TextEditingController();
  //phone
  final TextEditingController phoneController = TextEditingController();

  //address1
  final TextEditingController address1Controller = TextEditingController();
  //address2
  final TextEditingController address2Controller = TextEditingController();
  //city
  final TextEditingController cityController = TextEditingController();
  //county
  final TextEditingController countyController = TextEditingController();
  CountryMd? country;
  //postcode
  final TextEditingController postcodeController = TextEditingController();

  //Currency
  CurrencyMd? currency;
  //payment method
  PaymentMethodMd? paymentMethod;
  //payment due
  final TextEditingController paymentDueController = TextEditingController();
  //Invoice Period
  InvoicePeriod? invoicePeriod;
  //Invoice Day
  final TextEditingController invoiceDayController = TextEditingController();
  //combine invoice
  bool isCombineInvoices = false;
  //send invoices
  bool isSendInvoices = false;
  //comment
  final TextEditingController commentController = TextEditingController();
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
    companyController.text = c.company ?? "";
    emailController.text = c.email ?? "";
    phoneController.text = c.phone ?? "";

    address1Controller.text = c.address.line1;
    address2Controller.text = c.address.line2;
    cityController.text = c.address.city;
    countyController.text = c.address.county;
    country = c.address.getCountryMd(lists.countries);
    postcodeController.text = c.address.postcode;

    currency = c.getCurrencyMd(lists.currencies);
    paymentMethod = c.getPaymentMethodMd(lists.paymentMethods);
    paymentDueController.text = c.payingDays.toString();
    invoicePeriod = c.getInvoicePeriod(lists.invoicePeriods);
    invoiceDayController.text = c.invoiceDay?.toString() ?? "";
    isActive = c.active;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
        builder: (context) {
          return Column(
            children: [
              ShiftCard(
                  title: "Personal Info",
                  width: context.width * 0.5,
                  items: [
                    ShiftCardItem(
                        title: "Name",
                        simpleText: name,
                        maxLines: 2,
                        onChanged: (value) {
                          name = value;
                        }),
                  ]),
            ],
          );
        },
        title: "${isNew ? "Add" : "Edit"} Client");
  }
}
