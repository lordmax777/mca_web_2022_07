import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/table_helpers.dart';

class ViewStockHistoryPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  final StockMd stock;
  const ViewStockHistoryPopup(
      {super.key, required this.warehouse, required this.stock});

  @override
  State<ViewStockHistoryPopup> createState() => _ViewStockHistoryPopupState();
}

class _ViewStockHistoryPopupState extends State<ViewStockHistoryPopup>
    with TableFocusNodeMixin<ViewStockHistoryPopup, Map, Map> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SpacedRow(
        children: [
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.arrow_back),
          ),
          const Text("Stock History")
        ],
      ),
      content: const SizedBox(),
    );
  }
}
