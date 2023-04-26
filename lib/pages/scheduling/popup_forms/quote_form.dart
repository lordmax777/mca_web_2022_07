import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_scrollbar.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import '../../../comps/autocomplete_input_field.dart';
import '../../../manager/general_controller.dart';
import '../../../manager/model_exporter.dart';
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
                height: MediaQuery.of(context).size.height * .75,
                child: CustomExpandableTabBar(
                  expandedWidgetList: [
                    ExpandedWidgetType(
                        initExpanded: true,
                        title: "Personal Information",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalSpace: 16,
                          children: [
                            SpacedRow(
                              horizontalSpace: 64,
                              children: [
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalSpace: 16,
                                  children: [
                                    labelWithField(
                                      "Contact Name",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        hintText: "Enter name",
                                        onChanged: (value) {
                                          data.quote.name = value;
                                        },
                                        isRequired: true,
                                      ),
                                    ),
                                    labelWithField(
                                      "Company Name",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        onChanged: (value) {
                                          data.quote.company = value;
                                        },
                                        hintText: "Enter company name",
                                      ),
                                    ),
                                  ],
                                ),
                                SpacedColumn(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalSpace: 16,
                                    children: [
                                      labelWithField(
                                        "Phone Number",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          onChanged: (value) {
                                            data.quote.phone = value;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          hintText: "Enter phone number",
                                        ),
                                      ),
                                      labelWithField(
                                        "Email",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          onChanged: (value) {
                                            data.quote.email = value;
                                          },
                                          isRequired: true,
                                          validator: (p0) {
                                            if (p0 != null) {
                                              //validate using Regex
                                              if (!RegExp(
                                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(p0)) {
                                                return "Invalid email";
                                              }
                                            }

                                            return null;
                                          },
                                          hintText: "Enter email",
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                            SpacedRow(
                              horizontalSpace: 64,
                              children: [
                                SpacedColumn(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalSpace: 16,
                                    children: [
                                      labelWithField(
                                        "Client Notes",
                                        TextInputWidget(
                                          width: fieldWidth * 2 + 64,
                                          hintText: "",
                                          onChanged: (value) {
                                            data.quote.notes = value;
                                          },
                                        ),
                                      ),
                                    ]),
                              ],
                            )
                          ],
                        )),
                    ExpandedWidgetType(
                        title: "Payment Information",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalSpace: 16,
                          children: [
                            SpacedRow(
                              horizontalSpace: 64,
                              children: [
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalSpace: 16,
                                  children: [
                                    labelWithField(
                                      "Payment terms",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        isRequired: true,
                                        controller: TextEditingController(
                                            text: data.quote.payingDays
                                                .toString()),
                                        hintText: "Enter payment terms",
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          data.quote.payingDays =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    ),
                                    labelWithField(
                                      "Currency",
                                      DropdownWidgetV2(
                                        hintText: "Select currency",
                                        dropdownBtnWidth: fieldWidth,
                                        isRequired: true,
                                        dropdownOptionsWidth: fieldWidth,
                                        items: currencies
                                            .map((e) => CustomDropdownValue(
                                                name: e.sign))
                                            .toList(),
                                        value: CustomDropdownValue(
                                            name: currencies
                                                .firstWhereOrNull((element) =>
                                                    element.id ==
                                                    data.quote.currencyId)
                                                ?.sign),
                                        onChanged: (index) {
                                          setState(() {
                                            data.quote.currencyId =
                                                currencies[index].id;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SpacedColumn(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalSpace: 16,
                                    children: [
                                      labelWithField(
                                        "Payment Method",
                                        DropdownWidgetV2(
                                          hasSearchBox: true,
                                          isRequired: true,
                                          hintText: "Select payment method",
                                          dropdownBtnWidth: fieldWidth,
                                          dropdownOptionsWidth: fieldWidth,
                                          items: paymentMethods
                                              .map((e) => CustomDropdownValue(
                                                  name: e.name))
                                              .toList(),
                                          value: CustomDropdownValue(
                                              name: paymentMethods
                                                  .firstWhereOrNull((element) =>
                                                      element.id ==
                                                      data.quote
                                                          .paymentMethodId)
                                                  ?.name),
                                          onChanged: (index) {
                                            setState(() {
                                              data.quote.paymentMethodId =
                                                  paymentMethods[index].id;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        )),
                    ExpandedWidgetType(
                        title: "Invoice Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalSpace: 16,
                          children: [
                            SpacedRow(
                              horizontalSpace: 64,
                              children: [
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalSpace: 16,
                                  children: [
                                    labelWithField(
                                      "Address Line 1",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        controller: TextEditingController(
                                            text: data.quote.addressLine1),
                                        hintText: "Enter address line 1",
                                        onChanged: (value) =>
                                            data.quote.addressLine1 = value,
                                      ),
                                    ),
                                    labelWithField(
                                      "City",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        controller: TextEditingController(
                                            text: data.quote.addressCity),
                                        hintText: "Enter city",
                                        onChanged: (value) =>
                                            data.quote.addressCity = value,
                                      ),
                                    ),
                                    labelWithField(
                                      "Country",
                                      DropdownWidgetV2(
                                        hasSearchBox: true,
                                        hintText: "Select country",
                                        dropdownBtnWidth: fieldWidth,
                                        dropdownOptionsWidth: fieldWidth,
                                        items: countries
                                            .map((e) => CustomDropdownValue(
                                                name: e.name))
                                            .toList(),
                                        value: CustomDropdownValue(
                                            name: countries
                                                    .firstWhereOrNull(
                                                        (element) =>
                                                            element.code ==
                                                            data.quote
                                                                .addressCountry)
                                                    ?.name ??
                                                ""),
                                        onChanged: (index) {
                                          setState(() {
                                            data.quote.addressCountry =
                                                countries[index].code;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SpacedColumn(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalSpace: 16,
                                    children: [
                                      labelWithField(
                                        "Address Line 2",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text: data.quote.addressLine2),
                                          hintText: "Enter address line 2",
                                          onChanged: (value) =>
                                              data.quote.addressLine2 = value,
                                        ),
                                      ),
                                      labelWithField(
                                        "County",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text: data.quote.addressCounty),
                                          hintText: "Enter county",
                                          onChanged: (value) =>
                                              data.quote.addressCounty = value,
                                        ),
                                      ),
                                      labelWithField(
                                        "Postcode",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text: data.quote.addressPostcode),
                                          hintText: "Enter postcode",
                                          onChanged: (value) => data
                                              .quote.addressPostcode = value,
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        )),
                    ExpandedWidgetType(
                        title: "Work Address",
                        child: SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalSpace: 16,
                          children: [
                            SpacedRow(
                              horizontalSpace: 64,
                              children: [
                                SpacedColumn(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalSpace: 16,
                                  children: [
                                    labelWithField(
                                      "Address Line 1",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        controller: TextEditingController(
                                            text: data.quote.workAddressLine1),
                                        hintText: "Enter address line 1",
                                        onChanged: (value) =>
                                            data.quote.workAddressLine1 = value,
                                      ),
                                    ),
                                    labelWithField(
                                      "City",
                                      TextInputWidget(
                                        width: fieldWidth,
                                        controller: TextEditingController(
                                            text: data.quote.workAddressCity),
                                        hintText: "Enter city",
                                        onChanged: (value) =>
                                            data.quote.workAddressCity = value,
                                      ),
                                    ),
                                    labelWithField(
                                      "Country",
                                      DropdownWidgetV2(
                                        hasSearchBox: true,
                                        hintText: "Select country",
                                        dropdownBtnWidth: fieldWidth,
                                        dropdownOptionsWidth: fieldWidth,
                                        items: countries
                                            .map((e) => CustomDropdownValue(
                                                name: e.name))
                                            .toList(),
                                        value: CustomDropdownValue(
                                            name: countries
                                                    .firstWhereOrNull((element) =>
                                                        element.code ==
                                                        data.quote
                                                            .workAddressCountry)
                                                    ?.name ??
                                                ""),
                                        onChanged: (index) {
                                          setState(() {
                                            data.quote.workAddressCountry =
                                                countries[index].code;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SpacedColumn(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    verticalSpace: 16,
                                    children: [
                                      labelWithField(
                                        "Address Line 2",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text:
                                                  data.quote.workAddressLine2),
                                          hintText: "Enter address line 2",
                                          onChanged: (value) => data
                                              .quote.workAddressLine2 = value,
                                        ),
                                      ),
                                      labelWithField(
                                        "County",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text:
                                                  data.quote.workAddressCounty),
                                          hintText: "Enter county",
                                          onChanged: (value) => data
                                              .quote.workAddressCounty = value,
                                        ),
                                      ),
                                      labelWithField(
                                        "Postcode",
                                        TextInputWidget(
                                          width: fieldWidth,
                                          controller: TextEditingController(
                                              text: data
                                                  .quote.workAddressPostcode),
                                          hintText: "Enter postcode",
                                          onChanged: (value) => data.quote
                                              .workAddressPostcode = value,
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        )),
                    ExpandedWidgetType(
                        title: "Comments",
                        child: labelWithField(
                          "Quote Notes",
                          TextInputWidget(
                            width: fieldWidth * 2 + 64,
                            hintText: "",
                            onChanged: (value) {
                              data.quote.quoteComments = value;
                            },
                          ),
                        )),
                    ExpandedWidgetType(
                        title: "Products", child: _products(state)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addIcon(
      {String? tooltip,
      VoidCallback? onPressed,
      HeroIcons? icon,
      Color? color}) {
    return IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (color ?? ThemeColors.MAIN_COLOR)
                    .withOpacity(.5), //Colors.grey[300]!,
              ),
            ),
            child: HeroIcon(
              icon ?? HeroIcons.add,
              color: (color ?? ThemeColors.MAIN_COLOR),
            )));
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
