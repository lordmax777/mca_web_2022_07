import 'dart:async';

import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

/////////

extension WidgetHelper on PlutoColumnRendererContext {
  Widget defaultText(
      {bool isSelectable = false,
      String? title,
      IconData? icon,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      bool isActive = true}) {
    final isS = isSelectable;
    final text = Text(
        (title ?? (cell.value?.toString() ?? "-")).isEmpty
            ? "-"
            : title ?? (cell.value?.toString() ?? "-"),
        textAlign: mainAxisAlignment.toTextAlign,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: stateManager.style.cellTextStyle.copyWith(
          color: isS ? Colors.blueAccent : null,
          decoration:
              !isActive ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.black,
          decorationThickness: 1,
        ));
    if (isS) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IgnorePointer(
          ignoring: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: icon != null ? null : column.width - 60,
                child: text,
              ),
              const SizedBox(width: 5),
              if (icon != null) Icon(icon, size: 15, color: Colors.blueAccent)
            ],
          ),
        ),
      );
    }
    return text;
  }

  Widget defaultTooltipWidget({String? title}) {
    return Tooltip(
      message: cell.value.toString().isEmpty ? "---" : cell.value.toString(),
      child: defaultText(
          title: title ?? "Read Comment",
          isSelectable: true,
          mainAxisAlignment: MainAxisAlignment.start),
    );
  }

  Widget actionMenuWidget({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context) => [
        if (onEdit != null)
          const PopupMenuItem(
            value: 1,
            child: Text("Edit"),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 2,
            child: Text("Delete"),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            onEdit?.call();
            break;
          case 2:
            onDelete?.call();
            break;
        }
      },
    );
  }

  Widget defaultEditableCellWidget() {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            cell.value.toString(),
            style: stateManager.style.cellTextStyle,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}

/////////

////////

