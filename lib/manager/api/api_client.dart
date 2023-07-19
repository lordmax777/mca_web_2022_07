import 'package:dio/dio.dart';
import 'package:mca_dashboard/manager/api/default_int.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

//Create a singleton class to manage the API client
class DioClient {
  final dependencies = DependencyManager.instance;
  //Db
  MCADb get db => dependencies.db;
  String get apiBaseUrl => db.getApiBaseUrl();
  String get accessToken => db.getAccessToken();
  bool get hasAccessToken => accessToken.isNotEmpty;

  //Create a private field to store the API client
  late final Dio _dio;

  //Create a getter to return the API client
  Dio get dio => _dio;

  final defaultInterceptors = DefaultInterceptor();

  //Create a method to initialize the API client
  Future<void> init() async {
    //Create a new instance of Dio
    _dio = Dio();

    //Set the base url

    //Set the request headers
    _dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    //Set the request interceptors
    _dio.interceptors.add(defaultInterceptors.loggingInterceptor);
    _dio.interceptors.add(defaultInterceptors.duplicateRequestInterceptor);
    _dio.interceptors.add(defaultInterceptors.tokenRenewInterceptor);
    _dio.interceptors.add(defaultInterceptors.cancelInterceptor);
    _dio.interceptors.add(defaultInterceptors.defaultInterceptor(db));

    logger("API Client initialized", hint: "API Client");
  }
}
