import 'package:flutter/material.dart';

class UserTimesheetPopup extends StatefulWidget {
  final int userId;
  const UserTimesheetPopup({super.key, required this.userId});

  @override
  State<UserTimesheetPopup> createState() => _UserTimesheetPopupState();
}

class _UserTimesheetPopupState extends State<UserTimesheetPopup> {
  int get userId => widget.userId;


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
