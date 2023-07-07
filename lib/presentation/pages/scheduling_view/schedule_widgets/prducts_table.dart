import 'package:flutter/material.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ProductsTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final List<PlutoColumn> columns;
  final List<PlutoRow>? rows;

  const ProductsTable(
      {super.key, required this.onLoaded, required this.columns, this.rows});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: PlutoGrid(
        columns: columns.map<PlutoColumn>((e) {
          e.enableColumnDrag = false;
          e.enableContextMenu = false;
          e.enableDropToResize = false;
          e.enableRowDrag = false;
          return e;
        }).toList(),
        mode: PlutoGridMode.normal,
        configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              activatedBorderColor: context.colorScheme.primary,
              gridBorderColor: Colors.grey[300]!,
            ),
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
        rows: rows ?? [],
        onLoaded: onLoaded,
        noRowsWidget: Center(
          child: Text("No products added",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.grey)),
        ),
      ),
    );
  }
}
