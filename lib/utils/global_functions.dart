import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:get_ip_address/get_ip_address.dart' as getIp;
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:file_picker/file_picker.dart';

logger(var str, {String? hint, bool json = false}) {
  if (GlobalConstants.enableLogger) {
    debugPrint(hint != null ? "-----$hint------" : '-------');
    if (json) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(str));
    } else {
      debugPrint(str.toString());
    }
    debugPrint(hint != null ? "-----$hint------" : '-------');
  }
}

////////

///While using this function, make sure to return [Either] type of left [T] and right [ErrorMd]
FutureOr<Either<T, ErrorMd>> dispatch<T>(Object action) {
  try {
    return appStore.dispatch(action);
  } catch (e) {
    Logger.e(e.toString(), tag: "Message in [dispatch] function");
    return const Right(
        ErrorMd(message: "Error occurred", code: null, data: null));
  }
}

////////

////////

Future<Either<T, ErrorMd>> apiCall<T>(Future<T> Function() callback) async {
  try {
    final T res = await callback();
    return Left(res);
  } on DioError catch (e) {
    Logger.e(e.toString(), tag: "Message in apiCall");
    return Right(ErrorMd(
        data: e.response?.data,
        code: e.response?.statusCode,
        message: e.response?.handleApiErrorMessage ?? "Unknown error"));
  } on Exception catch (e) {
    Logger.e(e.toString(), tag: "Message");
    Logger.e(e.runtimeType, tag: "Type");
    return const Right(
        ErrorMd(message: "Error occurred", code: null, data: null));
  } catch (e) {
    Logger.e(e.toString(), tag: "Message catch");
    Logger.e(e.runtimeType, tag: "Type catch");
    if (e is ErrorMd) {
      return Right(e);
    }
    return Right(ErrorMd(message: e.toString(), code: null, data: null));
  }
}

/////////////
///Returns String of IP address if found, else null
Future<String?> getIpAddress() async {
  String? ipAddress;
  try {
    final getIp.IpAddress ip = getIp.IpAddress();
    ipAddress = await ip.getIpAddress();
  } on Exception {
    ipAddress = null;
  }
  return ipAddress;
}

/////////////

////////////

Future<PlatformFile?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    return file;
  }
  // User canceled the picker
  return null;
}
