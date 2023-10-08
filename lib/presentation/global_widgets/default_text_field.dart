import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

class DefaultTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? label;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool disabled;
  final bool isTextCenter;
  const DefaultTextField(
      {super.key,
      this.onChanged,
      this.enabled = true,
      this.disabled = false,
      this.isTextCenter = false,
      this.label,
      this.keyboardType = TextInputType.text,
      this.maxLines,
      this.focusNode,
      this.initialValue,
      this.onTap,
      this.width,
      this.obscureText = false,
      this.height,
      this.controller,
      this.validator});

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool isObscured = false;

  void toggleObscureText() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode ?? FocusNode(),
      readOnly: !widget.enabled,
      enabled: !widget.disabled,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
          label: widget.label != null
              ? SpacedRow(
                  horizontalSpace: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.label!),
                    if (widget.validator != null)
                      const Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                )
              : null,
          filled: widget.disabled,
          fillColor: widget.disabled ? Colors.grey[200] : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: context.colorScheme.primary)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(color: Colors.red),
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: widget.width ?? 200,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: widget.obscureText ? toggleObscureText : null,
                  icon: Icon(
                    widget.obscureText
                        ? isObscured
                            ? Icons.visibility
                            : Icons.visibility_off
                        : null,
                    color: Colors.grey,
                  ),
                )
              : null),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: widget.disabled ? Colors.grey[600] : Colors.grey[800],
      ),
      mouseCursor: widget.disabled ? SystemMouseCursors.forbidden : null,
      controller: widget.controller,
      obscureText: widget.obscureText ? !isObscured : false,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      inputFormatters: [
        if (widget.keyboardType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }
}
