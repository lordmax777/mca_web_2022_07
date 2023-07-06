import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/users_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../manager/dependencies/dependency_manager.dart';
export 'users_view_widgets/dialogs/new_user_popup.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView>
    with TableFocusNodeMixin<UsersView, UserMd, UserMd> {
  final deps = DependencyManager.instance;

  ListMd get lists => appStore.state.generalState.lists;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<UserMd>>(
        converter: (store) => store.state.generalState.users,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return UsersTable(
            onSelected: showUserDetailsDialog,
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
            headerEnd: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Create User"),
              onPressed: () {
                showUserDetailsDialog(null, context, null);
              },
            ),
            rows: kDebugMode
                ? appStore.state.generalState.users
                    .map((e) => buildRow(e))
                    .toList()
                : [],
          );
        });
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "",
          field: "id",
          hide: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Name",
          field: "name",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(isSelectable: true);
          },
        ),
        PlutoColumn(
          title: "Username",
          field: "username",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(isSelectable: true);
          },
        ),
        PlutoColumn(
          title: "Department",
          field: "department",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
            title: "Main Location",
            field: "main_location",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Payroll",
          field: "payroll",
          width: 80,
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                title: "View",
                isSelectable: true,
                mainAxisAlignment: MainAxisAlignment.center,
                icon: Icons.remove_red_eye_outlined);
          },
        ),
        PlutoColumn(
          title: "Reviews",
          field: "reviews",
          width: 80,
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                title: "View",
                isSelectable: true,
                mainAxisAlignment: MainAxisAlignment.center,
                icon: Icons.remove_red_eye_outlined);
          },
        ),
        PlutoColumn(
          title: "Visa",
          field: "visa",
          width: 80,
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                title: "View",
                isSelectable: true,
                mainAxisAlignment: MainAxisAlignment.center,
                icon: Icons.remove_red_eye_outlined);
          },
        ),
        PlutoColumn(
          title: "Preferred Shifts",
          field: "preferred_shifts",
          width: 80,
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                title: "View",
                isSelectable: true,
                mainAxisAlignment: MainAxisAlignment.center,
                icon: Icons.remove_red_eye_outlined);
          },
        ),
        PlutoColumn(
          title: "Qualifications",
          field: "qualifications",
          width: 80,
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                title: "View",
                isSelectable: true,
                mainAxisAlignment: MainAxisAlignment.center,
                icon: Icons.remove_red_eye_outlined);
          },
        ),
      ];

  @override
  Future<List<UserMd>?> fetch() async {
    final res = await dispatch<List<UserMd>>(const GetUsersAction());
    if (res.isLeft) {
      return res.left;
    }
    return null;
  }

  @override
  PlutoRow buildRow(user) {
    String dep = user.groupId ?? "-";
    for (var el in lists.groups) {
      if (dep != "-") {
        if (el.id == int.tryParse(dep)) {
          dep = el.name;
          if (user.groupAdmin) {
            dep = '[Admin] - $dep';
          }
        }
      } else {
        if (user.groupAdmin) {
          dep = '[Admin]';
        }
      }
    }
    String loc = user.locationId?.toString() ?? "-";
    for (var el in lists.locations) {
      if (loc != "-") {
        if (el.id == int.tryParse(loc)) {
          loc = el.name;
          if (user.locationAdmin) {
            loc = '[Admin] - $loc';
          }
        }
      } else {
        if (user.locationAdmin) {
          loc = '[Admin]';
        }
      }
    }
    return PlutoRow(cells: {
      "id": PlutoCell(value: user.id),
      "name": PlutoCell(value: user.fullname),
      "username": PlutoCell(value: user.username),
      "department": PlutoCell(value: dep),
      "main_location": PlutoCell(value: loc),
      "payroll": PlutoCell(value: ""),
      "reviews": PlutoCell(value: ""),
      "visa": PlutoCell(value: ""),
      "preferred_shifts": PlutoCell(value: "-"),
      "qualifications": PlutoCell(value: "-"),
    });
  }

  void showUserDetailsDialog(
      UserMd? user, BuildContext context, int? initialTabIndex) async {
    if (stateManager!.hasFocus) {
      stateManager?.gridFocusNode.removeListener(handleFocus);
    }
    final success =
        await DependencyManager.instance.navigation.showCustomDialog(
            context: context,
            builder: (context) {
              return NewUserPopup(
                user: user,
                initialTabIndex: initialTabIndex,
              );
            });
    if (success != null) {
      // stateManager.removeAllRows();
      // stateManager.appendRows(success.map((e) => buildRow(e)).toList());
    }
  }
}
