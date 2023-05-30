import 'dart:math';

import '../../comps/custom_multi_select_dropdown.dart';
import '../../theme/theme.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<MultiSelectGroup> items = [
    MultiSelectGroup(
      items: [
        MultiSelectItem(label: "One", id: "1"),
        MultiSelectItem(label: "One", id: "1.1"),
        MultiSelectItem(label: "Two", id: "2"),
        MultiSelectItem(label: "Three", id: "3"),
        MultiSelectItem(label: "Four", id: "5"),
      ],
      label: "Numbers",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: TableWrapperWidget(
        child: Center(
          child: SpacedColumn(
            verticalSpace: 32,
            children: [
              CustomMultiSelectDropdown(
                items: items,
                width: 300,
                isMultiSelect: true,
                onChange: (value) {
                  logger(value);
                },
              ),
              Text(items.first.label),
              _button(() {
                final oldItems = items.first.items;
                items.clear();
                items.addAll([
                  MultiSelectGroup(items: oldItems),
                ]);
                setState(() {});
              }, title: "Update items"),
              // CustomMultiSelectDropdown(
              //   items: items,
              //   onChange: (value) {
              //     logger(value);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(VoidCallback onTap, {String? title}) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(title ?? 'Test Button'),
    );
  }
}
