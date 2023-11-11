import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/clients_view/dialogs/clients_edit_2_dialog.dart';
import 'package:mca_dashboard/presentation/pages/locations_view/create_location_popup.dart';
import 'package:mca_dashboard/presentation/pages/quotes_view/widgets/repeat_widget.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../scheduling_view/data/week_days_m.dart';
import '../../scheduling_view/dialogs/team_popup2.dart';
import '../../scheduling_view/schedule_widgets/team_member2_widget.dart';

class CreateQuoteDialog extends StatefulWidget {
  final QuoteMd? quote;
  final bool isJob;

  const CreateQuoteDialog({
    super.key,
    this.quote,
    this.isJob = false,
  });

  @override
  State<CreateQuoteDialog> createState() => _CreateQuoteDialogState();
}

class _CreateQuoteDialogState extends State<CreateQuoteDialog> {
  QuoteMd? get quote => widget.quote;

  QuoteProcess? get processStatus => quote?.processStatusEnum;

  bool get isCreate => quote == null;

  bool get isJob => widget.isJob;

  bool get isQuote => !isJob;

  final List<UserMd> unavailableUsers = [];
  final List<UserMd> addedUsers = [];
  String? currentIpAddress;
  int? tempLocationId;

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
      width: 150,
      minWidth: 150,
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
      width: 120,
      minWidth: 120,
      type: PlutoColumnType.number(),
      field: "quantity",
      enableAutoEditing: true,
      enableEditingMode: true,
      // footerRenderer: (context) {
      //   final TextEditingController controller = TextEditingController();
      //   context.stateManager.keyManager?.eventResult
      //       .skip(KeyEventResult.ignored);
      //   final double total = context.stateManager.rows
      //       .where((element) => element.checked ?? false)
      //       .map((e) =>
      //           (e.cells["price"]?.value ?? 0) *
      //           (e.cells["quantity"]?.value ?? 0))
      //       .fold(0, (a, b) {
      //     return a + b;
      //   });
      //
      //   FocusNode focusNode = FocusNode(onKey: (_, __) {
      //     return KeyEventResult.handled;
      //   });
      //   return Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         const Text(
      //           "Discount:",
      //           maxLines: 2,
      //           textAlign: TextAlign.end,
      //           softWrap: true,
      //           overflow: TextOverflow.ellipsis,
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //         const SizedBox(width: 10),
      //         SizedBox(
      //           width: 100,
      //           height: 50,
      //           child: TextField(
      //             focusNode: focusNode,
      //           ),
      //           // FormInput(
      //           //     vm: InputModel(
      //           //   name: productsDiscount,
      //           //   valueTransformer: (value) => double.tryParse(value ?? ""),
      //           //   // inputFormatters: [
      //           //   //   GlobalConstants.numbersAndDecimalOnlyFormatter
      //           //   // ],
      //           // )),
      //         ),
      //         const Text(
      //           "%",
      //           maxLines: 2,
      //           textAlign: TextAlign.end,
      //           softWrap: true,
      //           overflow: TextOverflow.ellipsis,
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //       ],
      //     ),
      //   );
      // },
      renderer: (rendererContext) =>
          rendererContext.defaultEditableCellWidget(),
    ),
    //included in service checkbox
    PlutoColumn(
      width: 120,
      minWidth: 120,
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
      minWidth: 40,
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          setIp();
          setupVars();
          fetchUnavailableUsers();
        }
      },
    );
  }

  void updateUI(VoidCallback? callback) {
    if (mounted) {
      setState(callback ?? () {});
    }
  }

  void setIp() async {
    final ipAddress = await getIpAddress();
    updateUI(() => currentIpAddress = ipAddress);
  }

  Future<void> fetchUnavailableUsers() async {
    if (getTimingDate == null) return;
    DependencyManager.instance.navigation.futureLoading(() async {
      final users = await dispatch<List<UserMd>>(
          //2023, 04, 23 => can use for testing, that has unav users
          GetUnavailableUserListAction(
        // DateTime(2023, 04, 23),
        getTimingDate!,
      ));
      if (users.isLeft) {
        // can use users from store
        unavailableUsers.clear();
        unavailableUsers.addAll(users.left);

        //removing initially added members if they are unavailable
        for (final user in users.left) {
          if (user.unavailability.isUnavailable) {
            addedUsers.removeWhere((element) => element.id == user.id);
          }
        }
        updateUI(() {});
      } else {
        updateUI(() {
          DependencyManager.instance.navigation.showFail(
              'Failed to fetch unavailable users. ${users.right.message}');
        });
      }
    });
  }

  void setupVars() {
    if (quote != null) {
      try {
        formVm.patchValue({
          quoteName: quote!.name,
          quoteComment: quote!.notes,
          quoteActive: quote!.active,
          clientId: quote!.clientId.toString(),
          workLine1: quote!.addressLine1,
          workLine2: quote!.addressLine2,
          workCity: quote!.addressCity,
          workPostcode: quote!.addressPostcode,
          workCountryId: quote!.addressCountry,
          workCounty: quote!.addressCounty,
          workLocationLatitude: quote!.workLocationLatitude.toString(),
          workLocationLongitude: quote!.workLocationLongitude.toString(),
          workLocationRadius: quote!.workLocationRadius.toString(),
          workStaticIpAddresses:
              quote!.workStaticIpAddresses?.split(",").join("\n"),
          startTime: quote!.workStartTime?.timeToDateTime,
          endTime: quote!.workFinishTime?.timeToDateTime,
          allDay: quote!.allDay,
          timingRepeatId: quote
              ?.workRepeatMd(appStore.state.generalState.lists.workRepeats)
              .id
              .toString(),
          timingDate: quote!.workStartDateDt,
          packageSelect: quote!
              .jobTemplateMd(appStore.state.generalState.jobTemplates)
              ?.id
              .toString(),
          // timingRepeatUntil: quote?.workRepeatUntilDt,//todo: when api is ready
        });

        //The weekdays are hidden until the repeat day validates it.
        //So need to wait UI until it opens weekdays
        Future.delayed(const Duration(milliseconds: 100), () {
          formVm.patchValue({
            timingWeek1: WeekDaysMd.fromQuoteWorkDays(quote?.workDays ?? [])
                .asListString,
            timingWeek2: WeekDaysMd.fromQuoteWorkDays(quote?.workDays ?? [],
                    isFortnightly: true)
                .asListString,
            workLocationId: quote!.locationId.toString(),
          });
        });
        updateUI(formVm.save);
      } on TypeError catch (e) {
        print(e.toString());
        print(e.stackTrace);
      }
    }
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
  static const String timingDate = "timingDate";
  static const String timingRepeatUntil = "timingRepeatUntil";
  static const String productsDiscount = "productsDiscount";

  String? get getQuoteName => formVm.getValue(quoteName);
  bool? get getQuoteActive => formVm.getValue(quoteActive);
  String? get getQuoteComment => formVm.getValue(quoteComment);
  String? get getClientId => formVm.getValue(clientId);
  String? get getWorkLocationId => formVm.getValue(workLocationId);
  String? get getWorkLine1 => formVm.getValue(workLine1);
  String? get getWorkLine2 => formVm.getValue(workLine2);
  String? get getWorkCity => formVm.getValue(workCity);
  String? get getWorkPostcode => formVm.getValue(workPostcode);
  String? get getWorkCountryId => formVm.getValue(workCountryId);
  String? get getWorkCounty => formVm.getValue(workCounty);
  String? get getWorkLocationLatitude => formVm.getValue(workLocationLatitude);
  String? get getWorkLocationLongitude =>
      formVm.getValue(workLocationLongitude);
  String? get getWorkLocationRadius => formVm.getValue(workLocationRadius);
  String? get getWorkStaticIpAddresses =>
      formVm.getValue(workStaticIpAddresses);
  DateTime? get getStartTime => formVm.getValue(startTime);
  DateTime? get getEndTime => formVm.getValue(endTime);
  bool? get getAllDay => formVm.getValue(allDay);
  String? get getTimingRepeatId => formVm.getValue(timingRepeatId);
  List<String>? get getTimingWeek1 => formVm.getValue(timingWeek1);
  List<String>? get getTimingWeek2 => formVm.getValue(timingWeek2);
  DateTime? get getTimingDate => formVm.getValue(timingDate);
  DateTime? get getTimingRepeatUntil => formVm.getValue(timingRepeatUntil);
  String? get getPackageSelect => formVm.getValue(packageSelect);
  static const DpItem noneItem = DpItem(id: "-1", title: "None");

  FormContainer quoteWidget(
      {required double containerWidth, required GeneralState vm}) {
    return FormContainer(
      title: "${isJob ? "Job" : "Quote"} Details",
      width: containerWidth,
      left: <Widget>[
        FormWithLabel(
            labelVm: const LabelModel(text: "Job Title"),
            formBuilderField: isCreate
                ? const FormInput(
                    vm: InputModel(
                        name: quoteName,
                        helperText:
                            "Leave empty to use default name\nWork address + First Service/Package + Client"))
                : buildText(quote!.name)),
        // if (quote != null) divider(),
        if (quote != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Quote Number"),
              formBuilderField: buildText(quote!.identifier)),
        // if (quote != null) divider(),
        if (quote != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Status"),
              formBuilderField: buildText(quote!.processStatus)),
        // if (quote?.lastAllocationMd != null) divider(),
        if (quote?.lastAllocationMd != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Previous shift"),
              formBuilderField:
                  buildText(quote!.shiftMd(vm.properties)?.title ?? "-")),
        // if (quote?.nextAllocationMd != null) divider(),
        if (quote?.nextAllocationMd != null)
          FormWithLabel(
              labelVm: const LabelModel(text: "Next scheduled date"),
              formBuilderField:
                  buildText(quote!.nextAllocationMd?.date ?? "-")),
        Visibility(
            maintainState: true,
            visible: !isCreate,
            child: FormSwitch(
                vm: SwitchModel(
                    name: quoteActive,
                    initialValue: isCreate,
                    title: "Active"))),
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
      required AddressMd address}) {
    return FormContainer(
        title: "Invoice Address",
        width: containerWidth,
        left: [
          buildText("${address.line1}, "
              "${address.postcode ?? ""}, ${address.city ?? ""}, ${address.getCountryMd(vm.lists.countries)?.name ?? ""}"),
          // // divider(),
          // FormWithLabel(
          //     labelVm: const LabelModel(text: "Line 2"),
          //     formBuilderField: buildText(client?.address.line2 ?? "-")),
          // // divider(),
          // FormWithLabel(
          //     labelVm: const LabelModel(text: "City"),
          //     formBuilderField: buildText(client?.address.city ?? "-")),
          // // divider(),
          // FormWithLabel(
          //     labelVm: const LabelModel(text: "Postcode"),
          //     formBuilderField: buildText(client?.address.postcode ?? "-")),
          // // divider(),
          // FormWithLabel(
          //     labelVm: const LabelModel(text: "Country"),
          //     formBuilderField: buildText(
          //         client?.address.getCountryMd(vm.lists.countries)?.name ??
          //             "-")),
        ]);
  }

  Widget workAddressWidget2(
      {required double containerWidth,
      required List<LocationMd> locations,
      required List<CountryMd> countries,
      required ClientMd? client}) {
    final LocationMd? location = locations.firstWhereOrNull(
        (element) => element.id.toString() == getWorkLocationId);
    return FormContainer(
        title: "Work address",
        width: containerWidth,
        trailing: IconButton(
          tooltip: "Create location",
          icon: const Icon(Icons.add_circle_outline),
          color: context.theme.primaryColor,
          onPressed: onCreateLocation,
        ),
        left: [
          if (client != null && locations.isNotEmpty)
            FormWithLabel(
                labelVm: const LabelModel(text: "Locations", isRequired: true),
                formBuilderField: FormDropdown(
                    vm: DropdownModel(
                        helperText: "Select location or search for address",
                        onChanged: (p0) => updateUI(formVm.save),
                        name: workLocationId,
                        validator: FormBuilderValidators.required(
                            errorText: "Please select location"),
                        hasSearchBox: true,
                        items: locations
                            .map((e) =>
                                DpItem(id: e.id.toString(), title: e.name))
                            .toList())))
          else
            Text("No locations found. Please select client with location!",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge),
          if (location == null)
            const SizedBox()
          else
            buildText(
                "${location.address.line1}, ${location.address.city}, ${location.address.getCountryMd(countries)?.name ?? ""}"),
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
                      hasSearchBox: true,
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
        FormWithLabel(
            labelVm: const LabelModel(text: "Line 1", isRequired: true),
            formBuilderField: FormInput(
                vm: InputModel(
                    name: workLine1,
                    validators: [FormBuilderValidators.required()]))),
        FormWithLabel(
            labelVm: const LabelModel(text: "City", isRequired: true),
            formBuilderField: FormInput(
                vm: InputModel(
                    name: workCity,
                    validators: [FormBuilderValidators.required()]))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Postcode", isRequired: true),
            formBuilderField: FormInput(
                vm: InputModel(
                    name: workPostcode,
                    validators: [FormBuilderValidators.required()]))),
        FormWithLabel(
            labelVm: const LabelModel(text: "Country", isRequired: true),
            formBuilderField: FormDropdown(
              vm: DropdownModel(
                name: workCountryId,
                hasSearchBox: true,
                hintText: "",
                validator: FormBuilderValidators.required(),
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
        FormWithLabel(
            labelVm: LabelModel(
                text: "Date",
                isRequired: processStatus == QuoteProcess.jobCreated),
            formBuilderField: FormDatePicker(
              vm: DatePickerModel(
                  name: timingDate,
                  onChanged: (value) {
                    if (value == null) return;
                    updateUI(() {
                      fetchUnavailableUsers();
                    });
                  },
                  validators: [
                    if (processStatus == QuoteProcess.jobCreated)
                      FormBuilderValidators.required()
                  ]),
            )),
        const SizedBox(),
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
        FormWithLabel(
            labelVm: LabelModel(
                text: "Start Time",
                isRequired: processStatus == QuoteProcess.jobCreated),
            formBuilderField: FormDatePicker(
                vm: DatePickerModel(
              name: startTime,
              type: InputType.time,
              validators: [
                if (processStatus == QuoteProcess.jobCreated)
                  FormBuilderValidators.required(),
              ],
            ))),
        FormWithLabel(
            labelVm: LabelModel(
                text: "End Time",
                isRequired: processStatus == QuoteProcess.jobCreated),
            formBuilderField: FormDatePicker(
                vm: DatePickerModel(
                    name: endTime,
                    type: InputType.time,
                    validators: [
                      if (processStatus == QuoteProcess.jobCreated)
                        FormBuilderValidators.required(),
                    ],
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
        if (formVm.getValue(timingRepeatId) != null &&
            formVm.getValue(timingRepeatId) != "1")
          FormWithLabel(
              labelVm: const LabelModel(text: "Repeat until", isRequired: true),
              formBuilderField: FormDatePicker(
                vm: DatePickerModel(
                    name: timingRepeatUntil,
                    validators: [FormBuilderValidators.required()]),
              )),
        RepeatWidget(
            onDpChanged: (_) => updateUI(formVm.save),
            label: "Repeat Frequency",
            repeatName: timingRepeatId,
            week1Name: timingWeek1,
            week2Name: timingWeek2,
            formVm: formVm),
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
      trailing: isCreate
          ? Row(
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
            )
          : null,
      left: [
        Visibility(
          maintainState: true,
          visible: isCreate,
          child: FormWithLabel(
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
        ),
        if (!isCreate)
          FormWithLabel(
              labelVm: const LabelModel(text: "Client"),
              formBuilderField: buildText(client?.name ?? "-")),
        FormWithLabel(
          labelVm: const LabelModel(text: "Company"),
          formBuilderField: buildText(client?.company ?? "-"),
        ),
        // divider(),
        FormWithLabel(
          labelVm: const LabelModel(text: "Phone"),
          formBuilderField: buildText(client?.phone ?? "-"),
        ),
        // divider(),
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
          height: context.height * .5,
          child: DefaultTable(
              headerStart: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Products and Services",
                      style: context.textTheme.headlineMedium!
                          .copyWith(color: Colors.black)),
                  if (isJob && !isCreate)
                    const SizedBox()
                  else
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
                                                final template =
                                                    packages.firstWhereOrNull(
                                                        (element) =>
                                                            element.id ==
                                                            templateId);
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

                if (quote != null) {
                  for (JobTemplateItemMd item
                      in (quote?.jobTemplateMd(packages)?.items ?? [])) {
                    onAddProduct(item.item(storageItems));
                  }
                  //Add all items from quote
                  for (var item in quote!.items) {
                    onAddProduct(item.itemMd(storageItems));
                  }
                }

                productSm?.addListener(() {
                  if (productSm?.rows.isEmpty == true) {
                    //clear product and package select if the table is empty
                    updateUI(() {
                      formVm.patchValue(
                          {productSelect: null, packageSelect: null});
                      formVm.save();
                    });
                  }
                  updateUI(() {});
                });
              },
              columns: productTableColumns,
              hasFooter: false,
              mode: isJob && !isCreate
                  ? PlutoGridMode.selectWithOneTap
                  : PlutoGridMode.normal,
              rows: [])),
    );
  }

  Widget teamsWidget(
      {required double containerWidth, required GeneralState vm}) {
    return FormContainer(
      title: "Teams",
      trailing: getTimingDate != null
          ? IconButton(
              tooltip: "Add team member",
              onPressed: onAddTeamMember,
              color: context.theme.primaryColor,
              icon: const Icon(Icons.add_circle_outline))
          : null,
      width: containerWidth,
      left: [
        if (addedUsers.isNotEmpty)
          ...addedUsers.map((e) {
            return Column(
              children: [
                TeamMember2Widget(
                  userName: e.fullname,
                  specialStartTime: e.specialStartTime,
                  specialFinishTime: e.specialFinishTime,
                  onSpecialFinishTimeChanged: (value) {
                    updateUI(() {
                      e.specialFinishTime = value;
                    });
                  },
                  onSpecialStartTimeChanged: (value) {
                    updateUI(() {
                      e.specialStartTime = value;
                    });
                  },
                  onDeleted: () {
                    updateUI(() {
                      addedUsers.remove(e);
                    });
                  },
                  specialRateId: e.specialRateId,
                  onSpecialRateChanged: (value) {
                    updateUI(() {
                      e.specialRateId = value;
                    });
                  },
                ),
                if (addedUsers.last != e) const SizedBox(height: 10),
                if (addedUsers.last != e) divider(),
              ],
            );
          }),
        if (getTimingDate == null)
          Center(
            child: Text("Please select date to add team members.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge),
          )
        else
          Center(
            child: Text("No team members added.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge),
          ),
      ],
    );
  }

  Widget buildText(String text) {
    return SelectableText(
      text.isEmpty ? "-" : text,
      style:
          context.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget divider() {
    return const Divider(indent: 0, endIndent: 0, height: 0);
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

        final LocationMd? tempLocation = vm.locations
            .firstWhereOrNull((element) => element.id == tempLocationId);

        final List<LocationMd> locations = [
          if (tempLocation != null) tempLocation,
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

        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          insetPadding: const EdgeInsets.all(16),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          elevation: 10,
          title: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8,
            children: [
              IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                isJob ? "Job" : "Quote",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            ElevatedButton(
                onPressed: () => onSave(vm), child: Text(getSaveText()))
          ],
          content: DefaultForm(
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
                      child:
                          FormWrap(alignment: WrapAlignment.center, children: [
                        //Quote Widget
                        quoteWidget(containerWidth: containerWidth, vm: vm),
                        //Work address
                        // workAddressWidget(
                        //     containerWidth: containerWidth,
                        //     client: client,
                        //     workLocation: workLocation,
                        //     locations: locations,
                        //     countries: vm.lists.countries),
                        teamsWidget(containerWidth: containerWidth, vm: vm),
                        //Timing
                        timingWidget(
                            containerWidth: containerWidth,
                            vm: vm,
                            quote: quote),
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
                      if (client != null)
                        invoiceAddressWidget(
                            containerWidth: containerWidth,
                            vm: vm,
                            address: client.address),
                      //Work address
                      workAddressWidget2(
                          containerWidth: containerWidth,
                          client: client,
                          countries: vm.lists.countries,
                          locations: locations),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onCreateLocation() async {
    final int? res = await context.showDialog(const CreateLocationPopup());
    if (res != null) {
      updateUI(() => tempLocationId = res);
      formVm.patchValue({workLocationId: res.toString()});
      formVm.save();
    }
  }

  void onAddTeamMember() async {
    final res = await DependencyManager.instance.navigation
        .showCustomDialog<List<UserMd>?>(
            context: context,
            builder: (context) {
              return TeamPopup2(
                addedUsers: addedUsers,
                unavailableUsers: unavailableUsers,
              );
            });
    if (res != null) {
      updateUI(() {
        addedUsers.clear();
        addedUsers.addAll(res);
      });
    }
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

  void onSave(GeneralState vm) {
    formVm.saveAndValidate();
    if (!formVm.isValid) return;
    if (productSm!.rows.isEmpty) {
      context.showError("Please add at least one product or service");
      return;
    }
    //If Quote Create -> POST quote
    //If Job -> POST quote, POST quotestatus(accept), POST job from quote
    switch (processStatus) {
      case null:
        if (isJob) {
          //Create Job
          context.futureLoading(() async {
            try {
              final postQuoteResponse = await postQuote(
                  clients: vm.clients,
                  locations: vm.locations,
                  packages: vm.jobTemplates);
              postQuoteResponse.fold((l) async {
                if (l != null) {
                  //success accept quote
                  final quoteAccepted = await changeQuoteStatus(
                      quoteId: l, status: QuoteStatus.accept);
                  quoteAccepted.fold((left) async {
                    //success make job from quote
                    //todo: make job from quote
                    final jobFromQuote = await makeJobFromQuote(quoteId: l);
                    jobFromQuote.fold((left) {
                      //success pop the page or continue
                      context.showSuccess("Job created successfully");
                    }, (right) {
                      //error
                      context.showError(right.message);
                    });
                    // emailQuoteToClient(l);
                  }, (right) {
                    //error
                    context.showError(right.message);
                  });
                } else {
                  context.showError("Error creating quote. Please try again.");
                }
              }, (r) {
                context.showError(r.message);
              });
            } on TypeError catch (e) {
              print(e.stackTrace);
              context.showError("Error creating quote. ${e.toString()}");
            } catch (e) {
              print(e);
            }
          });
        } else {
          //Create quote
          context.futureLoading(() async {
            try {
              final postQuoteResponse = await postQuote(
                  clients: vm.clients,
                  locations: vm.locations,
                  packages: vm.jobTemplates);
              postQuoteResponse.fold((l) {
                if (l != null) {
                  emailQuoteToClient(l).then((value) {
                    context.pop();
                  });
                } else {
                  context.showError("Error creating quote. Please try again.");
                }
              }, (r) {
                context.showError(r.message);
              });
            } on TypeError catch (e) {
              print(e.stackTrace);
              context.showError("Error creating quote. ${e.toString()}");
            }
          });
        }

        break;
      case QuoteProcess.jobCreated:
        // todo: Schedule Job Api
        print("schedule job api");
        break;
      default:
        //todo: do other processes'
        print("default");
        changeQuoteStatus(quoteId: quote!.id, status: QuoteStatus.accept);
    }
  }

  Future<Either<int?, ErrorMd>> postQuote(
      {required List<ClientMd> clients,
      required List<LocationMd> locations,
      required List<JobTemplateMd> packages}) async {
    final clientMd = clients
        .firstWhereOrNull((element) => element.id.toString() == getClientId);
    final repeat = appStore.state.generalState.lists.workRepeats
        .firstWhereOrNull(
            (element) => element.id.toString() == getTimingRepeatId);
    final workLocation = locations.firstWhereOrNull(
        (element) => element.id.toString() == getWorkLocationId);
    final package = packages.firstWhereOrNull(
        (element) => element.id.toString() == getPackageSelect);
    final res = await dispatch<int?>(PostQuoteAction2(
      quoteId: quote?.id,
      jobTitle: getQuoteName,
      client: clientMd!,
      quoteComment: getQuoteComment,
      products: ProductData(stateManager: productSm),
      workLocation: workLocation!,
      active: getQuoteActive,
      workLocationId: getWorkLocationId,
      workStartDate: getTimingDate,
      workStartTime: getStartTime,
      workEndTime: getEndTime,
      packageName: package?.name,
      repeatId: getTimingRepeatId,
      repeatUntilDate: getTimingRepeatUntil,
      team: addedUsers,
      week1: getTimingWeek1,
      week2: getTimingWeek2,
      // checklistTemplateId: //todo:
    ));
    await dispatch(const GetLocationsAction());
    return res;
  }

  Future<Either<bool, ErrorMd>> changeQuoteStatus(
      {required int quoteId, required QuoteStatus status}) async {
    final res = await dispatch<bool>(
        ChangeQuoteStatusAction(id: quoteId, status: status.toStr));
    return res;
  }

  Future<Either<int?, ErrorMd>> makeJobFromQuote({required int quoteId}) async {
    final res = await dispatch<int?>(
        MakeJobFromQuoteAction(quoteId: quoteId, date: getTimingDate));
    return res;
  }

  String getSaveText() {
    switch (processStatus) {
      case null:
        if (isJob) {
          return "Create Job";
        } else {
          return "Create Quote";
        }
      case QuoteProcess.jobCreated:
        return "Schedule Job";
      default:
        return "Save";
    }
  }
}
