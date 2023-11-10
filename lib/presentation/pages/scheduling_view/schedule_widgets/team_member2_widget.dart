import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

class TeamMember2Widget extends StatefulWidget {
  final String userName;
  final TimeOfDay? specialStartTime;
  final TimeOfDay? specialFinishTime;
  final int? specialRateId;
  final ValueChanged<int?> onSpecialRateChanged;
  final ValueChanged<TimeOfDay?> onSpecialStartTimeChanged;
  final ValueChanged<TimeOfDay?> onSpecialFinishTimeChanged;
  final VoidCallback? onDeleted;
  const TeamMember2Widget({
    super.key,
    required this.userName,
    required this.onDeleted,
    this.specialStartTime,
    this.specialFinishTime,
    this.specialRateId,
    required this.onSpecialRateChanged,
    required this.onSpecialStartTimeChanged,
    required this.onSpecialFinishTimeChanged,
  });

  @override
  State<TeamMember2Widget> createState() => _TeamMember2WidgetState();
}

class _TeamMember2WidgetState extends State<TeamMember2Widget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1)),
      leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: widget.onDeleted,
          tooltip: "Remove",
          color: context.colorScheme.primary,
          icon: const Icon(Icons.close)),
      title: Row(
        children: [
          //Name
          SpacedRow(
            horizontalSpace: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100,
                  child: Text(
                    widget.userName,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SpacedColumn(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Special Start Time
                    // const SizedBox(width: 8),
                    Column(
                      children: [
                        const Text(
                          "Special Start Time",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () async {
                              final res = await showTimePicker(
                                  context: context,
                                  initialTime: widget.specialStartTime ??
                                      TimeOfDay.now());
                              if (res != null) {
                                widget.onSpecialStartTimeChanged(res);
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 14)),
                            child: Text(
                                widget.specialStartTime?.format(context) ??
                                    "Select",
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    // const SizedBox(width: 16),
                    Column(
                      children: [
                        const Text(
                          "Special Finish Time",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () async {
                              final res = await showTimePicker(
                                  context: context,
                                  initialTime: widget.specialFinishTime ??
                                      TimeOfDay.now());
                              if (res != null) {
                                widget.onSpecialFinishTimeChanged(res);
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 14)),
                            child: Text(
                                widget.specialFinishTime?.format(context) ??
                                    "Select",
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(
          //   width: 170,
          //   child: FormWithLabel(
          //     labelVm: const LabelModel(text: "Special Rate"),
          //     formBuilderField: StoreConnector<AppState, List<SpecialRateMd>>(
          //       converter: (store) =>
          //           store.state.generalState.lists.specialRates,
          //       builder: (context, vm) => FormDropdown(
          //         vm: DropdownModel(
          //             onChanged: (p0) =>
          //                 widget.onSpecialRateChanged(int.tryParse(p0 ?? "")),
          //             name: "specialRate${widget.userName}",
          //             hasSearchBox: true,
          //             initialValue: widget.specialRateId?.toString(),
          //             items: vm
          //                 .map((e) => DpItem(
          //                     id: e.id.toString(),
          //                     title: e.name,
          //                     subtitle: e.rate?.toString()))
          //                 .toList()),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
      isThreeLine: true,
      subtitle: StoreConnector<AppState, List<SpecialRateMd>>(
        converter: (store) => store.state.generalState.lists.specialRates,
        builder: (context, vm) => DefaultDropdown(
            onChanged: (p0) => widget.onSpecialRateChanged(p0.id),
            hasSearchBox: true,
            label: "Special Rate",
            width: double.infinity,
            valueId: widget.specialRateId,
            items: vm
                .map((e) => DefaultMenuItem(
                    id: e.id, title: e.name, subtitle: e.rate?.toString()))
                .toList()),
      ),

      //Special Price
      // trailing: DefaultTextField(
      //   label: "Special Price",
      //   controller: TextEditingController(
      //       text: widget.specialRate?.toStringAsFixed(2) ?? ""),
      //   keyboardType: TextInputType.number,
      //   width: 140,
      //   height: 40,
      //   onChanged: (value) {
      //     widget.onSpecialRateChanged(double.parse(value));
      //   },
      // ),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
    );
  }
}
