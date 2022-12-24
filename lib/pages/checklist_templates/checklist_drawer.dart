import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';

import '../../manager/redux/sets/state_value.dart';
import '../../theme/theme.dart';

class ChecklistDrawer extends StatefulWidget {
  final ChecklistTemplateMd checklist;
  const ChecklistDrawer({Key? key, required this.checklist}) : super(key: key);

  @override
  State<ChecklistDrawer> createState() => _ChecklistDrawerState();
}

class _ChecklistDrawerState extends State<ChecklistDrawer> {
  final List<CodeMap<List>> items = [];
  final List<CodeMap<List>> backupItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    items.clear();
    for (var user in widget.checklist.getRooms) {
      items.add(user);
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
            return element.name!
                .toLowerCase()
                .contains((_searchController.text.toLowerCase()));
          }).toList());
          if (items.isEmpty) {
            items.addAll(backupItems.where((element) {
              return element.code!
                  .join(",")
                  .toLowerCase()
                  .contains((_searchController.text.toLowerCase()));
            }).toList());
          }
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
                text: widget.checklist.name,
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
            hintText: "Search ...",
            controller: _searchController,
            defaultBorderColor: ThemeColors.gray11,
            width: double.infinity,
            onChanged: (value) => _onSearch(),
            leftIcon: HeroIcons.search),
        const SizedBox(height: 16.0),
        if (items.isEmpty)
          KText(
              text: "Nothing found",
              textColor: ThemeColors.gray5,
              fontSize: 14.0,
              fontWeight: FWeight.bold)
        else
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: double.infinity,
            child: ListView.builder(
                itemBuilder: _itemBuilder, itemCount: items.length),
          ),
      ]),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final user = items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SpacedColumn(
        verticalSpace: 4.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KText(
            maxLines: 2,
            isSelectable: false,
            text: user.name!,
            fontSize: 14.0,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.bold,
          ),
          KText(
            maxLines: 20,
            isSelectable: false,
            text: user.code!.isEmpty ? "-" : user.code!.join(", "),
            fontSize: 14.0,
            textColor: ThemeColors.black,
            fontWeight: FWeight.regular,
          ),
        ],
      ),
    );
  }
}
