import 'package:pluto_grid/pluto_grid.dart';

import '../pages/users_list_page.dart';
import '../theme/theme.dart';

class UsersListTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final Widget Function(PlutoGridStateManager) footer;
  const UsersListTable(
      {Key? key,
      required this.rows,
      required this.onSmReady,
      required this.cols,
      required this.footer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      col.enableAutoEditing = false;
      col.enableEditingMode = false;
      col.titleSpan = TextSpan(
        text: col.title,
        children: const [
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: HeroIcon(HeroIcons.caretVerticalSmall,
                    size: 15, color: ThemeColors.gray2),
              )),
        ],
      );
      _cols.add(col);
    }
    var _w = MediaQuery.of(context).size.width;
    var _tableSize = 0.0;
    print(_w);
    for (var c in cols) {
      _tableSize += c.width;
    }
    print(_tableSize);
    bool isEqual = _tableSize == _w;
    return SizedBox(
      height: 625,
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
          style: const PlutoGridStyleConfig(
            columnHeight: 48.0,
            rowHeight: 48.0,
            borderColor: ThemeColors.transparent,
            gridBorderColor: ThemeColors.transparent,
            activatedBorderColor: ThemeColors.transparent,
            activatedColor: ThemeColors.blue12,
            columnTextStyle: ThemeText.tableColumnTextStyle,
          ),
          columnSize: PlutoGridColumnSizeConfig(
              autoSizeMode:
                  isEqual ? PlutoAutoSizeMode.none : PlutoAutoSizeMode.scale),
        ),
        columns: _cols,
        rows: rows,
        onLoaded: (e) {
          onSmReady(e.stateManager);
        },
        // createFooter: (stateManager) {
        // PlutoPagination();
        //   return footer(stateManager);
        // },
      ),
    );
  }
}
