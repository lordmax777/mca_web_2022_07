import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';

import '../../manager/models/warehouse_md.dart';
import '../../theme/theme.dart';

class WarehouseDrawer extends StatefulWidget {
  final WarehouseMd warehouse;
  const WarehouseDrawer({Key? key, required this.warehouse}) : super(key: key);

  @override
  State<WarehouseDrawer> createState() => _WarehouseDrawerState();
}

class _WarehouseDrawerState extends State<WarehouseDrawer> {
  List<Map> items = [];
  List<Map> backupItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final len = (widget.warehouse.properties?.length) ?? 0;
    for (int i = 0; i < len; i++) {
      final Map map = {
        "name": (widget.warehouse.properties?[i].propertyName) ?? "-",
      };
      items.add(map);
    }
    backupItems.clear();
    backupItems.addAll(items);
    _onSearch();
  }

  void _onSearch() {
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          items = backupItems.where((element) {
            return element['name']
                .toLowerCase()
                .contains(RegExp(_searchController.text.toLowerCase()));
          }).toList();
          return;
        }
        items.clear();
        items.addAll(backupItems);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 535,
      backgroundColor: ThemeColors.white,
      elevation: 0.8,
      child: SpacedColumn(
        children: [
          _header(),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: ThemeColors.gray11,
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KText(
              isSelectable: false,
              text: widget.warehouse.name,
              fontSize: 18.0,
              textColor: ThemeColors.gray2,
              fontWeight: FWeight.bold,
            ),
            InkWell(
                child: const HeroIcon(
                  HeroIcons.x,
                  size: 16.0,
                  color: ThemeColors.gray5,
                ),
                onTap: () {
                  context.popRoute();
                }),
          ]),
    );
  }

  Widget _body() {
    if (items.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KText(
            text: "No properties found!",
            fontSize: 24.0,
            textColor: ThemeColors.gray5,
            isSelectable: false,
            fontWeight: FWeight.bold,
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SpacedColumn(children: [
        TextInputWidget(
            hintText: "Search properties...",
            controller: _searchController,
            defaultBorderColor: ThemeColors.gray11,
            width: double.infinity,
            // onChanged: (value) => _onSearch(),
            leftIcon: HeroIcons.search),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 600,
          width: double.infinity,
          child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemBuilder: _itemBuilder,
              itemCount: items.length),
        ),
      ]),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.house,
            size: 24.0,
            color: ThemeColors.gray5,
          ),
          const SizedBox(width: 16.0),
          KText(
            isSelectable: false,
            text: items[index]['name'],
            fontSize: 16.0,
            textColor: ThemeColors.gray2,
          ),
        ],
      ),
    );
  }
}
