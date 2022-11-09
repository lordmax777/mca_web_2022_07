import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GBuilder<T extends GetxController> extends StatelessWidget {
  final Widget Function(T controller) child;
  final String? tag;
  const GBuilder({Key? key, required this.child, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        id: tag,
        dispose: (state) => state.controller?.onDelete(),
        builder: (controller) => Obx(() => child(controller)));
  }
}
