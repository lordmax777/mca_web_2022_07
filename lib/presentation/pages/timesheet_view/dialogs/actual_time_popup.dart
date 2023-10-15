import 'package:flutter/material.dart';

class ActualTimePopup extends StatefulWidget {
  final Map<String, dynamic> model;
  const ActualTimePopup({super.key, required this.model});

  @override
  State<ActualTimePopup> createState() => _ActualTimePopupState();
}

class _ActualTimePopupState extends State<ActualTimePopup> {
  Map<String, dynamic> get model => widget.model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(onPressed: () {}, child: Text('Submit')),
      ],
    );
  }
}
