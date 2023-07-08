import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../manager/manager.dart';

final List<Map<String, dynamic>> _destinations = [
  {
    'route': MCANavigation.dashboard,
    'title': 'Dashboard',
    'icon': Icons.dashboard,
  },
  {
    'route': MCANavigation.users,
    'title': 'Users',
    'icon': Icons.people,
  },
  {
    'route': MCANavigation.depsAndGroups,
    'title': 'Departments & Groups',
    'icon': Icons.home_work,
  },
  {
    'route': MCANavigation.qualifications,
    'title': 'Qualifications',
    'icon': Icons.badge,
  },
  {
    'route': MCANavigation.scheduling,
    'title': 'Scheduling',
    'icon': Icons.schedule,
  },
  {
    'route': MCANavigation.quotes,
    'title': 'Quotes',
    'icon': Icons.request_quote_rounded,
  },
  {
    'route': MCANavigation.warehouses,
    'title': 'Warehouses',
    'icon': Icons.home,
  },
  {
    'route': MCANavigation.storageItems,
    'title': 'Storage Items',
    'icon': Icons.storage,
  },
  {
    'route': MCANavigation.handoverTypes,
    'title': 'Handover Types',
    'icon': Icons.how_to_vote,
  },
  {
    'route': MCANavigation.locations,
    'title': 'Locations',
    'icon': Icons.location_on,
  },
  {
    'route': MCANavigation.checklistTemplates,
    'title': 'Checklist Templates',
    'icon': Icons.checklist,
  },
  {
    'route': MCANavigation.properties,
    'title': 'Properties',
    'icon': Icons.home_work,
  },
  {
    'route': MCANavigation.approvals,
    'title': 'Approvals',
    'icon': Icons.approval,
  },
  if (kDebugMode)
    {
      'route': MCANavigation.debug,
      'title': 'Debug',
      'icon': Icons.bug_report,
    },
];

class DefaultNavigationRail extends StatelessWidget {
  DefaultNavigationRail({super.key});

  final dependencies = DependencyManager.instance;

  int get selectedIndex {
    final route = dependencies.navigation.router.location;
    final int index =
        _destinations.indexWhere((element) => element['route'] == route);
    if (index.isNegative) return 0;
    return index;
  }

  void onDestinationSelected(int index, BuildContext context) {
    if (index == selectedIndex) return;
    final route = _destinations[index]['route'];
    context.go(route);
    dependencies.dioClient.defaultInterceptors.cancelRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: NavigationDrawer(
          indicatorColor: Theme.of(context).colorScheme.primary,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              onDestinationSelected(index, context),
          children: [
            for (final destination in _destinations)
              NavigationDrawerDestination(
                selectedIcon: Icon(destination['icon'],
                    color: Theme.of(context).colorScheme.onPrimary),
                icon: Icon(destination['icon']),
                label: label(destination['title'].toString()),
              ),
          ]),
    );
    return NavigationRail(
      selectedIndex: selectedIndex,
      extended: true,
      minExtendedWidth: 160,
      onDestinationSelected: (index) => onDestinationSelected(index, context),
      destinations: [
        for (final destination in _destinations)
          NavigationRailDestination(
            icon: Icon(destination['icon']),
            label: label(destination['title'].toString()),
          ),
      ],
    );
  }

  Widget label(String label) {
    return SizedBox(
      width: 120,
      child: Text(
        label,
        maxLines: 2,
        softWrap: true,
      ),
    );
  }
}
