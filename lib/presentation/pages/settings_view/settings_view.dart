import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/availability_tab.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/change_password_tab.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/color_tab.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/holidays_tab.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/tabs/login_status_tab.dart';

import 'tabs/company_tab.dart';
import 'tabs/shift_tab.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final List<TabChild> tabs = [
    const TabChild(tabName: "Company Settings", child: CompanyTab()),
    const TabChild(tabName: "Account Availability", child: AvailabilityTab()),
    const TabChild(tabName: "Account Password", child: ChangePasswordTab()),
    const TabChild(tabName: "Login and Status", child: LoginStatusTab()),
    const TabChild(tabName: "Holidays and Sick", child: HolidaysTab()),
    const TabChild(tabName: "Shift", child: ShiftTab()),
    const TabChild(tabName: "Color Theme", child: ColorTab()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabWrapper(children: tabs);
  }
}
