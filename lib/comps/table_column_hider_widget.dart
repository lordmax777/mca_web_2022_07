import '../theme/theme.dart';

class ColumnHiderValues {
  String value;
  String label;
  bool isChecked;

  ColumnHiderValues(
      {required this.value, required this.label, this.isChecked = true});
}

class TableColumnHiderWidget extends StatelessWidget {
  final GlobalKey gKey;
  final List<ColumnHiderValues> columns;

  final ValueChanged<ColumnHiderValues> onChanged;
  const TableColumnHiderWidget(
      {required this.gKey, required this.columns, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: gKey,
      offset: const Offset(0.0, 50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      tooltip: "Show Columns",
      itemBuilder: (_) =>
          columns.map<PopupMenuItem>((e) => _buildItem(e)).toList(),
      onSelected: (dynamic val) {
        final ColumnHiderValues _v = columns.firstWhere((element) {
          if (val == element.value) {
            element.isChecked = !element.isChecked;
          }
          return val == element.value;
        });

        onChanged(_v);
      },
      child: ButtonMediumSecondary(
          leftIcon:
              const HeroIcon(HeroIcons.cog, color: ThemeColors.blue3, size: 20),
          text: "Columns",
          onPressed: () {
            dynamic state = gKey.currentState;
            state.showButtonMenu();
          }),
    );
  }

  PopupMenuItem _buildItem(ColumnHiderValues e) {
    return PopupMenuItem(
        value: e.value,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        height: 36.0,
        child: StatefulBuilder(builder: (context, setState) {
          return SpacedRow(
            horizontalSpace: 8.0,
            children: [
              ToggleCheckboxWidget(
                  value: e.isChecked,
                  width: 32.0,
                  height: 16.0,
                  toggleSize: 14.0,
                  padding: 1.0,
                  activeColor: ThemeColors.blue3,
                  inactiveColor: ThemeColors.gray11,
                  onToggle: (bool value) {
                    setState(() {
                      e.isChecked = value;
                    });
                    onChanged(e);
                  }),
              KText(
                text: e.label,
                isSelectable: false,
                fontSize: 14.0,
                fontWeight: FWeight.medium,
                textColor: ThemeColors.gray2,
              ),
            ],
          );
        }));
  }
}
