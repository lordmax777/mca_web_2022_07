import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class ShiftTab extends StatefulWidget {
  const ShiftTab({super.key});

  @override
  State<ShiftTab> createState() => _ShiftTabState();
}

class _ShiftTabState extends State<ShiftTab> with FormsMixin<ShiftTab> {
  final generalState = appStore.state.generalState;
  final double fieldWidth = 450;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  late final rotaLengths = [...generalState.lists.workRepeats];

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultDropdown(
                    label: "Length of the Rota",
                    width: fieldWidth,
                    valueId: selected1?.id ??
                        rotaLengths
                            .firstWhereOrNull(
                                (element) => element.name == "Basic")
                            ?.id,
                    items: [
                      for (final item in rotaLengths)
                        DefaultMenuItem(
                            id: item.id,
                            title: item.name,
                            subtitle: "${item.days} days"),
                    ],
                    hasSearchBox: true,
                    onChanged: (value) {
                      setState(() {
                        selected1 = value;
                      });
                    },
                  ),
                  subLabel("Default: Weekly"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "Annual Holiday Entitlement (Weeks)",
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 5.6 weeks"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "SSP Waiting Days",
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 3 Days"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "SSP Link Period of Incapacity for Work (Weeks)",
                    controller: controller4,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 8 Weeks"),
                ],
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
      final res = await dispatch<bool>(SaveCompanyDetailsAction());
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
