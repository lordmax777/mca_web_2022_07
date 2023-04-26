import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../scheduling/create_shift_popup.dart';
import '../scheduling/scheduling_page.dart';

mixin GridOnLoadMixin<T extends StatefulWidget> on State<T> {
  bool reload = false;

  Future<void> onReload() async {
    setState(() {
      reload = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      reload = false;
    });
  }
}

class QuotesListPage extends StatefulWidget {
  const QuotesListPage({Key? key}) : super(key: key);

  @override
  State<QuotesListPage> createState() => _QuotesListPageState();
}

class _QuotesListPageState extends State<QuotesListPage>
    with GridOnLoadMixin<QuotesListPage> {
  //Etc
  CompanyMd get company => GeneralController.to.companyInfo;

  //Header
  final TextEditingController _searchController = TextEditingController();

  //Table

  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "",
          field: "quote",
          hide: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Name",
          field: "name",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Contact Details",
          field: "contact",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Status",
          field: "status",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Quote Value (${company.currency.sign})",
          field: "value",
          type: PlutoColumnType.currency(),
        ),
        PlutoColumn(
          title: "Last Sent",
          field: "last_sent",
          type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm"),
          renderer: (rendererContext) {
            return KText(
              text: rendererContext.cell.value.toString().isEmpty
                  ? "Never"
                  : rendererContext.cell.value.toString(),
              textColor: ThemeColors.gray2,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              textAlign: rendererContext.column.textAlign.value,
            );
          },
        ),
        PlutoColumn(
          title: "Created On",
          field: "created_on",
          type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm"),
        ),
        PlutoColumn(
          title: "Valid Until",
          field: "valid_until",
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: "Action",
          field: "edit_btn",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return GridTableHelpers.getActionRenderer(
              rendererContext,
              onTap: (value) {
                _onAddQuoteTap(
                    successMessage: "Quote updated successfully",
                    quoteId: rendererContext.row.cells['quote']!.value);
              },
            );
          },
        ),
      ].map((e) {
        final e1 = e;
        e1.textAlign = PlutoColumnTextAlign.center;
        return e1;
      }).toList();

  PlutoGridStateManager? stateManager;

  bool get isStateManagerInitialized => stateManager != null;

  void _setFilter() {
    _searchController.addListener(() {
      //TODO: NOT WORKING
      if (_searchController.text.isNotEmpty) {
        if (stateManager!.page > 1) {
          stateManager!.setPage(1);
        }
        stateManager!.setFilter(
          (element) {
            final String search = _searchController.text.toLowerCase();
            bool searched =
                element.cells['name']?.value.toLowerCase().contains(search);
            if (!searched) {
              searched = element.cells['contact']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['value']!.value
                    .toString()
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = element.cells['last_sent']?.value
                      .toLowerCase()
                      .contains(search);
                  if (!searched) {
                    searched = element.cells['created_on']?.value
                        .toLowerCase()
                        .contains(search);
                    if (!searched) {
                      searched = element.cells['valid_until']?.value
                          .toLowerCase()
                          .contains(search);
                      if (!searched) {
                        searched = element.cells['contact']?.value
                            .toLowerCase()
                            .contains(search);
                      }
                    }
                  }
                }
              }
            }
            return searched;
          },
        );
        _onPageChange(stateManager!.page);
        _onPageSizeChange(Constants.tablePageSizes[0].toString());
        return;
      }

      stateManager!.setFilter((element) => true);
      _onPageChange(stateManager!.page);
      _onPageSizeChange(Constants.tablePageSizes[0].toString());
    });
  }

  void _onPageSizeChange(String pageS) {
    int pageSize = int.tryParse(pageS) ?? 10;
    stateManager!.setPageSize(pageSize);
    stateManager!.setPage(1);
  }

  void _onPageChange(int page) {
    stateManager!.setPage(page);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (kDebugMode) {
      // await onReload();
    }
  }

  void _onAddQuoteTap({
    String? successMessage,
    int? quoteId,
  }) async {
    final quoteCreated = await showCreateShiftPopup<ApiResponse?>(
        context,
        CreateShiftDataQuote(
          quoteId: quoteId,
        ));
    if (quoteCreated != null) {
      showError(successMessage ?? "Quote Created Successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onWillChange: (previousViewModel, newViewModel) {
        final oldQuotes = previousViewModel?.generalState.allSortedQuotes;
        final newQuotes = newViewModel.generalState.allSortedQuotes;
        if (oldQuotes?.length != newQuotes.length) {
          if (isStateManagerInitialized) {
            stateManager!.removeAllRows();
            stateManager!
                .appendRows(newQuotes.map((e) => _buildRow(e)).toList());
          }
        }
      },
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            title: 'Quotes',
            btnText: 'Add New Quote',
            onRightBtnClick: () {
              _onAddQuoteTap();
            },
          ),
          TableWrapperWidget(
              child: SizedBox(
            width: double.infinity,
            child: SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(state),
                _body(state),
                if (isStateManagerInitialized) _footer(state),
                const SizedBox(height: 4),
              ],
            ),
          )),
        ]),
      ),
    );
  }

  Widget _header(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
            hintText: 'Search quote...',
            controller: _searchController,
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }

  PlutoRow _buildRow(QuoteInfoMd quote, {bool checked = false}) {
    String name = quote.name;
    String contact = "-";
    String status = "Pending";
    double value = quote.quoteValue.toDouble();
    String lastSent = "";
    String createdOn = quote.createdOn;
    String validUntil = quote.validUntil;

    if (quote.company != null) {
      name += " (${quote.company!})";
    }

    if (quote.email != null) {
      contact = quote.email!;
    }
    if (quote.phone != null) {
      contact += "\n${quote.phone!}";
    }

    if (quote.quoteStatus != null) {
      status = quote.quoteStatus!;
    }

    if (quote.lastSent != null) {
      lastSent = quote.lastSent!;
    }

    return PlutoRow(
      checked: checked,
      cells: {
        'quote': PlutoCell(value: quote),
        'name': PlutoCell(value: name),
        'contact': PlutoCell(value: contact),
        'status': PlutoCell(value: status),
        'value': PlutoCell(value: value),
        'last_sent': PlutoCell(value: lastSent),
        'created_on': PlutoCell(value: createdOn),
        'valid_until': PlutoCell(value: validUntil),
        'edit_btn': PlutoCell(value: ""),
      },
    );
  }

  Widget _body(AppState state) {
    if (reload) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return UsersListTable(
          gridBorderColor: Colors.grey[300]!,
          rows: [],
          noRowsText: 'No quotes found',
          onSmReady: (p0) {
            if (!isStateManagerInitialized) {
              stateManager = p0;
              stateManager!.addListener(() {
                setState(() {});
              });
              final allQuotes = state.generalState.allSortedQuotes;
              stateManager!.removeAllRows();
              stateManager!
                  .appendRows(allQuotes.map((e) => _buildRow(e)).toList());

              _setFilter();
            }
            stateManager!.setPage(1);
            stateManager!.setPageSize(10);
          },
          cols: columns);
    }
  }

  Widget _footer(AppState state) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),
      child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedRow(
                horizontalSpace: 8.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KText(
                      text: "Showing",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                  DropdownWidgetV2(
                    hintText: "Entries",
                    items: Constants.tablePageSizes
                        .map((e) => CustomDropdownValue(name: e.toString()))
                        .toList(),
                    dropdownBtnWidth: 120,
                    onChanged: (index) => _onPageSizeChange(
                        Constants.tablePageSizes[index].toString()),
                    value: CustomDropdownValue(
                        name: stateManager!.pageSize.toString()),
                  ),
                  KText(
                      text: "of ${stateManager!.rows.length} entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(
                currentPage: stateManager!.page,
                totalPages: stateManager!
                    .totalPage, //(widget._itemCount / _pageSize).ceil(),
                onPageChanged: (int i) => _onPageChange(i)),
          ]),
    );
  }
}
