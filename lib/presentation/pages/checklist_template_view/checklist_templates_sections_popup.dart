// import 'package:flutter/material.dart';
// import 'package:mca_dashboard/manager/data/data.dart';
// import 'package:mca_dashboard/presentation/global_widgets/default_text_field.dart';
//
// class ChecklistTemplatesSectionsAction extends StatefulWidget {
//   final ChecklistTemplateMd model;
//   const ChecklistTemplatesSectionsAction({super.key, required this.model});
//
//   @override
//   State<ChecklistTemplatesSectionsAction> createState() =>
//       _ChecklistTemplatesSectionsActionState();
// }
//
// class _ChecklistTemplatesSectionsActionState extends State<ChecklistTemplatesSectionsAction> {
//   final TextEditingController _searchController = TextEditingController();
//   //implement a filter function
//   List<ChecklistTemplateMd> _filterWarehouses(String search) {
//     if (search.isEmpty) {
//       return widget.model.contents;
//     }
//     final List<ChecklistTemplateMd> filteredList = [];
//     for (var model in widget.model.contents) {
//       if (model.propertyName.toLowerCase().contains(search.toLowerCase())) {
//         filteredList.add(model);
//       } else {
//         if (model.locationName
//             .toLowerCase()
//             .contains(search.toLowerCase())) {
//           filteredList.add(model);
//         }
//       }
//     }
//     return filteredList;
//   }
//
//   final List<WarehousePropertyMd> _properties = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _properties.addAll(widget.model.properties);
//     _searchController.addListener(() {
//       setState(() {
//         _properties.clear();
//         _properties.addAll(_filterWarehouses(_searchController.text));
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       insetPadding: const EdgeInsets.all(0),
//       contentPadding: const EdgeInsets.only(right: 16, bottom: 16, top: 16),
//       title: Text(widget.model.name),
//       alignment: Alignment.centerRight,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child:
//               DefaultTextField(controller: _searchController, label: "Search"),
//         ),
//         for (final property in _properties)
//           ListTile(
//               leading: const Icon(
//                 Icons.home_outlined,
//                 weight: 10,
//               ),
//               title: Text(property.propertyName),
//               subtitle: Text(property.locationName)),
//       ],
//     );
//   }
// }
