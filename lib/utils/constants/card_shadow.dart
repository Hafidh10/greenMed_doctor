import 'package:flutter/material.dart';

import 'colors.dart';

class SkiiveCardShadow {
  static final verticalCardShadow = BoxShadow(
    color: SkiiveColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}
