// import 'package:auto_route/auto_route.dart';
//
// class AuthGuard extends AutoRedirectGuard {
//   static bool isLoaded = false;
//   @override
//   Future<void> onNavigation(
//       NavigationResolver resolver, StackRouter router) async {
//     LoginDataMd? loginData = HiveClient.getToken();
//     logger(isLoaded.toString());
//     if (loginData != null && loginData.token != null) {
//       if (!isLoaded) {
//         ApiResponse res = await appStore.dispatch(GetJwtTokenAction(
//             authReq: AuthReq(
//           userType: loginData.userType!,
//           id: loginData.loginId!,
//           password: loginData.password!,
//         )));
//
//         if (res.success) {
//           if (appStore.state.businessState.allStores.list == null) {
//             await appStore.dispatch(GetAllStoresAction());
//           }
//           await appStore.dispatch(GetStoresAction(findReq: FindReq()));
//           if (appStore.state.businessState.currentStoreId.isEmpty) {
//             if (appStore.state.businessState.stores.list != null) {
//               StoreData? storeData =
//                   appStore.state.businessState.stores.list!.first;
//               await appStore.dispatch(SetCurrentStoreAction(store: storeData));
//             }
//           }
//           if (appStore.state.authState.userInfo.name == null) {
//             await appStore.dispatch(GetUserInfoAction());
//           }
//           if (appStore.state.businessState.storeInfo.storeName == null) {
//             await appStore.dispatch(GetStoreInfoAction(
//                 storeId: appStore.state.businessState.currentStoreId));
//           }
//
//           await appStore.dispatch(GetCatalogItemGroupAction(
//               getCatalogItemGroupReq: FindReq(pageSize: -1)));
//           await appStore
//               .dispatch(GetStorePlacesAction(findReq: FindReq(pageSize: -1)));
//
//           isLoaded = true;
//           resolver.next();
//           return;
//         } else {
//           router.push(AuthRoutesWrapper(resolver: () {
//             resolver.next();
//           }));
//         }
//       } else {
//         resolver.next();
//         return;
//       }
//     }
//     router.push(AuthRoutesWrapper(resolver: () {
//       resolver.next();
//     }));
//   }
//
//   @override
//   Future<bool> canNavigate(RouteMatch route) {
//     throw UnimplementedError();
//   }
// }
