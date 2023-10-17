import 'package:flutter/material.dart';

class ActualTimePopup extends StatefulWidget {
  final Map<String, dynamic> model;
  const ActualTimePopup({super.key, required this.model});

  @override
  State<ActualTimePopup> createState() => _ActualTimePopupState();
}

class _ActualTimePopupState extends State<ActualTimePopup> {
  Map<String, dynamic> get model => widget.model;

  String get fullName => model['firstName'] + ' ' + model['lastName'];

  @override
  void initState() {
    super.initState();
    print(model);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Punch Time'),
      actions: [
        ElevatedButton(onPressed: () {}, child: Text('Submit')),
      ],
    );
  }
}
