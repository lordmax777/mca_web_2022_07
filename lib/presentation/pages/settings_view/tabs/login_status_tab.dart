import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class LoginStatusTab extends StatefulWidget {
  const LoginStatusTab({super.key});

  @override
  State<LoginStatusTab> createState() => _LoginStatusTabState();
}

class _LoginStatusTabState extends State<LoginStatusTab>
    with FormsMixin<LoginStatusTab> {
  final generalState = appStore.state.generalState;
  final double fieldWidth = 450;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller1.text = generalState.companyInfo.maxAttempts.toString();
      controller2.text = generalState.companyInfo.locktime.toString();
      controller3.text = generalState.companyInfo.autoLogout.toString();
      checked1 = generalState.companyInfo.photoRequired;
      controller4.text = generalState.companyInfo.undoTime.toString();
      checked2 = generalState.companyInfo.strictLocation;
      setState(() {});
    });
  }

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
                  DefaultTextField(
                    width: fieldWidth,
                    label: "Login Attempts Allowed",
                    controller: controller1,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 3"),
                ],
              ),

              //lock time after failed login
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "Lock Time After Failed Login (Minutes)",
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 5 minutes"),
                ],
              ),

              //auto logout (minutes)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "Auto Logout (Minutes)",
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 5 minutes"),
                ],
              ),
              DefaultSwitch(
                value: checked1,
                onChanged: (value) {
                  checked1 = value;
                  setState(() {});
                },
                isLabelFirst: false,
                label: "Photo Required with Mobile",
              ),
              DefaultTextField(
                width: fieldWidth,
                label: "Undo Time After Status Change (Seconds)",
                controller: controller4,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
              ),
              DefaultSwitch(
                value: checked2,
                onChanged: (value) {
                  checked2 = value;
                  setState(() {});
                },
                isLabelFirst: false,
                label: "Strict Location at Status Change",
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
      final res = await dispatch<bool>(SaveCompanyDetailsAction(
          maxAttempts: int.tryParse(controller1.text),
          lockingTime: int.tryParse(controller2.text),
          autoLogoutTime: int.tryParse(controller3.text),
          isPhotoRequired: checked1,
          undoTime: int.tryParse(controller4.text),
          isStrictLocation: checked2));
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
