import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/delete_user_contract_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/delete_user_review_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/post_user_details_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_pref_shift_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_qualif_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_reviews_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_status_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_visa_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/data/data_source.dart';
import 'package:mca_dashboard/presentation/pages/users_view/data/user_data_source.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/dialogs/payroll_popup.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/dialogs/visa_popup.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/general_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/mobile_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/payroll_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/preferred_shift_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/qualification_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/reviews_tab.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/tabs/visa_tab.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'qualif_popup.dart';
import 'review_popup.dart';
import 'shift_popup.dart';

class NewUserPopup extends StatelessWidget {
  final UserMd? user;
  final int? initialTabIndex;

  const NewUserPopup({super.key, this.user, this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    return _UserTabsWidget(user: user, initialTabIndex: initialTabIndex);
  }
}

class _UserInfoWidget extends StatelessWidget {
  final UserMd user;

  const _UserInfoWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 64.0,
            children: [
              _buildIconItem(
                context,
                icon: Icons.person,
                title: "Name",
                subtitle: user.fullname,
              ),
              _buildIconItem(
                context,
                icon: Icons.phone,
                title: "Phone Number",
                subtitle: "-",
              ),
              _buildIconItem(
                context,
                icon: Icons.mail,
                title: "Email",
                subtitle: "-",
              ),
            ]),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return SpacedRow(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 16.0,
        children: [
          Icon(icon, size: 32.0, color: Theme.of(context).primaryColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        ]);
  }
}

class _UserTabsWidget extends StatefulWidget {
  final UserMd? user;
  final int? initialTabIndex;

  const _UserTabsWidget({super.key, this.user, this.initialTabIndex});

  @override
  State<_UserTabsWidget> createState() => _UserTabsWidgetState();
}

