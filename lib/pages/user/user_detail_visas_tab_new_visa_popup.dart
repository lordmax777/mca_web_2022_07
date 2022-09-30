import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../manager/models/visa_md.dart';
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
  ListVisa? _visaType;
  bool _hasExire = true;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _commentController = TextEditingController();

  bool isNew = true;

  @override
  void initState() {
    super.initState();
    if (widget.visa != null) {
      isNew = false;
      _documentNoController.text = widget.visa!.document_no;
      _visaType = appStore.state.generalState.paramList.data!.visas
          .firstWhere((element) => element.name == widget.visa!.title);
      _hasExire = !widget.visa!.notExpire;
      _startDate = DateTime.tryParse(widget.visa!.startDate.date);
      _endDate = widget.visa!.endDate != null
          ? DateTime.tryParse(widget.visa!.endDate!.date)
          : null;
      _commentController.text = widget.visa!.notes;
    }
    logger(widget.visa?.toJson());
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
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 32.0,
          children: [
            const SizedBox(height: 1),
            TextInputWidget(
              isRequired: true,
              width: dpWidth / 3 + 12,
              enabled: false,
              labelText: "Document #",
              controller: _documentNoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
              },
            ),
            DropdownWidget(
              hintText: "Visa Type",
              value: _visaType?.name,
              dropdownBtnWidth: dpWidth / 3 + 12,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 3 + 12,
              dropdownMaxHeight: 400.0,
              hasSearchBox: true,
              onChanged: (val) {
                setState(() {
                  _visaType = appStore.state.generalState.paramList.data!.visas
                      .firstWhere((element) => element.name == val);
                });
              },
              items: appStore.state.generalState.paramList.data!.visas
                  .map((e) => e.name)
                  .toList(),
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
                  enabled: false,
                  controller:
                      TextEditingController(text: _startDate?.toString()),
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
                      initialDate: DateTime(2015),
                      firstDate: DateTime(1930),
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
                  enabled: false,
                  labelText: "Expire Date",
                  controller: TextEditingController(text: _endDate?.toString()),
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
                      initialDate: DateTime(2015),
                      firstDate: DateTime(1930),
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
            TextInputWidget(
              width: dpWidth / 3 + 12,
              enabled: false,
              labelText: "Comment",
              controller: _commentController,
              maxLines: 4,
            ),
            const SizedBox(),
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
            onPressed: () {
              formKey.currentState!.validate();
              // context.popRoute();
            },
          ),
        ],
      ),
    );
  }
}
