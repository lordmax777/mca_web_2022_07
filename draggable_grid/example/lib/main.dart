import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void logger(dynamic msg, [String? hint]) {
  final h = hint ?? "LOGGER";
  log("[$h] - ${msg.toString()} - [$h]");
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Schedule Example Test"),
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: DailyViewCalendar()));
  }
}

class DailyViewCalendar extends StatefulWidget {
  DailyViewCalendar({Key? key}) : super(key: key);

  @override
  State<DailyViewCalendar> createState() => _DailyViewCalendarState();
}

class _DailyViewCalendarState extends State<DailyViewCalendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.timelineDay,
      resourceViewHeaderBuilder: (context, details) {
        return Container(
          height: 50,
          width: 50,
          color: Colors.red,
          child: Column(
            children: [
              Text(details.resource.displayName),
              if (details.resource.image != null)
                Image(
                  image: details.resource.image!,
                  width: 50,
                  height: 50,
                )
            ],
          ),
        );
      },
      resourceViewSettings: ResourceViewSettings(
        displayNameTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        size: 330,
        visibleResourceCount: 10,
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
        timeIntervalHeight: 50,
        timeIntervalWidth: 80,
        timeFormat: "H:mm a",
        timeTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
      headerHeight: 0,
      viewHeaderHeight: 0,
      viewNavigationMode: ViewNavigationMode.none,
      viewHeaderStyle: const ViewHeaderStyle(
        backgroundColor: Color(0xFFE8E8EA),
      ),
      dragAndDropSettings: const DragAndDropSettings(
        allowScroll: true,
        allowNavigation: true,
      ),
      onSelectionChanged: (calendarSelectionDetails) {
        logger(calendarSelectionDetails.date, 'Date');
        logger(calendarSelectionDetails.resource, 'RESOURCE');
      },
      todayHighlightColor: Colors.blueAccent,
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      allowDragAndDrop: true,
    );
  }
}

class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
