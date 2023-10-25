import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

final class ShiftCardDropdown extends Equatable {
  final Iterable<DefaultMenuItem> items;
  final ValueChanged<DefaultMenuItem>? onChanged;
  final int? valueId;
  final String? additionalValueId;
  final String? label;

  const ShiftCardDropdown({
    required this.items,
    this.onChanged,
    this.valueId,
    this.additionalValueId,
    this.label,
  });

  @override
  List<Object?> get props =>
      [items, onChanged, valueId, label, additionalValueId];
}

final class ShiftCardItem extends Equatable {
  final String? title;
  final String? simpleText;
  final VoidCallback? onSimpleTextTapped;
  final ValueChanged<bool>? onChecked;
  final bool? checked;
  final Widget? customWidget;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ShiftCardDropdown? dropdown;

  const ShiftCardItem({
    this.title,
    this.onChanged,
    this.maxLines,
    this.onSimpleTextTapped,
    this.onChecked,
    this.checked,
    this.simpleText,
    this.customWidget,
    this.dropdown,
  });

  @override
  List<Object?> get props => [
        title,
        simpleText,
        checked,
        customWidget,
        dropdown,
        maxLines,
        onChanged,
        dropdown
      ];
}

class ShiftCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<ShiftCardItem> items;
  final ShiftCardDropdown? dropdown;
  final bool isExpanded;
  final double width;
  final bool isTrailingRight;
  const ShiftCard({
    Key? key,
    required this.title,
    required this.items,
    this.isExpanded = false,
    this.isTrailingRight = true,
    this.trailing,
    this.dropdown,
    this.width = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return titleWithDivider(
      title,
      Container(
          width: isExpanded ? double.infinity : width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            dividerColor: Theme.of(context).dividerColor.withOpacity(.5),
            children: [
              for (var item in items)
                if (item.customWidget != null)
                  item.customWidget!
                else
                  labelWithField(
                    context,
                    item,
                    labelWidth: 160,
                  ),
            ],
          )),
      context,
    );
  }

  Widget titleWithDivider(String? title, Widget? child, BuildContext context) {
    return SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            SpacedRow(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 6,
              children: [
                if (trailing != null && !isTrailingRight) trailing!,
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (trailing != null && isTrailingRight) trailing!,
              ],
            ),
          if (title != null)
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: isExpanded ? double.infinity : width,
              height: 1,
              color: Colors.grey,
            ),
          if (dropdown != null)
            DefaultDropdown(
              hasSearchBox: true,
              width: width,
              label: dropdown!.label,
              items: dropdown!.items.toList(),
              onChanged: dropdown!.onChanged,
              valueId: dropdown!.valueId,
            ),
          if (dropdown != null) const SizedBox(height: 8),
          if (child != null) child,
        ]);
  }

  Widget labelWithField(BuildContext context, ShiftCardItem item,
      {double? labelWidth}) {
    return SpacedRow(
      horizontalSpace: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            "${item.title}:",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        _textField(
          context,
          item,
        ),
      ],
    );
  }

  Widget _textField(
    BuildContext context,
    ShiftCardItem item,
  ) {
    if (item.onChanged != null) {
      return DefaultTextField(
        width: width / 1.5,
        height: (item.maxLines ?? 1) * 40,
        label: "Enter ${item.title}",
        onChanged: item.onChanged!,
        maxLines: item.maxLines,
        controller: TextEditingController(text: item.simpleText),
      );
    }
    if (item.onChecked != null && item.checked != null) {
      return DefaultSwitch(
        value: item.checked!,
        onChanged: item.onChecked!,
        activeIcon: Icons.check,
        inactiveIcon: Icons.close,
      );
    }
    if (item.dropdown != null) {
      return DefaultDropdown(
        hasSearchBox: true,
        width: width / 2.2,
        label: item.title,
        items: item.dropdown!.items.toList(),
        onChanged: item.dropdown?.onChanged,
        valueId: item.dropdown!.valueId,
        valueAdditionalId: item.dropdown!.additionalValueId,
      );
    }
    return SizedBox(
      width: width / 2.2,
      child: InkWell(
        onTap: item.onSimpleTextTapped,
        child: Text(
          item.simpleText == null
              ? "-"
              : (item.simpleText!.isEmpty ? "-" : item.simpleText!),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                decoration: item.onSimpleTextTapped != null
                    ? TextDecoration.underline
                    : null,
                decorationColor: context.colorScheme.primary,
                decorationThickness: 2,
                color: item.onSimpleTextTapped != null
                    ? context.colorScheme.primary
                    : null,
              ),
        ),
      ),
    );
  }
}
