import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class VisaWidget extends StatefulWidget {
  AppState state;
  VisaWidget({Key? key, required this.state}) : super(key: key);

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
          width: 80.0,
          title: "Document #",
          field: "document_no",
          textAlign: PlutoColumnTextAlign.right,
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          width: 140.0,
          title: "Type",
          field: "title",
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 100.0,
        title: "Valid From - To",
        field: "startToEndDate",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          final VisaMd date = ctx.row.cells['action']!.value;
          return KText(
            text: "${date.startDate.date} - ${date.endDate?.date ?? "N/A"}",
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
          );
        },
      ),
      PlutoColumn(
          width: 80.0,
          title: "Comment",
          field: "comment",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            final String msg = ctx.cell.value.toString();
            return Tooltip(
              decoration: const BoxDecoration(color: ThemeColors.transparent),
              richMessage: TextSpan(children: [
                WidgetSpan(
                    child: TableWrapperWidget(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: ThemeColors.gray12,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: ThemeColors.gray11),
                      ),
                      child: Text(msg.isEmpty ? "NO-COMMENT" : msg,
                          style: TextStyle(
                            color: msg.isEmpty
                                ? Colors.redAccent
                                : ThemeColors.gray2,
                          ))),
                )),
              ]),
              child: KText(
                onTap: () {},
                text: "Read Comment",
                textColor: ThemeColors.blue3,
                fontWeight: FWeight.regular,
                fontSize: 14,
                isSelectable: false,
                icon: const HeroIcon(
                  HeroIcons.eye,
                  color: ThemeColors.blue3,
                ),
              ),
            );
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
                print(ctx.cell.value);
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
    _contracts.clear();
    _contracts.addAll(widget.state.usersState.userDetailVisas.data!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _body(),
        ],
      ),
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

  Widget _body() {
    return UserDetailPayrollTabTable(
      onSmReady: _setSm,
      rows: widget.state.usersState.userDetailVisas.data!
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "document_no": PlutoCell(
                  value: e.document_no.isNotEmpty ? e.document_no : "-"),
              "title": PlutoCell(value: e.title),
              "startToEndDate": PlutoCell(value: e.startDate),
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
