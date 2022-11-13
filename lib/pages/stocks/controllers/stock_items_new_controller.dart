import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';

import '../../../theme/theme.dart';

class StockItemsNewItemController extends GetxController {
  final ListStorageItem? stockItem;

  StockItemsNewItemController({this.stockItem});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ourPriceController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();
  final TextEditingController taxController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    ourPriceController.dispose();
    customPriceController.dispose();
    taxController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    if (stockItem != null) {
      //TODO: Add prices and tax
      nameController.text = stockItem!.name;
      // ourPriceController.text = stockItem!;
      // setLevels(qualif!.levels);
      // setExpire(qualif!.expire);
    }
  }
}
