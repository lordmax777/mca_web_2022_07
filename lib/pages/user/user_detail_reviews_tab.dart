import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/users_state/users_state.dart';
import '../../theme/theme.dart';

class ReviewsWidget extends StatefulWidget {
  ReviewsWidget({Key? key}) : super(key: key);

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<ColumnHiderValues> columnHideValues = [];

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          // width: 80.0,
          title: "Conducted By",
          field: "conducted_by",
          enableRowChecked: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 50.0,
          title: "Conducted On",
          field: "date",
          type: PlutoColumnType.date(
            format: 'dd/MM/yyyy',
          )),
      PlutoColumn(
          // width: 100.0,
          title: "Title",
          field: "title",
          type: PlutoColumnType.text()),
      PlutoColumn(
          // width: 80.0,
          title: "Comment",
          field: "comment",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return TableTooltipWidget(
                title: "Read Comment", message: ctx.cell.value.toString());
          }),
      PlutoColumn(
          title: "Action",
          enableSorting: false,
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () {
                showOverlayPopup(
                    body: UserDetailReviewNewReviewPopupWidget(
                        review: ctx.cell.value),
                    context: context);
              },
              icon:  HeroIcon(
                HeroIcons.pen,
                color: ThemeColors.MAIN_COLOR,
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
            onPressed: () async {
              final selectedItemIds = userDetailsPayrollSm.checkedRows
                  .map<int>((e) => (e.cells['action']?.value as ReviewMd).id)
                  .toList();
              if (selectedItemIds.isNotEmpty) {
                await appStore.dispatch(
                    GetDeleteUserDetailsReviewsAction(ids: selectedItemIds));
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
              text: "New Review",
              onPressed: () {
                showOverlayPopup(
                    body: const UserDetailReviewNewReviewPopupWidget(),
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
      rows: state.usersState.userDetailReviews.data!
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "conducted_by": PlutoCell(value: e.conducted_by),
              "date": PlutoCell(value: e.date),
              "title": PlutoCell(value: e.title),
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
