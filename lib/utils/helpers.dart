import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/models/company_md.dart';
import 'package:mca_web_2022_07/pages/scheduling/quick_schedule_drawer.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import '../manager/redux/sets/app_state.dart';
import '../manager/rest/nocode_helpers.dart';
import 'currency_format.dart';

extension TimeExtensionsForNum on num {
  double get inHours {
    //thi is in minutes and convert to hours
    return this / 60;
  }

  double get inMinutes {
    // Find the decimals of this.inHours and return the minutes
    logger(inHours % 1 * 60);
    return (inHours % 1) * 60;
  }
}

extension DateTimeExtensions on DateTime {
  String get formattedDate => "$day/$month/$year";

  String get formatDateForApi => "$year-$month-$day";
}

extension TimeExtensionsString on String {
  TimeOfDay? get formattedTime {
    dynamic time = split(" ");
    if (time.length == 1) {
      time = split(":").map((e) => int.tryParse(e)).toList();
      if (time.any((element) => element == null)) return null;
      return TimeOfDay(hour: time[0], minute: time[1]);
    }
    time.removeLast();
    time = time.join(" ");
    time = time.split(":");
    time = time.map((e) => int.tryParse(e)).toList();
    if (time.any((element) => element == null)) return null;
    return TimeOfDay(hour: time[0], minute: time[1]);
  }
}

extension TimeOfDayExtensions on TimeOfDay {
  String get formattedTime {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}

extension TimeExtensions on TextEditingController {
  List<int>? get formattedTime {
    dynamic time = text.split(" ");
    if (time.length == 1) {
      time = text.split(":").map((e) => int.tryParse(e)).toList();
      if (time.any((element) => element == null)) return null;
      return time.cast<int>();
    }
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
    String? symbol = currency.sign;
    int decimalDigits = currency.digits;
    bool isRightSymbol = currency.signFront;
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

  static Widget getStatusRenderer(PlutoColumnRendererContext ctx,
      {String? successKey, String? failKey}) {
    final value = ctx.cell.value;
    Color color = value == "active" ? ThemeColors.green2 : ThemeColors.gray5;
    String text = value
        .toString()
        .replaceFirst(value.toString()[0], value.toString()[0].toUpperCase());
    if (successKey != null && value == successKey) {
      color = ThemeColors.green2;
    }
    if (failKey != null && value == failKey) {
      color = ThemeColors.red3;
    }

    return SpacedRow(
        horizontalSpace: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          UsersListTable.defaultTextWidget(text),
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
      HeroIcons? icon,
      bool? disableIcon = false,
      Color? color}) {
    return KText(
      text: title,
      textColor: color ?? ThemeColors.MAIN_COLOR,
      fontWeight: FWeight.regular,
      fontSize: 14,
      mainAxisSize: MainAxisSize.min,
      isSelectable: false,
      onTap: onTap != null ? () => onTap(ctx) : null,
      // rowCenter: ctx.column.textAlign.value == TextAlign.center,
      icon: disableIcon!
          ? null
          : HeroIcon(
              icon ?? HeroIcons.edit,
              color: color ?? ThemeColors.MAIN_COLOR,
              size: 12,
            ),
    );
  }

  static Widget getActionRendererForApproval(
    PlutoColumnRendererContext ctx, {
    ValueChanged<PlutoColumnRendererContext>? approveBtnTap,
    ValueChanged<PlutoColumnRendererContext>? declineBtnTap,
  }) {
    return SpacedRow(
      children: [
        ButtonSmall(
            icon: const HeroIcon(HeroIcons.bin,
                color: ThemeColors.white, size: 16),
            text: "Approve",
            onPressed: approveBtnTap != null ? () => approveBtnTap(ctx) : null,
            bgColor: ThemeColors.green2),
        ButtonSmall(
            icon: const HeroIcon(HeroIcons.plusCircle,
                color: ThemeColors.white, size: 16),
            text: "Decline",
            onPressed: declineBtnTap != null ? () => declineBtnTap(ctx) : null,
            bgColor: ThemeColors.red3),
      ],
    );
  }
}

class ApiErrorResponseModel {
  final String? message;
  final Map? errors;

