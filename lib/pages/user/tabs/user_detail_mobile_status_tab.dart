import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../theme/theme.dart';

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
  ListShift? _shift;
  String? shiftItemName;
  final TextEditingController _commentController = TextEditingController();
  bool stConfirm = true;

  bool unauthorize = false;
  bool confirm = true;

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
                  _bottom(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _top(AppState state) {
    final StatussMd? statusMd = state.usersState.userDetailStatus.data;
    if (statusMd == null) return Container();
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
            onChanged: (val) {},
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
    final shifts = generalState.paramList.data!.shifts
        .where((element) => element.active)
        .toList();

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
            DropdownWidget1<ListStatus>(
              hintText: "Status",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 4,
              value: status?.name,
              objItems: statuses,
              hasSearchBox: true,
              items: statuses.map((e) => e.name).toList(),
              onChangedWithObj: (DpItem val) {
                setState(() {
                  status = statuses
                      .firstWhere((element) => element.name == val.name);
                });
              },
            ),
            DropdownWidget1<ListLocation>(
              hintText: "Location",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 4,
              value: location?.name,
              objItems: locs,
              hasSearchBox: true,
              items: locs.map((e) => e.name).toList(),
              onChangedWithObj: (DpItem val) {
                setState(() {
                  location =
                      locs.firstWhere((element) => element.name == val.name);
                });
              },
            ),
            DropdownWidget1<ListShift>(
              hintText: "Shift",
              dropdownBtnWidth: dpWidth / 4,
              isRequired: true,
              dropdownOptionsWidth: dpWidth / 4,
              value: shiftItemName,
              objItems: shifts,
              hasSearchBox: true,
              items: shifts
                  .map((e) =>
                      "${locs.firstWhere((element) => element.toJson()['id'] == e.location_id).name}, ${e.name}")
                  .toList(),
              onChangedWithObj: (DpItem val) {
                setState(() {
                  shiftItemName = val.name;
                  _shift = val.item as ListShift;
                });
              },
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
                    onPressed: stConfirm ? _onStatusSubmit : null,
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Future<void> _onStatusSubmit() async {
    if (_formStKey.currentState!.validate()) {
      await appStore.dispatch(GetPostUserDetailsStatusAction(
        locationId: location!.id,
        shiftId: _shift!.id,
        statusId: status!.id,
        comment: _commentController.text,
      ));
    }
  }

  Widget _bottom(AppState state) {
    final dpWidth = MediaQuery.of(context).size.width;
    final MobileMd? mobile = state.usersState.userDetailMobileIsRegistered.data;

    if (mobile == null) return Container();

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
            if (mobile.isRegistered)
              KText(
                text:
                    'Mobile device was last authorized on ${mobile.registered_on}',
                fontSize: 16.0,
                isSelectable: false,
                textColor: ThemeColors.gray2,
              )
            else
              KText(
                text: 'Mobile device is not registered',
                fontSize: 16.0,
                isSelectable: false,
                textColor: ThemeColors.gray2,
              ),
            const SizedBox(height: 4.0),
            if (mobile.isRegistered)
              DropdownWidget1<bool>(
                hintText: "Action",
                dropdownBtnWidth: dpWidth / 4,
                isRequired: true,
                value: unauthorize ? "Unauthorize" : null,
                dropdownOptionsWidth: dpWidth / 4,
                objItems: const [true],
                onChangedWithObj: (val) {
                  setState(() {
                    unauthorize = val.item as bool;
                  });
                },
                items: const ['Unauthorize'],
              ),
            const SizedBox(height: 4.0),
            SizedBox(
              width: dpWidth / 4,
              child: SpacedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (mobile.isRegistered)
                    SpacedRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      horizontalSpace: 8.0,
                      children: [
                        CheckboxWidget(
                          value: confirm,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                confirm = value;
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
                    onPressed: !confirm
                        ? null
                        : mobile.isRegistered
                            ? _onMobileSubmit
                            : null,
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Future<void> _onMobileSubmit() async {
    if (_formMobileKey.currentState!.validate()) {
      if (unauthorize) {
        await appStore.dispatch(GetDeleteUserDetailsMobileAction());
      } else {
        //Authorize
      }
    }
  }
}
