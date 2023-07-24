import 'package:flutter/material.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';

class DefaultSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final IconData? inactiveIcon;
  final IconData? activeIcon;
  final bool isLabelFirst;
  const DefaultSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.isLabelFirst = true,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (label != null)
          if (isLabelFirst)
            Text(label!, style: Theme.of(context).textTheme.titleSmall!),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbIcon: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Icon(activeIcon ?? Icons.check, color: Colors.white);
            }
            if (inactiveIcon != null) {
              return Icon(inactiveIcon, color: Colors.white);
            }
            return null;
          }),
          activeColor: context.colorScheme.primary,
          activeTrackColor: context.colorScheme.primary.withOpacity(0.5),
          inactiveThumbColor: Theme.of(context).dividerColor.withOpacity(0.8),
          inactiveTrackColor: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        if (label != null)
          if (!isLabelFirst)
            Text(label!, style: Theme.of(context).textTheme.titleSmall!),
      ],
    );
  }
}
