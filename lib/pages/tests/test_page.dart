import 'dart:math';

import 'package:mca_web_2022_07/manager/model_exporter.dart';

import '../../comps/custom_multi_select_dropdown.dart';
import '../../theme/theme.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final items = [
    MultiSelectGroup(
      label: "Numbers",
      items: [
        MultiSelectItem(label: "One", id: "1"),
        MultiSelectItem(label: "One", id: "1.1"),
        MultiSelectItem(label: "Two", id: "2"),
        MultiSelectItem(label: "Three", id: "3"),
        MultiSelectItem(label: "Four", id: "4"),
      ],
    ),
    MultiSelectGroup(
      label: "Colors",
      items: [
        MultiSelectItem(label: "Red", id: "red"),
      ],
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
                onChange: (list) {
                  logger(list);
                },
                initiallySelected: [
                  items.first.items[2],
                ],
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
