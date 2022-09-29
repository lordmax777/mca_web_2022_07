import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../theme/theme.dart';

class UserDetailQualifNewQualifPopupWidget extends StatefulWidget {
  final QualifsMd? qualif;
  const UserDetailQualifNewQualifPopupWidget({Key? key, this.qualif})
      : super(key: key);

  @override
  State<UserDetailQualifNewQualifPopupWidget> createState() =>
      _UserDetailQualifNewQualifPopupWidgetState();
}

class _UserDetailQualifNewQualifPopupWidgetState
    extends State<UserDetailQualifNewQualifPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ListQualification? _qualif;
  final TextEditingController _certController = TextEditingController();
  ListQualificationLevel? _level;
  bool hasExpire = true;
  DateTime? _expireDate;
  DateTime? _startDate;
  final TextEditingController _notesController = TextEditingController();

  bool isNew = true;

  @override
  void dispose() {
    _certController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.qualif != null) {
      isNew = false;
      _qualif = appStore.state.generalState.paramList.data!.qualifications
          .firstWhere((element) => widget.qualif!.title == element.title);
      _certController.text = widget.qualif!.certificateNumber;
      _level = appStore.state.generalState.paramList.data!.qualification_levels
          .firstWhere((element) => widget.qualif!.level == element.level);
      hasExpire = widget.qualif!.expire;
      _expireDate = DateTime.tryParse(widget.qualif!.expiryDate.date);
      _startDate = widget.qualif!.achievementDate != null
          ? DateTime.tryParse(widget.qualif!.achievementDate!.date)
          : null;
      _notesController.text = widget.qualif!.comments ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return TableWrapperWidget(
        child: Form(
      key: formKey,
      child: SpacedColumn(children: [
        _header(context),
        const Divider(color: ThemeColors.gray11, height: 1.0),
        const SizedBox(),
        _body(dpWidth),
        const Divider(color: ThemeColors.gray11, height: 1.0),
        _footer(),
      ]),
    ));
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: isNew ? 'Add Qualification' : 'Edit Qualification',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: () {
                context.popRoute();
              },
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(),
          DropdownWidget(
            value: _qualif?.title,
            hasSearchBox: true,
            hintText: "Qualification",
            dropdownBtnWidth: dpWidth / 3 + 12,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            onChanged: (val) {
              setState(() {
                _qualif = appStore
                    .state.generalState.paramList.data!.qualifications
                    .firstWhere((element) => element.title == val);
              });
            },
            items: appStore.state.generalState.paramList.data!.qualifications
                .map((e) => e.title)
                .toList(),
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 3 + 12,
            enabled: false,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter a valid certificate number';
              }
              return null;
            },
            labelText: "Certificate #",
            controller: _certController,
            onTap: () {},
          ),
          DropdownWidget(
            hintText: "Level",
            dropdownBtnWidth: dpWidth / 6 + 12,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            value: _level?.level,
            onChanged: (val) {
              setState(() {
                _level = appStore
                    .state.generalState.paramList.data!.qualification_levels
                    .firstWhere((element) => element.level == val);
              });
            },
            items: appStore
                .state.generalState.paramList.data!.qualification_levels
                .map((e) => e.level)
                .toList(),
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                value: hasExpire,
                onChanged: (value) {
                  setState(() {
                    hasExpire = value!;
                  });
                },
              ),
              KText(
                text: "Has Expiry Date",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          SpacedRow(
            horizontalSpace: 12.0,
            children: [
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Start Date",
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please enter a valid start date';
                  }
                  return null;
                },
                controller:
                    TextEditingController(text: _startDate?.toIso8601String()),
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _startDate = value;
                      });
                    }
                  });
                },
              ),
              if (hasExpire)
                TextInputWidget(
                  isRequired: true,
                  width: dpWidth / 6,
                  enabled: false,
                  labelText: "Expiry Date",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter a valid expiry date';
                    }
                    return null;
                  },
                  leftIcon: HeroIcons.calendar,
                  controller: TextEditingController(
                      text: _expireDate?.toIso8601String()),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _expireDate = value;
                        });
                      }
                    });
                  },
                ),
            ],
          ),
          TextInputWidget(
            width: dpWidth / 3 + 12,
            enabled: false,
            labelText: "Comment",
            controller: _notesController,
            onTap: () {},
            maxLines: 4,
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.end,
        horizontalSpace: 16.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonLargeSecondary(
            text: 'Cancel',
            paddingWithoutIcon: true,
            onPressed: () {
              context.popRoute();
            },
          ),
          ButtonLarge(
            paddingWithoutIcon: true,
            text: isNew ? 'Add Qualification' : 'Update Qualification',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // context.popRoute();
              }
            },
          ),
        ],
      ),
    );
  }
}
