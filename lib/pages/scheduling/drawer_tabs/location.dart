// import 'package:collection/collection.dart';
// import 'package:mca_web_2022_07/pages/scheduling/schdule_appointment_drawer.dart';
// import 'package:mca_web_2022_07/theme/theme.dart';
// import 'package:mca_web_2022_07/utils/global_functions.dart';
// import '../../../manager/models/property_md.dart';
// import '../../../manager/models/users_list.dart';
// import '../../../manager/redux/sets/app_state.dart';
// import '../../../manager/redux/states/schedule_state.dart';
//
// class ScheduleLocationTab extends StatefulWidget {
//   final AppState state;
//   final void Function(int locId) onPropertySelected;
//   final void Function(int userId) onUserSelected;
//   final List<CustomProperty> selectedProperties;
//   final bool isAppSelected;
//   final List<PropertiesMd> allProperties;
//   final List<UserRes> allUsers;
//   const ScheduleLocationTab({
//     Key? key,
//     required this.state,
//     required this.onPropertySelected,
//     required this.onUserSelected,
//     required this.selectedProperties,
//     required this.allProperties,
//     required this.allUsers,
//     required this.isAppSelected,
//   }) : super(key: key);
//
//   @override
//   State<ScheduleLocationTab> createState() => _ScheduleLocationTabState();
// }
//
// class _ScheduleLocationTabState extends State<ScheduleLocationTab> {
//   final TextEditingController _searchController = TextEditingController();
//
//   AppState get state => widget.state;
//
//   ScheduleState get scheduleState => widget.state.scheduleState;
//
//   List<UserRes> get allUsers => widget.allUsers;
//
//   List<PropertiesMd> get allProperties => widget.allProperties;
//
//   bool get isUserView => scheduleState.sidebarType == SidebarType.user;
//
//   final List<PropertiesMd> filteredLocations = [];
//
//   final List<UserRes> filteredUsers = [];
//
//   bool filterNotFound = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _onSearch();
//   }
//
//   void _onSearch() {
//     _searchController.addListener(() {
//       setState(() {
//         if (_searchController.text.isNotEmpty) {
//           if (isUserView) {
//             filteredLocations.clear();
//             filteredLocations.addAll(allProperties.where((element) {
//               return element.title!
//                   .toLowerCase()
//                   .contains((_searchController.text.toLowerCase()));
//             }).toList());
//             if (filteredLocations.isEmpty) {
//               filteredLocations.addAll(allProperties.where((element) {
//                 return element.locationName!
//                     .toLowerCase()
//                     .contains((_searchController.text.toLowerCase()));
//               }).toList());
//             }
//             if (filteredLocations.isNotEmpty) {
//               filterNotFound = false;
//             }
//           } else {
//             filteredUsers.clear();
//             filteredUsers.addAll(allUsers.where((element) {
//               return element.fullname
//                   .toLowerCase()
//                   .contains((_searchController.text.toLowerCase()));
//             }).toList());
//             if (filteredUsers.isNotEmpty) {
//               filterNotFound = false;
//             }
//           }
//         } else {
//           setState(() {
//             filteredLocations.clear();
//             filteredUsers.clear();
//             filterNotFound = true;
//           });
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final locs = <PropertiesMd>[];
//     final usrs = <UserRes>[];
//     locs.addAll(filteredLocations);
//     usrs.addAll(filteredUsers);
//     if (filterNotFound) {
//       locs.addAll(allProperties);
//       usrs.addAll(allUsers);
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: SpacedColumn(children: [
//         TextInputWidget(
//             width: double.infinity,
//             controller: _searchController,
//             defaultBorderColor: ThemeColors.gray11,
//             hintText: isUserView
//                 ? "Search by location or ${Constants.propertyName.capitalize} ..."
//                 : "Search by user name ...",
//             leftIcon: HeroIcons.search),
//         const SizedBox(height: 16),
//         if (isUserView)
//           SizedBox(
//             height: MediaQuery.of(context).size.height * (0.59),
//             child: ListView.builder(
//               itemBuilder: (context, index) =>
//                   _itemBuilder(context, index, locs: locs),
//               itemCount: locs.length,
//             ),
//           ),
//         if (!isUserView)
//           SizedBox(
//             height: MediaQuery.of(context).size.height * (0.59),
//             child: ListView.builder(
//               itemBuilder: (context, index) =>
//                   _itemBuilder(context, index, usrs: usrs),
//               itemCount: usrs.length,
//             ),
//           ),
//       ]),
//     );
//   }
//
//   Widget _itemBuilder(BuildContext context, int index,
//       {List<PropertiesMd>? locs, List<UserRes>? usrs}) {
//     if (locs != null) {
//       final property = locs[index];
//       final bool isSelected = widget.selectedProperties
//           .any((element) => element.propertyId == property.id);
//
//       void onTap() {
//         widget.onPropertySelected(property.id!);
//         setState(() {});
//       }
//
//       return ListTile(
//         hoverColor: ThemeColors.gray11,
//         leading: CustomCheckboxWidget(
//           onChanged: (value) {
//             onTap();
//           },
//           isChecked: isSelected,
//         ),
//         title: SpacedRow(
//           horizontalSpace: 8,
//           children: [
//             const CircleAvatar(
//               backgroundColor: ThemeColors.blue7,
//               maxRadius: 18.0,
//               child: HeroIcon(
//                 HeroIcons.pin,
//                 size: 18.0,
//                 color: ThemeColors.white,
//               ),
//             ),
//             SizedBox(
//                 width: 350,
//                 child: Text(
//                     "${property.title ?? ""} - ${property.locationName ?? ""}")),
//           ],
//         ),
//         onTap: onTap,
//       );
//     } else {
//       final user = usrs![index];
//       final bool isSelected =
//           widget.selectedProperties.any((element) => element.userId == user.id);
//
//       void onTap() {
//         widget.onUserSelected(user.id);
//         setState(() {});
//       }
//
//       return ListTile(
//         hoverColor: ThemeColors.gray11,
//         leading: CustomCheckboxWidget(
//           onChanged: (value) {
//             onTap();
//           },
//           isChecked: isSelected,
//         ),
//         title: SpacedRow(
//           horizontalSpace: 8,
//           children: [
//             CircleAvatar(
//               backgroundColor: user.userRandomBgColor,
//               maxRadius: 18.0,
//               child: KText(
//                 fontSize: 14.0,
//                 isSelectable: false,
//                 fontWeight: FWeight.bold,
//                 textColor: user.foregroundColor,
//                 text:
//                     "${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}"
//                         .toUpperCase(),
//               ),
//             ),
//             SizedBox(
//                 width: 350, child: Text("${user.firstName} ${user.lastName}")),
//           ],
//         ),
//         onTap: onTap,
//       );
//     }
//   }
// }
