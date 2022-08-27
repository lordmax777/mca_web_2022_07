import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class PayrollWidget extends StatefulWidget {
  AppState state;
  PayrollWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<PayrollWidget> createState() => _PayrollWidgetState();
}

class _PayrollWidgetState extends State<PayrollWidget> {
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<ColumnHiderValues> columnHideValues = [];
  final List<ContractMd> _contracts = [];

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          title: "Contract Type",
          field: "contract_type",
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          width: 200.0,
          title: "Start Date",
          field: "start_date",
          type: PlutoColumnType.text()),
      PlutoColumn(
          width: 200.0,
          title: "End Date",
          field: "end_date",
          type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Holiday Calculation",
          field: "holiday_calculation",
          type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Weekly Hours",
          field: "weekly_hours",
          type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Working Days",
          field: "working_days",
          type: PlutoColumnType.text()),
      PlutoColumn(
        title: "Annual Holiday Entitlement",
        field: "annual_holiday_entitlement",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: "Action",
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
                size: 12,
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
    _contracts.addAll(widget.state.usersState.userDetailContracts);
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
              text: "New Contract",
              onPressed: () {
                context
                    .navigateTo(const UserDetailsPayrollTabNewContractRoute());
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
      rows: widget.state.usersState.userDetailContracts
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "contract_type": PlutoCell(value: e.contractType),
              "start_date": PlutoCell(value: e.csd?.date ?? "-"),
              "end_date": PlutoCell(value: e.ced?.date ?? "-"),
              "holiday_calculation": PlutoCell(value: e.hct),
              "weekly_hours": PlutoCell(value: e.awh),
              "working_days": PlutoCell(value: e.wdpw),
              "annual_holiday_entitlement": PlutoCell(value: e.ahe ?? "-"),
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
