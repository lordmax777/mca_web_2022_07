import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/pages.dart';
import 'package:mca_dashboard/utils/utils.dart';

class MCANavigation extends IMCANavigation {
  final MCALoginState loginState = MCALoginState();

  /// Global key for the navigator
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Routes
  /// Debug Page
  static const String debug = '/debug';

  ///Root is where we check if the user is logged in or not
  static const String root = '/root';

  ///Login is where the user logs in
  static const String login = '/login';

  ///Dashboard is where the user is logged in
  static const String dashboard = '/dashboard';

  /// Users list view
  static const String users = '/users';

  /// Schedule view
  static const String scheduling = '/scheduling';

  /// Quotes
  static const String quotes = '/quotes';

  //Deps and Groups
  static const String depsAndGroups = '/depsAndGroups';

  //Qualifications
  static const String qualifications = '/qualifications';

  //Warehouses
  static const String warehouses = '/warehouses';

  //Storage Items
  static const String storageItems = '/storageItems';

  //Handover Types
  static const String handoverTypes = '/handoverTypes';

  //Locations
  static const String locations = '/locations';

  //checklist templates
  static const String checklistTemplates = '/checklistTemplates';

  //properties
  static const String properties = '/properties';

  //Approvals
  static const String approvals = '/approvals';

  //Checklists
  static const String checklists = '/checklists';

  //Settings
  static const String settings = '/settings';

  //Timesheet
  static const String timesheet = '/timesheet';

  //Clients
  static const String clients = '/clients';

  /// router
  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: loginState,
    navigatorKey: navigatorKey,
    observers: [
      BotToastNavigatorObserver(),
    ],
    routes: [
      GoRoute(
        path: "/",
        name: "root",
        redirect: (state, context) => login,
      ),
      GoRoute(
        path: login,
        name: login.substring(1),
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: LoginView(),
          );
        },
      ),
      ShellRoute(
          builder: (context, state, child) {
            return DefaultLayout(child: child);
          },
          routes: [
            GoRoute(
              path: dashboard,
              name: dashboard.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const DashboardView(),
                );
              },
            ),
            GoRoute(
              path: users,
              name: users.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const UsersView(),
                );
              },
            ),
            GoRoute(
              path: scheduling,
              name: scheduling.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const SchedulingView(),
                );
              },
            ),
            GoRoute(
              path: quotes,
              name: quotes.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const QuotesView(),
                );
              },
            ),
            GoRoute(
              path: depsAndGroups,
              name: depsAndGroups.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const DepsAndGroupsWrapper(),
                );
              },
            ),
            GoRoute(
              path: qualifications,
              name: qualifications.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const QualificationsView(),
                );
              },
            ),
            GoRoute(
              path: warehouses,
              name: warehouses.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const WarehousesView(),
                );
              },
            ),
            GoRoute(
              path: storageItems,
              name: storageItems.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const StorageItemsView(),
                );
              },
            ),
            GoRoute(
              path: handoverTypes,
              name: handoverTypes.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HandoverTypesView(),
                );
              },
            ),
            GoRoute(
              path: locations,
              name: locations.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const LocationsView(),
                );
              },
            ),
            GoRoute(
              path: checklistTemplates,
              name: checklistTemplates.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ChecklistTemplateView(),
                );
              },
            ),
            GoRoute(
              path: properties,
              name: properties.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const PropertiesView(),
                );
              },
            ),
            GoRoute(
              path: approvals,
              name: approvals.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ApprovalsView(),
                );
              },
            ),
            GoRoute(
              path: checklists,
              name: checklists.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ChecklistsView(),
                );
              },
            ),

            //Timesheet
            GoRoute(
              path: timesheet,
              name: timesheet.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const TimesheetView(),
                );
              },
            ),

            //Settings
            GoRoute(
              path: settings,
              name: settings.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: SettingsView(),
                );
              },
            ),
            //Clients
            GoRoute(
              path: clients,
              name: clients.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: ClientsView(),
                );
              },
            ),

            //Debug only
            if (kDebugMode)
              GoRoute(
                path: debug,
                name: debug.substring(1),
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: const DebugView(),
                  );
                },
              ),
          ]),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: Scaffold(
          body: Center(
        child: Text(
          'Page not found: ${state.path}\n'
          'This is the default error page.\n',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    ),
    redirect: (context, state) {
      //todo: redirect to old page
      final loginLoc = state.namedLocation(login.substring(1));
      final dashName = state.namedLocation(dashboard.substring(1));

      final loggedIn = loginState.isLoggedIn;

      final loggingIn = state.location == loginLoc;

      if (!loggedIn && !loggingIn) return login;
      if (loggedIn && loggingIn) return dashboard;
      return null;
    },
  );

  //Loading related functions
  @override
  CancelFunc showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false}) {
    if (GlobalConstants.enableLoadingIndicator) {
      return BotToast.showCustomLoading(
        toastBuilder: (cancelFunc) {
          return MCALoadingWidget(
              onClose: kDebugMode
                  ? cancelFunc
                  : showCancelButton
                      ? cancelFunc
                      : null);
        },
        clickClose: barrierDismissible,
        allowClick: false,
        backButtonBehavior: BackButtonBehavior.ignore,
      );
    } else {
      return () {};
    }
  }

  @override
  void closeLoading() {
    BotToast.closeAllLoading();
  }

  @override
  Future<T> futureLoading<T>(Future<T> Function() future) async {
    if (GlobalConstants.enableLoadingIndicator) {
      CancelFunc cancel = showLoading();
      T result = await future();
      cancel();
      return result;
    } else {
      T result = await future();
      return result;
    }
  }

  @override
  Future<bool?> showAlert(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete file permanently?'),
              content: const Text(
                'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
              ),
              actions: [
                FilledButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    context.pop(true);
                  },
                ),
                FilledButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.pop(false),
                ),
              ],
            ));
  }

  @override
  void showSuccess(String msg, {VoidCallback? onClose}) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: const Duration(seconds: 4),
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: const Text('Success'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cancelFunc();
                    onClose?.call();
                  },
                  child: const Text('Close'),
                ),
              ],
              content: msg.isNotEmpty
                  ? Text(msg, textAlign: TextAlign.center)
                  : null,
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  void showFail(String msg, {VoidCallback? onClose}) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: null,
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              // title: const Text('Error'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cancelFunc();
                    onClose?.call();
                  },
                  child: const Text('Close'),
                ),
              ],
              content: Text(msg, textAlign: TextAlign.center),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = false,
  }) async {
    return await showDialog<T>(
      barrierDismissible: kDebugMode ? true : barrierDismissible,
      context: context,
      builder: builder,
    );
  }
}

