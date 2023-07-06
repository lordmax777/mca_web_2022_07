import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_text_field.dart';

class WarehousePropertiesPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  const WarehousePropertiesPopup({super.key, required this.warehouse});

  @override
  State<WarehousePropertiesPopup> createState() =>
      _WarehousePropertiesPopupState();
}

class _WarehousePropertiesPopupState extends State<WarehousePropertiesPopup> {
  final TextEditingController _searchController = TextEditingController();
  //implement a filter function
  List<WarehousePropertyMd> _filterWarehouses(String search) {
    if (search.isEmpty) {
      return widget.warehouse.properties;
    }
    final List<WarehousePropertyMd> filteredList = [];
    for (var warehouse in widget.warehouse.properties) {
      if (warehouse.propertyName.toLowerCase().contains(search.toLowerCase())) {
        filteredList.add(warehouse);
      } else {
        if (warehouse.locationName
            .toLowerCase()
            .contains(search.toLowerCase())) {
          filteredList.add(warehouse);
        }
      }
    }
    return filteredList;
  }

  final List<WarehousePropertyMd> _properties = [];

  @override
  void initState() {
    super.initState();
    _properties.addAll(widget.warehouse.properties);
    _searchController.addListener(() {
      setState(() {
        _properties.clear();
        _properties.addAll(_filterWarehouses(_searchController.text));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(right: 16, bottom: 16, top: 16),
      title: Text(widget.warehouse.name),
      alignment: Alignment.centerRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child:
              DefaultTextField(controller: _searchController, label: "Search"),
        ),
        for (final property in _properties)
          ListTile(
              leading: const Icon(
                Icons.home_outlined,
                weight: 10,
              ),
              title: Text(property.propertyName),
              subtitle: Text(property.locationName)),
      ],
    );
  }
}
