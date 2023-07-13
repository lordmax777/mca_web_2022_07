import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

class UsersViewPopup extends StatefulWidget {
  final ChecklistMd model;
  const UsersViewPopup({super.key, required this.model});

  @override
  State<UsersViewPopup> createState() => _UsersViewPopupState();
}

class _UsersViewPopupState extends State<UsersViewPopup> {
  ChecklistMd get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SimpleDialog(
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            title: Row(
              children: [
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users',
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.model.fullTitle,
                      style: context.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    //date
                    if (model.updatedOnDt != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat("HH:mm, dd/MM/yyyy")
                                .format(model.updatedOnDt!),
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: context.pop,
                ),
                const SizedBox(width: 20),
              ],
            ),
            children: [
              SizedBox(
                width: 400,
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.grey),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        SpacedRow(
                          horizontalSpace: 10,
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 350,
                              child: Text(
                                model.users[index].fullname ?? "-",
                                maxLines: 10,
                                softWrap: true,
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: model.users.length,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
