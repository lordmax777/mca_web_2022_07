import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

class TeamMemberWidget extends StatefulWidget {
  final String name;
  final TimeOfDay? specialStartTime;
  final double? specialRate;
  final ValueChanged<double> onSpecialRateChanged;
  final ValueChanged<TimeOfDay?> onSpecialStartTimeChanged;
  final VoidCallback? onDeleted;
  const TeamMemberWidget({
    super.key,
    required this.name,
    required this.onDeleted,
    this.specialStartTime,
    this.specialRate,
    required this.onSpecialRateChanged,
    required this.onSpecialStartTimeChanged,
  });

  @override
  State<TeamMemberWidget> createState() => _TeamMemberWidgetState();
}

class _TeamMemberWidgetState extends State<TeamMemberWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: widget.onDeleted,
          tooltip: "Delete",
          color: context.colorScheme.primary,
          icon: const Icon(Icons.close)),
      title: Row(
        children: [
          //Name
          SizedBox(
              width: 100,
              child: Text(
                widget.name,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
          //Special Start Time
          const SizedBox(width: 8),
          TextButton(
              onPressed: () async {
                final res = await showTimePicker(
                    context: context,
                    initialTime: widget.specialStartTime ?? TimeOfDay.now());
                if (res != null) {
                  widget.onSpecialStartTimeChanged(res);
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12)),
              child: Text(
                  widget.specialStartTime?.format(context) ??
                      "Special\nStart Time",
                  textAlign: TextAlign.center)),
        ],
      ),
      //Special Price
      trailing: DefaultTextField(
        label: "Special Price",
        controller: TextEditingController(
            text: widget.specialRate?.toStringAsFixed(2) ?? ""),
        keyboardType: TextInputType.number,
        width: 140,
        height: 40,
        onChanged: (value) {
          widget.onSpecialRateChanged(double.parse(value));
        },
      ),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
    );
  }
}
