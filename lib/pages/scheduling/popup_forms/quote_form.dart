import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/client_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';
import '../scheduling_page.dart';

// Shift details form
class QuoteForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CreateShiftDataQuote data;
  const QuoteForm(this.formKey, this.data, {Key? key}) : super(key: key);

  @override
  State<QuoteForm> createState() => QuoteFormState();
}

class QuoteFormState extends State<QuoteForm> {
  CreateShiftDataQuote get data => widget.data;

  bool get isCreate => data.isCreate;

  ScheduleCreatePopupMenus get type => data.type;

  CompanyMd get company => GeneralController.to.companyInfo;

  //Ephemeral state
  bool get isActive => data.isActive;
  set isActive(bool value) => data.isActive = value;

  DateTime? get altStartDate => data.altStartDate;
  set altStartDate(DateTime? value) => data.altStartDate = value;

  bool get isAllDay => data.isAllDay;
  set isAllDay(bool value) => data.isAllDay = value;

  DateTime? get date => data.date;
  set date(DateTime? value) => data.date = value;

  TimeOfDay? get startTime => data.startTime;
  set startTime(TimeOfDay? value) => data.startTime = value;

  TimeOfDay? get endTime => data.endTime;
  set endTime(TimeOfDay? value) => data.endTime = value;

  int? get repeatTypeIndex => data.repeatTypeIndex;
  set repeatTypeIndex(int? value) => data.repeatTypeIndex = value;
  List<int> get repeatDays => data.repeatDays;
  set repeatDays(List<int> value) => data.repeatDays = value;

  // NO NEED !
  int? selectedWarehouseId;
  int? selectedChecklistTemplateId;

