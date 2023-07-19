import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:mca_dashboard/utils/utils.dart';

class NewUserDefaultTable extends StatelessWidget {
  final List<PlutoColumn> columns;
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final List<PlutoRow> rows;
  final void Function(UserReviewMd?) onEditReview;
  final void Function(UserReviewMd) onDeleteReview;
  const NewUserDefaultTable({
    super.key,
    required this.columns,
    required this.onDeleteReview,
    required this.onEditReview,
    required this.rows,
    required this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns.map<PlutoColumn>((e) {
        e.enableAutoEditing = false;
        e.enableColumnDrag = false;
        e.enableContextMenu = false;
        e.enableDropToResize = false;
        e.enableRowDrag = false;
        e.enableEditingMode = false;
        return e;
      }).toList(),
      configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            activatedBorderColor: context.colorScheme.primary,
            borderColor: Colors.grey[200]!,
            gridBorderColor: Colors.grey[300]!,
          ),
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale)),
      createHeader: (stateManager) {
        return _Header(stateManager,
            onDeleteReview: onDeleteReview, onEditReview: onEditReview);
      },
      onLoaded: onLoaded,
      rows: rows,
    );
  }
}

class _Header extends StatefulWidget {
  final PlutoGridStateManager stateManager;
  final void Function(UserReviewMd?) onEditReview;
  final void Function(UserReviewMd) onDeleteReview;
  const _Header(this.stateManager,
      {required this.onDeleteReview, required this.onEditReview});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  PlutoGridStateManager get stateManager => widget.stateManager;
  @override
  void initState() {
    super.initState();
    stateManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: stateManager.checkedRows.isEmpty
                    ? null
                    : () {
                        final selected = stateManager.checkedRows;
                        for (final row in selected) {
                          final review =
                              row.cells['action']!.value as UserReviewMd;
                          widget.onDeleteReview(review);
                        }
                      },
                child: const Text("Delete Selected")),
            ElevatedButton(
                onPressed: () {
                  widget.onEditReview(null);
                },
                child: const Text("Add New")),
          ],
        ),
      ),
    );
  }
}
