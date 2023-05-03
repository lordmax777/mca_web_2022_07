import 'dart:async';

import 'package:mca_web_2022_07/theme/theme.dart';

class CustomAutocompleteTextField<T extends Object> extends StatelessWidget {
  final FutureOr<Iterable<T>> Function(TextEditingValue) options;
  final String Function(T) displayStringForOption;
  final Widget Function(T)? listItemWidget;
  final void Function(T)? onSelected;
  final String? hintText;
  final double? width;
  final double? height;
  const CustomAutocompleteTextField({
    Key? key,
    required this.options,
    required this.onSelected,
    this.hintText,
    this.width,
    this.height,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.listItemWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 300,
      height: height ?? 40,
      child: LayoutBuilder(builder: (context, c) {
        return Autocomplete<T>(
          optionsViewBuilder: (context, onSelected, opts) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: c.maxWidth,
                  height: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: opts.map((e) {
                            return ListTile(
                              title:
                                  listItemWidget?.call(e) ?? Text(e.toString()),
                              onTap: () {
                                logger((e as dynamic).toJson());
                                onSelected(e);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      // Container(
                      //   height: 50,
                      //   color: Colors.grey,
                      // ),
                    ],
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
                labelText: hintText ?? "Search a product",
                suffixIcon: const Icon(Icons.arrow_drop_down),
                prefixIcon: const Icon(Icons.search),
              ),
            );
          },
          optionsBuilder: options,
          onSelected: onSelected,
          optionsMaxHeight: 100.0,
        );
      }),
    );
  }
}
