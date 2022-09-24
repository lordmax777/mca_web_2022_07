import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../comps/show_overlay_popup.dart';
import '../../theme/theme.dart';

class VisaWidget extends StatefulWidget {
  VisaWidget({Key? key}) : super(key: key);

  @override
  State<VisaWidget> createState() => _VisaWidgetState();
}

class _VisaWidgetState extends State<VisaWidget> {
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<ColumnHiderValues> columnHideValues = [];
  final List<VisaMd> _contracts = [];

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          // width: 80.0,
          title: "Document #",
          field: "document_no",
          textAlign: PlutoColumnTextAlign.right,
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 140.0,
          title: "Type",
          field: "title",
          type: PlutoColumnType.text()),
      PlutoColumn(
        // width: 100.0,
        title: "Valid From - To",
        field: "startToEndDate",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          // width: 80.0,
          title: "Comment",
          field: "comment",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            final String msg = ctx.cell.value.toString();
            return TableTooltipWidget(title: "Read Comment", message: msg);
          }),
      PlutoColumn(
          title: "Action",
          enableSorting: false,
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () {
                showOverlayPopup(
                    body:
                        UserDetailVisaNewVisaPopupWidget(visa: ctx.cell.value),
                    context: context);
              },
              icon: const HeroIcon(
                HeroIcons.pen,
                color: ThemeColors.blue3,
              ),
            );
          }),
    ];
  }

  @override
  void initState() {
    super.initState();
    columnHideValues.clear();
    columnHideValues.addAll(_cols
        .skipWhile((value) => value.hide)
        .toList()
        .map<ColumnHiderValues>(
            (e) => ColumnHiderValues(value: e.field, label: e.title))
        .toList());
    // _contracts.clear();
    // _contracts.addAll(widget.state.usersState.userDetailVisas.data!);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final e1 = state.usersState.userDetailReviews.error;
        final errors = [e1];
        return ErrorWrapper(
          errors: errors,
          child: SizedBox(
            width: double.infinity,
            child: SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                _body(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonMedium(
            bgColor: ThemeColors.red3,
            icon: const HeroIcon(HeroIcons.bin,
                color: ThemeColors.white, size: 20),
            text: "Delete Selected",
            onPressed: () {},
          ),
          SpacedRow(horizontalSpace: 16.0, children: [
            TableColumnHiderWidget(
                gKey: _columnsMenuKey,
                columns: columnHideValues,
                onChanged: (value) {
                  PlutoGridStateManager state = userDetailsPayrollSm;
                  PlutoColumn _c = state.refColumns.originalList
                      .firstWhere((e) => e.field == value.value);
                  state.hideColumn(_c, !value.isChecked);
                }),
            ButtonMedium(
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              text: "New Vias/Permit",
              onPressed: () {
                showOverlayPopup(
                    body: const UserDetailVisaNewVisaPopupWidget(),
                    context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(AppState state) {
    return UserDetailPayrollTabTable(
      onSmReady: _setSm,
      rows: state.usersState.userDetailVisas.data!
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "document_no": PlutoCell(
                  value: e.document_no.isNotEmpty ? e.document_no : "-"),
              "title": PlutoCell(value: e.title),
              "startToEndDate": PlutoCell(
                  value:
                      "${getDateFormat(DateTime.tryParse(e.startDate.date), dateSeparatorSymbol: "/")} -\n ${e.endDate != null ? getDateFormat(DateTime.tryParse(e.endDate!.date), dateSeparatorSymbol: "/") : ""}"),
              "comment": PlutoCell(value: e.notes),
              "action": PlutoCell(value: e),
            }),
          )
          .toList(),
      cols: _cols,
    );
  }

  void _setSm(PlutoGridStateManager sm) {
    setState(() {
      userDetailsPayrollSm = sm;
      _isSmLoaded = true;
    });
  }
}
