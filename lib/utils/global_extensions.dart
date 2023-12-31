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
      final code = statusCode;
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
  final controller15 = TextEditingController();

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

  bool checked1 = true;
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
    controller15.dispose();
    super.dispose();
  }
}

//////////

final _deps = DependencyManager.instance;
/////////

extension ContextHelper on BuildContext {
  void showError(String message, {VoidCallback? onClose, String? closeText}) {
    _deps.navigation.showFail(message, onClose: onClose, closeText: closeText);
  }

  Future<T> futureLoading<T>(Future<T> Function() callback) async {
    return await _deps.navigation.futureLoading<T>(() async {
      return await callback();
    });
  }

  void showSuccess(String message, {VoidCallback? onClose}) {
    _deps.navigation.showSuccess(message, onClose: onClose);
  }

  Future<T?> showDialog<T>(Widget dialog,
      {bool barrierDismissible = true}) async {
    return await _deps.navigation.showCustomDialog<T>(
        context: this,
        builder: (context) => dialog,
        barrierDismissible: barrierDismissible);
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

  DateTime? get timeToDateTime {
    //convert 11:00 to DatTime
    try {
      final time = split(':');
      return DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, int.parse(time[0]), int.parse(time[1]));
    } on FormatException catch (e) {
      return null;
    }
  }

  String? get emptyOrNull {
    if (isEmpty) {
      return null;
    }
    return this;
  }
}

///////////////////////

mixin ActionMixin<R> {
  Future<Either<R, ErrorMd>> fetch(AppState state);
}

//////////////////////

//create enum for these values and call it QuoteProcessStatus
//quote requested, quote prepared, quote revision, quote sent, declined, accepted, job created, job scheduled, job started, job completed, invoiced, closed
enum QuoteProcess {
  quoteRequested,
  quotePrepared,
  quoteRevision,
  quoteSent,
  declined,
  accepted,
  jobCreated,
  jobScheduled,
  jobStarted,
  jobCompleted,
  invoiced,
  closed,
}

//from String extension for QuoteProcessStatus
extension QuoteProcessStatusHelperString on String {
  QuoteProcess get toQuoteProcess {
    switch (this) {
      //quote
      case "quote requested":
        return QuoteProcess.quoteRequested;
      case "quote prepared":
        return QuoteProcess.quotePrepared;
      case "quote revision":
        return QuoteProcess.quoteRevision;
      case "quote sent":
        return QuoteProcess.quoteSent;
      case "declined":
        return QuoteProcess.declined;
      case "accepted":
        return QuoteProcess.accepted;

      //if products is changed then send quote email
      //job
      case "job created":
        return QuoteProcess.jobCreated; //missing in db
      case "job scheduled":
        return QuoteProcess.jobScheduled;
      case "job started":
        return QuoteProcess.jobStarted;

      //POST invoice, if client invoice period is manual make a button to send invoice, else remove button
      case "job completed":
        return QuoteProcess.jobCompleted;

      //invoice
      case "invoiced":
        return QuoteProcess.invoiced;

      default:
        return QuoteProcess.closed; //todo: check later
    }
  }
}

//from QuoteProcessStatus extension to String
extension QuoteProcessStatusHelper on QuoteProcess {
  String get toStr {
    switch (this) {
      case QuoteProcess.quoteRequested:
        return "quote requested";
      case QuoteProcess.quotePrepared:
        return "quote prepared";
      case QuoteProcess.quoteRevision:
        return "quote revision";
      case QuoteProcess.quoteSent:
        return "quote sent";
      case QuoteProcess.declined:
        return "declined";
      case QuoteProcess.accepted:
        return "accepted";
      case QuoteProcess.jobCreated:
        return "job created";
      case QuoteProcess.jobScheduled:
        return "job scheduled";
      case QuoteProcess.jobStarted:
        return "job started";
      case QuoteProcess.jobCompleted:
        return "job completed";
      case QuoteProcess.invoiced:
        return "invoiced";
      default:
        return "closed";
    }
  }
}

//Create a quote status enum and call it QuoteStatus
//pending, accept, decline
enum QuoteStatus {
  pending,
  accept,
  decline,
}

//from String extension for QuoteStatus
extension QuoteStatusHelperString on String {
  QuoteStatus get toQuoteStatus {
    switch (this) {
      case "pending":
        return QuoteStatus.pending;
      case "accept":
        return QuoteStatus.accept;
      default:
        return QuoteStatus.decline;
    }
  }
}

//from QuoteStatus extension to String
extension QuoteStatusHelper on QuoteStatus {
  String get toStr {
    switch (this) {
      case QuoteStatus.pending:
        return "pending";
      case QuoteStatus.accept:
        return "accept";
      default:
        return "decline";
    }
  }
}
