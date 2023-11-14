import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_tab_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/storage_items_view/packages_view.dart';
import 'package:mca_dashboard/presentation/pages/storage_items_view/storage_items_view.dart';

class StorageItemsWrapper extends StatefulWidget {
  const StorageItemsWrapper({super.key});

  @override
  State<StorageItemsWrapper> createState() => _StorageItemsWrapperState();
}

class _StorageItemsWrapperState extends State<StorageItemsWrapper> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabWrapper(
      children: [
        TabChild(tabName: "Storage Items", child: StorageItemsView()),
        TabChild(tabName: "Packages", child: PackagesView()),
      ],
    );
  }
}
