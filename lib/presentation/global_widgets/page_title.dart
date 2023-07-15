import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';

class PageTitle extends StatelessWidget {
  PageTitle({super.key});

  final deps = DependencyManager.instance;

  @override
  Widget build(BuildContext context) {
    final title = deps.navigation.router.location.substring(1);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: 56,
      width: double.infinity,
      child: Text(title, style: Theme.of(context).textTheme.headlineLarge),
    );
  }
}
