import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class UserDetailsPayrollTabNewContractPage extends StatefulWidget {
  const UserDetailsPayrollTabNewContractPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPayrollTabNewContractPage> createState() =>
      _UserDetailsPayrollTabNewContractPageState();
}

class _UserDetailsPayrollTabNewContractPageState
    extends State<UserDetailsPayrollTabNewContractPage> {
  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final user = state.usersState.userDetails.data;
          String nameWithUsername = "-";
          if (user != null) {
            nameWithUsername =
                "Next Contract (${user.first_name} ${user.last_name})";
          }
          return PageWrapper(
              child: SpacedColumn(verticalSpace: 16.0, children: [
            PageGobackWidget(text: nameWithUsername),
            TableWrapperWidget(
              padding: const EdgeInsets.only(
                  left: 48.0, right: 48.0, top: 48.0, bottom: 16.0),
              child: SpacedColumn(
                verticalSpace: 16.0,
                children: [
                  SpacedRow(
                    horizontalSpace: dpWidth * .05,
                    children: [
                      _buildLeft(dpWidth),
                      _buildRight(dpWidth),
                    ],
                  ),
                  const Divider(color: ThemeColors.gray11, thickness: 1.0),
                  const _SaveAndCancelButtonsWidget(),
                ],
              ),
            ),
          ]));
        });
  }

  Widget _buildLeft(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            hintText: "Job Title",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Contract Type",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Contract Start Date",
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(2015),
                    firstDate: DateTime(1930),
                    lastDate: DateTime(2035),
                  );
                },
              ),
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Contract End Date",
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(1930),
                    firstDate: DateTime(1930),
                    lastDate: DateTime(2035),
                  );
                },
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Agreed Weekly Hours",
                onTap: () {},
              ),
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Agreed Days per Week",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(),
          _buildLeftBottom(dpWidth),
        ]);
  }

  Widget _buildRight(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            hintText: "Annual Holiday Entitlement Start",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Holiday Calculation Type",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Annual Holiday Entitlement",
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Holidays Carried Over",
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                width: dpWidth / 6,
                labelText: "Paid Lunchtime (min)",
              ),
              TextInputWidget(
                width: dpWidth / 6,
                labelText: "Unpaid Lunchtime (min)",
              ),
            ],
          ),
        ]);
  }

  Widget _buildLeftBottom(double dpWidth) {
    return SpacedColumn(verticalSpace: 24.0, children: [
      _buildSalary(dpWidth, 'Salary Per Hour', true),
      _buildSalary(dpWidth, 'Salary Per Hour (Overtime)', false),
      _buildSalary(dpWidth, 'Salary Per Annum', true),
    ]);
  }

  Widget _buildSalary(double dpWidth, String label, bool isRequired) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200.0,
          child: SpacedRow(
            horizontalSpace: 4.0,
            children: [
              KText(
                  text: label,
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  fontSize: 14.0,
                  textColor: ThemeColors.gray2),
              if (isRequired)
                KText(
                  text: '*',
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  fontSize: 14.0,
                  textColor: ThemeColors.red3,
                ),
            ],
          ),
        ),
        TextInputWidget(
          width: dpWidth / 8,
          hintText: "0.00",
          rightIcon: HeroIcons.pound,
          onTap: () {},
        ),
      ],
    );
  }
}

class _SaveAndCancelButtonsWidget extends StatelessWidget {
  const _SaveAndCancelButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      mainAxisAlignment: MainAxisAlignment.end,
      horizontalSpace: 14.0,
      children: [
        ButtonLargeSecondary(
          paddingWithoutIcon: true,
          text: "Cancel",
          onPressed: () {
            context.navigateBack();
          },
          bgColor: ThemeColors.white,
        ),
        ButtonLarge(
          icon: const HeroIcon(HeroIcons.check),
          text: "Add Contract",
          onPressed: () {},
        ),
      ],
    );
  }
}
