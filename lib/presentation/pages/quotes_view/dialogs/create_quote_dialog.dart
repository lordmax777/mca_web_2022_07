import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/clients_view/dialogs/clients_edit_2_dialog.dart';
import 'package:mca_dashboard/presentation/pages/quotes_view/widgets/repeat_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../scheduling_view/data/week_days_m.dart';

class CreateQuoteDialog extends StatefulWidget {
  final QuoteMd? quote;

  const CreateQuoteDialog({
    super.key,
    this.quote,
  });

  @override
  State<CreateQuoteDialog> createState() => _CreateQuoteDialogState();
}

class _CreateQuoteDialogState extends State<CreateQuoteDialog> {
  QuoteMd? get quote => widget.quote;
  QuoteProcess get processStatus =>
      quote?.processStatusEnum ?? QuoteProcess.idle;

  final List<UserMd> unavailableUsers = [];
  String? currentIpAddress;

  late final List<PlutoColumn> productTableColumns = [
    PlutoColumn(
      title: "id",
      type: PlutoColumnType.text(),
      field: "id",
      hide: true,
    ),
    PlutoColumn(
        title: "Title",
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        field: "title"),
    PlutoColumn(
      title: "Customer's price",
      type: PlutoColumnType.currency(
          symbol: appStore.state.generalState.companyInfo.currency.sign),
      field: "price",
      enableAutoEditing: true,
      width: 200,
      minWidth: 200,
      enableEditingMode: true,
      footerRenderer: (context) {
        final double total = context.stateManager.rows
            .where((element) => element.checked ?? false)
            .map((e) =>
                (e.cells["price"]?.value ?? 0) *
                (e.cells["quantity"]?.value ?? 0))
            .fold(0, (a, b) {
          return a + b;
        });

        return Tooltip(
          message: total.getPriceMap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              total.getPriceMap(),
              maxLines: 2,
              textAlign: TextAlign.end,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      renderer: (rendererContext) =>
          rendererContext.defaultEditableCellWidget(),
    ),
    PlutoColumn(
      title: "Quantity",
      width: 150,
      minWidth: 150,
      type: PlutoColumnType.number(),
      field: "quantity",
      enableAutoEditing: true,
      enableEditingMode: true,
      renderer: (rendererContext) =>
          rendererContext.defaultEditableCellWidget(),
    ),
    //included in service checkbox
    PlutoColumn(
      width: 120,
      title: "Included in service (All)",
      type: PlutoColumnType.text(),
      enableRowChecked: true,
      enableSorting: false,
      enableFilterMenuItem: false,
      enableAutoEditing: false,
      enableEditingMode: false,
      field: "auto",
    ),
    PlutoColumn(
      width: 40,
      title: "",
      field: "deleteBtn",
      enableAutoEditing: false,
      enableEditingMode: false,
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        return Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.error,
            constraints: const BoxConstraints(),
            onPressed: () {
              rendererContext.stateManager.removeRows([rendererContext.row]);
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    )
  ];
  PlutoGridStateManager? productSm;

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
          setIp();
          setupVars();
          //todo: init
        }
      },
    );
  }

  void setIp() async {
    final ipAddress = await getIpAddress();
    updateUI(() => currentIpAddress = ipAddress);
  }

  void setupVars() {
    updateUI(() {
      if (quote != null) {
        formVm.patchValue({
          quoteName: quote?.name,
          quoteComment: quote?.notes,
          quoteActive: quote?.active,
          clientId: quote?.clientId.toString(),
          workLocationId: quote?.locationId.toString(),
          workLine1: quote?.addressLine1,
          workLine2: quote?.addressLine2,
          workCity: quote?.addressCity,
          workPostcode: quote?.addressPostcode,
          workCountryId: quote?.addressCountry,
          workCounty: quote?.addressCounty,
          workLocationLatitude: quote?.workLocationLatitude,
          workLocationLongitude: quote?.workLocationLongitude,
          workLocationRadius: quote?.workLocationRadius,
          // workStaticIpAddresses: quote?.,//TODO:
          startTime: quote?.workStartTime?.timeToDateTime,
          endTime: quote?.workFinishTime?.timeToDateTime,
          allDay: quote?.allDay,
          timingRepeatId: quote?.workRepeat?.toString(),
          timingWeek1: WeekDaysMd.fromQuoteWorkDays(quote?.workDays ?? []),
          timingWeek2: WeekDaysMd.fromQuoteWorkDays(quote?.workDays ?? [],
              isFortnightly: true),
        });
        formVm.save();
      }
    });
  }

  final formVm = FormModel();
  // static const String quoteId = "quoteId";
  static const String quoteName = "quoteName";
  static const String quoteActive = "quoteActive";
  static const String quoteComment = "quoteComment";
  static const String clientId = "clientId";
  static const String workLocationId = "workLocationId";
  static const String workLine1 = "workLine1";
  static const String workLine2 = "workLine2";
  static const String workCity = "workCity";
  static const String workPostcode = "workPostcode";
  static const String workCountryId = "workCountryId";
  static const String workCounty = "workCounty";
  static const String workLocationLatitude = "workLocationLatitude";
  static const String workLocationLongitude = "workLocationLongitude";
  static const String workLocationRadius = "workLocationRadius";
  static const String workStaticIpAddresses = "workStaticIpAddresses";
  static const String startTime = "startTime";
  static const String endTime = "endTime";
  static const String duration = "duration";
  static const String allDay = "allDay";
  static const String timingRepeatId = "timingRepeatId";
  static const String timingWeek1 = "timingWeek1";
  static const String timingWeek2 = "timingWeek2";
  static const String productSelect = "productSelect";
  static const String packageSelect = "packageSelect";

  static const DpItem noneItem = DpItem(id: "-1", title: "None");

  FormContainer quoteWidget(
      {required double containerWidth, required GeneralState vm}) {
    return FormContainer(
      title: "Quote Details",
      width: containerWidth,
      left: <Widget>[
        if (processStatus == QuoteProcess.idle)
          FormWithLabel(
              labelVm: const LabelModel(text: "Job Title"),
              formBuilderField: processStatus == QuoteProcess.idle
                  ? const FormInput(
                      vm: InputModel(
                          name: quoteName,
                          helperText:
                              "Leave empty to use default name\nDefault name is used from company settings"))
                  : buildText(quote!.name)),
        if (quote != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Quote Number"),
              formBuilderField:
                  buildText("quote!.identifier")), //todo: update quote model
        if (quote != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Status"),
              formBuilderField: buildText(processStatus.name)),
        if (quote?.lastAllocationMd != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Previous shift"),
              formBuilderField:
                  buildText(quote!.shiftMd(vm.properties)?.title ?? "-")),

        if (quote?.nextAllocationMd != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Next scheduled date"),
              formBuilderField:
                  buildText(quote!.nextAllocationMd?.date ?? "-")),
        if (processStatus != QuoteProcess.idle)
          const FormSwitch(vm: SwitchModel(name: quoteActive, title: "Active")),
        const FormWithLabel(
            labelVm: LabelModel(text: "Comment"),
            formBuilderField: FormInput(
                vm: InputModel(
                    name: quoteComment,
                    helperText: "Press ENTER to add new line"))),
      ],
    );
  }

  FormContainer invoiceAddressWidget(
      {required double containerWidth,
      required GeneralState vm,
      required ClientMd? client}) {
    return FormContainer(
        title: "Invoice Address",
        width: containerWidth,
        left: [
          FormWithLabel(
              labelVm: const LabelModel(text: "Line 1"),
              formBuilderField: buildText(client?.address.line1 ?? "-")),
          FormWithLabel(
              labelVm: const LabelModel(text: "Line 2"),
              formBuilderField: buildText(client?.address.line2 ?? "-")),
          FormWithLabel(
              labelVm: const LabelModel(text: "City"),
              formBuilderField: buildText(client?.address.city ?? "-")),
          FormWithLabel(
              labelVm: const LabelModel(text: "Postcode"),
              formBuilderField: buildText(client?.address.postcode ?? "-")),
          FormWithLabel(
              labelVm: const LabelModel(text: "Country"),
              formBuilderField: buildText(
                  client?.address.getCountryMd(vm.lists.countries)?.name ??
                      "-")),
        ]);
  }

  FormContainer workAddressWidget(
      {required double containerWidth,
      required ClientMd? client,
      required LocationMd? workLocation,
      required List<LocationMd> locations,
      required List<CountryMd> countries}) {
    return FormContainer(
      title: "Work Address",
      width: containerWidth,
      left: [
        if (client != null && locations.isNotEmpty)
          FormWithLabel(
              labelVm: const LabelModel(text: "Locations", isRequired: true),
              formBuilderField: FormDropdown(
                  vm: DropdownModel(
                      helperText: "Select location or search for address",
                      onChanged: (p0) => updateUI(formVm.save),
                      name: workLocationId,
                      items: locations
                          .map(
                              (e) => DpItem(id: e.id.toString(), title: e.name))
                          .toList())))
        else
          Text("No locations found. Please select client with location!",
              textAlign: TextAlign.center, style: context.textTheme.bodyLarge),
        FormWithLabel(
          labelVm: const LabelModel(text: "Search Address"),
          formBuilderField: AddressAutocompleteWidget(
              width: containerWidth * .95,
              onSelected: (value) {
                formVm.patchValue({
                  workLine1: value.line1,
                  workLine2: value.line2,
                  workCity: value.city,
                  workPostcode: value.postcode,
                  workCountryId: value.country?.code,
                });
              }),
        ),
        const FormWithLabel(
            labelVm: LabelModel(text: "Line 1"),
            formBuilderField: FormInput(vm: InputModel(name: workLine1))),
        const FormWithLabel(
            labelVm: LabelModel(text: "City"),
            formBuilderField: FormInput(vm: InputModel(name: workCity))),
        const FormWithLabel(
            labelVm: LabelModel(text: "Postcode"),
            formBuilderField: FormInput(vm: InputModel(name: workPostcode))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Country", isRequired: true),
            formBuilderField: FormDropdown(
              vm: DropdownModel(
                name: workCountryId,
                items: countries
                    .map((e) => DpItem(id: e.code, title: e.name))
                    .toList(),
              ),
            )),
      ],
      additionalText: "Show additional details",
      hidden: [
        const FormWithLabel(
            labelVm: LabelModel(text: "Line 2"),
            formBuilderField: FormInput(vm: InputModel(name: workLine2))),
        const FormWithLabel(
            labelVm: LabelModel(text: "County"),
            formBuilderField: FormInput(vm: InputModel(name: workCounty))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Latitude"),
            formBuilderField: FormInput(
                vm: InputModel(
              name: workLocationLatitude,
              valueTransformer: (value) => double.tryParse(value ?? ""),
              inputFormatters: [GlobalConstants.numbersAndDecimalOnlyFormatter],
            ))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Longitude"),
            formBuilderField: FormInput(
                vm: InputModel(
              valueTransformer: (value) => double.tryParse(value ?? ""),
              name: workLocationLongitude,
              inputFormatters: [GlobalConstants.numbersAndDecimalOnlyFormatter],
            ))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Radius"),
            formBuilderField: FormInput(
                vm: InputModel(
              valueTransformer: (value) => double.tryParse(value ?? ""),
              name: workLocationRadius,
              inputFormatters: [GlobalConstants.numbersAndDecimalOnlyFormatter],
            ))),
        FormWithLabel(
          labelVm: const LabelModel(text: "Current IP Address"),
          formBuilderField: buildText(currentIpAddress ?? "-"),
        ),
        const FormWithLabel(
            labelVm: LabelModel(text: "Static IP Addresses"),
            formBuilderField: FormInput(
                vm: InputModel(
              name: workStaticIpAddresses,
              helperText: "Separate with new line (ENTER)",
            ))),
      ],
    );
  }

  FormContainer timingWidget(
      {required double containerWidth,
      required GeneralState vm,
      required QuoteMd? quote}) {
    return FormContainer(
      title: "Timing",
      width: containerWidth,
      left: [
        FormSwitch(
            vm: SwitchModel(
          name: allDay,
          title: "All Day",
          onChanged: (value) {
            if (value == true) {
              formVm.patchValue({
                startTime: DateTime(2021, 1, 1, 0, 0),
                endTime: DateTime(2021, 1, 1, 23, 59),
              });
            } else {
              formVm.patchValue({
                startTime: null,
                endTime: null,
              });
            }
          },
        )),
        const FormWithLabel(
            labelVm: LabelModel(text: "Start Time"),
            formBuilderField: FormDatePicker(
                vm: DatePickerModel(name: startTime, type: InputType.time))),
        const FormWithLabel(
            labelVm: LabelModel(text: "End Time"),
            formBuilderField: FormDatePicker(
                vm: DatePickerModel(
                    name: endTime,
                    type: InputType.time,
                    helperText: "Can add duration instead of end time"))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Duration (hours)"),
            formBuilderField: FormInput(
                vm: InputModel(
              name: duration,
              helperText: "Duration is calculated automatically",
              onChanged: (value) {
                final start = formVm.getValue(startTime);
                if (start == null) return;
                if (double.tryParse(value ?? "") == null) {
                  print(value);
                  formVm.patchValue({endTime: null});
                  formVm.save();
                  return;
                }
                //value may come as 3.5 hours, so convert it to minutes
                final inMinutes = double.parse(value!) * 60;
                DateTime newEnd =
                    start.add(Duration(minutes: inMinutes.toInt()));
                formVm.patchValue({endTime: newEnd});
                formVm.save();
              },
              inputFormatters: [GlobalConstants.numbersAndDecimalOnlyFormatter],
            ))),
        const SizedBox(height: 4),
        RepeatWidget(
            onDpChanged: (_) => updateUI(formVm.save),
            label: "Repeat Frequency",
            repeatName: timingRepeatId,
            week1Name: timingWeek1,
            week2Name: timingWeek2,
            formVm: formVm)
      ],
    );
  }

  Widget clientWidget(
      {required double containerWidth,
      required List<ClientMd> clients,
      required ClientMd? client}) {
    return FormContainer(
      width: containerWidth,
      title: "Client Details",
      trailing: Row(
        children: [
          if (client != null)
            IconButton(
                tooltip: "Edit client",
                onPressed: () => onEditClient(client),
                color: context.theme.primaryColor,
                icon: const Icon(Icons.edit_outlined)),
          IconButton(
              tooltip: "Add new client",
              onPressed: () => onEditClient(null),
              color: context.theme.primaryColor,
              icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      left: [
        FormWithLabel(
            labelVm: const LabelModel(text: "Client", isRequired: true),
            formBuilderField: FormDropdown(
                vm: DropdownModel(
                    name: clientId,
                    onChanged: (p0) {
                      updateUI(formVm.save);
                    },
                    hasSearchBox: true,
                    items: clients
                        .map((e) => DpItem(
                            id: e.id.toString(),
                            title: e.name,
                            subtitle: e.company))
                        .toList()
                      ..insert(0, noneItem)))),
        FormWithLabel(
          labelVm: const LabelModel(text: "Company"),
          formBuilderField: buildText(client?.company ?? "-"),
        ),
        FormWithLabel(
          labelVm: const LabelModel(text: "Phone"),
          formBuilderField: buildText(client?.phone ?? "-"),
        ),
        FormWithLabel(
          labelVm: const LabelModel(text: "Email"),
          formBuilderField: buildText(client?.email ?? "-"),
        ),
      ],
      // additionalText: "Show Client Details",
    );
  }

  Widget productTable(
      {required List<StorageItemMd> storageItems,
      required List<JobTemplateMd> packages}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
          width: double.infinity,
          height: context.height * .7,
          child: DefaultTable(
              headerStart: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Products and Services",
                      style: context.textTheme.headlineMedium!
                          .copyWith(color: Colors.black)),
                  SizedBox(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Product select
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FormLabel(
                                    vm: LabelModel(text: "Product")),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: FormDropdown(
                                      vm: DropdownModel(
                                          name: productSelect,
                                          hasSearchBox: true,
                                          onChanged: (p0) {
                                            onAddProduct(storageItems
                                                .firstWhereOrNull((element) =>
                                                    element.id.toString() ==
                                                    p0));
                                          },
                                          hintText:
                                              "Search for product or service",
                                          items: storageItems
                                              .map((e) => DpItem(
                                                  id: e.id.toString(),
                                                  title: e.name,
                                                  subtitle: e.service
                                                      ? "Service"
                                                      : null))
                                              .toList())),
                                ),
                              ],
                            ),
                          ),
                          //Package select
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FormLabel(
                                    vm: LabelModel(text: "Package")),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: FormDropdown(
                                      vm: DropdownModel(
                                          name: packageSelect,
                                          hasSearchBox: true,
                                          hintText: "Search for package",
                                          onChanged: (p0) {
                                            final int? templateId =
                                                int.tryParse(p0 ?? "");
                                            if (templateId != null) {
                                              final template = packages
                                                  .firstWhereOrNull((element) =>
                                                      element.id == templateId);
                                              if (template != null) {
                                                //remove all items before adding
                                                productSm?.removeAllRows();
                                                //add all items
                                                for (var item
                                                    in template.items) {
                                                  onAddProduct(storageItems
                                                      .firstWhereOrNull(
                                                          (element) =>
                                                              element.id ==
                                                              item.itemId));
                                                }
                                              }
                                            }
                                          },
                                          items: packages
                                              .map((e) => DpItem(
                                                  id: e.id.toString(),
                                                  title: e.name,
                                                  subtitle:
                                                      "${e.items.length} items"))
                                              .toList())),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              onLoaded: (p0) {
                p0.stateManager.setPageSize(100);
                productSm = p0.stateManager;

                productSm?.addListener(() {
                  updateUI(() {});
                });
              },
              columns: productTableColumns,
              hasFooter: false,
              mode: PlutoGridMode.normal,
              rows: [])),
    );
  }

  Widget buildText(String text) {
    return SelectableText(
      text.isEmpty ? "-" : text,
      style:
          context.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
      converter: (store) => store.state.generalState,
      builder: (context, vm) {
        final List<ClientMd> clients =
            [...vm.clients].where((element) => element.active).toList();

        final ClientMd? client = clients.firstWhereOrNull(
            (element) => element.id.toString() == formVm.getValue(clientId));

        final LocationMd? workLocation = vm.locations.firstWhereOrNull(
            (element) =>
                element.id.toString() == formVm.getValue(workLocationId));

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

        return DefaultForm(
          vm: formVm,
          child: SizedBox(
            height: context.height * 1.2,
            width: context.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Quote, Work Address, Timing, Product table
                SizedBox(
                  width: containerWidth * 3.5,
                  child: SingleChildScrollView(
                    child: FormWrap(alignment: WrapAlignment.center, children: [
                      //Quote Widget
                      quoteWidget(containerWidth: containerWidth, vm: vm),
                      //Work address
                      workAddressWidget(
                          containerWidth: containerWidth,
                          client: client,
                          workLocation: workLocation,
                          locations: locations,
                          countries: vm.lists.countries),
                      //Timing
                      timingWidget(
                          containerWidth: containerWidth, vm: vm, quote: quote),
                      //Product table
                      productTable(
                          packages: jobTemplates, storageItems: storageItems),
                    ]),
                  ),
                ),
                //Divider
                Container(
                  margin: const EdgeInsets.only(right: 40),
                  height: context.height * 1.2,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: context.theme.dividerColor, width: 1),
                    ),
                  ),
                ),
                //Client
                SpacedColumn(
                  mainAxisSize: MainAxisSize.min,
                  verticalSpace: 10,
                  children: [
                    clientWidget(
                        containerWidth: containerWidth,
                        clients: clients,
                        client: client),
                    //Invoice address
                    invoiceAddressWidget(
                        containerWidth: containerWidth, vm: vm, client: client),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onEditClient(ClientMd? client) async {
    final int? updatedClientId = await showDialog(
        context: context,
        builder: (context) {
          return ClientsEdit2Dialog(client: client);
        });
    if (updatedClientId != null) {
      formVm.patchValue({clientId: updatedClientId.toString()});
      updateUI(formVm.save);
    }
  }

  PlutoRow buildStorageRow(StorageItemMd storageItem, {bool checked = false}) {
    final isService = storageItem.service;
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: storageItem.id),
        "title": PlutoCell(
            value: "${storageItem.name} ${isService ? "(Service)" : ""}"),
        "price": PlutoCell(value: storageItem.outgoingPrice),
        "quantity": PlutoCell(value: storageItem.quantity),
        "auto": PlutoCell(value: "Included in service"),
        "deleteBtn": PlutoCell(value: ""),
      },
    );
  }

  void onAddProduct([StorageItemMd? storageItem]) {
    if (storageItem != null) {
      //Add to table
      if (productSm?.rows
              .any((element) => element.cells['id']!.value == storageItem.id) ==
          true) {
        final rowIdx = productSm?.rows.indexWhere(
            (element) => element.cells['id']!.value == storageItem.id);
        if (rowIdx == null) return;
        final row = productSm?.rows[rowIdx];
        if (row == null) return;
        final qty = row.cells['quantity']!.value as int;
        productSm?.rows[rowIdx].cells['quantity']!.value = qty + 1;
        updateUI(() {});
      } else {
        productSm?.insertRows(
            0, [buildStorageRow(storageItem, checked: storageItem.auto)]);
      }
    }
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
}
