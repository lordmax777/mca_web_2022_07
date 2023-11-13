import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/manager.dart';

class PageTitle extends StatelessWidget {
  PageTitle({super.key});

  final deps = DependencyManager.instance;

  @override
  Widget build(BuildContext context) {
    String title = deps.navigation.router.location.substring(1);
    if (title == MCANavigation.properties.substring(1)) {
      title = appStore.state.generalState.propertyName;
    }
    String t = title[0].toUpperCase() + title.substring(1);
    //separate words by capital letters
    t = t.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match[0]}');
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: 56,
      width: double.infinity,
      child: Text(t, style: Theme.of(context).textTheme.headlineLarge),
    );
  }
}
