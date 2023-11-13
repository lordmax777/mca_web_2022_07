import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_tab_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/pages.dart';

class QuotesWrapper extends StatelessWidget {
  const QuotesWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabWrapper(
      children: [
        TabChild(tabName: "Quotes", child: QuotesView()),
        TabChild(tabName: "Jobs", child: QuotesView(isJob: true)),
        TabChild(tabName: "Invoices", child: QuotesView(isInvoice: true)),
      ],
    );
  }
}
