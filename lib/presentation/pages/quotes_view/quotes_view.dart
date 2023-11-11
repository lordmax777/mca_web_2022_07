import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/quotes_view/dialogs/create_quote_dialog.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class QuotesView extends StatefulWidget {
  const QuotesView({super.key});

  @override
  State<QuotesView> createState() => _QuotesViewState();
}

class _QuotesViewState extends State<QuotesView>
    with TableFocusNodeMixin<QuotesView, QuoteMd, QuoteMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<QuoteMd>>(
        converter: (store) => store.state.generalState.quotes,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
            rowColorCallback: (p0) {
              final bool isAccepted =
                  p0.row.cells['status']?.value == "accepted";
              return isAccepted ? Colors.green[50]! : Colors.grey[100]!;
            },
            headerEnd: SpacedRow(
              horizontalSpace: 8,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      if (stateManager!.hasFocus) {
                        stateManager?.gridFocusNode.removeListener(handleFocus);
                      }
                      dependencyManager.navigation.showCustomDialog(
                          context: context,
                          builder: (context) {
                            return const CreateQuoteDialog(isJob: true);
                          });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Job")),
                ElevatedButton.icon(
                    onPressed: () {
                      if (stateManager!.hasFocus) {
                        stateManager?.gridFocusNode.removeListener(handleFocus);
                      }
                      dependencyManager.navigation.showCustomDialog(
                          context: context,
                          builder: (context) {
                            return const CreateQuoteDialog();
                          });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Quote")),
              ],
            ),
            rows: kDebugMode
                ? appStore.state.generalState.quotes
                    .map((e) => buildRow(e))
                    .toList()
                : [],
          );
        });
  }

  @override
  PlutoRow buildRow(model) {
    String name = model.name;
    String contact = "-";
    final String status = model.processStatus;
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
        "name": PlutoCell(value: name),
        "identifier": PlutoCell(value: model.identifier),
        "contact": PlutoCell(value: contact),
        "status": PlutoCell(value: status),
        "value": PlutoCell(value: value),
        "last_sent": PlutoCell(value: model.lastSent ?? "Never"),
        "created_on": PlutoCell(value: model.createdOn),
        "valid_until": PlutoCell(value: model.validUntil),
        // "processStatus": PlutoCell(value: model.processStatus),
        "action": PlutoCell(value: ""),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "",
          field: "id",
          hide: true,
          type: PlutoColumnType.text(),
          textAlign: PlutoColumnTextAlign.center,
        ),
        PlutoColumn(
          title: "Identifier",
          field: "identifier",
          type: PlutoColumnType.text(),
          textAlign: PlutoColumnTextAlign.center,
        ),
        PlutoColumn(
          title: "Name",
          field: "name",
          type: PlutoColumnType.text(),
          textAlign: PlutoColumnTextAlign.center,
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
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
          // width: 100,
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
          title: "Value",
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
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 80,
          renderer: (rendererContext) {
            final quoteId = rendererContext.row.cells["id"]?.value;
            final status = rendererContext.row.cells["status"]?.value
                .toString()
                .toLowerCase();
            return PopupMenuButton(
              onSelected: (value) {
                if (stateManager!.hasFocus) {
                  stateManager?.gridFocusNode.removeListener(handleFocus);
                }
                switch (value) {
                  case "edit":
                    ShiftData data = ShiftData.init(
                        isCreate: false,
                        isQuote: true,
                        quoteData: QuoteData(id: quoteId));
                    dependencyManager.navigation.showCustomDialog(
                        context: context,
                        builder: (context) {
                          return CreateQuoteDialog(
                              quote: appStore.state.generalState.quotes
                                  .firstWhereOrNull(
                                      (element) => element.id == quoteId));
                        });

                    break;
                  case "email":
                    loading(() async {
                      final success =
                          await dispatch<bool>(SendQuoteEmailAction(quoteId!));
                      if (success.isLeft && success.left) {
                        await dispatch(const GetQuotesAction());
                        context.showSuccess(
                            "Successfully sent email to ${rendererContext.row.cells["name"]?.value}");
                      } else if (success.isRight) {
                        context.showError(
                            "Failed to send email, ${success.right.message}");
                      } else {
                        context.showError("Failed to send email");
                      }
                    });
                    break;
                  case "accept":
                    loading(() async {
                      final success = await dispatch<bool>(
                          ChangeQuoteStatusAction(
                              id: quoteId!, status: 'accept'));
                      if (success.isLeft && success.left) {
                        await dispatch(const GetQuotesAction());
                        context.showSuccess("Successfully accepted quote");
                      } else if (success.isRight) {
                        context.showError(
                            "Failed to accept quote, ${success.right.message}");
                      } else {
                        context.showError("Failed to accept quote");
                      }
                    });
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      value: "edit",
                      child: SpacedRow(
                          horizontalSpace: 4,
                          children: const [Icon(Icons.edit), Text("Edit")])),
                  if (quoteId != null)
                    PopupMenuItem(
                        value: "email",
                        child: SpacedRow(horizontalSpace: 4, children: const [
                          Icon(Icons.email),
                          Text("Send Email")
                        ])),
                  if (status == "pending" && quoteId != null)
                    PopupMenuItem(
                        value: "accept",
                        child: SpacedRow(horizontalSpace: 4, children: const [
                          Icon(Icons.check),
                          Text("Accept")
                        ])),
                ];
              },
              icon: const Icon(Icons.more_vert),
            );
          },
        ),
        // PlutoColumn(
        //     title: "Process Status",
        //     field: "processStatus",
        //     type: PlutoColumnType.text())
      ];

  @override
  Future<List<QuoteMd>?> fetch() async {
    final res = await dispatch<List<QuoteMd>>(const GetQuotesAction());
    if (res.isLeft) {
      return res.left;
    }
    return null;
  }
}
