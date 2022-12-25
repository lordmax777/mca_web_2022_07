import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../comps/dropdown_widget1.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';

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

  CodeMap _qualif = CodeMap(code: null, name: null);

  final TextEditingController _certController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  CodeMap _level = CodeMap(code: null, name: null);

  bool hasExpire = true;

  DateTime? _expireDate;
  DateTime? _startDate;

  bool isNew = true;

  List errors = [];

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
      final qualifs =
          appStore.state.generalState.paramList.data!.qualifications;
      final levels =
          appStore.state.generalState.paramList.data!.qualification_levels;
      isNew = false;
      _qualif = CodeMap(
          name: qualifs
              .firstWhere((element) => widget.qualif!.title == element.title)
              .title,
          code: qualifs
              .firstWhere((element) => widget.qualif!.title == element.title)
              .id
              .toString());

      _certController.text = widget.qualif!.certificateNumber;

      _level = CodeMap(
          name: levels
              .firstWhere((element) => widget.qualif!.level == element.level)
              .level,
          code: levels
              .firstWhere((element) => widget.qualif!.level == element.level)
              .id
              .toString());

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
    final qualifs = appStore.state.generalState.paramList.data!.qualifications;
    final levels =
        appStore.state.generalState.paramList.data!.qualification_levels;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          DropdownWidget1<ListQualification>(
            value: _qualif.name,
            hasSearchBox: true,
            hintText: "Qualification",
            dropdownBtnWidth: dpWidth / 3 + 12,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            objItems: qualifs,
            items: qualifs.map((e) => e.title).toList(),
            onChangedWithObj: (value) {
              setState(() {
                _qualif =
                    CodeMap(code: value.item.id.toString(), name: value.name);
              });
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 3 + 12,
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
          DropdownWidget1<ListQualificationLevel>(
            hintText: "Level",
            dropdownBtnWidth: dpWidth / 6 + 12,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            value: _level.name,
            objItems: levels,
            isRequired: true,
            items: levels.map((e) => e.level).toList(),
            onChangedWithObj: (DpItem value) {
              setState(() {
                _level =
                    CodeMap(code: value.item.id.toString(), name: value.name);
              });
            },
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
                disableAll: false,
                labelText: "Start Date",
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please enter a valid start date';
                  }
                  return null;
                },
                controller:
                    TextEditingController(text: _startDate?.formattedDate),
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2035),
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
                  disableAll: false,
                  labelText: "Expiry Date",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter a valid expiry date';
                    }
                    return null;
                  },
                  leftIcon: HeroIcons.calendar,
                  controller:
                      TextEditingController(text: _expireDate?.formattedDate),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2035),
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
          if (errors.isNotEmpty)
            Center(
              child: KText(
                text: errors.join(".\n"),
                textColor: ThemeColors.red3,
                fontSize: 18,
              ),
            ),
          TextInputWidget(
            width: dpWidth / 3 + 12,
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
            onPressed: () async {
              setState(() {
                errors.clear();
              });

              if (formKey.currentState!.validate()) {
                final ApiResponse? res =
                    await appStore.dispatch(GetPostUserDetailsQualifsAction(
                  levelId: _level,
                  certificateNumber: _certController.text,
                  expiryDate: _expireDate,
                  achievementDate: _startDate!,
                  qualificationId: _qualif,
                  userqualificationid: widget.qualif?.uqId,
                  comments: _notesController.text,
                ));
                if (res != null) {
                  if (res.success) {
                    //Do nothing
                  } else {
                    if (res.rawError != null) {
                      final e = jsonDecode(res.rawError!.data)['errors'].values;
                      for (var element in e) {
                        setState(() {
                          errors.add(element.first);
                        });
                      }
                    }
                  }
                }
              }
              // context.popRoute();
            },
          ),
        ],
      ),
    );
  }
}
