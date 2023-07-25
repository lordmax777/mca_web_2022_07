import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class CreateNewUnavToWorkPopup extends StatefulWidget {
  const CreateNewUnavToWorkPopup({super.key});

  @override
  State<CreateNewUnavToWorkPopup> createState() =>
      _CreateNewUnavToWorkPopupState();
}

class _CreateNewUnavToWorkPopupState extends State<CreateNewUnavToWorkPopup>
    with FormsMixin<CreateNewUnavToWorkPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Unavailable to work date and time"),
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close))
        ],
      ),
      content: Form(
        key: formKey,
        child: UserCard(title: "", items: [
          UserCardItem(
            title: "Start Date",
            isRequired: true,
            simpleText:
                controller1.text.isEmpty ? "Select date" : controller1.text,
            onSimpleTextTapped: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ).then((value) {
                if (value != null) {
                  controller1.text = DateFormat("dd/MM/yyyy").format(value);
                } else {
                  controller1.text = "";
                }
                setState(() {});
              });
            },
          ),
          //end date
          if (checked1)
            UserCardItem(
              title: "End Date",
              isRequired: true,
              simpleText:
                  controller2.text.isEmpty ? "Select date" : controller2.text,
              onSimpleTextTapped: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ).then((value) {
                  if (value != null) {
                    controller2.text = DateFormat("dd/MM/yyyy").format(value);
                  } else {
                    controller2.text = "";
                  }
                });
              },
            ),

          //start time
          if (!checked1)
            UserCardItem(
              title: "Start Time",
              isRequired: !checked1,
              simpleText:
                  controller3.text.isEmpty ? "Select time" : controller3.text,
              onSimpleTextTapped: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    controller3.text = value.format(context);
                  } else {
                    controller3.text = "";
                  }
                  setState(() {});
                });
              },
            ),

          //end time
          if (!checked1)
            UserCardItem(
              title: "End Time",
              isRequired: !checked1,
              simpleText:
                  controller4.text.isEmpty ? "Select time" : controller4.text,
              onSimpleTextTapped: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    controller4.text = value.format(context);
                  } else {
                    controller4.text = "";
                  }
                  setState(() {});
                });
              },
            ),
          UserCardItem(
            title: "Full Day",
            checked: checked1,
            onChecked: (value) {
              setState(() {
                checked1 = value;
              });
            },
          ),
          //comment
          UserCardItem(
            title: "Comment",
            controller: controller5,
            maxLines: 3,
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (!isFormValid) return;
            if (controller1.text.isEmpty) {
              return context.showError("Start date is required");
            }
            if (controller2.text.isEmpty && !checked1) {
              return context.showError("End date is required");
            }
            context.futureLoading(() async {
              final res = await dispatch<bool>(
                  CreateAccountUserAvailabilityAction(
                      startDate:
                          DateFormat("dd/MM/yyyy").parse(controller1.text),
                      endDate: DateFormat("dd/MM/yyyy").parse(controller2.text),
                      startTime: controller3.text.isEmpty
                          ? null
                          : TimeOfDay(
                              hour: int.parse(controller3.text.split(":")[0]),
                              minute:
                                  int.parse(controller3.text.split(":")[1])),
                      endTime: controller4.text.isEmpty
                          ? null
                          : TimeOfDay(
                              hour: int.parse(controller4.text.split(":")[0]),
                              minute:
                                  int.parse(controller4.text.split(":")[1])),
                      isFullDay: checked1));
              if (res.isLeft) {
                context.pop(true);
              } else if (res.isRight) {
                context.showError(res.right.message);
              } else {
                context.showError("Something went wrong");
              }
            });
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
