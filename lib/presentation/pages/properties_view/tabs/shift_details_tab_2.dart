import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/elements/default_form.dart';
import 'package:mca_dashboard/presentation/form/elements/form_checkbox.dart';
import 'package:mca_dashboard/presentation/form/elements/form_container.dart';
import 'package:mca_dashboard/presentation/form/elements/form_date_picker.dart';
import 'package:mca_dashboard/presentation/form/elements/form_dropdown.dart';
import 'package:mca_dashboard/presentation/form/elements/form_input.dart';
import 'package:mca_dashboard/presentation/form/elements/form_with_label.dart';
import 'package:mca_dashboard/presentation/form/elements/save_button.dart';
import 'package:mca_dashboard/presentation/form/models/checkbox_model.dart';
import 'package:mca_dashboard/presentation/form/models/date_picker_model.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/form/models/dropdown_model.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';
import 'package:mca_dashboard/presentation/form/models/label_model.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ShiftDetailsTab2 extends StatelessWidget {
  final ValueChanged<ShiftDetailsData> onChanged;
  final ShiftDetailsData data;

  ShiftDetailsTab2({super.key, required this.data, required this.onChanged});

  set data(ShiftDetailsData value) {
    onChanged(value);
  }

  final formVm = FormModel();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final locations = [...vm.lists.locations];
          final clients = [...vm.lists.clients];
          final warehouses = [...vm.lists.warehouses];
          final checklistTemplates = [...vm.checklistTemplates];

          return SingleChildScrollView(
            // padding: const EdgeInsets.only(top: 16),
            child: DefaultForm(
              vm: formVm,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.start,
                runSpacing: 16.0,
                children: [],
              ),
            ),
          );
        });
  }
}