  PlutoGridStateManager get gridStateManager => data.gridStateManager;
  set gridStateManager(PlutoGridStateManager value) =>
      data.gridStateManager = value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isCreate) return;
      //TODO: Handle when data is passed
    });
  }

  final fieldWidth = 400.0;

  void _onEditPm() async {
    final ClientInfoMd? res =
        await appStore.dispatch(OnCreateNewClientTap(context,
            type: ClientFormType.quoteClient,
            clientInfo: ClientInfoMd.init(
              name: data.quote.name,
              company: data.quote.company,
              email: data.quote.email,
              phone: data.quote.phone,
              payingDays: data.quote.payingDays,
              currencyId: data.quote.currencyId.toString(),
              paymentMethodId: data.quote.paymentMethodId.toString(),
              notes: data.quote.notes,
            )));
    if (res == null) return;
    setState(() {
      data.quote.name = res.name;
      data.quote.company = res.company;
      data.quote.email = res.email;
      data.quote.phone = res.phone;
      data.quote.payingDays = res.payingDays;
      data.quote.currencyId = int.parse(res.currencyId);
      data.quote.paymentMethodId = int.parse(res.paymentMethodId!);
      data.quote.notes = res.notes;
    });
  }

  void _editInvoiceAddress() async {
    final ClientAddressForm? res =
        await appStore.dispatch(OnCreateNewClientTap(context,
            type: ClientFormType.quoteLocation,
            clientInfo: ClientInfoMd.init(
                address: Address(
              line1: data.quote.addressLine1,
              line2: data.quote.addressLine2,
              city: data.quote.addressCity,
              county: data.quote.addressCounty,
              postcode: data.quote.addressPostcode,
              country: data.quote.addressCountry,
            ))));
    if (res == null) return;
    setState(() {
      data.quote.addressLine1 = res.addressLine1;
      data.quote.addressLine2 = res.addressLine2;
      data.quote.addressCity = res.addressCity;
      data.quote.addressCounty = res.addressCounty;
      data.quote.addressPostcode = res.addressPostcode;
      data.quote.addressCountry = res.addressCountryId;
    });
  }

  void _editWorkAddress() async {
    final ClientAddressForm? res =
        await appStore.dispatch(OnCreateNewClientTap(context,
            type: ClientFormType.quoteLocation,
            clientInfo: ClientInfoMd.init(
                address: Address(
              line1: data.quote.workAddressLine1,
              line2: data.quote.workAddressLine2,
              city: data.quote.workAddressCity,
              county: data.quote.workAddressCounty,
              postcode: data.quote.workAddressPostcode,
              country: data.quote.workAddressCountry,
            ))));
    if (res == null) return;
    setState(() {
      data.quote.workAddressLine1 = res.addressLine1;
      data.quote.workAddressLine2 = res.addressLine2;
      data.quote.workAddressCity = res.addressCity;
      data.quote.workAddressCounty = res.addressCounty;
      data.quote.workAddressPostcode = res.addressPostcode;
      data.quote.workAddressCountry = res.addressCountryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final List<ListWorkRepeats> workRepeats = [
          ...state.generalState.workRepeats
        ];
        List<ListCurrency> currencies = [...state.generalState.currencies];
        List<ListCountry> countries = [...state.generalState.countries];
        List<ListPaymentMethods> paymentMethods = [
          ...state.generalState.paymentMethods
        ];

        return CustomScrollbar(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
            child: Form(
              key: widget.formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .8,
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 64,
                  children: [
                    SpacedRow(
                      horizontalSpace: 72,
                      children: [
                        _container(
                          onEdit: () {
                            _onEditPm();
                          },
                          "Personal Information",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                "Name:",
                                null,
                                customLabel: _textField(data.quote.name),
                              ),
                              const Divider(),
                              labelWithField(
                                "Company:",
                                null,
                                customLabel: _textField(data.quote.company),
                              ),
                              const Divider(),
                              labelWithField(
                                "Email:",
                                null,
                                customLabel: _textField(data.quote.email),
                              ),
                              const Divider(),
                              labelWithField(
                                "Phone:",
                                null,
                                customLabel: _textField(data.quote.phone),
                              ),
                              const Divider(),
                              labelWithField(
                                "Payment Terms:",
                                null,
                                customLabel: _textField(
                                    data.quote.payingDays.toString()),
                              ),
                              const Divider(),
                              labelWithField(
                                "Currency:",
                                null,
                                customLabel: _textField(currencies
                                    .firstWhereOrNull((element) =>
                                        data.quote.currencyId == element.id)
                                    ?.sign),
                              ),
                              const Divider(),
                              labelWithField("Payment method:", null,
                                  customLabel: _textField(paymentMethods
                                      .firstWhereOrNull((element) =>
                                          data.quote.paymentMethodId ==
                                          element.id)
                                      ?.name)),
                              const Divider(),
                              labelWithField(
                                "Client Notes:",
                                null,
                                customLabel: _textField(data.quote.notes),
                              ),
                            ],
                          ),
                        ),
                        _container(
                          onEdit: () {
                            _editInvoiceAddress();
                          },
                          "Invoice Address",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                "Address Line 1:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressLine1),
                              ),
                              const Divider(),
                              labelWithField(
                                "Address Line 2:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressLine2),
                              ),
                              const Divider(),
                              labelWithField(
                                "City:",
                                null,
                                customLabel: _textField(data.quote.addressCity),
                              ),
                              const Divider(),
                              labelWithField(
                                "County:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressCounty),
                              ),
                              const Divider(),
                              labelWithField(
                                "Country:",
                                null,
                                customLabel: _textField(countries
                                    .firstWhereOrNull((element) =>
                                        element.code ==
                                        data.quote.addressCountry)
                                    ?.name),
                              ),
                              const Divider(),
                              labelWithField(
                                "Postcode:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressPostcode),
                              ),
                            ],
                          ),
                        ),
                        _container(
                          onEdit: () {
                            _editWorkAddress();
                          },
                          "Work Address",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                "Work Address Line 1:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressLine1),
                              ),
                              const Divider(),
                              labelWithField(
                                "Work Address Line 2:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressLine2),
                              ),
                              const Divider(),
                              labelWithField(
                                "Work City:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressCity),
                              ),
                              const Divider(),
                              labelWithField(
                                "Work County:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressCounty),
                              ),
                              const Divider(),
                              labelWithField(
                                "Work Country:",
                                null,
                                customLabel: _textField(countries
                                    .firstWhereOrNull((element) =>
                                        element.code ==
                                        data.quote.workAddressCountry)
                                    ?.name),
                              ),
                              const Divider(),
                              labelWithField(
                                "Work Postcode:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressPostcode),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _products(state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _textField(String? text) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .08,
        child: Text(
          text == null ? "-" : (text.isEmpty ? "-" : text),
          style: ThemeText.tabTextStyle,
        ));
  }

  Widget _container(String title, Widget child, {VoidCallback? onEdit}) {
    return titleWithDivider(
      titleIcon: onEdit != null
          ? addIcon(
              tooltip: "Edit $title",
              onPressed: onEdit,
              icon: HeroIcons.edit,
            )
          : null,
      title,
      Container(
          width: MediaQuery.of(context).size.width * .2,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child),
    );
  }

  List<PlutoColumn> cols(AppState state) => [
        PlutoColumn(
          title: "",
          field: "id",
          type: PlutoColumnType.text(),
          hide: true,
        ),
        // Items and description - String, ordered - double, rate - double, amount - double, Inc in fixed price - bool => Y/N
        PlutoColumn(
          title: "Title",
          field: "title",
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Customer's price (${company.currency.sign})",
          field: "customer_price",
          enableAutoEditing: true,
          type: PlutoColumnType.currency(),
          footerRenderer: (context) {
            final double total = context.stateManager.rows
                .where((element) => element.checked ?? false)
                .map((e) =>
                    (e.cells["customer_price"]?.value ?? 0) *
                    (e.cells["quantity"]?.value ?? 0))
                .fold(0, (a, b) {
              return a + b;
            });

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      total.getPriceMap().formattedVer,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        PlutoColumn(
          title: "Quantity",
          field: "quantity",
          enableAutoEditing: true,
          type: PlutoColumnType.number(),
        ),
        PlutoColumn(
          title: "Included in service (All)",
          field: "include_in_service",
          enableRowChecked: true,
          enableSorting: false,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "",
          field: "delete_action",
          enableEditingMode: false,
          enableSorting: false,
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return addIcon(
              tooltip: "Delete",
              onPressed: () {
                gridStateManager.removeRows([
                  rendererContext.row,
                ]);
              },
              icon: HeroIcons.bin,
              color: ThemeColors.red3,
            );
          },
        ),
      ];

  PlutoRow _buildRow(StorageItemMd contractShiftItem, {bool checked = false}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: contractShiftItem.id),
        "title": PlutoCell(value: contractShiftItem.name),
        "customer_price": PlutoCell(value: contractShiftItem.outgoingPrice),
        "quantity": PlutoCell(value: 1),
        "delete_action": PlutoCell(value: ""),
        "include_in_service": PlutoCell(value: "Included in service"),
      },
    );
  }

  Widget _products(AppState state) {
    return labelWithField(
        "",
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.77,
          height: 300,
          child: UsersListTable(
              enableEditing: true,
              rows: [],
              mode: PlutoGridMode.normal,
              gridBorderColor: Colors.grey[300]!,
              noRowsText: "No product or service added yet",
              onSmReady: (e) {
                gridStateManager = e;
                gridStateManager.addListener(() {
                  onTableChangeDone();
                });
              },
              cols: cols(state)),
        ),
        customLabel: Row(
          children: [
            addIcon(
                tooltip: "Create service/product",
                onPressed: () async {
                  final resId = await showDialog<int>(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => StorageItemForm(state: state));
                  if (resId == null) return;
                  final item = appStore.state.generalState.storage_items
                      .firstWhereOrNull((element) => element.id == resId);
                  if (item == null) return;
                  gridStateManager
                      .insertRows(0, [_buildRow(item, checked: true)]);
                },
                icon: HeroIcons.add),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomAutocompleteTextField<StorageItemMd>(
                  listItemWidget: (p0) => Text(p0.name),
                  onSelected: (p0) {
                    gridStateManager
                        .insertRows(0, [_buildRow(p0, checked: true)]);
                  },
                  displayStringForOption: (option) {
                    return option.name;
                  },
                  options: (p0) => state.generalState.storage_items
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(p0.text.toLowerCase()))
                      .toList()),
            ),
          ],
        ));
  }

  void onTableChangeDone() {
    setState(() {});
  }
}
