import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/checklist_action.dart';

class DamagesViewPopup extends StatefulWidget {
  final ChecklistMd model;
  const DamagesViewPopup({super.key, required this.model});

  @override
  State<DamagesViewPopup> createState() => _DamagesViewPopupState();
}

class _DamagesViewPopupState extends State<DamagesViewPopup> {
  ChecklistMd get model => widget.model;
  final List<ChecklistDamageImageMd> _photos = [];
  final Map<String, List<ChecklistDamageImageMd>> _imagesByRoom = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        fetch();
      }
    });
  }

  void fetch() {
    context.futureLoading(() async {
      final success = await dispatch<List<ChecklistDamageImageMd>>(
          GetChecklistImagesAction(ids: model.ids));
      if (success.isLeft) {
        _photos.addAll(success.left);
        for (var element in _photos) {
          if (_imagesByRoom.containsKey(element.room)) {
            _imagesByRoom[element.room]!.add(element);
          } else {
            _imagesByRoom[element.room] = [element];
          }
        }
        if (mounted) {
          setState(() {});
        }
      } else if (success.isRight) {
        context.showError(success.right.message);
      } else {
        context.showError('Something went wrong');
      }
    });
  }

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
                      'Damages',
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.model.fullTitle,
                      style: context.textTheme.bodyLarge,
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
                width: 600,
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.grey),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemBuilder: (context, index) {
                    final photo = _imagesByRoom.keys.toList()[index];
                    final image = _imagesByRoom[photo]!;
                    logger(image.first.room);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Text(
                          image.first.room,
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          runSpacing: 10,
                          children: [
                            for (var element in image)
                              MaterialButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          titlePadding:
                                              const EdgeInsets.all(10),
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          surfaceTintColor: Colors.white,
                                          title: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: context.pop,
                                            ),
                                          ),
                                          children: [
                                            Image.memory(
                                              element.photoBytes,
                                              width: element.width.toDouble(),
                                              height: element.height.toDouble(),
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        );
                                      });
                                },
                                minWidth: 120,
                                child: Image.memory(
                                  element.photoBytes,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      child: Icon(Icons.error_outline),
                                    );
                                  },
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: _imagesByRoom.length,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
