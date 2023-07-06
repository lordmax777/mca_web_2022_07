import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';

class CapacityTab extends StatefulWidget {
  final PropertyDetailMd model;
  final ValueChanged<PropertyDetailMd> onSaved;
  const CapacityTab({super.key, required this.model, required this.onSaved});

  @override
  State<CapacityTab> createState() => _CapacityTabState();
}

class _CapacityTabState extends State<CapacityTab>
    with FormsMixin<CapacityTab> {
  PropertyDetailMd get model => widget.model;

  @override
  void initState() {
    controller1.text = model.bedrooms.toString();
    controller2.text = model.bathrooms.toString();
    controller3.text = model.minSleeps.toString();
    controller4.text = model.maxSleeps.toString();
    controller5.text = model.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Form(
          key: formKey,
          child: Column(
            children: [
              UserCard(title: "", items: [
                UserCardItem(
                  title: "Bedrooms",
                  controller: controller1,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                UserCardItem(
                  title: "Bathrooms",
                  controller: controller2,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                UserCardItem(
                  title: "Min Sleeps",
                  controller: controller3,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                UserCardItem(
                  title: "Max Sleeps",
                  controller: controller4,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                UserCardItem(
                    title: "Comment", controller: controller5, maxLines: 5),
              ]),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    widget.onSaved(PropertyDetailMd(
                      bedrooms: int.parse(controller1.text),
                      bathrooms: int.parse(controller2.text),
                      minSleeps: int.parse(controller3.text),
                      maxSleeps: int.parse(controller4.text),
                      notes: controller5.text,
                    ));
                  }
                },
                child: const Text("Save"),
              ),
            ],
          )),
    );
  }
}
