import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../comps/custom_scrollbar.dart';
import '../../../comps/title_container.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';
import '../../../utils/global_functions.dart';
import '../../scheduling/create_shift_popup.dart';
import '../../scheduling/popup_forms/client_form.dart';
import '../../scheduling/popup_forms/storage_item_form.dart';
import '../../scheduling/popup_forms/timing_form.dart';

class QuoteEditForm extends StatefulWidget {
  final CreateShiftDataQuote data;

  const QuoteEditForm({Key? key, required this.data}) : super(key: key);

  @override
  State<QuoteEditForm> createState() => _QuoteEditFormState();
}

class _QuoteEditFormState extends State<QuoteEditForm> {
  //Getters
  late final CreateShiftDataQuote data = widget.data;

  bool get isCreate => data.isCreate;

  ScheduleCreatePopupMenus get type => data.type;

  CompanyMd get company => GeneralController.to.companyInfo;

  PlutoGridStateManager get gridStateManager => data.gridStateManager;

  //Setters
  set gridStateManager(PlutoGridStateManager value) =>
      widget.data.gridStateManager = value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCreate ? 'Create ${type.label}' : 'Edit ${type.label}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () {
                    onWillPop(context).then((value) {
                      if (value) {
                        context.popRoute();
                      }
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ButtonLarge(
              text: 'Cancel',
              onPressed: () {
                onWillPop(context).then((value) {
                  if (value) {
                    context.popRoute();
                  }
                });
              }),
          ButtonLarge(text: 'Publish', onPressed: () => _saveQuote(state)),
        ],
        content: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                  color: ThemeColors.gray6,
                  width: 2,
                  strokeAlign: StrokeAlign.outside),
            ),
            child: _Form(state)),
      ),
    );
  }

  //Functions
  void _saveQuote(AppState state) async {
    final quote = data.quote;
    final storageItems = [...state.generalState.storage_items];
    final workRepeats = [...state.generalState.workRepeats];
    Get.showOverlay(
        asyncFunction: () async {
          ApiResponse? quoteCreated = await appStore.dispatch(CreateQuoteAction(
            id: quote.id,
            email: quote.email ?? "",
            name: quote.name,
            company: quote.company,
            phone: quote.phone,
            addressLine1: quote.addressLine1,
            addressLine2: quote.addressLine2,
            addressCounty: quote.addressCounty,
            addressCity: quote.addressCity,
            addressCountry: quote.addressCountry,
            addressPostcode: quote.addressPostcode,
            active: quote.active,
            altWorkStartDate: quote.altWorkStartDate,
            currencyId: quote.currencyId,
            payingDays: quote.payingDays,
            paymentMethodId: quote.paymentMethodId,
            quoteComments: data.quote.quoteComments,
            workAddressLine1: quote.workAddressLine1,
            workAddressLine2: quote.workAddressLine2,
            workAddressCounty: quote.workAddressCounty,
            workAddressCity: quote.workAddressCity,
            workAddressCountry: quote.workAddressCountry,
            workAddressPostcode: quote.workAddressPostcode,
            notes: quote.notes,
            workStartDate: quote.workStartDate,
            workRepeatId: workRepeats
                    .firstWhereOrNull(
                        (element) => quote.workRepeat == element.days)
                    ?.id ??
                1,
            workStartTime: quote.workStartTime,
            workFinishTime: quote.workFinishTime,
            workDays: quote.workDays,
            storageItems: gridStateManager.rows
                .map<StorageItemMd>((row) {
                  final item = storageItems.firstWhereOrNull(
                      (element) => element.id == row.cells['id']!.value);
                  if (item != null) {
                    item.quantity = row.cells['quantity']!.value;
                    item.outgoingPrice = row.cells['customer_price']!.value;
                    item.auto = row.checked ?? false;

                    return item;
                  }
                  return StorageItemMd.init();
                })
                .where((element) => element.id != -1)
                .toList(),
          ));
          if (quoteCreated?.success == true) {
            exit(context).then((value) {
              showError(
                  "Quote ${quote.id == 0 ? "created" : "updated"} successfully",
                  titleMsg: "Success");
            });
          }
        },
        loadingWidget: const Center(child: CircularProgressIndicator()));
  }

  void _onEditPm() async {
    // final ClientInfoMd? res =
    //     await appStore.dispatch(OnCreateNewClientTap(context,
    //         type: ClientFormType.quoteClient,
    //         clientInfo: ClientInfoMd.init(
    //           name: data.quote.name,
    //           company: data.quote.company,
    //           email: data.quote.email,
    //           phone: data.quote.phone,
    //           payingDays: data.quote.payingDays,
    //           currencyId: data.quote.currencyId.toString(),
    //           paymentMethodId: data.quote.paymentMethodId.toString(),
    //           notes: data.quote.notes,
    //         )));
    // if (res == null) return;
    // setState(() {
    //   data.quote.name = res.name;
    //   data.quote.company = res.company;
    //   data.quote.email = res.email;
    //   data.quote.phone = res.phone;
    //   data.quote.payingDays = res.payingDays;
    //   data.quote.currencyId = int.parse(res.currencyId);
    //   data.quote.paymentMethodId = int.parse(res.paymentMethodId!);
    //   data.quote.notes = res.notes;
    // });
  }

  void _editInvoiceAddress() async {
    // final ClientAddressForm? res =
    //     await appStore.dispatch(OnCreateNewClientTap(context,
    //         type: ClientFormType.quoteLocation,
    //         clientInfo: ClientInfoMd.init(
    //             address: Address(
    //           line1: data.quote.addressLine1 ?? "",
    //           line2: data.quote.addressLine2 ?? "",
    //           city: data.quote.addressCity ?? "",
    //           county: data.quote.addressCounty ?? "",
    //           postcode: data.quote.addressPostcode ?? "",
    //           country: data.quote.addressCountry ?? "",
    //           latitude: 0,
    //           longitude: 0,
    //           radius: 0,
    //         ))));
    // if (res == null) return;
    // setState(() {
    //   data.quote.addressLine1 = res.addressLine1;
    //   data.quote.addressLine2 = res.addressLine2;
    //   data.quote.addressCity = res.addressCity;
    //   data.quote.addressCounty = res.addressCounty;
    //   data.quote.addressPostcode = res.addressPostcode;
    //   data.quote.addressCountry = res.addressCountryId;
    // });
  }

  void _editWorkAddress() async {
    // final ClientAddressForm? res =
    //     await appStore.dispatch(OnCreateNewClientTap(context,
    //         type: ClientFormType.quoteLocation,
    //         clientInfo: ClientInfoMd.init(
    //             address: Address(
    //           line1: data.quote.workAddressLine1 ?? "",
    //           line2: data.quote.workAddressLine2 ?? "",
    //           city: data.quote.workAddressCity ?? "",
    //           county: data.quote.workAddressCounty ?? "",
    //           postcode: data.quote.workAddressPostcode ?? "",
    //           country: data.quote.workAddressCountry ?? "",
    //           latitude: 0,
    //           longitude: 0,
    //           radius: 0,
    //         ))));
    // if (res == null) return;
    // setState(() {
    //   data.quote.workAddressLine1 = res.addressLine1;
    //   data.quote.workAddressLine2 = res.addressLine2;
    //   data.quote.workAddressCity = res.addressCity;
    //   data.quote.workAddressCounty = res.addressCounty;
    //   data.quote.workAddressPostcode = res.addressPostcode;
    //   data.quote.workAddressCountry = res.addressCountryId;
    // });
  }

  void _editTiming() async {
    // final CreatedTimingReturnValue? res = await appStore.dispatch(
    //   OnCreateNewClientTap(
    //     context,
    //     type: ClientFormType.timing,
    //     quoteInfo: data.quote,
    //   ),
    // );
    // if (res == null) return;
    // setState(() {
    //   data.quote.workStartDate = res.startDate?.formatDateForApi;
    //   data.quote.altWorkStartDate = res.altStartDate?.formatDateForApi;
    //   data.quote.workStartTime = res.startTime?.formattedTime;
    //   data.quote.workFinishTime = res.endTime?.formattedTime;
    //   data.quote.workRepeat =
    //       appStore.state.generalState.workRepeats[res.repeatTypeIndex!].days;
    //   data.quote.workDays = res.repeatDays.sorted((a, b) => a > b ? 1 : -1);
    // });
  }

