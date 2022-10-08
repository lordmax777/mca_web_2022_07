import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class NewChecklistTemplatePage extends StatefulWidget {
  final int? id;
  const NewChecklistTemplatePage({Key? key, this.id}) : super(key: key);

  @override
  State<NewChecklistTemplatePage> createState() =>
      _NewChecklistTemplatePageState();
}

class _NewChecklistTemplatePageState extends State<NewChecklistTemplatePage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNewContract = true;

  TextEditingController nameContr = TextEditingController();
  TextEditingController titleContr = TextEditingController();

  final List<Widget> _generalItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      isNewContract = false;
    }
  }

  @override
  void dispose() {
    nameContr.dispose();
    titleContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return PageWrapper(
              child: SpacedColumn(verticalSpace: 16.0, children: [
            const PageGobackWidget(),
            TableWrapperWidget(
              padding: const EdgeInsets.only(
                  left: 48.0, right: 48.0, top: 48.0, bottom: 16.0),
              child: Form(
                key: formKey,
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 16.0,
                  children: [
                    _buildBody(dpWidth),
                    const Divider(color: ThemeColors.gray11, thickness: 1.0),
                    _buildExpandable(),
                    _buildAdder(),
                    const Divider(color: ThemeColors.gray11, thickness: 1.0),
                    _SaveAndCancelButtonsWidget(isNewContract: isNewContract),
                  ],
                ),
              ),
            ),
          ]));
        });
  }

  Widget _buildBody(double dpWidth) {
    return SpacedColumn(
      verticalSpace: 32.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputWidget(
          isRequired: true,
          width: dpWidth / 2.5,
          enabled: false,
          labelText: "Template Name",
          controller: nameContr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a name";
            }
          },
        ),
        TextInputWidget(
          isRequired: true,
          width: dpWidth / 2.5,
          labelText: "Template Title",
          controller: titleContr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a title";
            }
          },
        ),
      ],
    );
  }

  Widget _buildAdder() {
    return Container();
  }

  Widget _buildExpandable() {
    return Container();
  }

  Widget _buildExpandableItem(Widget child, String title,
      {bool isExpanded = false}) {
    bool a = true;
    return StatefulBuilder(
      builder: (context, ss) {
        return ExpansionTile(
          maintainState: true,
          initiallyExpanded: isExpanded,
          childrenPadding:
              const EdgeInsets.only(left: 48.0, bottom: 48.0, top: 24.0),
          tilePadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          trailing: const SizedBox(),
          onExpansionChanged: (value) {
            ss(() {
              a = !value;
            });
          },
          // childrenPadding: EdgeInsets.symmetric(vertical: 16.0),
          leading: HeroIcon(!a ? HeroIcons.up : HeroIcons.down, size: 18.0),
          title: KText(
            text: title,
            isSelectable: false,
            fontWeight: FWeight.bold,
            fontSize: 16.0,
            textColor: !a ? ThemeColors.blue6 : ThemeColors.gray2,
          ),
          expandedAlignment: Alignment.topLeft,
          children: [child],
        );
      },
    );
  }
}

class _SaveAndCancelButtonsWidget extends StatelessWidget {
  final bool isNewContract;
  const _SaveAndCancelButtonsWidget({Key? key, this.isNewContract = true})
      : super(key: key);

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
          text: isNewContract ? "Add Contract" : "Save Contract",
          onPressed: () {
            _NewChecklistTemplatePageState.formKey.currentState?.validate();
          },
        ),
      ],
    );
  }
}
