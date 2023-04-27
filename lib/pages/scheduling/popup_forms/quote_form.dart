import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/client_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/shift_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/timing_form.dart';
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

  PlutoGridStateManager get gridStateManager => data.gridStateManager;
  set gridStateManager(PlutoGridStateManager value) =>
      data.gridStateManager = value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isCreate) return;
    });
  }

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

  void _editTiming() async {
    final CreatedTimingReturnValue? res = await appStore.dispatch(
      OnCreateNewClientTap(
        context,
        type: ClientFormType.timing,
        quoteInfo: data.quote,
      ),
    );
    if (res == null) return;
    logger(res.startDate);
    setState(() {
      data.quote.workStartDate = res.startDate?.formatDateForApi;
      data.quote.altWorkStartDate = res.altStartDate?.formatDateForApi;
      data.quote.workStartTime = res.startTime?.formattedTime;
      data.quote.workFinishTime = res.endTime?.formattedTime;
      data.quote.workRepeat =
          appStore.state.generalState.workRepeats[res.repeatTypeIndex!].id;
      data.quote.workDays = res.repeatDays;
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

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomScrollbar(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 36, bottom: 36, right: 36, left: 36),
              child: Form(
                key: widget.formKey,
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 64,
                  children: [
                    SpacedRow(
                      horizontalSpace: 32,
                      children: [
                        _container(
                          onEdit: _onEditPm,
                          "Personal Information",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                labelWidth: 160,
                                "Name:",
                                null,
                                customLabel: _textField(data.quote.name),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Company:",
                                null,
                                customLabel: _textField(data.quote.company),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Email:",
                                null,
                                customLabel: _textField(data.quote.email),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Phone:",
                                null,
                                customLabel: _textField(data.quote.phone),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Payment Terms:",
                                null,
                                customLabel: _textField(
                                    data.quote.payingDays.toString()),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Currency:",
                                null,
                                customLabel: _textField(currencies
                                    .firstWhereOrNull((element) =>
                                        data.quote.currencyId == element.id)
                                    ?.sign),
                              ),
                              const Divider(),
                              labelWithField(
                                  labelWidth: 160,
                                  "Payment method:",
                                  null,
                                  customLabel: _textField(paymentMethods
                                      .firstWhereOrNull((element) =>
                                          data.quote.paymentMethodId ==
                                          element.id)
                                      ?.name)),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Client Notes:",
                                null,
                                customLabel: _textField(data.quote.notes),
                              ),
                            ],
                          ),
                        ),
                        _container(
                          onEdit: _editInvoiceAddress,
                          "Invoice Address",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                labelWidth: 160,
                                "Address Line 1:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressLine1),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Address Line 2:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressLine2),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "City:",
                                null,
                                customLabel: _textField(data.quote.addressCity),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "County:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressCounty),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
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
                                labelWidth: 160,
                                "Postcode:",
                                null,
                                customLabel:
                                    _textField(data.quote.addressPostcode),
                              ),
                            ],
                          ),
                        ),
                        _container(
                          onEdit: _editWorkAddress,
                          "Work Address",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                labelWidth: 160,
                                "Work Address Line 1:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressLine1),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Work Address Line 2:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressLine2),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Work City:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressCity),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Work County:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressCounty),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
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
                                labelWidth: 160,
                                "Work Postcode:",
                                null,
                                customLabel:
                                    _textField(data.quote.workAddressPostcode),
                              ),
                            ],
                          ),
                        ),
                        _container(
                          onEdit: _editTiming,
                          "Timing",
                          SpacedColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithField(
                                labelWidth: 160,
                                "Work Start Date:",
                                null,
                                customLabel:
                                    _textField(data.quote.workStartDate),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Alternative Work Start Date:",
                                null,
                                customLabel:
                                    _textField(data.quote.altWorkStartDate),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Work Start Time:",
                                null,
                                customLabel:
                                    _textField(data.quote.workStartTime),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Work Finish Time:",
                                null,
                                customLabel:
                                    _textField(data.quote.workFinishTime),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Repeat:",
                                null,
                                customLabel: _textField(data.quote.workRepeat !=
                                        null
                                    ? workRepeats
                                        .firstWhereOrNull((element) =>
                                            element.id == data.quote.workRepeat)
                                        ?.name
                                    : null),
                              ),
                              const Divider(),
                              labelWithField(
                                labelWidth: 160,
                                "Active:",
                                null,
                                customLabel: checkbox(data.quote.active, (p0) {
                                  setState(() {
                                    data.quote.active = p0;
                                  });
                                }),
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
        width: 200,
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
          width: 410,
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

  PlutoRow _buildRow(StorageItemMd contractShiftItem,
      {bool checked = false, int? qty}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: contractShiftItem.id),
        "title": PlutoCell(value: contractShiftItem.name),
        "customer_price": PlutoCell(value: contractShiftItem.outgoingPrice),
        "quantity": PlutoCell(value: qty ?? 1),
        "delete_action": PlutoCell(value: ""),
        "include_in_service": PlutoCell(value: "Included in service"),
      },
    );
  }

  Widget _products(AppState state) {
    return labelWithField(
        labelWidth: 160,
        "Products and services",
        SizedBox(
          width: MediaQuery.of(context).size.width * .95,
          height: 300,
          child: UsersListTable(
              enableEditing: true,
              rows: [],
              mode: PlutoGridMode.normal,
              gridBorderColor: Colors.grey[300]!,
              noRowsText: "No product or service added yet",
              onSmReady: (e) {
                gridStateManager = e;
                if (!isCreate) {
                  gridStateManager.appendRows(data.quote.items
                      .map(
                        (e) => _buildRow(
                          StorageItemMd(
                            id: e.itemId,
                            active: true,
                            name: e.itemName,
                            incomingPrice: 0,
                            outgoingPrice: e.price,
                            service: false,
                            taxId: 1,
                          ),
                          checked: true,
                          qty: e.quantity,
                        ),
                      )
                      .toList());
                }
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
