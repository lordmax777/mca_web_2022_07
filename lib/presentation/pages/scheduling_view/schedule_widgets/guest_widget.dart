import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class GuestWidget extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback? onAdded;
  final VoidCallback? onRemoved;
  const GuestWidget(
      {super.key,
      required this.title,
      required this.value,
      this.onAdded,
      this.onRemoved});

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              "$title:",
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        const SizedBox(width: 20),
        EasyButton(
          // style: IconButton.styleFrom(
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(10))),
          //     side: BorderSide(
          //         color: Theme.of(context).colorScheme.secondary, width: 1)),
          // color: Theme.of(context).colorScheme.onPrimary,
          // padding: const EdgeInsets.all(0),
          // constraints: const BoxConstraints(
          //   minWidth: 30,
          //   minHeight: 30,
          // ),
          // icon: const Icon(Icons.remove),
          borderRadius: 8,
          width: 30,
          height: 30,
          idleStateWidget: const Icon(Icons.remove),
          loadingStateWidget: Transform.scale(
            scale: .6,
            child: const CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.white,
                color: Colors.black),
          ),
          type: onRemoved == null
              ? EasyButtonType.outlined
              : EasyButtonType.elevated,
          onPressed: onRemoved,
          useWidthAnimation: false,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(width: 10),
        EasyButton(
          // style: IconButton.styleFrom(
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(10))),
          //     side: BorderSide(
          //         color: Theme.of(context).colorScheme.secondary, width: 1)),
          // color: Theme.of(context).colorScheme.onPrimary,
          // padding: const EdgeInsets.all(0),
          // constraints: const BoxConstraints(
          //   minWidth: 30,
          //   minHeight: 30,
          // ),
          // icon: const Icon(Icons.add),
          borderRadius: 8,
          width: 30,
          height: 30,
          idleStateWidget: const Icon(Icons.add),
          useWidthAnimation: false,

          loadingStateWidget: Transform.scale(
            scale: .6,
            child: const CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.white,
                color: Colors.black),
          ),
          type: onAdded == null
              ? EasyButtonType.outlined
              : EasyButtonType.elevated,
          onPressed: onAdded,
        ),
      ],
    );
  }
}
