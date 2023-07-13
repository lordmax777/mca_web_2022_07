import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_action.dart';
import 'package:mca_dashboard/utils/utils.dart';

class CommentsViewPopup extends StatefulWidget {
  final ChecklistMd model;
  const CommentsViewPopup({super.key, required this.model});

  @override
  State<CommentsViewPopup> createState() => _CommentsViewPopupState();
}

class _CommentsViewPopupState extends State<CommentsViewPopup> {
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
                      'Comments',
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
                        Text(
                          model.comments[index],
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                  itemCount: model.comments.length,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