//Widget
  Widget _Form(AppState state) {
    final List<ListWorkRepeats> workRepeats = [
      ...state.generalState.workRepeats
    ];
    List<ListCurrency> currencies = [...state.generalState.currencies];
    List<ListCountry> countries = [...state.generalState.countries];
    List<ListPaymentMethods> paymentMethods = [
      ...state.generalState.paymentMethods
    ];

    String week1 = "* Week 1\n";
    String week2 = "* Week 2\n";
    String week = "";

    for (var day in data.quote.workDays) {
      if (data.quote.workRepeat == 7) {
        //Week
        week1 += "${Constants.daysOfTheWeek[day]}\n";
        week2 = "";
      }
      if (data.quote.workRepeat == 14) {
        //Fortnightly
        if (day > 7) {
          week2 += "${Constants.daysOfTheWeek[day]}\n";
        } else {
          week1 += "${Constants.daysOfTheWeek[day]}\n";
        }
      }
    }
    if (week1 == "* Week 1\n" && week2 == "* Week 2\n") {
      week = "";
    } else {
      week = "$week1\n$week2";
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomScrollbar(
        child: Container(
          padding:
              const EdgeInsets.only(top: 36, bottom: 36, right: 36, left: 36),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: 64,
            children: [
              SpacedRow(
                horizontalSpace: 32,
                children: [
                  SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 16,
                    children: [
                      TitleContainer(
                        onEdit: _onEditPm,
                        title: "Personal Information",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutocompleteTextField<ClientInfoMd>(
                                width: 400,
                                height: 50,
                                hintText: "Select Client",
                                listItemWidget: (p0) => Text(p0.name),
                                onSelected: (p0) {
                                  data.client = p0;
                                  setState(() {});
                                },
                                displayStringForOption: (option) {
                                  return option.name;
                                },
                                options: (p0) => state.generalState.clientInfos
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(p0.text.toLowerCase()))),
                            const SizedBox(height: 16),
                            labelWithField(
                              labelWidth: 160,
                              "Name:",
                              null,
                              customLabel: _textField(widget.data.quote.name),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Company:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.company),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Email:",
                              null,
                              customLabel: _textField(widget.data.quote.email),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Phone:",
                              null,
                              customLabel: _textField(widget.data.quote.phone),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Payment Terms:",
                              null,
                              customLabel: _textField(
                                  widget.data.quote.payingDays.toString()),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Currency:",
                              null,
                              customLabel: _textField(currencies
                                  .firstWhereOrNull((element) =>
                                      widget.data.quote.currencyId ==
                                      element.id)
                                  ?.sign),
                            ),
                            const Divider(),
                            labelWithField(
                                labelWidth: 160,
                                "Payment method:",
                                null,
                                customLabel: _textField(paymentMethods
                                    .firstWhereOrNull((element) =>
                                        widget.data.quote.paymentMethodId ==
                                        element.id)
                                    ?.name)),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Client Notes:",
                              null,
                              customLabel: _textField(widget.data.quote.notes),
                            ),
                          ],
                        ),
                      ),
                      labelWithField(
                        labelWidth: 160,
                        "Quote Comments",
                        TextInputWidget(
                          width: 400,
                          maxLines: 4,
                          hintText: "Add quote comments",
                          controller: TextEditingController(
                              text: widget.data.quote.quoteComments),
                          onChanged: (value) {
                            widget.data.quote.quoteComments = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SpacedColumn(
                    verticalSpace: 16,
                    children: [
                      TitleContainer(
                        onEdit: _editInvoiceAddress,
                        title: "Invoice Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutocompleteTextField<LocationAddress>(
                                width: 400,
                                height: 50,
                                hintText: "Select Location",
                                listItemWidget: (p0) => Text(p0.name ?? ""),
                                onSelected: (p0) {
                                  data.invoiceLocation = p0;
                                  setState(() {});
                                },
                                displayStringForOption: (option) {
                                  return option.name ?? "";
                                },
                                options: (p0) => state.generalState.locations
                                    .where((element) => (element.name ?? "")
                                        .toLowerCase()
                                        .contains(p0.text.toLowerCase()))),
                            const SizedBox(height: 16),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 1:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.addressLine1),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Address Line 2:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.addressLine2),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "City:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.addressCity),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "County:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.addressCounty),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Country:",
                              null,
                              customLabel: _textField(countries
                                  .firstWhereOrNull((element) =>
                                      element.code ==
                                      widget.data.quote.addressCountry)
                                  ?.name),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Postcode:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.addressPostcode),
                            ),
                          ],
                        ),
                      ),
                      TitleContainer(
                        onEdit: _editWorkAddress,
                        title: "Work Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutocompleteTextField<LocationAddress>(
                                width: 400,
                                height: 50,
                                hintText: "Select Location",
                                listItemWidget: (p0) => Text(p0.name ?? ""),
                                onSelected: (p0) {
                                  data.workLocation = p0;
                                  setState(() {});
                                },
                                displayStringForOption: (option) {
                                  return option.name ?? "";
                                },
                                options: (p0) => state.generalState.locations
                                    .where((element) => (element.name ?? "")
                                        .toLowerCase()
                                        .contains(p0.text.toLowerCase()))),
                            const SizedBox(height: 16),
                            labelWithField(
                              labelWidth: 160,
                              "Work Address Line 1:",
                              null,
                              customLabel: _textField(
                                  widget.data.quote.workAddressLine1),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Work Address Line 2:",
                              null,
                              customLabel: _textField(
                                  widget.data.quote.workAddressLine2),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Work City:",
                              null,
                              customLabel:
                                  _textField(widget.data.quote.workAddressCity),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Work County:",
                              null,
                              customLabel: _textField(
                                  widget.data.quote.workAddressCounty),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Work Country:",
                              null,
                              customLabel: _textField(countries
                                  .firstWhereOrNull((element) =>
                                      element.code ==
                                      widget.data.quote.workAddressCountry)
                                  ?.name),
                            ),
                            const Divider(),
                            labelWithField(
                              labelWidth: 160,
                              "Work Postcode:",
                              null,
                              customLabel: _textField(
                                  widget.data.quote.workAddressPostcode),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TitleContainer(
                    onEdit: _editTiming,
                    title: "Timing",
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithField(
                          labelWidth: 160,
                          "Work Start Date:",
                          null,
                          customLabel:
                              _textField(widget.data.quote.workStartDate),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Alternative Work Start Date:",
                          null,
                          customLabel:
                              _textField(widget.data.quote.altWorkStartDate),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Work Start Time:",
                          null,
                          customLabel:
                              _textField(widget.data.quote.workStartTime),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Work Finish Time:",
                          null,
                          customLabel:
                              _textField(widget.data.quote.workFinishTime),
                        ),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Repeat:",
                          null,
                          customLabel: _textField(
                              widget.data.quote.workRepeat != null
                                  ? workRepeats
                                      .firstWhereOrNull((element) =>
                                          element.days ==
                                          widget.data.quote.workRepeat)
                                      ?.name
                                  : null),
                        ),
                        if (widget.data.quote.workRepeat != null &&
                            (widget.data.quote.workRepeat != 0 ||
                                widget.data.quote.workRepeat != 1))
                          const Divider(),
                        if (widget.data.quote.workRepeat != null &&
                            (widget.data.quote.workRepeat != 0 ||
                                widget.data.quote.workRepeat != 1))
                          labelWithField(
                              labelWidth: 160,
                              "Days:",
                              null,
                              customLabel: _textField(week)),
                        const Divider(),
                        labelWithField(
                          labelWidth: 160,
                          "Active:",
                          null,
                          customLabel: checkbox(widget.data.quote.active, (p0) {
                            setState(() {
                              widget.data.quote.active = p0;
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
                        (e) => data.buildRow(
                          StorageItemMd(
                            id: e.itemId,
                            active: true,
                            name: e.itemName,
                            incomingPrice: 0,
                            outgoingPrice: e.price,
                            service: false,
                            taxId: 1,
                          ),
                          checked: e.auto,
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
                      .insertRows(0, [data.buildRow(item, checked: true)]);
                },
                icon: HeroIcons.add),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomAutocompleteTextField<StorageItemMd>(
                  listItemWidget: (p0) => Text(p0.name),
                  onSelected: (p0) {
                    gridStateManager
                        .insertRows(0, [data.buildRow(p0, checked: true)]);
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
