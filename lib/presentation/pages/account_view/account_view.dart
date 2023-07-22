import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_tab_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/account_view/tabs/availability_tab.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabWrapper(
      children: [
        TabChild(tabName: "Availability", child: AvailabilityTab()),
      ],
    );
  }
}
