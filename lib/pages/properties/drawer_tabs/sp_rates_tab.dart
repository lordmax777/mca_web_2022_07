import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../../../comps/custom_get_builder.dart';
import '../../../theme/theme.dart';
import '../property_drawer.dart';

class PropertySpRatesTab extends StatelessWidget {
  final PropertiesMd property;
  const PropertySpRatesTab(this.property, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: 16.0,
      children: [
        _buildRegularTime(),
      ],
    );
  }

  Widget _buildRegularTime() {
    int? minWorkTime = property.minWorkTime;
    int? minPaidTime = property.minPaidTime;
    bool splitTime = property.splitTime ?? false;
    final List<ListSpecialRate> specialRates =
        appStore.state.generalState.paramList.data?.special_rates ?? [];
    final List<ListSpecialRate> specialRatesList = [];
    final int shiftId = property.id ?? -1;
    if (shiftId != -1) {
      for (var spRate in specialRates) {
        if (spRate.shift_id == shiftId) {
          specialRatesList.add(spRate);
        }
      }
      return Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, left: 32.0, bottom: 16.0),
              child: SpacedColumn(verticalSpace: 24.0, children: [
                if (minWorkTime != null)
                  _buildTime("Minimum Working Time:", "$minWorkTime minutes"),
                if (minPaidTime != null)
                  _buildTime("Paid Time:", "$minPaidTime minutes"),
                SpacedRow(horizontalSpace: 16.0, children: [
                  HeroIcon(splitTime ? HeroIcons.check : HeroIcons.x,
                      color: splitTime ? ThemeColors.green2 : ThemeColors.red3,
                      size: 24.0),
                  KText(
                      text: "Split Time",
                      fontSize: 16.0,
                      textColor: ThemeColors.gray2,
                      fontWeight: FWeight.regular)
                ]),
              ])),
          for (var rate in specialRatesList) _buildExpandedWidget(rate),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildExpandedWidget(ListSpecialRate rate) {
    return Column(
      children: [
        const Divider(height: 0, color: ThemeColors.gray11),
        ExpandableItemWidget(
            title: rate.name, child: _buildExpandedItemChild(rate)),
      ],
    );
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

  Widget _buildExpandedItemChild(ListSpecialRate rate) {
    final spRate = rate.rate.getPriceMap(2).formattedVer;
    final minWorkTime = rate.min_work_time;
    final paidTime = rate.paid_time;
    final splitTime = rate.split_time;

    return SpacedColumn(verticalSpace: 24.0, children: [
      _buildTime("Special Rate:", "$spRate"),
      if (minWorkTime != null)
        _buildTime("Minimum Working Time:", "$minWorkTime minutes"),
      if (paidTime != null) _buildTime("Paid Time:", "$paidTime minutes"),
      SpacedRow(horizontalSpace: 16.0, children: [
        HeroIcon(splitTime ? HeroIcons.check : HeroIcons.x,
            color: splitTime ? ThemeColors.green2 : ThemeColors.red3,
            size: 24.0),
        KText(
            text: "Split Time",
            fontSize: 16.0,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.regular)
      ]),
    ]);
  }
}
