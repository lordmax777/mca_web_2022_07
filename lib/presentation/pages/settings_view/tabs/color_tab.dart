import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class ColorTab extends StatefulWidget {
  const ColorTab({super.key});

  @override
  State<ColorTab> createState() => _ColorTabState();
}

class _ColorTabState extends State<ColorTab> with FormsMixin<ColorTab> {
  final generalState = appStore.state.generalState;
  final double fieldWidth = 450;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final color = generalState.lists.colorSchemas.firstWhereOrNull(
          (element) => element.id == generalState.companyInfo.colourSchemaId);
      if (color != null) {
        selected1 = DefaultMenuItem(id: color.id, title: color.name);
      }
      setState(() {});
    });
  }

  late final colorSchemas = [...generalState.lists.colorSchemas];

  late Color currentPrimaryColor = Theme.of(context).colorScheme.primary;
  late Color currentSecondaryColor = Theme.of(context).colorScheme.secondary;
  late Color currentTertiaryColor = Theme.of(context).colorScheme.tertiary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      surfaceTintColor: Colors.white,
      scrollable: true,
      content: Form(
        key: formKey,
        child: SizedBox(
          width: context.width * 0.8,
          child: SpacedColumn(
            verticalSpace: 36,
            children: [
              //Create a template widget to preview the color theme,
              //template preview has an app bar, body and a single button with primary color
              Container(
                width: fieldWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: currentPrimaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: SpacedColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalSpace: 24,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //show some place holders with grey color
                          SpacedRow(
                            horizontalSpace: 64,
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: currentSecondaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                width: 180,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: currentTertiaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 180,
                            height: 40,
                            decoration: BoxDecoration(
                              color: currentTertiaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: currentPrimaryColor,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const SizedBox(height: 25, width: 80),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              DefaultDropdown(
                label: "Color Theme",
                width: fieldWidth,
                valueId: selected1?.id,
                items: [
                  for (final item in colorSchemas)
                    DefaultMenuItem(id: item.id, title: item.name),
                ],
                onChanged: (value) {
                  setState(() {
                    selected1 = value;
                    final color = generalState.lists.colorSchemas
                        .firstWhereOrNull(
                            (element) => element.id == selected1?.id);
                    if (color != null) {
                      final primary =
                          Color(int.parse("0xFF${color.colour1.substring(1)}"));
                      final secondary =
                          Color(int.parse("0xFF${color.colour2.substring(1)}"));
                      final tertiary =
                          Color(int.parse("0xFF${color.colour3.substring(1)}"));
                      currentPrimaryColor = primary;
                      currentSecondaryColor = secondary;
                      currentTertiaryColor = tertiary;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(onPressed: save, child: const Text("Save")),
      ],
    );
  }

  void save() {
    if (!isFormValid) return;
    context.futureLoading(() async {
      final res = await dispatch<bool>(
          SaveCompanyDetailsAction(colorSchemaId: selected1?.id));
      if (res.isLeft) {
        context.showSuccess("Saved successfully");
      } else if (res.isRight) {
        context.showError(res.right.message);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  Text subLabel(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
