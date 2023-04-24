import 'dart:async';

import 'package:mca_web_2022_07/theme/theme.dart';

class CustomAutocompleteTextField<T extends Object> extends StatelessWidget {
  final FutureOr<Iterable<T>> Function(TextEditingValue) options;
  final String Function(T) displayStringForOption;
  final Widget Function(T)? listItemWidget;
  final void Function(T)? onSelected;
  const CustomAutocompleteTextField({
    Key? key,
    required this.options,
    required this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.listItemWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 40,
      child: LayoutBuilder(builder: (context, c) {
        return Autocomplete<T>(
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: c.maxWidth,
                  height: 200,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    children: options
                        .map((e) => ListTile(
                              title:
                                  listItemWidget?.call(e) ?? Text(e.toString()),
                              onTap: () {
                                onSelected(e);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          },
          displayStringForOption: displayStringForOption,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onSubmitted: (value) {
                onFieldSubmitted();
              },
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textEditingController.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
                border: const OutlineInputBorder(),
                labelText: "Search a product",
              ),
            );
          },
          optionsBuilder: options,
          onSelected: onSelected,
          optionsMaxHeight: 50.0,
        );
      }),
    );
  }
}
