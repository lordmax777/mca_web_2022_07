import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../manager/redux/sets/app_state.dart';

class QuotesListPage extends StatefulWidget {
  const QuotesListPage({Key? key}) : super(key: key);

  @override
  State<QuotesListPage> createState() => _QuotesListPageState();
}

class _QuotesListPageState extends State<QuotesListPage> {
  //Etc
  CompanyMd get company => GeneralController.to.companyInfo;

  //Header
  final TextEditingController _searchController = TextEditingController();

  //Table
  late final PlutoGridStateManager stateManager;
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
          title: "Quote Value ${company.currency.sign}",
          field: "value",
          type: PlutoColumnType.currency(),
        ),
        PlutoColumn(
          title: "Last Sent",
          field: "last_sent",
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: "Created On",
          field: "created_on",
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: "Valid Until",
          field: "valid_until",
          type: PlutoColumnType.date(),
        ),
        PlutoColumn(
          title: "",
          field: "edit_btn",
          type: PlutoColumnType.text(),
        ),
      ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            title: 'Quotes',
            btnText: 'Add New Quote',
            onRightBtnClick: () {
              //TODO: Add new quote
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
                _footer(),
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
    return PlutoRow(
      checked: checked,
      cells: {
        'quote': PlutoCell(value: quote),
        'name': PlutoCell(value: quote.name),
        'contact': PlutoCell(value: quote.contact),
        'status': PlutoCell(value: quote.quoteStatus),
        'value': PlutoCell(value: quote.quoteValue),
        'last_sent': PlutoCell(value: quote.lastSent),
        'created_on': PlutoCell(value: quote.createdOn),
        'valid_until': PlutoCell(value: quote.validUntil),
        'edit_btn': PlutoCell(value: ""),
      },
    );
  }

  Widget _body(AppState state) {
    return UsersListTable(
        rows: [],
        noRowsText: 'No quotes found',
        onSmReady: (p0) {
          stateManager = p0;
          final allQuotes = [...state.generalState.quotes];
          stateManager.appendRows(allQuotes.map((e) => _buildRow(e)).toList());
        },
        cols: columns);
  }

  Widget _footer() {
    return Container();
  }
}
