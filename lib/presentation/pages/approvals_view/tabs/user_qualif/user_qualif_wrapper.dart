import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/approvals_action.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/user_qualif/user_qualif_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../manager/manager.dart';

class UserQualificationWrapper extends StatefulWidget {
  const UserQualificationWrapper({super.key});

  @override
  State<UserQualificationWrapper> createState() =>
      _UserQualificationWrapperState();
}

class _UserQualificationWrapperState extends State<UserQualificationWrapper>
    with
        TableFocusNodeMixin<UserQualificationWrapper, PendingUserQualifMd,
            PendingUserQualifMd> {
  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {}
      },
    );
  }

  @override
  Future<List<PendingUserQualifMd>?> fetch() async {
    return appStore.state.generalState.approvals.pendingUserQualifications;
  }

  @override
  PlutoRow buildRow(PendingUserQualifMd model) {
    return PlutoRow(cells: {
      "user": PlutoCell(value: model.fullname),
      "qualification": PlutoCell(
          value: model
              .qualificationMd(appStore.state.generalState.lists.qualifications)
              ?.title),
      "certificate": PlutoCell(value: model.thumbnailBytes),
      "documentNumber": PlutoCell(value: model.certificateNumber),
      "dateAcquired": PlutoCell(value: model.achievementDate), //start - end
      "expiryDate": PlutoCell(value: model.expiryDate), //start - end
      "comments": PlutoCell(value: model.comments),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<PendingUserQualifMd>>(
      converter: (store) =>
          store.state.generalState.approvals.pendingUserQualifications,
      onDidChange: onDidChange,
      builder: (context, vm) {
        return UserQualifTable(
          onLoaded: onLoaded,
          onApprove: onApprove,
          focusNode: focusNode,
          rows: stateManager == null ? [] : stateManager!.rows,
        );
      },
    );
  }

  void onApprove(PlutoRow? singleRow, bool isApprove) {
    context.futureLoading<void>(() async {
      final selected = [...stateManager!.checkedRows];
      if (singleRow != null) {
        selected.clear();
        selected.add(singleRow);
      }
      if (selected.isEmpty) {
        return;
      }
      final List<String> failed = [];
      for (final row in selected) {
        final qualifId = row.cells['action']!.value.id;
        final userId = row.cells['action']!.value.userId;
        final success = await dispatch<bool>(ApproveUserQualificationAction(
          userId: userId,
          userQualificationId: qualifId,
        ));
        if (success.isRight) {
          failed.add(row.cells['user']!.value);
        }
      }
      if (failed.isNotEmpty) {
        context.showError("Failed ${failed.join(", ")}");
      }
    });
  }
}