  ApiErrorResponseModel({
    this.message,
    this.errors,
  });

  //from json
  factory ApiErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponseModel(
      message: json['message'],
      errors: json['errors'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors,
    };
  }

  String getErrors() {
    String msg = "";
    if (errors != null) {
      errors!.forEach((key, value) {
        msg += "$key: $value";
      });
    }
    return msg;
  }
}

class ApiHelpers {
  static String getRawDataErrorMessages(ApiResponse res) {
    String msg = "Error";
    if (res.rawError != null) {
      try {
        ApiErrorResponseModel? error =
            ApiErrorResponseModel.fromJson(jsonDecode(res.rawError!.data));
        msg = error.getErrors();
      } catch (e) {
        msg = res.rawError!.data;
      }
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

enum RowState { created, updated, idle, deleted }

Future<T?> openEndDrawer<T>(Widget drawer) async {
  appStore.dispatch(UpdateUIStateAction(endDrawer: drawer));
  await Future.delayed(const Duration(milliseconds: 100));
  if (Constants.scaffoldKey.currentState != null) {
    if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
      Constants.scaffoldKey.currentState!.openEndDrawer();
    }
  }
}

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

enum AllocationActions {
  add,
  remove,
  publish,
  unpublish,
  more,
  less,
  copy;

  String get name {
    switch (this) {
      case AllocationActions.add:
        return "add";
      case AllocationActions.remove:
        return "remove";
      case AllocationActions.publish:
        return "publish";
      case AllocationActions.unpublish:
        return "unpublish";
      case AllocationActions.copy:
        return "copy";
      case AllocationActions.more:
        return "more";
      case AllocationActions.less:
        return "less";
    }
  }
}

abstract class HtmlHelper {
  static String replaceBr(String html) {
    try {
      if (html.contains("<br>")) {
        return html.replaceAll("<br>", "\n");
      } else if (html.contains("<br/>")) {
        return html.replaceAll("<br/>", "\n");
      } else if (html.contains("<br />")) {
        return html.replaceAll("<br />", "\n");
      } else {
        return html;
      }
    } catch (e) {
      return html;
    }
  }
}

extension StringExt on String {
  DateTime? toDate([String splitBy = "-"]) {
    try {
      int day = int.parse(split(splitBy)[2]);
      int month = int.parse(split(splitBy)[1]);
      int year = int.parse(split(splitBy)[0]);
      return DateTime(year, month, day);
    } catch (e) {
      throw Exception("Invalid date format");
    }
  }
}

mixin LoadingModel<T extends StatefulWidget> on State<T> {
  LoadingHelper loadingHelper = LoadingHelper.idle;
  String? message;

  void setLoading(LoadingHelper loadingHelper, [String? message]) {
    if (mounted) {
      setState(() {
        this.loadingHelper = loadingHelper;
        this.message = message;
      });
    }
  }

  Widget getLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingHelper == LoadingHelper.loading
              ? const CircularProgressIndicator()
              : loadingHelper == LoadingHelper.error
                  ? const HeroIcon(
                      HeroIcons.exclamationCircle,
                      color: ThemeColors.red3,
                      size: 40,
                    )
                  : const SizedBox(),
          const SizedBox(height: 10),
          Text(
            message ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeColors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (loadingHelper == LoadingHelper.error)
            ButtonSmall(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                text: "Close")
        ],
      ),
    );
  }

  Widget stack(Widget child) {
    return Stack(
      children: [
        Opacity(
            opacity: loadingHelper == LoadingHelper.idle ? 1 : 0.5,
            child: child),
        if (loadingHelper != LoadingHelper.idle)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: getLoadingWidget(),
          ),
      ],
    );
  }
}

enum LoadingHelper {
  idle,
  loading,
  error;
}