abstract class IMCANavigation {
  //Loading related functions
  CancelFunc showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false});

  void closeLoading();

  Future<T> futureLoading<T>(Future<T> Function() future);

  Future<bool?> showAlert(BuildContext context);

  void showSuccess(String msg, {VoidCallback? onClose});

  void showFail(String msg);

  Future<T?> showCustomDialog<T>(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool barrierDismissible = false});
}

class MCALoginState extends ChangeNotifier {
  ///Do not use this class directly, use [DependencyManager.instance.navigation.loginState] instead
  ///
  /// Do not use [DependencyManager.instance] inside this class
  MCALoginState() {
    init();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  bool _isLoggingIn = false;

  /// This is used to hide login page when checking if the user's token is valid or not.
  ///
  /// Shows a loading in login page.
  ///
  /// [_isLoggingIn] is always false after checking.
  bool get isLoggingIn => _isLoggingIn;

  Future<void> login() async {
    final initSuccess = await dispatch<bool>(const GetInitActions());
    _isLoggingIn = false;
    if (initSuccess.isLeft) {
      _isLoggedIn = true;
      notifyListeners();
    } else {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    //clear all data
    await dispatch<void>(const GetClearDataAction());
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> init() async {
    logger("MCALoginState created");
    //Check access token is valid, checking by calling getFormats api
    _isLoggingIn = true;
    notifyListeners();
    final formats = await dispatch<FormatMd>(const GetFormatsAction());
    formats.fold((left) async {
      Logger.i("Logged in");
      //if success then move to dashboard
      await login();
    }, (right) async {
      Logger.e("Not Logged in");
      _isLoggingIn = false;
      notifyListeners();
      //if fail then move to login page
      await logout();
    });
  }
}
