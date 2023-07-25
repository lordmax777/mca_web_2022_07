import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class CompanyTab extends StatefulWidget {
  const CompanyTab({super.key});

  @override
  State<CompanyTab> createState() => _CompanyTabState();
}

class _CompanyTabState extends State<CompanyTab> with FormsMixin<CompanyTab> {
  final deps = DependencyManager.instance;

  @override
  void initState() {
    super.initState();
    controller1.text = generalState.companyInfo.name;
    final locale = generalState.companyInfo.locale;
    final loc = languages.firstWhereOrNull((element) => element.code == locale);
    setState(() {
      if (loc != null) {
        selected1 = DefaultMenuItem(
          id: 0,
          title: loc.name,
          additionalId: loc.code,
        );
      }
      selected3 = DefaultMenuItem(
        id: 0,
        title:
            "${generalState.companyInfo.currency.code} (${generalState.companyInfo.currency.sign})",
        additionalId: generalState.companyInfo.currency.code,
      );
      selected2 = DefaultMenuItem(
        id: 0,
        title: generalState.companyInfo.timezone,
        additionalId: generalState.companyInfo.timezone,
      );
    });
  }

  final generalState = appStore.state.generalState;
  final double fieldWidth = 450;
  final currencies = [...appStore.state.generalState.lists.currencies];
  final languages = [...appStore.state.generalState.lists.languages];
  late final timezones = getTimezones().keys.toList();

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
              DefaultTextField(
                width: fieldWidth,
                label: "Your Domain",
                initialValue: appStore.state.generalState.companyInfo.domain,
                disabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your domain";
                  }
                  return null;
                },
              ),
              DefaultTextField(
                width: fieldWidth,
                label: "Company Name",
                controller: controller1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter company name";
                  }
                  return null;
                },
              ),
              _buildCompanyLogo(),
              DefaultDropdown(
                label: "Timezone",
                width: fieldWidth,
                hasSearchBox: true,
                onChanged: (value) {
                  setState(() {
                    selected2 = value;
                  });
                },
                valueAdditionalId: selected2?.additionalId ?? "",
                items: [
                  for (int i = 0; i < timezones.length; i++)
                    DefaultMenuItem(
                      id: i,
                      title: timezones[i],
                      additionalId: timezones[i],
                    )
                ],
              ),
              DefaultDropdown(
                width: fieldWidth,
                label: 'Language',
                onChanged: (value) {
                  setState(() {
                    selected1 = value;
                  });
                },
                valueAdditionalId: selected1?.additionalId,
                items: [
                  for (int i = 0; i < languages.length; i++)
                    DefaultMenuItem(
                      id: i,
                      title: languages[i].name,
                      additionalId: languages[i].code,
                    )
                ],
              ),
              DefaultDropdown(
                width: fieldWidth,
                label: 'Currency',
                onChanged: (value) {
                  setState(() {
                    selected3 = value;
                  });
                },
                valueAdditionalId: selected3?.additionalId,
                items: [
                  for (int i = 0; i < currencies.length; i++)
                    DefaultMenuItem(
                      id: currencies[i].id,
                      title: "${currencies[i].code} (${currencies[i].sign})",
                      additionalId: currencies[i].code,
                    ),
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
    if (selected1 == null) {
      context.showError("Please select language");
      return;
    }
    if (selected3 == null) {
      context.showError("Please select currency");
      return;
    }
    if (selected2 == null) {
      context.showError("Please select timezone");
      return;
    }
    context.futureLoading(() async {
      final res = await dispatch<bool>(SaveCompanyDetailsAction(
        companyName: controller1.text,
        locale: selected1!.additionalId,
        timezone: selected2!.additionalId,
        logo:
            file1?.bytes != null ? base64.encode(file1!.bytes!.toList()) : null,

        // currencyId: selected3!.id,
      ));
      if (res.isLeft) {
        context.showSuccess("Saved successfully");
      } else if (res.isRight) {
        context.showError(res.right.message);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  Widget _buildCompanyLogo() {
    print("Company logo: ${generalState.companyInfo.logoBytes}");
    return SelectAvatarWidget(
      width: fieldWidth,
      height: 200,
      title: "Company Logo",
      image: generalState.companyInfo.logoBytes.isEmpty
          ? null
          : generalState.companyInfo.logoBytes,
      onImageChanged: (value) {
        file1 = value;
      },
    );
  }
}
