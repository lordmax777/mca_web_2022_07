import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';

import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/users_state/users_state.dart';
import '../../theme/theme.dart';

class UserDetailReviewNewReviewPopupWidget extends StatefulWidget {
  final ReviewMd? review;
  const UserDetailReviewNewReviewPopupWidget({Key? key, this.review})
      : super(key: key);

  @override
  State<UserDetailReviewNewReviewPopupWidget> createState() =>
      _UserDetailReviewNewReviewPopupWidgetState();
}

class _UserDetailReviewNewReviewPopupWidgetState
    extends State<UserDetailReviewNewReviewPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNew = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  DateTime? _conductedOn;

  CodeMap _conductedBy = CodeMap(code: null, name: null);

  List errors = [];

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      isNew = false;
    }

    if (!isNew) {
      _titleController.text = widget.review!.title;
      _commentController.text = widget.review!.notes;
      _conductedOn = DateTime.parse(widget.review!.date);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => TableWrapperWidget(
          child: Form(
        key: formKey,
        child: SpacedColumn(children: [
          _header(context),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          const SizedBox(),
          _body(dpWidth, state),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          _footer(),
        ]),
      )),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: 'New Review',
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

  Widget _body(double dpWidth, AppState state) {
    final adminUsers = [...state.usersState.usersList.data!];
    final groups = state.generalState.paramList.data!.groups;
    adminUsers.removeWhere((element) => !(element.groupAdmin));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 4,
            labelText: "Title",
            controller: _titleController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Title is required";
              }
            },
            onTap: () {},
          ),
          DropdownWidget1<UserRes>(
            hintText: "Conducted By",
            value: _conductedBy.name,
            hasSearchBox: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            objItems: adminUsers,
            items: adminUsers.map((e) => e.fullname).toList(),
            onChangedWithObj: (value) {
              setState(() {
                _conductedBy =
                    CodeMap(code: value.item.id.toString(), name: value.name);
              });
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 6,
            enabled: false,
            labelText: "Conducted On",
            controller:
                TextEditingController(text: _conductedOn?.formattedDate),
            leftIcon: HeroIcons.calendar,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Date is required";
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
                  _conductedOn = val;
                });
              }
            },
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
            width: dpWidth / 4,
            labelText: "Comment",
            controller: _commentController,
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
            text: isNew ? 'Add Review' : "Save Review",
            onPressed: () async {
              setState(() {
                errors.clear();
              });

              if (formKey.currentState!.validate()) {
                final ApiResponse? res =
                    await appStore.dispatch(GetPostUserDetailsReviewAction(
                  title: _titleController.text,
                  date: _conductedOn!,
                  conductedBy: _conductedBy,
                  notes: _commentController.text,
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
