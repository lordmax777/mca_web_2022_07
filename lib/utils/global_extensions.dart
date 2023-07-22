import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

////////

extension ApiResponseExtension on Response {
  String? get handleApiErrorMessage {
    try {
      final data = this.data is String ? jsonDecode(this.data) : this.data;
      if (data is Map && data.containsKey("error_description")) {
        return data["error_description"];
      } else if (data is Map && data.containsKey("errors")) {
        return (data["errors"] as Map<String, dynamic>)
            .entries
            .toList()
            .join("\n")
            .replaceAll("MapEntry(", "")
            .replaceAll(")", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
      }
    } on FormatException catch (e) {
      final data = this.data is String ? this.data : "";
      Logger.e(e.toString(),
          tag: "ApiResponseExtension FormatException catch 1");
      return data;
    } catch (e, stackTrace) {
      Logger.e(e.toString(),
          tag: "ApiResponseExtension handleApiErrorMessage catch 1");
      Logger.e(stackTrace,
          tag: "ApiResponseExtension handleApiErrorMessage catch 2");
      return null;
    }
    return null;
  }
}

////////

extension MainAxisAlignmentHelper on MainAxisAlignment {
  TextAlign get toTextAlign {
    switch (this) {
      case MainAxisAlignment.start:
        return TextAlign.start;
      case MainAxisAlignment.end:
        return TextAlign.end;
      case MainAxisAlignment.center:
        return TextAlign.center;
      case MainAxisAlignment.spaceBetween:
        return TextAlign.start;
      case MainAxisAlignment.spaceAround:
        return TextAlign.start;
      case MainAxisAlignment.spaceEvenly:
        return TextAlign.start;
    }
  }
}

///////////

///////////

extension DateTimeHelpers on DateTime {
  String companyFormatDateTime([bool withTime = false]) {
    return DateFormat(withTime
            ? appStore.state.generalState.formatMd.formLong
            : appStore.state.generalState.formatMd.formShort)
        .format(this);
  }

  ///2023-01-01
  String get toApiDateWithDash => DateFormat("yyyy-MM-dd").format(this);

  ///01/01/2023
  String get toApiDateWithSlash => DateFormat("dd/MM/yyyy").format(this);

  //11:00
  String get toApiTime => DateFormat("HH:mm").format(this);

  //2023-05-01 11:00
  String get toApiDateTime => DateFormat("yyyy-MM-dd HH:mm").format(this);

  String get ddMMyyyyHHmm => DateFormat("dd/MM/yyyy HH:mm").format(this);
}

///////////

extension TimeOfDayExtensions on TimeOfDay {
  String get toApiTime {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}

///////////

mixin FormsMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isFormValid => formKey.currentState?.validate() ?? false;

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    formKey.currentState?.reset();
  }

  final controller1 = TextEditingController();

