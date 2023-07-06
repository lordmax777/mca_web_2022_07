import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';

import 'widgets.dart';

class MCALoadingWidget extends StatelessWidget {
  final VoidCallback? onClose;
  const MCALoadingWidget({Key? key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        verticalSpace: 16,
        children: [
          const CircularProgressIndicator(),
          if (onClose != null)
            ElevatedButton(
                onPressed: () {
                  DependencyManager.instance.dioClient.defaultInterceptors
                      .cancelRequest();
                  onClose!();
                },
                child: const Text("Cancel"))
        ],
      ),
    );
  }
}
