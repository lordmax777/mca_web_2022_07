import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/autocomplete_input_field.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../utils/constants.dart';
import '../../utils/global_functions.dart';
import '../../utils/log_tester.dart';

enum QuickScheduleDrawerResponse {
  emptyQuote;

  String get message {
    switch (this) {
      case QuickScheduleDrawerResponse.emptyQuote:
        return "No ${Constants.propertyName.capitalize} found.\nPlease add ${Constants.propertyName} first.";
    }
  }
}

class QuickScheduleDrawer extends StatefulWidget {
  JobModel? data;
  QuickScheduleDrawer({Key? key, this.data}) : super(key: key) {
    data = data ?? JobModel();
  }

  @override
  State<QuickScheduleDrawer> createState() => _QuickScheduleDrawerState();
}

class _QuickScheduleDrawerState extends State<QuickScheduleDrawer> {
  JobModel get data => widget.data!;

  @override
  void initState() {
    if (appStore.state.generalState.quotes.isEmpty) {
      appStore.dispatch(GetQuotesAction());
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //Do after widget is built
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        if (store.state.generalState.quotes.isEmpty) {
          final List<QuoteInfoMd> quotes =
              await store.dispatch(GetQuotesAction());
          if (quotes.isEmpty) {
            //TODO: Show error
            await Navigator.maybePop(context);
            showError(QuickScheduleDrawerResponse.emptyQuote.message);
          }
          return;
        }
      },
      rebuildOnChange: false,
      builder: (context, state) {
        final allJobs = [...state.generalState.allJobs];
        logger('allJobs: ${allJobs.length}');
        return Drawer(
          width: CalendarConstants.quickScheduleDrawerWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quick Schedule",
                    style: Theme.of(context).textTheme.headline5),
                const Divider(),
                Flexible(
                  child: ListView(
                    children: [
                      _jobField(allJobs.map((e) => e.quote!).toList()),
                      // _team(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _jobField(List<QuoteInfoMd> quotes) {
    return CustomAutocompleteTextField<QuoteInfoMd>(
      hintText: "Select a Job",
      height: 50,
      options: (val) => quotes
          .where((element) =>
              element.name.toLowerCase().contains(val.text.toLowerCase()) ||
              element.addressModel.line1
                  .toLowerCase()
                  .contains(val.text.toLowerCase()))
          .toList(),
      initialValue:
          data.quote != null ? TextEditingValue(text: data.quote!.name) : null,
      displayStringForOption: (p0) => "${p0.name} (${p0.addressModel.line1})",
      listItemWidget: (p0) => ListTile(
        title: Text(p0.name),
        subtitle: Text(p0.addressModel.line1),
        style: ListTileStyle.drawer,
      ),
      onSelected: (quote) {
        setState(() {
          data.quote = quote;
        });
      },
    );
  }
}