  Widget textField1(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller1,
      validator: validator,
    );
  }

  final controller2 = TextEditingController();

  Widget textField2(
      {required String label,
      String? Function(String?)? validator,
      int? maxLines}) {
    return DefaultTextField(
      label: label,
      controller: controller2,
      validator: validator,
      maxLines: maxLines,
    );
  }

  final controller3 = TextEditingController();

  Widget textField3(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller3,
      validator: validator,
    );
  }

  final controller4 = TextEditingController();

  Widget textField4(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller4,
      validator: validator,
    );
  }

  final controller5 = TextEditingController();
  final controller6 = TextEditingController();
  final controller7 = TextEditingController();
  final controller8 = TextEditingController();
  final controller9 = TextEditingController();
  final controller10 = TextEditingController();
  final controller11 = TextEditingController();
  final controller12 = TextEditingController();
  final controller13 = TextEditingController();
  final controller14 = TextEditingController();

  Widget textField5(
      {required String label, String? Function(String?)? validator}) {
    return DefaultTextField(
      label: label,
      controller: controller5,
      validator: validator,
    );
  }

  DefaultMenuItem? selected1;

  Widget dropdown1(
      {required String label,
      required List<DefaultMenuItem> list,
      double? width}) {
    return DefaultDropdown(
        label: label,
        width: width,
        onChanged: (value) {
          setState(() {
            selected1 = value;
          });
        },
        valueId: selected1?.id,
        items: list);
  }

  DefaultMenuItem? selected2;

  Widget dropdown2(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected2 = value;
          });
        },
        initialValue: selected2,
        items: list);
  }

  DefaultMenuItem? selected3;

  Widget dropdown3(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected3 = value;
          });
        },
        initialValue: selected3,
        items: list);
  }

  DefaultMenuItem? selected4;

  Widget dropdown4(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected4 = value;
          });
        },
        initialValue: selected4,
        items: list);
  }

  DefaultMenuItem? selected5;

  Widget dropdown5(String label, List<DefaultMenuItem> list, {double? width}) {
    return DefaultDropdownMenu(
        label: label,
        width: width,
        onSelected: (value) {
          setState(() {
            selected5 = value;
          });
        },
        initialValue: selected5,
        items: list);
  }

  DateTime? selectedDate1;

  Widget datePicker1(
    String label, {
    String? Function(String?)? validator,
    double? width,
  }) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text:
            selectedDate1 == null ? "" : selectedDate1!.companyFormatDateTime(),
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate1);
        if (date != null) {
          setState(() {
            selectedDate1 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate2;

  Widget datePicker2(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text:
            selectedDate2 == null ? "" : selectedDate2!.companyFormatDateTime(),
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate1);
        if (date != null) {
          setState(() {
            selectedDate2 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate3;

  Widget datePicker3(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text:
            selectedDate3 == null ? "" : selectedDate3!.companyFormatDateTime(),
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate3);
        if (date != null) {
          setState(() {
            selectedDate3 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate4;

  Widget datePicker4(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text:
            selectedDate4 == null ? "" : selectedDate4!.companyFormatDateTime(),
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate4);
        if (date != null) {
          setState(() {
            selectedDate4 = date;
          });
        }
      },
    );
  }

  DateTime? selectedDate5;

  Widget datePicker5(String label,
      {String? Function(String?)? validator, double? width}) {
    return DefaultTextField(
      width: width,
      enabled: false,
      label: label,
      validator: validator,
      controller: TextEditingController(
        text:
            selectedDate5 == null ? "" : selectedDate5!.companyFormatDateTime(),
      ),
      onTap: () async {
        final DateTime? date =
            await showCustomDatePicker(context, initialTime: selectedDate5);
        if (date != null) {
          setState(() {
            selectedDate5 = date;
          });
        }
      },
    );
  }

  bool checked1 = false;
  bool checked2 = false;
  bool checked3 = false;
  bool checked4 = false;
  bool checked5 = false;

  PlatformFile? file1;
  PlatformFile? file2;
  PlatformFile? file3;
  PlatformFile? file4;
  PlatformFile? file5;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    controller7.dispose();
    controller8.dispose();
    controller9.dispose();
    controller10.dispose();
    controller11.dispose();
    controller12.dispose();
    controller13.dispose();
    controller14.dispose();
    super.dispose();
  }
}

//////////

final _deps = DependencyManager.instance;
/////////

extension ContextHelper on BuildContext {
  void showError(String message, {VoidCallback? onClose}) {
    _deps.navigation.showFail(message, onClose: onClose);
  }

  Future<T> futureLoading<T>(Future<T> Function() callback) async {
    return await _deps.navigation.futureLoading<T>(() async {
      return await callback();
    });
  }

  void showSuccess(String message) {
    _deps.navigation.showSuccess(message);
  }

  Future<T?> showDialog<T>(Widget dialog) async {
    return await _deps.navigation
        .showCustomDialog<T>(context: this, builder: (context) => dialog);
  }

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;
}

/////////

extension NumHelper on num {
  String getPriceMap([int decimalPoints = 0, bool withSymbol = true]) {
    final CompanyInfoMd company = appStore.state.generalState.companyInfo;
    return NumberFormat.currency(
      name: company.currency.sign,
      decimalDigits: company.currency.digits,
    ).format(this);
  }
}

///////////////

//Create a mixin which is extended by Equatable and has above functions to must override
//copyWith

mixin DataSourceMixin<T> implements Equatable {
  T copyWith();

  @override
  bool? get stringify => true;

  void dispose();
}

///////////////

extension StringHelpers on String {
  TimeOfDay? get toTimeOfDay {
    try {
      final time = split(':');
      return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
    } catch (e) {
      return null;
    }
  }
}

///////////////////////

mixin ActionMixin<R> {
  Future<Either<R, ErrorMd>> fetch(AppState state);
}

//////////////////////
