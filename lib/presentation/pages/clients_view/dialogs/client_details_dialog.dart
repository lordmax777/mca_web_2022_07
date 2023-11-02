import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/data/models/client.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dialog.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_tab_wrapper.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ClientDetailsDialog extends StatefulWidget {
  final ClientMd client;
  const ClientDetailsDialog({super.key, required this.client});

  @override
  State<ClientDetailsDialog> createState() => _ClientDetailsDialogState();
}

class _ClientDetailsDialogState extends State<ClientDetailsDialog> {
  ClientMd get client => widget.client;
  List<ClientShiftMd> get shifts => client.shiftsList;
  List<ClientInvoiceMd> get invoices => client.invoicesList;
  List<QuoteMd> get quotes => appStore.state.generalState.quotes
      .where((element) => element.clientId == client.id)
      .toList();
  List<ClientExpenseMd> get expenses => client.expensesList;

  PlutoGridStateManager? shiftsManager;
  PlutoGridStateManager? invoicesManager;
  PlutoGridStateManager? quotesManager;
  PlutoGridStateManager? expensesManager;

  final List<PlutoColumn> shiftsColumns = [
    PlutoColumn(
      title: "Name",
      field: "name",
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Location",
      field: "location",
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoColumn> invoicesColumns = [
    PlutoColumn(
      title: "Date",
      field: "date",
      type: PlutoColumnType.date(format: "dd/MM/yyyy"),
    ),
    PlutoColumn(
      title: "Due Date",
      field: "dueDate",
      type: PlutoColumnType.date(format: "dd/MM/yyyy"),
    ),
    PlutoColumn(
      title: "Amount",
      field: "amount",
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Payment method",
      field: "paymentMethod",
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Paid",
      field: "paid",
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoColumn> quotesColumns = [
    // PlutoColumn(
    //   title: "Name",
    //   field: "name",
    //   type: PlutoColumnType.text(),
    //   textAlign: PlutoColumnTextAlign.center,
    //   renderer: (rendererContext) {
    //     return rendererContext.defaultText();
    //   },
    // ),
    PlutoColumn(
      title: "Contact",
      field: "contact",
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      renderer: (rendererContext) {
        return rendererContext.defaultText();
      },
    ),
    PlutoColumn(
      width: 100,
      title: "Status",
      field: "status",
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      formatter: (value) {
        return value.toString().toUpperCase();
      },
    ),
    PlutoColumn(
      width: 100,
      title: "Amount",
      field: "value",
      type: PlutoColumnType.number(format: "#,###.##"),
      textAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      width: 120,
      title: "Last Sent",
      field: "last_sent",
      type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm"),
      textAlign: PlutoColumnTextAlign.center,
      renderer: (rendererContext) {
        return rendererContext.defaultText();
      },
    ),
    PlutoColumn(
      width: 120,
      title: "Created On",
      field: "created_on",
      type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm"),
      textAlign: PlutoColumnTextAlign.center,
      renderer: (rendererContext) {
        return rendererContext.defaultText();
      },
    ),
    PlutoColumn(
      width: 100,
      title: "Valid Until",
      field: "valid_until",
      type: PlutoColumnType.date(format: "dd/MM/yyyy"),
      textAlign: PlutoColumnTextAlign.center,
    ),
  ];

  final List<PlutoColumn> expensesColumns = [
    PlutoColumn(
        title: "Category", field: 'category', type: PlutoColumnType.text()),
    PlutoColumn(
      title: "Amount",
      field: "amount",
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Invoiced",
      field: "invoiced",
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Completed",
      field: "completed",
      type: PlutoColumnType.text(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: "Client Details",
      builder: (context) {
        return DefaultTabWrapper(
          children: [
            TabChild(
                tabName: "Shifts",
                child: DefaultTable(
                    columnFilter: const PlutoGridColumnFilterConfig(filters: [
                      ...FilterHelper.defaultFilters,
                    ]),
                    onLoaded: onShiftsLoaded,
                    columns: shiftsColumns,
                    rows: [])),
            TabChild(
                tabName: "Invoices",
                child: DefaultTable(
                    columnFilter: const PlutoGridColumnFilterConfig(filters: [
                      ...FilterHelper.defaultFilters,
                    ]),
                    onLoaded: onInvoicesLoaded,
                    columns: invoicesColumns,
                    rows: [])),
            TabChild(
                tabName: "Quotes",
                child: DefaultTable(
                    columnFilter: const PlutoGridColumnFilterConfig(filters: [
                      ...FilterHelper.defaultFilters,
                    ]),
                    onLoaded: onQuotesLoaded,
                    columns: quotesColumns,
                    rowColorCallback: (p0) {
                      final bool isAccepted =
                          p0.row.cells['status']?.value == "accepted";
                      return isAccepted ? Colors.green[50]! : Colors.grey[100]!;
                    },
                    rows: [])),
            TabChild(
                tabName: "Expenses",
                child: DefaultTable(
                    columnFilter: const PlutoGridColumnFilterConfig(filters: [
                      ...FilterHelper.defaultFilters,
                    ]),
                    onLoaded: onExpensesLoaded,
                    columns: expensesColumns,
                    rows: [])),
          ],
        );
      },
    );
  }

  void onShiftsLoaded(PlutoGridOnLoadedEvent event) {
    shiftsManager = event.stateManager;
    shiftsManager!.setShowColumnFilter(true);
    shiftsManager!.appendRows(shifts
        .map((e) => PlutoRow(cells: {
              "name": PlutoCell(value: e.name),
              "location": PlutoCell(value: e.locationName),
            }))
        .toList());
  }

  void onInvoicesLoaded(PlutoGridOnLoadedEvent event) {
    invoicesManager = event.stateManager;
    invoicesManager!.setShowColumnFilter(true);
    invoicesManager!.appendRows(invoices
        .map((e) => PlutoRow(cells: {
              "date": PlutoCell(value: e.date),
              "dueDate": PlutoCell(value: e.dueDate),
              "amount": PlutoCell(value: e.value),
              "paymentMethod": PlutoCell(value: e.paymentMethod),
              "paid": PlutoCell(value: e.paid ? "Yes" : "No"),
            }))
        .toList());
  }

  void onQuotesLoaded(PlutoGridOnLoadedEvent event) {
    quotesManager = event.stateManager;
    quotesManager!.setShowColumnFilter(true);
    PlutoRow buildRow(model) {
      String name = model.name;
      String contact = "-";
      final String status = model.quoteStatus ? "accepted" : "pending";
      double value = model.quoteValue.toDouble();
      if (model.company.isNotEmpty) {
        name += " (${model.company})";
      }
      if (model.email.isNotEmpty) {
        contact = model.email;
      }
      if (model.phone.isNotEmpty) {
        contact += "\n${model.phone}";
      }
      return PlutoRow(
        cells: {
          "id": PlutoCell(value: model.id),
          // "name": PlutoCell(value: name),
          "contact": PlutoCell(value: contact),
          "status": PlutoCell(value: status),
          "value": PlutoCell(value: value),
          "last_sent": PlutoCell(value: model.lastSent ?? "Never"),
          "created_on": PlutoCell(value: model.createdOn),
          "valid_until": PlutoCell(value: model.validUntil),
          "action": PlutoCell(value: ""),
        },
      );
    }

    final rows = quotes.map((e) => buildRow(e)).toList();
    quotesManager!.appendRows(rows);
  }

  void onExpensesLoaded(PlutoGridOnLoadedEvent event) {
    expensesManager = event.stateManager;
    expensesManager!.setShowColumnFilter(true);
    expensesManager!.appendRows(expenses
        .map((e) => PlutoRow(cells: {
              "category": PlutoCell(value: e.category),
              "amount": PlutoCell(value: e.value),
              "invoiced": PlutoCell(value: e.invoiced ? "Yes" : "No"),
              "completed": PlutoCell(value: e.completed ? "Yes" : "No"),
            }))
        .toList());
  }
}
