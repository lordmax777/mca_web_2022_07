import '../../../manager/models/property_md.dart';
import '../../../theme/theme.dart';

class PropertyTimingsTab extends StatelessWidget {
  final PropertiesMd property;
  const PropertyTimingsTab(this.property, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(verticalSpace: 16.0, children: [
      _buildRegularTime(),
      const Divider(height: 1, color: ThemeColors.gray11),
      _buildMobileTime(),
    ]);
  }

  Widget _buildRegularTime() {
    String? startTime = property.startTime;
    String? endTime = property.finishTime;
    bool strictBreak = property.strictBreak ?? false;
    String? breakStartTime = property.startBreak;
    String? breakEndTime = property.finishBreak;

    return Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 32.0, bottom: 16.0),
        child: SpacedColumn(verticalSpace: 24.0, children: [
          if (startTime != null) _buildTime("Start Time:", startTime),
          if (endTime != null) _buildTime("Finish Time:", endTime),
          if (breakStartTime != null)
            _buildTime("Start Break:", breakStartTime),
          if (breakEndTime != null) _buildTime("Finish Break:", breakEndTime),
          SpacedRow(horizontalSpace: 16.0, children: [
            HeroIcon(strictBreak ? HeroIcons.check : HeroIcons.x,
                color: strictBreak ? ThemeColors.green2 : ThemeColors.red3,
                size: 24.0),
            KText(
                text: "Strict Break Time",
                fontSize: 16.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.regular)
          ])
        ]));
  }

  Widget _buildMobileTime() {
    String? startTime = property.fpStartTime;
    String? endTime = property.fpFinishTime;
    String? breakStartTime = property.fpStartBreak;
    String? breakEndTime = property.fpFinishBreak;
    return Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 32.0),
        child: SpacedColumn(verticalSpace: 24.0, children: [
          if (startTime != null) _buildTime("Mobile Start Time:", startTime),
          if (endTime != null) _buildTime("Mobile Finish Time:", endTime),
          if (breakStartTime != null)
            _buildTime("Mobile Start Break:", breakStartTime),
          if (breakEndTime != null)
            _buildTime("Mobile Finish Break:", breakEndTime),
        ]));
  }

  Widget _buildTime(String title, String time) {
    return SpacedRow(
      children: [
        SizedBox(
          width: 220,
          child: KText(
            text: title,
            fontSize: 16.0,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.bold,
          ),
        ),
        KText(
          text: time,
          fontSize: 16.0,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
        ),
      ],
    );
  }
}
