import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../../comps/dropdown_widget1.dart';
import '../../manager/redux/sets/state_value.dart';
import '../../manager/redux/states/users_state/users_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../theme/theme.dart';

class UserDetailVisaNewVisaPopupWidget extends StatefulWidget {
  final VisaMd? visa;
  const UserDetailVisaNewVisaPopupWidget({Key? key, this.visa})
      : super(key: key);

  @override
  State<UserDetailVisaNewVisaPopupWidget> createState() =>
      _UserDetailVisaNewVisaPopupWidgetState();
}

class _UserDetailVisaNewVisaPopupWidgetState
    extends State<UserDetailVisaNewVisaPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _documentNoController = TextEditingController();
  CodeMap _visaType = CodeMap(code: null, name: null);
  bool _hasExire = true;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _commentController = TextEditingController();

  bool isNew = true;

  List errors = [];

  @override
  void initState() {
    super.initState();
    if (widget.visa != null) {
      final visas = appStore.state.generalState.paramList.data!.visas;

      isNew = false;
      _documentNoController.text = widget.visa!.document_no;
      _visaType = CodeMap(
          name: visas
              .firstWhere((element) => element.name == widget.visa!.title)
              .name,
          code: visas
              .firstWhere((element) => element.name == widget.visa!.title)
              .id
              .toString());
      _hasExire = !widget.visa!.notExpire;
      _startDate = DateTime.tryParse(widget.visa!.startDate.date);
      _endDate = widget.visa!.endDate != null
          ? DateTime.tryParse(widget.visa!.endDate!.date)
          : null;
      _commentController.text = widget.visa!.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    return TableWrapperWidget(
        child: SpacedColumn(children: [
      _header(context),
      const Divider(color: ThemeColors.gray11, height: 1.0),
      const SizedBox(),
      _body(dpWidth),
      const Divider(color: ThemeColors.gray11, height: 1.0),
      _footer(),
    ]));
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: isNew ? 'New Visa/Permit' : "Edit Visa/Permit",
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
    final visas = appStore.state.generalState.paramList.data!.visas;
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 32.0,
          children: [
            const SizedBox(height: 1),
            DropdownWidget1<ListVisa>(
              hintText: "Visa Type",
              value: _visaType.name,
              hasSearchBox: true,
              dropdownBtnWidth: dpWidth / 3 + 12,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 3 + 12,
              objItems: visas,
              items: visas.map((e) => e.name).toList(),
              onChangedWithObj: (value) {
                setState(() {
                  _visaType =
                      CodeMap(code: value.item.id.toString(), name: value.name);
                });
              },
            ),
            TextInputWidget(
              isRequired: true,
              width: dpWidth / 3 + 12,
              labelText: "Document #",
              controller: _documentNoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
              },
            ),
            SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 8.0,
              children: [
                CheckboxWidget(
                  value: _hasExire,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _hasExire = value;
                      });
                    }
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
                  controller:
                      TextEditingController(text: _startDate?.formattedDate),
                  labelText: "Start Date",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                  },
                  leftIcon: HeroIcons.calendar,
                  onTap: () async {
                    DateTime? val = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2035),
                    );
                    if (val != null) {
                      setState(() {
                        _startDate = val;
                      });
                    }
                  },
                ),
                TextInputWidget(
                  isRequired: true,
                  width: dpWidth / 6,
                  disableAll: false,
                  labelText: "Expire Date",
                  controller:
                      TextEditingController(text: _endDate?.formattedDate),
                  leftIcon: HeroIcons.calendar,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter a value";
                    }
                    if (_startDate != null &&
                        _endDate != null &&
                        _startDate!.isAfter(_endDate!)) {
                      return "Expire date must be after start date";
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? val = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2035),
                    );
                    if (val != null) {
                      setState(() {
                        _endDate = val;
                      });
                    }
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
              controller: _commentController,
              maxLines: 4,
            ),
            const SizedBox(height: 1),
          ],
        ),
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
            text: isNew ? 'Add Visa/Permit' : 'Save',
            onPressed: () async {
              setState(() {
                errors.clear();
              });

              if (formKey.currentState!.validate()) {
                final ApiResponse? res =
                    await appStore.dispatch(GetPostUserDetailsVisaAction(
                  startDate: _startDate!,
                  documentNo: _documentNoController.text,
                  endDate: _endDate!,
                  notExpire: _hasExire,
                  visaTypeId: _visaType,
                  notes: _commentController.text,
                  visaid: widget.visa?.id,
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
            },
          ),
        ],
      ),
    );
  }
}
