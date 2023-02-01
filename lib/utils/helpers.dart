import 'dart:convert';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/models/company_md.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../manager/rest/nocode_helpers.dart';
import 'currency_format.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate => "$day/$month/$year";
}

extension TimeExtensions on TextEditingController {
  List<int>? get formattedTime {
    dynamic time = text.split(" ");
    time.removeLast();
    time = time.join(" ");
    time = time.split(":");
    time = time.map((e) => int.tryParse(e)).toList();
    if (time.any((element) => element == null)) return null;
    return time.cast<int>();
  }
}

int? toIntOrNull(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

extension TextEditingControllerExtensions on TextEditingController {
  int? toInt() {
    return toIntOrNull(text);
  }
}

class GridTableHelpers {
  static PlutoColumnType getCurrencyColumnType({bool allowNegative = true}) {
    Currency? currency = GeneralController.to.companyInfo.currency;
    String? symbol = currency?.sign;
    int decimalDigits = currency?.digits ?? 2;
    bool isRightSymbol = currency?.signFront ?? false;
    String format = "\u00A4 #,###.##";
    if (!isRightSymbol) {
      format = "#,###.## \u00A4";
    }
    return PlutoColumnType.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      format: format,
      negative: allowNegative,
    );
  }

  static Widget getCurrencyTypeRenderer(PlutoColumnRendererContext ctx) {
    assert(ctx.column.type.isCurrency);
    return UsersListTable.defaultTextWidget(
        ctx.column.type.applyFormat(ctx.cell.value),
        textAlign: TextAlign.right);
  }

  static Widget getStatusRenderer(PlutoColumnRendererContext ctx) {
    final Color color =
        ctx.cell.value == "active" ? ThemeColors.green2 : ThemeColors.gray8;
    return SpacedRow(
        horizontalSpace: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          UsersListTable.defaultTextWidget(ctx.cell.value
              .toString()
              .replaceFirst(ctx.cell.value.toString()[0],
                  ctx.cell.value.toString()[0].toUpperCase()))
        ]);
  }

  static Widget getMainColoredRenderer(PlutoColumnRendererContext ctx,
      {ValueChanged<PlutoColumnRendererContext>? onTap, String? title}) {
    return KText(
      text: title ?? ctx.cell.value,
      textColor: onTap != null ? ThemeColors.MAIN_COLOR : ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      mainAxisSize: MainAxisSize.min,
      isSelectable: false,
      onTap: onTap != null ? () => onTap(ctx) : null,
    );
  }

  static Widget getActionRenderer(PlutoColumnRendererContext ctx,
      {dynamic title = "Edit",
      ValueChanged<PlutoColumnRendererContext>? onTap,
      HeroIcons? icon}) {
    return KText(
      text: title,
      textColor: ThemeColors.MAIN_COLOR,
      fontWeight: FWeight.regular,
      fontSize: 14,
      mainAxisSize: MainAxisSize.min,
      isSelectable: false,
      onTap: onTap != null ? () => onTap(ctx) : null,
      icon: HeroIcon(
        icon ?? HeroIcons.edit,
        color: ThemeColors.MAIN_COLOR,
        size: 12,
      ),
    );
  }
}

class ApiHelpers {
  static String getRawDataErrorMessages(ApiResponse res) {
    String msg = "Error";
    if (res.rawError != null) {
      final list = jsonDecode(res.rawError!.data)['errors'].values;
      msg = list.join(",\n");
    }
    return msg;
  }
}

extension DoubleHelper on double {
  ModelFormatter getPriceMap([int decimalPoints = 0, bool withSymbol = true]) =>
      ModelFormatter(
          currencyFormatter(this,
              decimalPoints: decimalPoints, withSymbol: withSymbol),
          this);
}

extension NumHelper on num {
  ModelFormatter getPriceMap([int decimalPoints = 0, bool withSymbol = true]) =>
      ModelFormatter(
          currencyFormatter(this,
              decimalPoints: decimalPoints, withSymbol: withSymbol),
          this);
}

class ModelFormatter {
  dynamic formattedVer;
  dynamic rawVer;

  ModelFormatter(this.formattedVer, this.rawVer);
}

extension BuildContextHelper on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension NumHelpers on num {
  SizedBox get hs => SizedBox(height: toDouble());
  SizedBox get ws => SizedBox(width: toDouble());
}
