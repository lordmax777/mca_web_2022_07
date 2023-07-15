import 'dart:convert';

import '../../../../manager.dart';
import 'package:dio/dio.dart' as dio;

final class GetCurrentStockListAction {
  final int warehouseId;

  const GetCurrentStockListAction(this.warehouseId);
}

final class AddToStockAction {
  final int warehouseId;
  final Map<String, String> items;
  final String? comment;
  final String? documentNumber;

  const AddToStockAction({
    required this.warehouseId,
    required this.items,
    this.comment,
    this.documentNumber,
  });
}

final class StockTransferAction {
  final int fromWarehouseId;
  final int toWarehouseId;

  /// Map<itemId, quantity>
  final Map<String, String> items;
  final String? comment;
  final String? documentNumber;

  const StockTransferAction({
    required this.fromWarehouseId,
    required this.toWarehouseId,
    required this.items,
    this.comment,
    this.documentNumber,
  });

  Future<Either<bool, ErrorMd>> fetch(
      AppState state, StockTransferAction action) async {
    return await apiCall(() async {
      final dio.Dio apiClient = DependencyManager.instance.dioClient.dio
        ..options.contentType = "multipart/form-data";

      final dio.FormData formData = dio.FormData();
      logger("ItemsList: ${action.items}", hint: "ItemsList <->");
      final String items = base64.encode(utf8.encode(jsonEncode(action.items)));
      String? documentNumber;
      if (action.documentNumber != null && action.documentNumber!.isNotEmpty) {
        documentNumber =
            base64.encode(utf8.encode(jsonEncode(action.documentNumber)));
      }
      String? comment;
      if (action.comment != null && action.comment!.isNotEmpty) {
        comment = base64.encode(utf8.encode(jsonEncode(action.comment)));
      }

      formData.fields
        ..add(MapEntry('storageid', action.fromWarehouseId.toString()))
        ..add(MapEntry('targetid', action.toWarehouseId.toString()))
        ..add(MapEntry('items', items));

      if (documentNumber != null) {
        formData.fields.add(MapEntry('document_number', documentNumber));
      }
      if (comment != null) {
        formData.fields.add(MapEntry('comments', comment));
      }

      logger(
          "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}",
          hint: "FormData fields <->");

      dio.Response res =
          await apiClient.post('/api/fe/stocktransfer', data: formData);
      return res.statusCode == 200;
    });
  }
}

final class GetStockHistoryAction {
  final int warehouseId;
  final int itemId;

  const GetStockHistoryAction({
    required this.warehouseId,
    required this.itemId,
  });

  //fetch
  Future<Either<List<StockHistoryMd>, ErrorMd>> fetch(
      AppState state, GetStockHistoryAction action) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient.getStockHistory(
          storageid: action.warehouseId, itemid: action.itemId);
      try {
        final data = res.data['history'];
        return data
            .map<StockHistoryMd>((e) => StockHistoryMd.fromJson(e))
            .toList();
      } catch (e) {
        return [];
      }
    });
  }
}
