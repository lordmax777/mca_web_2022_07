import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../manager/models/list_all_md.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class PayrollWidget extends StatefulWidget {
  PayrollWidget({Key? key}) : super(key: key);

  @override
  State<PayrollWidget> createState() => _PayrollWidgetState();
}

class _PayrollWidgetState extends State<PayrollWidget> {
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<ColumnHiderValues> columnHideValues = [];

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          title: "Contract Type",
          field: "contract_type",
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 200.0,
          title: "Start Date",
          field: "start_date",
          type: PlutoColumnType.date(
            format: 'dd/MM/yyyy',
          )),
      PlutoColumn(
          // width: 200.0,
          title: "End Date",
          field: "end_date",
          type: PlutoColumnType.date(
            format: 'dd/MM/yyyy',
          )),
      PlutoColumn(
          title: "Holiday Calculation",
          field: "holiday_calculation",
          type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Weekly Hours",
          field: "weekly_hours",
          renderer: (ctx) {
            return UsersListTable.defaultTextWidget("${ctx.cell.value} hours");
          },
          type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Working Days",
          field: "working_days",
          renderer: (ctx) {
            return UsersListTable.defaultTextWidget("${ctx.cell.value} days");
          },
          type: PlutoColumnType.text()),
      PlutoColumn(
        title: "Annual Holiday Entitlement",
        field: "annual_holiday_entitlement",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return UsersListTable.defaultTextWidget("${ctx.cell.value} days");
        },
      ),
      PlutoColumn(
          title: "Action",
          field: "action",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (PlutoColumnRendererContext ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () {
                context.pushRoute(UserDetailsPayrollTabNewContractRoute(
                    contract: ctx.cell.value));
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
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final e1 = state.usersState.userDetailContracts.error;
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
              text: "New Contract",
              onPressed: () {
                context.navigateTo(UserDetailsPayrollTabNewContractRoute());
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(AppState state) {
    final List<ContractTypes> ctypes =
        state.generalState.paramList.data?.contract_types ?? [];
    final List<HolidayCalculationTypes> hCalcTypes =
        state.generalState.paramList.data?.holiday_calculation_types ?? [];
    return UserDetailPayrollTabTable(
      onSmReady: _setSm,
      rows: state.usersState.userDetailContracts.data!
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "contract_type": PlutoCell(
                  value: ctypes
                      .firstWhere((element) => element.id == e.contractType)
                      .name),
              "start_date": PlutoCell(value: e.csd?.date ?? "-"),
              "end_date": PlutoCell(value: e.ced?.date ?? "-"),
              "holiday_calculation": PlutoCell(
                  value: hCalcTypes
                      .firstWhere((element) => element.id == e.hct)
                      .name),
              "weekly_hours": PlutoCell(value: e.awh.toString()),
              "working_days": PlutoCell(value: e.wdpw.toString()),
              "annual_holiday_entitlement": PlutoCell(value: e.ahe),
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
