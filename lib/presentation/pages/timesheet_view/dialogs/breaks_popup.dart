import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../manager/data/models/timesheet_md.dart';

class BreaksPopup extends StatefulWidget {
  final TsData model;
  const BreaksPopup({super.key, required this.model});

  @override
  State<BreaksPopup> createState() => _BreaksPopupState();
}

class _BreaksPopupState extends State<BreaksPopup> {
  TsData get model => widget.model;

  List get breaks => model.breaks ?? [];

  String get fullName => '${model.firstName} ${model.lastName}';

  String get date {
    final DateTime? date = DateTime.tryParse(model.date ?? "");
    return date != null ? DateFormat.yMd().format(date) : '-';
  }

  String? get shiftName => model.shiftName;

  @override
  void initState() {
    super.initState();
    print(model.toJson());
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          IconButton(onPressed: context.pop, icon: Icon(Icons.close)),
          const SizedBox(width: 10),
          SizedBox(
            width: context.width * .3,
            child: Text(
              '$fullName - $date\n$shiftName',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      content: SizedBox(
        width: context.width * .4,
        child: Table(
          border: TableBorder.all(),
          children: [
            // TableRow(
            //   children: [
            //     Text(fullName, textAlign: TextAlign.center),
            //     Text(date, textAlign: TextAlign.center),
            //   ],
            // ),
            TableRow(
              children: [
                Text("Start", textAlign: TextAlign.center),
                Text("Finish", textAlign: TextAlign.center),
              ],
            ),
            ...breaks.map((e) {
              print(e);
              final DateTime? start = DateTime.tryParse(e['start'] ?? "");
              final DateTime? end = DateTime.tryParse(e['finish'] ?? "");
              final startTime = start != null
                  ? DateFormat.Hms().format(start)
                  : e['start'] ?? "-";
              final endTime = end != null
                  ? DateFormat.Hms().format(end)
                  : e['finish'] ?? "-";
              return TableRow(
                children: [
                  Text(startTime, textAlign: TextAlign.center),
                  Text(endTime, textAlign: TextAlign.center),
                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