mixin TableFocusNodeMixin<T extends StatefulWidget, MD, MD1> on State<T> {
  final DependencyManager dependencyManager = DependencyManager.instance;

  bool enableLoading = true;

  late final FocusNode focusNode;
  late final FocusNode focusNode1;

  PlutoGridStateManager? stateManager;
  PlutoGridStateManager? stateManager1;

  List<PlutoColumn> columns = [];
  List<PlutoColumn> columns1 = [];

  List<PlutoRow> get rows => stateManager == null ? [] : stateManager!.rows;

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    focusNode = FocusNode(onKey: (node, event) {
      if (event is RawKeyUpEvent) {
        return KeyEventResult.handled;
      }

      return stateManager!.keyManager!.eventResult.skip(KeyEventResult.ignored);
    });
    focusNode1 = FocusNode(onKey: (node, event) {
      if (event is RawKeyUpEvent) {
        return KeyEventResult.handled;
      }

      return stateManager1!.keyManager!.eventResult
          .skip(KeyEventResult.ignored);
    });
    super.initState();
  }

  @override
  void dispose() {
    stateManager?.gridFocusNode.removeListener(handleFocus);
    stateManager1?.gridFocusNode.removeListener(handleFocus1);
    super.dispose();
  }

  PlutoGridStateManager setRows(PlutoGridStateManager sm, List<PlutoRow> rs) {
    sm.removeAllRows();
    sm.appendRows(rs);
    final sortedColumn = sm.getSortedColumn;
    if (sortedColumn != null) {
      if (sortedColumn.sort.isAscending) {
        sm.sortAscending(sortedColumn);
      } else if (sortedColumn.sort.isDescending) {
        sm.sortDescending(sortedColumn);
      }
    }

    //todo:
    //filter rows
    // final filteredColumn = sm.filterRows;
    // if (sm.hasFilter) {
    //   print("has filter");
    // }
    return sm;
  }

  void onDidChange(List<MD>? prev, List<MD> current) {
    final oldItems = prev;
    final newItems = current;
    if (oldItems != newItems) {
      setRows(stateManager!, newItems.map((e) => buildRow(e)).toList());
    }
  }

  void onDidChange1(List<MD1>? prev, List<MD1> current) {
    final oldItems = prev;
    final newItems = current;
    if (oldItems != newItems) {
      setRows(stateManager1!, newItems.map((e) => buildRow1(e)).toList());
    }
  }

  void handleFocus() {
    stateManager?.setKeepFocus(!focusNode.hasFocus);
  }

  void handleFocus1() {
    stateManager1?.setKeepFocus(!focusNode1.hasFocus);
  }

  Future<A> loading<A>(Future<A> Function() callback) async {
    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager!.setShowLoading(true);
    }
    final res = await callback();

    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager!.setShowLoading(false);
    }
    return res;
  }

  Future<B> loading1<B>(Future<B> Function() callback) async {
    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager1?.setShowLoading(true);
    }
    final res = await callback();

    if (GlobalConstants.enableLoadingIndicator && enableLoading) {
      stateManager1?.setShowLoading(false);
    }
    return res;
  }

  PlutoRow buildRow(MD model) {
    throw UnimplementedError("Please override buildRow method");
  }

  PlutoRow buildRow1(MD1 model) {
    throw UnimplementedError("Please override buildRow1 method");
  }

  void onLoaded(PlutoGridOnLoadedEvent event) async {
    stateManager = event.stateManager;
    // stateManager!.setPageSize(GlobalConstants.pageSizes.first);
    stateManager!.keyManager!.eventResult.skip(KeyEventResult.ignored);
    final list = await loading<List<MD>?>(() async => await fetch());
    // stateManager!.gridFocusNode.addListener(handleFocus);
    if (list != null) {
      setRows(stateManager!, list.map((e) => buildRow(e)).toList());
    }
  }

  void onLoaded1(PlutoGridOnLoadedEvent event) async {
    stateManager1 = event.stateManager;
    stateManager1!.keyManager!.eventResult.skip(KeyEventResult.ignored);
    final list = await loading1<List<MD1>?>(() async => await fetch1());
    // stateManager1!.gridFocusNode.addListener(handleFocus1);
    if (list != null) {
      setRows(stateManager1!, list.map((e) => buildRow1(e)).toList());
    }
  }

  Future<List<MD>?> fetch() {
    return Future.value(null);
  }

  Future<List<MD1>?> fetch1() {
    return Future.value(null);
  }

  Future<void> onDelete(Future<bool> Function() callback,
      {bool showError = true}) async {
    try {
      context.futureLoading(() async {
        final success = await callback();
        if (success) {
          final l = await fetch();
          setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
          context.showSuccess("Deleted successfully!");
        } else {
          if (showError) context.showError("Cannot delete!");
        }
      });
    } catch (e) {
      if (showError) context.showError(e.toString());
    }
  }

  Future<void> onEdit(Widget Function(MD?) child, MD? model,
      {bool showSuccess = true}) async {
    if (stateManager!.hasFocus) {
      stateManager?.gridFocusNode.removeListener(handleFocus);
    }
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
            context: context,
            builder: (context) {
              return child(model);
            });

    if (res != null && res) {
      final l = await loading<List<MD>?>(() async => await fetch());
      setRows(stateManager!, l!.map((e) => buildRow(e)).toList());
      if (showSuccess) {
        context.showSuccess("");
        // context.showSuccess(
        //     "${model == null ? "Created" : "Updated"} successfully!");
      }
    }
  }

  Future<void> onDelete1(Future<bool> Function() callback,
      {bool showError = true}) async {
    try {
      context.futureLoading(() async {
        final success = await callback();
        if (success) {
          final l = await fetch1();
          setRows(stateManager1!, l!.map((e) => buildRow1(e)).toList());
          if (showError) context.showSuccess("Deleted successfully!");
        } else {
          if (showError) context.showError("Cannot delete!");
        }
      });
    } catch (e) {
      if (showError) context.showError(e.toString());
    }
  }

  Future<void> onEdit1(Widget Function(MD1?) child, MD1? model) async {
    if (stateManager1!.hasFocus) {
      stateManager1?.gridFocusNode.removeListener(handleFocus1);
    }
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
            context: context,
            builder: (context) {
              return child(model);
            });
    if (res != null && res) {
      final l = await loading1<List<MD1>?>(() async => await fetch1());
      setRows(stateManager1!, l!.map((e) => buildRow1(e)).toList());
    }
  }
}

/////////
