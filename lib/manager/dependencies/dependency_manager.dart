import 'package:get_it/get_it.dart';
import 'package:mca_dashboard/manager/api/api.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';

class DependencyManager {
  static final DependencyManager _instance = DependencyManager._internal();
  factory DependencyManager() {
    return _instance;
  }
  DependencyManager._internal();

  static DependencyManager get instance => _instance;

  final GetIt _getIt = GetIt.instance;

  //Application dependency
  AppDep get appDep => _getIt<AppDep>();

  MCANavigation get navigation => _getIt<MCANavigation>();

  DioClient get dioClient => _getIt<DioClient>();

  ApiClient get apiClient => _getIt<ApiClient>();

  MCADb get db => _getIt<MCADb>();

  //It is run in main.dart
  Future<void> init() async {
    //DB
    final db = MCADb();
    await db.initHive();
    _getIt.registerSingleton<MCADb>(db);
    //DB

    //DioClient
    final dioClient = DioClient();
    await dioClient.init();
    _getIt.registerSingleton<DioClient>(dioClient);
    //DioClient

    //ApiClient
    _getIt.registerSingleton<ApiClient>(ApiClient(dioClient.dio));
    //ApiClient

    //AppDep
    _getIt.registerSingleton<AppDep>(AppDep());
    //AppDep

    //Navigation
    _getIt.registerSingleton<MCANavigation>(MCANavigation());
    //Navigation
  }
}
