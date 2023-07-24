import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/availability_tab.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/change_password_tab.dart';

import 'tabs/company_tab.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final List<TabChild> tabs = [
    const TabChild(
      tabName: "Company",
      child: CompanyTab(),
    ),
    const TabChild(
      tabName: "Account Availability",
      child: AvailabilityTab(),
    ),
    const TabChild(
      tabName: "Change Password",
      child: ChangePasswordTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabWrapper(
      children: tabs,
    );
  }
}
