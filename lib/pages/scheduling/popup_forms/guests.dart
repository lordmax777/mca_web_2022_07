import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:mca_web_2022_07/pages/scheduling/table_views/data_source.dart';

import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';
import '../models/job_model.dart';

class JobGuests extends StatelessWidget {
  final JobModel data;
  final VoidCallback? onMinSleepAddSuccess;
  final VoidCallback? onMinSleepRemoveSuccess;
  final VoidCallback? onMaxSleepAddSuccess;
  final VoidCallback? onMaxSleepRemoveSuccess;
  final ValueChanged<int?>? onCurrentAddSuccess;
  final ValueChanged<int?>? onCurrentRemoveSuccess;
  final bool isLiveMode;

  const JobGuests({
    Key? key,
    required this.data,
    this.isLiveMode = false,
    this.onMinSleepAddSuccess,
    this.onMinSleepRemoveSuccess,
    this.onMaxSleepAddSuccess,
    this.onMaxSleepRemoveSuccess,
    this.onCurrentAddSuccess,
    this.onCurrentRemoveSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _guests();
  }

  Widget _guests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWithField(
            labelWidth: 100,
            "Min Sleeps: ",
            null,
            customLabel: _moreLessButtonWidget(
                onLess: () async {
                  try {
                    PropertyDetailsMd pd = data.allocation!.propertyDetails;
                    bool success = false;
                    if (isLiveMode) {
                      ApiResponse res = await restClient()
                          .updatePropertyDetails(data.allocation!.shift.id,
                              bedrooms: pd.bedrooms,
                              bathrooms: pd.bathrooms,
                              min_sleeps: pd.minSleeps - 1,
                              max_sleeps: pd.maxSleeps,
                              notes: pd.notes)
                          .nocodeErrorHandler();
                      success = res.success;
                    } else {
                      success = true;
                    }
                    if (success) {
                      onMinSleepRemoveSuccess?.call();
                    }
                  } catch (e) {
                    showError(e.toString());
                  }
                },
                onMore: () async {
                  try {
                    PropertyDetailsMd pd = data.allocation!.propertyDetails;
                    bool success = false;
                    if (isLiveMode) {
                      ApiResponse res = await restClient()
                          .updatePropertyDetails(data.allocation!.shift.id,
                              bedrooms: pd.bedrooms,
                              bathrooms: pd.bathrooms,
                              min_sleeps: pd.minSleeps + 1,
                              max_sleeps: pd.maxSleeps,
                              notes: pd.notes)
                          .nocodeErrorHandler();
                      success = res.success;
                    } else {
                      success = true;
                    }
                    if (success) {
                      onMinSleepAddSuccess?.call();
                    }
                  } catch (e) {
                    showError(e.toString());
                  }
                },
                value: data.allocation?.propertyDetails.minSleeps ?? 0)),
        const Divider(),
        labelWithField(
            labelWidth: 100,
            "Max Sleeps: ",
            null,
            customLabel: _moreLessButtonWidget(
                onLess: () async {
                  try {
                    PropertyDetailsMd pd = data.allocation!.propertyDetails;
                    bool success = false;
                    if (isLiveMode) {
                      ApiResponse res = await restClient()
                          .updatePropertyDetails(data.allocation!.shift.id,
                              bedrooms: pd.bedrooms,
                              bathrooms: pd.bathrooms,
                              min_sleeps: pd.minSleeps,
                              max_sleeps: pd.maxSleeps - 1,
                              notes: pd.notes)
                          .nocodeErrorHandler();
                      success = res.success;
                    } else {
                      success = true;
                    }
                    if (success) {
                      onMaxSleepRemoveSuccess?.call();
                    }
                  } catch (e) {
                    showError(e.toString());
                  }
                },
                onMore: () async {
                  try {
                    PropertyDetailsMd pd = data.allocation!.propertyDetails;
                    bool success = false;
                    if (isLiveMode) {
                      ApiResponse res = await restClient()
                          .updatePropertyDetails(data.allocation!.shift.id,
                              bedrooms: pd.bedrooms,
                              bathrooms: pd.bathrooms,
                              min_sleeps: pd.minSleeps,
                              max_sleeps: pd.maxSleeps + 1,
                              notes: pd.notes)
                          .nocodeErrorHandler();
                      success = res.success;
                    } else {
                      success = true;
                    }
                    if (success) {
                      onMaxSleepAddSuccess?.call();
                    }
                  } catch (e) {
                    showError(e.toString());
                  }
                },
                value: data.allocation?.propertyDetails.maxSleeps ?? 0)),
        const Divider(),
        labelWithField(
            labelWidth: 100,
            "Current: ",
            null,
            customLabel: Row(
              children: [
                _moreLessButtonWidget(
                    value: (data.allocation?.guests ?? 0),
                    onLess: () async {
                      if (data.allocation!.guests - 1 <
                          data.allocation!.propertyDetails.minSleeps) {
                        return;
                      }
                      try {
                        if (isLiveMode) {
                          Map<String, dynamic> response =
                              await appStore.dispatch(SCShiftGuestAction(
                            date: data.timingInfo.date!,
                            shiftId: data.allocation!.shift.id,
                            locationId: data.allocation!.location.id,
                            action: AllocationActions.less,
                          ));
                          onCurrentRemoveSuccess
                              ?.call(response['current'].values.first);
                        } else {
                          onCurrentRemoveSuccess?.call(null);
                        }
                      } on ShiftUpdateException catch (e) {
                        showError(e.message);
                      } catch (e) {
                        showError(e.toString());
                      }
                    },
                    onMore: () async {
                      if (data.allocation!.guests + 1 >
                          data.allocation!.propertyDetails.maxSleeps) {
                        return;
                      }
                      try {
                        if (isLiveMode) {
                          Map<String, dynamic> response =
                              await appStore.dispatch(SCShiftGuestAction(
                            date: data.timingInfo.date!,
                            shiftId: data.allocation!.shift.id,
                            locationId: data.allocation!.location.id,
                            action: AllocationActions.more,
                          ));
                          onCurrentAddSuccess
                              ?.call(response['current'].values.first);
                        } else {
                          onCurrentAddSuccess?.call(null);
                        }
                      } on ShiftUpdateException catch (e) {
                        showError(e.message);
                      } catch (e) {
                        showError(e.toString());
                      }
                    }),
              ],
            )),
      ],
    );
  }

  Widget _moreLessButtonWidget(
      {VoidCallback? onMore, VoidCallback? onLess, required int value}) {
    return SpacedRow(
      horizontalSpace: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EasyButton(
            width: 30,
            height: 30,
            borderRadius: 8,
            idleStateWidget: const Icon(Icons.remove),
            loadingStateWidget: Transform.scale(
              scale: .6,
              child: const CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.white,
                  color: Colors.black),
            ),
            type: EasyButtonType.elevated,
            buttonColor: ThemeColors.MAIN_COLOR,
            onPressed: data.allocation == null ? null : onLess),
        SizedBox(width: 30, child: _textField(value.toString())),
        EasyButton(
          width: 30,
          height: 30,
          borderRadius: 8,
          idleStateWidget: const Icon(Icons.add),
          loadingStateWidget: Transform.scale(
            scale: .6,
            child: const CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.white,
                color: Colors.black),
          ),
          type: EasyButtonType.elevated,
          buttonColor: ThemeColors.MAIN_COLOR,
          onPressed: data.allocation == null ? null : onMore,
        ),
      ],
    );
  }

  Widget _textField(String? text, {VoidCallback? onTap}) {
    return Tooltip(
      message: onTap == null ? "" : "Edit",
      child: InkWell(
        onTap: onTap,
        child: Text(
          text == null ? "-" : (text.isEmpty ? "-" : text),
          textAlign: TextAlign.center,
          style: ThemeText.tabTextStyle.copyWith(
              color: onTap != null ? Colors.blueAccent : null,
              decoration: onTap != null ? TextDecoration.underline : null),
        ),
      ),
    );
  }
}
