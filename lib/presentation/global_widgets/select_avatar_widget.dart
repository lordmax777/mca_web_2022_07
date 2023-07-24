import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class SelectAvatarWidget extends StatefulWidget {
  final Uint8List? image;
  final ValueChanged<PlatformFile>? onImageChanged;
  final double? width;
  final double? height;
  final String? title;
  const SelectAvatarWidget(
      {super.key,
      this.image,
      this.onImageChanged,
      this.width,
      this.height,
      this.title});

  @override
  State<SelectAvatarWidget> createState() => _SelectAvatarWidgetState();
}

class _SelectAvatarWidgetState extends State<SelectAvatarWidget> {
  PlatformFile? file;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.image != null) {
        file = PlatformFile(
          name: "avatar",
          size: widget.image!.length,
          bytes: widget.image!,
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      verticalSpace: 8,
      children: [
        Text(
          widget.title ?? "Avatar",
          style: context.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        MaterialButton(
            onPressed: () async {
              if (!kIsWeb) return;
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );
              if (result != null) {
                file = result.files.first;
                widget.onImageChanged?.call(file!);
                setState(() {});
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: file != null
                      ? Image.memory(
                          file!.bytes!,
                          fit: BoxFit.fitHeight,
                        )
                      : widget.image != null
                          ? Image.memory(
                              widget.image!,
                              fit: BoxFit.fitHeight,
                            )
                          : const SizedBox(),
                ),
                const Positioned(
                    bottom: 10, right: 10, child: Icon(Icons.add_a_photo)),
              ],
            )),
      ],
    );
  }
}