class _UserTabsWidgetState extends State<_UserTabsWidget>
    with SingleTickerProviderStateMixin {
  final DependencyManager deps = DependencyManager.instance;

  UserMd? get user => widget.user;

  late UserDataSource detailDataSource;

  late final TabController _tabController;
  final List<Tab> tabs = [
    const Tab(text: "General"),
    const Tab(text: "Payroll"),
    const Tab(text: "Reviews"),
    const Tab(text: "Visa, Work Permits"),
    const Tab(text: "Preferred Shifts"),
    const Tab(text: "Qualifications"),
    const Tab(text: "Mobile and Status"),
  ];

  late final bool isCreate;

  @override
  void initState() {
    detailDataSource = UserDataSource.init();
    isCreate = widget.user == null;
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.index = widget.initialTabIndex ?? 0;
    _tabController.addListener(() {
      updateUI();
    });
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          //fetch user details if !isCreate
          if (!isCreate) {
            await fetchAndRefreshUserDetails();
          }
        }
      },
    );
  }

  Future<void> fetchAndRefreshUserDetails() async {
    await context.futureLoading(() async {
      final success =
          await dispatch<UserDataSource>(GetUserDetailsAction(widget.user!.id));
      if (success.isLeft) {
        detailDataSource = success.left.copyWith(
            personal: success.left.personal.copyWith(id: widget.user!.id));
        detailDataSource.personal.username.text = widget.user!.username;

        updateUI();
      } else {
        context.showError(success.right.message);
      }
    });
  }

  AppState get appState => StoreProvider.of<AppState>(context).state;

  @override
  void dispose() {
    detailDataSource.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      title: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 8,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: context.pop,
          ),
          Text(isCreate ? "Create User" : "Edit User"),
        ],
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      insetPadding: const EdgeInsets.all(4),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
            appBar: isCreate
                ? null
                : AppBar(
                    toolbarHeight: 60,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    titleSpacing: 0.0,
                    title: widget.user != null
                        ? _UserInfoWidget(user: widget.user!)
                        : null,
                    bottom: TabBar(
                      tabs: tabs,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.grey[500],
                    ),
                  ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                UserGeneralTab(
                  data: detailDataSource,
                  onChanged: (value) {
                    detailDataSource = value;
                    updateUI();
                  },
                ),
                UserPayrollTab(
                  onLoaded: onPayrollLoaded,
                  rows: payrollGridManager != null
                      ? payrollGridManager!.rows
                      : [],
                  onEdit: onPayrollEdit,
                  onDelete: onPayrollDelete,
                ),
                UserReviewsTab(
                  rows: reviewsGridLoaded ? reviewsGridStateManager.rows : [],
                  onLoaded: onReviewsGridLoaded,
                  onDelete: onDeleteReview,
                  onEdit: onEditReview,
                  user: widget.user ?? UserMd.init(),
                ),
                UserVisaTab(
                  onLoaded: onVisaLoaded,
                  onDelete: onVisaDelete,
                  onEdit: onVisaEdit,
                  rows: visaGridManager != null ? visaGridManager!.rows : [],
                ),
                UserPreferredShiftsTab(
                  onLoaded: onShiftLoaded,
                  onDelete: onShiftDelete,
                  onEdit: onShiftEdit,
                  rows: shiftGridManager != null ? shiftGridManager!.rows : [],
                ),
                UserQualificationTab(
                  onCertificatePressed: onCertificatePressed,
                  onLoaded: onQualificationLoaded,
                  onDelete: onQualificationDelete,
                  onEdit: onQualificationEdit,
                  rows: qualificationGridManager != null
                      ? qualificationGridManager!.rows
                      : [],
                ),
                UserMobileTab(user: user ?? UserMd.init()),
              ],
            )),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      actions: _tabController.index != 0
          ? null
          : [
              ElevatedButton(
                  onPressed: context.pop, child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    if (!detailDataSource.isValid(context, isCreate)) return;
                    await context.futureLoading(() async {
                      final res = await dispatch<bool>(
                          PostUserDetailsAction(dataSource: detailDataSource));
                      if (res.isRight) {
                        context.showError(res.right.message);
                      } else {
                        context.pop(true);
                      }
                    });
                  },
                  child: const Text("Save")),
            ],
    );
  }

  ///Review
  late PlutoGridStateManager reviewsGridStateManager;
  bool reviewsGridLoaded = false;

  void onReviewsGridLoaded(PlutoGridOnLoadedEvent event) async {
    reviewsGridStateManager = event.stateManager;
    reviewsGridLoaded = true;
    if (reviewsGridLoaded) {
      await fetchAndRefreshReviews();
    }
  }

  void onEditReview(UserReviewMd? review) async {
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ReviewPopup(review: review, user: widget.user!);
      },
    );
    if (res == true) await fetchAndRefreshReviews();
  }

  void onDeleteReview(UserReviewMd? review) async {
    if (review != null) {
      context.futureLoading(() async {
        final deleted = await dispatch<bool>(
            GetDeleteUserReviewAction(widget.user!.id, review.id));
        if (deleted.isLeft) {
          reviewsGridStateManager.removeRows([
            reviewsGridStateManager.rows.firstWhere(
                (element) => element.cells["action"]!.value.id == review.id)
          ]);
        } else {
          context.showError("Failed to delete");
        }
      });
      return;
    }
    if (reviewsGridStateManager.checkedRows.isEmpty) return;
    List<UserReviewMd> deleteFailed = [];
    List<PlutoRow> deleteSuccess = [];
    await context.futureLoading(() async {
      for (final item in reviewsGridStateManager.checkedRows) {
        final c = item.cells["action"]!.value as UserReviewMd;
        final deleted = await dispatch<bool>(
            GetDeleteUserReviewAction(widget.user!.id, c.id));
        if (deleted.isLeft) {
          deleteSuccess.add(item);
        }
        if (deleted.isRight) {
          deleteFailed.add(c);
        }
      }
    });
    if (deleteFailed.isNotEmpty) {
      context.showError(
          "Failed to delete, ${deleteFailed.map((e) => e.title).join(", ")}");
    }
    if (deleteSuccess.isNotEmpty) {
      reviewsGridStateManager.removeRows(deleteSuccess);
    }
  }

  Future<void> fetchAndRefreshReviews() async {
    deps.navigation.showLoading();
    final list = await dispatch<List<UserReviewMd>>(
        GetUserReviewsAction(widget.user!.id));
    if (list.isLeft) {
      reviewsGridStateManager.removeAllRows();
      reviewsGridStateManager.appendRows(list.left
          .map((e) => PlutoRow(cells: {
                "conducted_by": PlutoCell(value: e.conducted_by),
                "date": PlutoCell(value: e.date),
                "title": PlutoCell(value: e.title),
                "comment": PlutoCell(value: e.notes),
                "action": PlutoCell(value: e),
              }))
          .toList());
    } else {
      deps.navigation.showFail("Failed to load reviews");
    }
    deps.navigation.closeLoading();
  }

  ///PAYROLL
  PlutoGridStateManager? payrollGridManager;

  Future<void> onPayrollLoaded(PlutoGridOnLoadedEvent event) async {
    payrollGridManager = event.stateManager;
    if (payrollGridManager != null) {
      await fetchAndRefreshPayrolls();
    }
  }

  Future<void> fetchAndRefreshPayrolls() async {
    deps.navigation.showLoading();
    final success =
        await dispatch<List<UserContractMd>>(GetUserContractsAction(user!.id));
    if (success.isLeft) {
      payrollGridManager!.removeAllRows();
      payrollGridManager!.appendRows(success.left
          .map((model) => PlutoRow(cells: {
                "csd": PlutoCell(value: model.csd),
                "ced": PlutoCell(value: model.ced),
                "contract_type": PlutoCell(
                    value: model
                        .contractTypeMd(
                            appState.generalState.lists.contractTypes)
                        ?.name),
                "hct": PlutoCell(
                    value: model
                        .hctMd(
                            appState.generalState.lists.holidayCalculationTypes)
                        ?.name),
                "awh": PlutoCell(value: model.awh),
                "wd": PlutoCell(value: model.wdpw),
                "ahe": PlutoCell(value: model.ahew),
                "edit": PlutoCell(value: model),
              }))
          .toList());
    } else {
      context.showError("Failed to load contracts");
    }

    deps.navigation.closeLoading();
  }

  void onPayrollEdit(UserContractMd? contract) async {
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return PayrollPopup(contract: contract, userId: widget.user!.id);
      },
    );
    if (res == true) await fetchAndRefreshPayrolls();
  }

  void onPayrollDelete() async {
    if (payrollGridManager!.checkedRows.isEmpty) return;
    List<UserContractMd> deleteFailed = [];
    List<PlutoRow> deleteSuccess = [];
    await context.futureLoading(() async {
      for (final item in payrollGridManager!.checkedRows) {
        final c = item.cells["edit"]!.value;
        final deleted = await dispatch<bool>(
            DeleteUserContractAction(widget.user!.id, c.id));
        if (deleted.isLeft) {
          deleteSuccess.add(item);
        }
        if (deleted.isRight) {
          deleteFailed.add(c);
        }
      }
    });
    if (deleteFailed.isNotEmpty) {
      context.showError(
          "Failed to delete, ${deleteFailed.map((e) => e.dateDt?.toApiDateWithDash).join(", ")}");
    }
    if (deleteSuccess.isNotEmpty) {
      payrollGridManager!.removeRows(deleteSuccess);
    }
  }

  ///VISA
  PlutoGridStateManager? visaGridManager;

  Future<void> onVisaLoaded(PlutoGridOnLoadedEvent event) async {
    visaGridManager = event.stateManager;
    if (visaGridManager != null) {
      await fetchAndRefreshVisas();
    }
  }

  Future<void> fetchAndRefreshVisas() async {
    deps.navigation.showLoading();
    final success =
        await dispatch<List<UserVisaMd>>(GetUserVisasAction(user!.id));
    if (success.isLeft) {
      visaGridManager!.removeAllRows();
      visaGridManager!.appendRows(success.left
          .map((model) => PlutoRow(cells: {
                "document_number": PlutoCell(value: model.documentNumber),
                "type": PlutoCell(
                    value: model
                        .visaTypeMd(appState.generalState.lists.visas)
                        ?.name),
                "valid_from": PlutoCell(value: model.startDate),
                "valid_to": PlutoCell(value: model.endDate),
                "comment": PlutoCell(value: model.notes),
                "edit": PlutoCell(value: model),
              }))
          .toList());
    } else {
      context.showError("Failed to load visas");
    }

    deps.navigation.closeLoading();
  }

  void onVisaEdit(UserVisaMd? visa) async {
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return VisaPopup(user: user!, item: visa);
      },
    );
    if (res == true) await fetchAndRefreshVisas();
  }

  void onVisaDelete() async {
    if (visaGridManager!.checkedRows.isEmpty) return;
    List<UserVisaMd> deleteFailed = [];
    List<PlutoRow> deleteSuccess = [];
    await context.futureLoading(() async {
      for (final item in visaGridManager!.checkedRows) {
        final c = item.cells["edit"]!.value;
        final deleted =
            await dispatch<bool>(DeleteUserVisaAction(widget.user!.id, c.id));
        if (deleted.isLeft) {
          deleteSuccess.add(item);
        }
        if (deleted.isRight) {
          deleteFailed.add(c);
        }
      }
    });
    if (deleteFailed.isNotEmpty) {
      context.showError(
          "Failed to delete, ${deleteFailed.map((e) => e.title).join(", ")}");
    }
    if (deleteSuccess.isNotEmpty) {
      visaGridManager!.removeRows(deleteSuccess);
    }
  }

  ///PREFERRED SHIFT
  PlutoGridStateManager? shiftGridManager;

  Future<void> onShiftLoaded(PlutoGridOnLoadedEvent event) async {
    shiftGridManager = event.stateManager;
    shiftGridManager!
        .setRowGroup(PlutoRowGroupByColumnDelegate(showCount: false, columns: [
      shiftGridManager!.columns[0],
      shiftGridManager!.columns[1],
    ]));
    if (shiftGridManager != null) {
      await fetchAndRefreshShifts();
    }
  }

  Future<void> fetchAndRefreshShifts() async {
    deps.navigation.showLoading();
    final success = await dispatch<List<UserPreferredShiftMd>>(
        GetUserPrefShiftsAction(user!.id));
    if (success.isLeft) {
      shiftGridManager!.removeAllRows();
      shiftGridManager!.appendRows(success.left
          .map((model) => PlutoRow(cells: {
                "weekId": PlutoCell(value: model.weekId),
                "dayId": PlutoCell(value: model.dayId),
                "location": PlutoCell(value: model.location),
                "shift": PlutoCell(value: model.title),
                "timing": PlutoCell(
                    value:
                        "${model.startDate?.toApiTime} - ${model.finishDate?.toApiTime}"),
                "delete": PlutoCell(value: model),
              }))
          .toList());
    } else {
      context.showError("Failed to load shifts");
    }

    deps.navigation.closeLoading();
  }

  void onShiftEdit(UserPreferredShiftMd? shift) async {
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ShiftPopup(user: user!, item: shift);
      },
    );
    if (res == true) await fetchAndRefreshShifts();
  }

  void onShiftDelete(UserPreferredShiftMd? item) async {
    if (item == null) return;
    await context.futureLoading(() async {
      final deleted = await dispatch<bool>(
          DeleteUserPrefShiftsAction(widget.user!.id, item.id));
      if (deleted.isLeft) {
        shiftGridManager!.removeRows(shiftGridManager!.refRows.where((element) {
          final c = element.cells["delete"]?.value;
          return c?.id == item.id;
        }).toList());
      }
      if (deleted.isRight) {
        context.showError("Failed to delete shift ${item.title}");
      }
    });
  }

  ///QUALIFICATION
  PlutoGridStateManager? qualificationGridManager;

  Future<void> onQualificationLoaded(PlutoGridOnLoadedEvent event) async {
    qualificationGridManager = event.stateManager;
    if (qualificationGridManager != null) {
      await fetchAndRefreshQualifications();
    }
  }

  Future<void> fetchAndRefreshQualifications() async {
    deps.navigation.showLoading();
    final success = await dispatch<List<UserQualificationMd>>(
        GetUserQualifAction(user!.id));
    if (success.isLeft) {
      qualificationGridManager!.removeAllRows();
      qualificationGridManager!.appendRows(success.left
          .map((model) => PlutoRow(cells: {
                "qualification": PlutoCell(value: model.title),
                "level": PlutoCell(value: model.level),
                "certificate": PlutoCell(value: model),
                "certification_number":
                    PlutoCell(value: model.certificateNumber),
                "achievement_date": PlutoCell(value: model.achievementDate),
                "expiry_date": PlutoCell(value: model.expiryDate),
                "comment": PlutoCell(value: model.comments),
                "action": PlutoCell(value: model),
              }))
          .toList());
    } else {
      context.showError("Failed to load qualifications");
    }

    deps.navigation.closeLoading();
  }

  void onQualificationEdit(UserQualificationMd? qualification) async {
    final res =
        await DependencyManager.instance.navigation.showCustomDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return QualifPopup(user: user!, item: qualification);
      },
    );
    if (res == true) await fetchAndRefreshQualifications();
  }

  void onQualificationDelete(UserQualificationMd? item) async {
    if (item != null) {
      final rowToBeChecked = qualificationGridManager!.rows.where((element) {
        final c = element.cells["action"]?.value;
        return c?.id == item.id;
      }).toList();
      qualificationGridManager!.setRowChecked(rowToBeChecked.first, true);
    }
    if (qualificationGridManager!.checkedRows.isEmpty) return;
    List<UserQualificationMd> deleteFailed = [];
    List<PlutoRow> deleteSuccess = [];
    await context.futureLoading(() async {
      for (final item in qualificationGridManager!.checkedRows) {
        final c = item.cells["action"]!.value;
        final deleted = await dispatch<bool>(DeleteUserQualifAction(
            userId: widget.user!.id, userQualifId: c.uqId));
        if (deleted.isLeft) {
          deleteSuccess.add(item);
        }
        if (deleted.isRight) {
          deleteFailed.add(c);
        }
      }
    });
    if (deleteFailed.isNotEmpty) {
      //unchecked all
      context.showError(
          "Failed to delete, ${deleteFailed.map((e) => e.title).join(", ")}");
    }
    if (deleteSuccess.isNotEmpty) {
      qualificationGridManager!.removeRows(deleteSuccess);
    }
  }

  void onCertificatePressed(UserQualificationMd item) {
    if (item.certificate.isEmpty) return;
    DependencyManager.instance.navigation.showCustomDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              children: [
                const Text("Certificate"),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            children: [
              Center(
                child: Image.memory(
                  item.certificateBytes,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text("Failed to load image");
                  },
                ),
              )
            ],
          );
        });
  }

  ///MOBILE AND STATUS
  // UserStatusMd? userStatus;
  // bool mobileRegistered = false;
  // Future<void> fetchUserStatus() async {
  //   final success =
  //       await dispatch<UserStatusMd>(GetUserStatusAction(userId: user!.id));
  //   if (success.isLeft) {
  //     userStatus = success.left;
  //     setState(() {});
  //   }
  // }
  //
  // Future<void> fetchUserMobile() async {
  //   final success = await dispatch<bool>(GetUserMobileAction(userId: user!.id));
  //   if (success.isLeft) {
  //     mobileRegistered = success.left;
  //     setState(() {});
  //   }
  // }
}
