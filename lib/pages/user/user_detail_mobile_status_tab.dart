import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

// ignore: must_be_immutable
class MobileStatusWidget extends StatefulWidget {
  AppState state;
  MobileStatusWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<MobileStatusWidget> createState() => _MobileStatusWidgetState();
}

class _MobileStatusWidgetState extends State<MobileStatusWidget> {
  final _formStKey = GlobalKey<FormState>();
  final _formMobileKey = GlobalKey<FormState>();

  ListStatus? status;
  ListLocation? location;
  Map _shift = {};
  final TextEditingController _commentController = TextEditingController();
  bool stConfirm = true;

  String? mobileAction;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final e1 = state.usersState.userDetailStatus.error;
        final e2 = state.usersState.userDetailMobileIsRegistered.error;
        final List<ErrorModel> errors = [e1, e2];
        return ErrorWrapper(
          errors: errors,
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: SizedBox(
              width: double.infinity,
              child: SpacedColumn(
                verticalSpace: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _top(state),
                  const Divider(height: 40.0, color: ThemeColors.gray11),
                  _bottom(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _top(AppState state) {
    final StatussMd statusMd = state.usersState.userDetailStatus.data!;
    return SpacedRow(horizontalSpace: 48.0, children: [
      _topLeft(statusMd),
      Container(
        width: 1,
        height: 400,
        color: ThemeColors.gray11,
      ),
      _topRight(state),
    ]);
  }

  Widget _topLeft(StatussMd st) {
    final dpWidth = MediaQuery.of(context).size.width;

    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 24.0,
        children: [
          KText(
            text: 'Current Status',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          DropdownWidget(
            hintText: "Status",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            value: st.name,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Location",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            value: st.location,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Shift",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            value: st.shift,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            disableAll: true,
            width: dpWidth / 4,
            maxLines: 4,
            controller: TextEditingController(text: st.comment),
            labelText: "Comment",
            onTap: () {},
          ),
        ]);
  }

  Widget _topRight(AppState state) {
    final dpWidth = MediaQuery.of(context).size.width;
    final GeneralState generalState = state.generalState;
    final statuses = generalState.paramList.data!.statuses;
    final locs = generalState.paramList.data!.locations;
    final shifts = generalState.paramList.data!.shifts;

    return Form(
      key: _formStKey,
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 24.0,
          children: [
            KText(
              text: 'New Status',
              fontSize: 18.0,
              fontWeight: FWeight.bold,
              isSelectable: false,
              textColor: ThemeColors.gray2,
            ),
            DropdownWidget(
              value: status?.name,
              hintText: "Status",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 4,
              onChanged: (val) {
                setState(() {
                  status =
                      statuses.firstWhere((element) => element.name == val);
                });
              },
              items: statuses.map((e) => e.name).toList(),
            ),
            DropdownWidget(
              hintText: "Location",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              value: location?.name,
              dropdownOptionsWidth: dpWidth / 4,
              hasSearchBox: true,
              onChanged: (val) {
                setState(() {
                  location = locs.firstWhere((element) => element.name == val);
                });
              },
              items: locs.map((e) => e.name).toList(),
            ),
            DropdownWidget(
              hintText: "Shift",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              value: _shift['displayName'],
              dropdownOptionsWidth: dpWidth / 4,
              hasSearchBox: true,
              onChanged: (val) {
                final int commaId = (val as String).lastIndexOf(", ") + 2;
                final _sh = val.substring(commaId, val.length);
                final _l = val.substring(0, commaId - 2);
                setState(() {
                  _shift['displayName'] =
                      "${locs.firstWhere((element) => element.name == _l).name}, ${shifts.firstWhere((element) => element.name == _sh).name}";
                  _shift['shift'] =
                      shifts.firstWhere((element) => element.name == _sh).id;
                  _shift['location'] =
                      locs.firstWhere((element) => element.name == _l).id;
                });
              },
              items: shifts
                  .where((e) => e.active)
                  .toList()
                  .map((e) =>
                      "${locs.firstWhere((element) => element.toJson()['id'] == e.location_id).name}, ${e.name}")
                  .toList(),
            ),
            TextInputWidget(
              controller: _commentController,
              width: dpWidth / 4,
              maxLines: 4,
              labelText: "Comment",
            ),
            SizedBox(
              width: dpWidth / 4,
              child: SpacedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SpacedRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    horizontalSpace: 8.0,
                    children: [
                      CheckboxWidget(
                        value: stConfirm,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              stConfirm = value;
                            });
                          }
                        },
                      ),
                      KText(
                        text: "Confirm",
                        fontSize: 14.0,
                        textColor: ThemeColors.gray2,
                        isSelectable: false,
                        fontWeight: FWeight.bold,
                      )
                    ],
                  ),
                  ButtonLarge(
                    icon: const HeroIcon(HeroIcons.check),
                    text: "Submit",
                    onPressed: () {
                      if (_formStKey.currentState!.validate()) {}
                    },
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _bottom() {
    final dpWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formMobileKey,
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 8.0,
          children: [
            KText(
              text: 'Mobile Authorization',
              fontSize: 18.0,
              fontWeight: FWeight.bold,
              isSelectable: false,
              textColor: ThemeColors.gray2,
            ),
            KText(
              text: 'Mobile device was last authorized on 22/07/2022 at 06:05',
              fontSize: 16.0,
              isSelectable: false,
              textColor: ThemeColors.gray2,
            ),
            const SizedBox(height: 4.0),
            DropdownWidget(
              hintText: "Action",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 4,
              onChanged: (_) {},
              items: [],
            ),
            const SizedBox(height: 4.0),
            SizedBox(
              width: dpWidth / 4,
              child: SpacedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SpacedRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    horizontalSpace: 8.0,
                    children: [
                      CheckboxWidget(
                        value: true,
                        onChanged: (value) {},
                      ),
                      KText(
                        text: "Confirm",
                        fontSize: 14.0,
                        textColor: ThemeColors.gray2,
                        isSelectable: false,
                        fontWeight: FWeight.bold,
                      )
                    ],
                  ),
                  ButtonLarge(
                    icon: const HeroIcon(HeroIcons.check),
                    text: "Submit",
                    onPressed: () {
                      if (_formMobileKey.currentState!.validate()) {}
                    },
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
