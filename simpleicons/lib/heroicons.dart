library simpleicons;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;

import 'heroicons.dart';
export 'src/icons.dart';

class HeroIcon extends StatelessWidget {
  const HeroIcon(
    this.icon, {
    this.color,
    this.size,
  });

  final HeroIcons icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final path = p.join(
      'packages/simpleicons/assets/icons/',
      icon.name,
    );
    return SvgPicture.asset(
      '$path.svg',
      color: color ?? IconTheme.of(context).color,
      width: size,
      height: size,
      cacheColorFilter: true,
      alignment: Alignment.center,
    );
  }
}
