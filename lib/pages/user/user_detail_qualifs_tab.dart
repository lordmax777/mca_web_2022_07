import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class QaulifsWidget extends StatefulWidget {
  AppState state;
  QaulifsWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<QaulifsWidget> createState() => _QaulifsWidgetState();
}

class _QaulifsWidgetState extends State<QaulifsWidget> {
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<ColumnHiderValues> columnHideValues = [];
  final List<QualifsMd> _contracts = [];

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          // width: 80.0,
          title: "",
          field: "item",
          hide: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 140.0,
          title: "Qualification",
          field: "qualification",
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 60.0,
          title: "Level",
          field: "level",
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 60.0,
          title: "Certificate",
          field: "certificate",
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            final QualifsMd msg = ctx.cell.value;
            return KText(
              onTap: () {},
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              icon: const HeroIcon(
                HeroIcons.eye,
                color: ThemeColors.blue3,
              ),
            );
          }),
      PlutoColumn(
          // width: 100.0,
          title: "Certificate #",
          field: "certificate_no",
          enableSorting: false,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 120.0,
          title: "Acheivement Date",
          field: "achievement_date",
          type: PlutoColumnType.date(format: "dd/MM/yyyy")),
      PlutoColumn(
          // width: 120.0,
          title: "Expiry Date",
          field: "expiry_date",
          type: PlutoColumnType.date(format: "dd/MM/yyyy")),
      PlutoColumn(
          // width: 140.0,
          title: "Comment",
          field: "comment",
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            final String? msg = ctx.cell.value;
            return TableTooltipWidget(
                title: "Read Comment", message: msg ?? "NO-COMMENT");
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
                    body: UserDetailQualifNewQualifPopupWidget(
                        qualif: ctx.cell.value),
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
    _contracts.clear();
    _contracts.addAll(widget.state.usersState.userDetailQualifs.data!);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final e1 = state.usersState.userDetailQualifs.error;
          final es = [e1];
          return ErrorWrapper(
              errors: es,
              child: SizedBox(
                width: double.infinity,
                child: SpacedColumn(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    _body(),
                  ],
                ),
              ));
        });
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
            onPressed: () async {
              final selectedItemIds = userDetailsPayrollSm.checkedRows
                  .map<int>((e) => e.cells['item']?.value.uqId)
                  .toList();
              if (selectedItemIds.isNotEmpty) {
                await appStore.dispatch(
                    GetDeleteUserDetailsQualifsAction(ids: selectedItemIds));
              }
            },
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
              text: "New Qualification",
              onPressed: () {
                showOverlayPopup(
                    body: const UserDetailQualifNewQualifPopupWidget(),
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
      rows: widget.state.usersState.userDetailQualifs.data!
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "item": PlutoCell(value: e),
              "qualification": PlutoCell(value: e.title),
              "level": PlutoCell(value: e.level),
              "certificate": PlutoCell(value: e),
              "certificate_no": PlutoCell(value: e.certificateNumber),
              "achievement_date":
                  PlutoCell(value: e.achievementDate?.date ?? "N/A"),
              "expiry_date": PlutoCell(value: e.expiryDate.date),
              "comment": PlutoCell(value: e.comments),
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
