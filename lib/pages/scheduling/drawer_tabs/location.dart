import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/property_md.dart';
import '../../../manager/models/shift_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';

class ScheduleLocationTab extends StatefulWidget {
  final AppState state;
  final void Function(PropertiesMd) onLocationSelected;
  final void Function(UserRes) onUserSelected;
  final List<PropertiesMd> selectedLocations;
  final List<UserRes> selectedUsers;
  const ScheduleLocationTab({
    Key? key,
    required this.state,
    required this.onLocationSelected,
    required this.onUserSelected,
    required this.selectedLocations,
    required this.selectedUsers,
  }) : super(key: key);

  @override
  State<ScheduleLocationTab> createState() => _ScheduleLocationTabState();
}

class _ScheduleLocationTabState extends State<ScheduleLocationTab> {
  final TextEditingController _searchController = TextEditingController();

  AppState get state => widget.state;

  ScheduleState get scheduleState => widget.state.scheduleState;

  bool get isUserView => scheduleState.sidebarType == SidebarType.user;
  final List<PropertiesMd> filteredLocations = [];
  final List<UserRes> filteredUsers = [];
  bool filterNotFound = true;

  @override
  void initState() {
    super.initState();
    _onSearch();
  }

  void _onSearch() {
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          if (isUserView) {
            filteredLocations.clear();
            filteredLocations.addAll(locations.where((element) {
              return element.title!
                  .toLowerCase()
                  .contains((_searchController.text.toLowerCase()));
            }).toList());
            if (filteredLocations.isEmpty) {
              filteredLocations.addAll(locations.where((element) {
                return element.locationName!
                    .toLowerCase()
                    .contains((_searchController.text.toLowerCase()));
              }).toList());
            }
            if (filteredLocations.isNotEmpty) {
              filterNotFound = false;
            }
          } else {
            filteredUsers.clear();
            filteredUsers.addAll(users.where((element) {
              return element.fullname
                  .toLowerCase()
                  .contains((_searchController.text.toLowerCase()));
            }).toList());
            if (filteredUsers.isNotEmpty) {
              filterNotFound = false;
            }
          }
        } else {
          setState(() {
            filteredLocations.clear();
            filteredUsers.clear();
            filterNotFound = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PropertiesMd> get locations => state.generalState.properties.data ?? [];
  List<UserRes> get users => state.usersState.usersList.data ?? [];

  @override
  Widget build(BuildContext context) {
    final locs = <PropertiesMd>[];
    final usrs = <UserRes>[];
    locs.addAll(filteredLocations);
    usrs.addAll(filteredUsers);
    if (filterNotFound) {
      locs.addAll(locations);
      usrs.addAll(users);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SpacedColumn(children: [
        TextInputWidget(
            width: double.infinity,
            controller: _searchController,
            defaultBorderColor: ThemeColors.gray11,
            hintText: isUserView
                ? "Search by location or property ..."
                : "Search by user name ...",
            leftIcon: HeroIcons.search),
        const SizedBox(height: 16),
        if (isUserView)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.59,
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _itemBuilder(context, index, locs: locs),
              itemCount: locs.length,
            ),
          ),
        if (!isUserView)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.59,
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _itemBuilder(context, index, usrs: usrs),
              itemCount: usrs.length,
            ),
          ),
      ]),
    );
  }

  Widget _itemBuilder(BuildContext context, int index,
      {List<PropertiesMd>? locs, List<UserRes>? usrs}) {
    if (locs != null) {
      final location = locs[index];
      final bool isSelected = widget.selectedLocations.contains(location);

      void onTap() {
        widget.onLocationSelected(location);
        setState(() {});
      }

      return ListTile(
        hoverColor: ThemeColors.gray11,
        leading: CustomCheckboxWidget(
          onChanged: (value) {
            onTap();
          },
          isChecked: isSelected,
        ),
        title: SpacedRow(
          horizontalSpace: 8,
          children: [
            const HeroIcon(
              HeroIcons.pin,
              size: 24.0,
              color: ThemeColors.gray2,
            ),
            Text("${location.title ?? ""} - ${location.locationName ?? ""}"),
          ],
        ),
        onTap: onTap,
      );
    } else {
      final user = usrs![index];
      final bool isSelected = widget.selectedUsers.contains(user);

      void onTap() {
        widget.onUserSelected(user);
        setState(() {});
      }

      return ListTile(
        hoverColor: ThemeColors.gray11,
        leading: CustomCheckboxWidget(
          onChanged: (value) {
            onTap();
          },
          isChecked: isSelected,
        ),
        title: SpacedRow(
          horizontalSpace: 8,
          children: [
            const HeroIcon(
              HeroIcons.pin,
              size: 24.0,
              color: ThemeColors.gray2,
            ),
            Text("${user.firstName ?? ""} ${user.lastName ?? ""}"),
          ],
        ),
        onTap: onTap,
      );
    }
  }
}
