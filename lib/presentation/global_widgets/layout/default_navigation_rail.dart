import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../manager/manager.dart';

final List<Map<String, dynamic>> _destinations = [
  {
    'route': MCANavigation.dashboard,
    'title': 'Dashboard',
    'icon': Icons.dashboard,
  },
  //Administration
  {
    "group": "administration",
    "icon": Icons.admin_panel_settings,
    "children": [
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
        'title': 'specialWord',
        'icon': Icons.home_work,
      },
      {
        'route': MCANavigation.clients,
        'title': 'Clients',
        'icon': Icons.people,
      },
    ],
  },
  //Operational Tasks
  {
    "group": "tasks",
    "icon": Icons.task,
    "children": [
      {
        'route': MCANavigation.quotes,
        'title': 'Quotes',
        'icon': Icons.request_quote_rounded,
      },
      {
        'route': MCANavigation.scheduling,
        'title': 'Scheduling',
        'icon': Icons.schedule,
      },
      {
        'route': MCANavigation.timesheet,
        'title': 'Timesheet',
        'icon': Icons.timer,
      },
      {
        'route': MCANavigation.handoverTypes,
        'title': 'Handover Types',
        'icon': Icons.how_to_vote,
      },
      {
        'route': MCANavigation.approvals,
        'title': 'Approvals',
        'icon': Icons.approval,
      },
      {
        'route': MCANavigation.checklists,
        'title': 'Checklists',
        'icon': Icons.checklist,
      },
    ],
  },
  //Finance
  {
    "group": "finance",
    "icon": Icons.monetization_on,
    "children": [],
  },
  //Settings
  {
    "group": "Settings",
    "icon": Icons.settings,
    "children": [
      {
        'route': MCANavigation.settings,
        'title': 'Settings',
        'icon': Icons.settings,
      },
    ]
  },

  if (kDebugMode)
    {
      "group": "adminstration",
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
    return Drawer(
      width: 300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //top
          SizedBox(
            height: context.height * 0.9,
            child: ListView(
              children: [
                ..._destinations.map((e) {
                  return DestinationItem(e);
                }),
              ],
            ),
          ),

          //end
          // Expanded(
          //   child: Container(color: Colors.red),
          // ),
        ],
      ),
    );
    return Container(
      width: 180,
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
                  label: label(destination['title'].toString() == "specialWord"
                      ? appStore.state.generalState.propertyName
                      : destination['title'].toString())),
          ]),
    );
    return NavigationRail(
      selectedIndex: selectedIndex,
      extended: true,
      minExtendedWidth: 140,
      onDestinationSelected: (index) => onDestinationSelected(index, context),
      trailing: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {},
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
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
      width: 100,
      child: Text(
        label,
        maxLines: 2,
        softWrap: true,
      ),
    );
  }
}

class DestinationItem extends StatelessWidget {
  final Map<String, dynamic> destination;
  const DestinationItem(this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isExpandable = destination.containsKey('children');
    final location = DependencyManager.instance.navigation.router.location;
    bool isActive = false;
    if (isExpandable) {
      if (destination['children']
          .any((element) => element['route'] == location)) {
        isActive = true;
      }
    } else {
      isActive = destination['route'] == location;
    }
    if (isExpandable) {
      return ExpansionTile(
        leading: Icon(
          destination['icon'],
          color: isActive
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
        ),
        title: Text(
            (destination['group'] as String).replaceFirst(
                destination['group'][0], destination['group'][0].toUpperCase()),
            style: TextStyle(
                color: isActive
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface)),
        maintainState: true,
        expandedAlignment: Alignment.centerLeft,
        initiallyExpanded: isActive,
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        backgroundColor: Colors.grey.shade100,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in destination['children'])
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go(child['route']),
                    child: Text(
                        child['title'] == "specialWord"
                            ? appStore.state.generalState.propertyName
                                .replaceAll(
                                    appStore.state.generalState.propertyName[0],
                                    appStore.state.generalState.propertyName[0]
                                        .toUpperCase())
                            : child['title'],
                        style: TextStyle(
                            color: location == child['route']
                                // isActive
                                ? context.colorScheme.primary
                                : null)),
                  ),
                ),
                if (child != destination['children'].last)
                  const SizedBox(height: 16),
              ],
            )
        ],
      );
    }
    return ListTile(
      leading: Icon(destination['icon'],
          color: isActive
              ? context.colorScheme.primary
              : context.colorScheme.onSurface),
      title: Text(destination['title']),
      titleTextStyle: TextStyle(
          color: isActive
              ? context.colorScheme.primary
              : context.colorScheme.onSurface),
      onTap: () => context.go(destination['route']),
    );
  }
}
