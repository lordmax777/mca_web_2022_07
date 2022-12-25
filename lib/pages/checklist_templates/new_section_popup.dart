import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:mca_web_2022_07/pages/checklist_templates/controllers/new_template_controller.dart';

import '../../theme/theme.dart';

class NewSectionPopup extends StatefulWidget {
  final String? title;
  const NewSectionPopup({super.key, this.title});

  @override
  State<NewSectionPopup> createState() => _NewSectionPopupState();
}

class _NewSectionPopupState extends State<NewSectionPopup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool isNew = true;
  bool roomExists = false;

  Map<ShortcutActivator, VoidCallback> bindings = {};

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      nameController.text = widget.title!;
      isNew = false;
    }

    nameController.addListener(() {
      setState(() {
        roomExists = NewTemplateController.to.roomExists(nameController.text);
      });
    });

    bindings = {
      LogicalKeySet(LogicalKeyboardKey.enter): _onSave,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    return TableWrapperWidget(
      child: Focus(
        onKey: (node, event) {
          KeyEventResult result = KeyEventResult.ignored;
          // Activates all key bindings that match, returns handled if any handle it.
          for (final ShortcutActivator activator in bindings.keys) {
            if (activator.accepts(event, RawKeyboard.instance)) {
              bindings[activator]!.call();
              result = KeyEventResult.handled;
            }
          }
          return result;
        },
        child: Form(
          key: formKey,
          child: SpacedColumn(children: [
            _header(context),
            const Divider(color: ThemeColors.gray11, height: 1.0),
            const SizedBox(),
            _body(dpWidth),
            const Divider(color: ThemeColors.gray11, height: 1.0),
            _footer(context),
          ]),
        ),
      ),
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
            text: isNew ? 'New Section' : 'Edit Section',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: context.popRoute,
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth) {
    logger('roomExists: $roomExists');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: 8.0,
            children: [
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 5,
                labelText: "Section Name",
                controller: nameController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              if (roomExists)
                KText(
                    text: "Section with this name already exists",
                    textColor: ThemeColors.red3,
                    fontWeight: FWeight.bold,
                    fontSize: 16.0,
                    isSelectable: false),
            ],
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
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
            icon: const HeroIcon(HeroIcons.check, size: 20.0),
            text: isNew ? "Add Section" : "Update Section",
            onPressed: roomExists ? null : _onSave,
          ),
        ],
      ),
    );
  }

  void _onSave() {
    if (formKey.currentState!.validate()) {
      context.popRoute(nameController.text.trim());
    }
  }
}
