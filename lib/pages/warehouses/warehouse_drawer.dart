import 'package:auto_route/auto_route.dart';
import '../../manager/models/warehouse_md.dart';
import '../../theme/theme.dart';

class WarehouseDrawer extends StatefulWidget {
  final WarehouseMd warehouse;
  const WarehouseDrawer({Key? key, required this.warehouse}) : super(key: key);

  @override
  State<WarehouseDrawer> createState() => _WarehouseDrawerState();
}

class _WarehouseDrawerState extends State<WarehouseDrawer> {
  List<PropertyMd> items = [];
  List<PropertyMd> backupItems = [];

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
      items.add(widget.warehouse.properties![i]);
    }
    backupItems.clear();
    backupItems.addAll(items);
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          items.clear();
          items.addAll(backupItems);
        });
      }
    });
    _onSearch();
  }

  void _onSearch() {
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          items.clear();
          items.addAll(backupItems.where((element) {
            return element.propertyName
                .toLowerCase()
                .contains((_searchController.text.toLowerCase()));
          }).toList());
        }
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
            SizedBox(
              width: 440,
              child: KText(
                isSelectable: false,
                text: widget.warehouse.name,
                fontSize: 18.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
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
        if (items.isEmpty)
          KText(
              text: "No property found",
              textColor: ThemeColors.gray5,
              fontSize: 14.0,
              fontWeight: FWeight.bold)
        else
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: double.infinity,
            child: ListView.builder(
                // separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: _itemBuilder,
                itemCount: items.length),
          ),
      ]),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final user = items[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const HeroIcon(
          //   HeroIcons.house,
          //   size: 24.0,
          //   color: ThemeColors.gray5,
          // ),
          CircleAvatar(
            backgroundColor: user.userRandomBgColor,
            maxRadius: 24.0,
            child: KText(
              fontSize: 16.0,
              isSelectable: false,
              textColor: ThemeColors.black,
              fontWeight: FWeight.bold,
              text: user.propertyName.substring(0, 2).toUpperCase(),
            ),
          ),
          const SizedBox(width: 16.0),
          KText(
            isSelectable: false,
            text: items[index].propertyName,
            fontSize: 16.0,
            textColor: ThemeColors.gray2,
          ),
        ],
      ),
    );
  }
}
