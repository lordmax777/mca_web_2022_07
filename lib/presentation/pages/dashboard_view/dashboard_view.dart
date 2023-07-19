import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/pages.dart';
import 'dashboard_view_vc.dart';

export 'dashboard_view_helper.dart';
export 'dashboard_view_vc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardViewVc vc = DashboardViewVc();

  final menuController = MenuController();

  DefaultMenuItem? item;

  // final place =
  //     FlutterGooglePlacesSdk("AIzaSyBD7ZbpM4T6JRYz2B-1NK3XEURGsCa9FWY");

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vc,
      builder: (context, child) => const Scaffold(
        body: Center(
          child: Column(
            children: [
              //Text
            ],
          ),
        ),
      ),
    );
  }
}
