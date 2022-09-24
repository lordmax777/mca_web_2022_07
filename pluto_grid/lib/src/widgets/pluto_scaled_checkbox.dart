import 'package:flutter/material.dart';

class PlutoScaledCheckbox extends StatelessWidget {
  final bool? value;

  final Function(bool? changed) handleOnChanged;

  final bool tristate;

  final double scale;

  final Color unselectedColor;

  final Color? activeColor;

  final Color checkColor;

  PlutoScaledCheckbox({
    Key? key,
    required this.value,
    required this.handleOnChanged,
    this.tristate = false,
    this.scale = 2.0,
    this.unselectedColor = Colors.black26,
    this.activeColor = Colors.lightBlue,
    this.checkColor = const Color(0xFF003CFF),
  }) : super(key: key);

  final Color _checkColor = Colors.white;
  final Color _activeBgColor = const Color(0xFF003CFF);
  final Color _inactiveBgColor = Colors.transparent;
  final double _scale = 1.2;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: Checkbox(
        value: value,
        splashRadius: 15,
        side: BorderSide(
          color: value == true ? _activeBgColor : const Color(0xFFE8E8EA),
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.5)),
        tristate: tristate,
        onChanged: handleOnChanged,
        activeColor: value == null ? _inactiveBgColor : _activeBgColor,
        checkColor: _checkColor,
      ),
    );
  }
}
