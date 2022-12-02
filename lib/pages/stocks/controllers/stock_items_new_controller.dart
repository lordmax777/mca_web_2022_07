import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_controller.dart';

import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';

class StockItemsNewItemController extends GetxController {
  final ListStorageItem? stockItem;

  static StockItemsNewItemController get to {
    Get.lazyPut(() => StockItemsNewItemController());
    return Get.find();
  }

  StockItemsNewItemController({this.stockItem});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ourPriceController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();
  final Rx<CodeMap> _tax = Rx<CodeMap>(CodeMap(name: null, code: null));
  CodeMap get tax => _tax.value;
  void onTaxChange(DpItem val) => _tax.value =
      CodeMap(name: val.name, code: (val.item as ListTaxes).id.toString());

  RxInt forObx = RxInt(0);
  int get forObxValue => forObx.value;
  set forObxValue(int value) => forObx.value = value;

  Future<void> create() async {
    if (formKey.currentState!.validate()) {
      showLoading();
      final ApiResponse res = await restClient()
          .postStorageItems(
            id: stockItem?.id ?? 0,
            name: nameController.text,
            active: true,
            service: true,
            incomingPrice: ourPriceController.text,
            outgoingPrice: customPriceController.text,
            taxId: int.parse(tax.code!),
          )
          .nocodeErrorHandler();

      if (res.success) {
        await appStore.dispatch(GetAllStorageItemsAction());
        closeLoading();
      } else {
        await closeLoading();
        showError(res.data['errors'].toString());
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ourPriceController.dispose();
    customPriceController.dispose();
    _tax.value = CodeMap(name: null, code: null);
    super.dispose();
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
