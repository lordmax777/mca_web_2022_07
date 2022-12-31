import '../../../manager/models/property_md.dart';
import '../../../theme/theme.dart';

class PropertyDaysTab extends StatefulWidget {
  final PropertiesMd property;

  const PropertyDaysTab(this.property, {Key? key}) : super(key: key);

  @override
  State<PropertyDaysTab> createState() => _PropertyDaysTabState();
}

class _PropertyDaysTabState extends State<PropertyDaysTab> {
  final Map<int, bool> days = <int, bool>{};

  @override
  void initState() {
    super.initState();
    _handleDaysTab();
  }

  void _handleDaysTab() {
    final property = widget.property;
    if (property.days != null) {
      if (property.days is List) {
        List<int> list = [...(property.days as List<dynamic>)];
        logger(list);
        if (list.isNotEmpty) {
          if (list.length == 1) {
            days[7] = true;
          } else if (list.length == 7) {
            for (int i = 1; i < 8; i++) {
              days[i] = true;
            }
          } else {
            days[1] = true;
            days[7] = true;
          }
        }
      } else if (property.days is Map) {
        for (MapEntry<String, dynamic> day in property.days.entries) {
          if (int.parse(day.key) == 0) {
            days[7] = true;
          } else if (int.parse(day.key) == 1) {
            days[1] = true;
          } else {
            days[int.parse(day.key)] = true;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 32.0),
      child: SpacedColumn(
        verticalSpace: 16.0,
        children: [
          for (var day in Constants.daysOfTheWeek.entries)
            _buildDay(day, days.containsKey(day.key)),
        ],
      ),
    );
  }

  Widget _buildDay(MapEntry<int, String> day, bool isActive) {
    return SpacedRow(
      horizontalSpace: 16.0,
      children: [
        HeroIcon(isActive ? HeroIcons.check : HeroIcons.x,
            color: isActive ? ThemeColors.green2 : ThemeColors.red3,
            size: 24.0),
        KText(
            text: day.value,
            fontSize: 16.0,
            fontWeight: FWeight.regular,
            textColor: ThemeColors.gray2),
      ],
    );
  }
}
