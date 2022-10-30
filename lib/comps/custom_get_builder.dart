import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GBuilder<T extends GetxController> extends StatelessWidget {
  final Widget Function(T controller) child;
  const GBuilder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        dispose: (state) => state.controller?.onDelete(),
        builder: (controller) => Obx(() => child(controller)));
  }
}
