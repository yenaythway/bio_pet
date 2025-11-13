import 'package:flutter/widgets.dart';

/// Small responsive helpers (width-percent, height-percent, scaled font)
/// Usage:
///   Responsive.wp(context, 50); // 50% of screen width
///   Responsive.hp(context, 10); // 10% of screen height
///   Responsive.sp(context, 16); // scaled font size based on reference width
class Responsive {
  // Base width chosen as a typical mobile device (iPhone 13 w=390)
  static const double _baseWidth = 390.0;

  static double wp(BuildContext context, double percent) {
    final w = MediaQuery.of(context).size.width;
    return w * (percent / 100);
  }

  static double hp(BuildContext context, double percent) {
    final h = MediaQuery.of(context).size.height;
    return h * (percent / 100);
  }

  /// Scale a font size relative to device width using a base reference width.
  static double sp(BuildContext context, double fontSize) {
    final w = MediaQuery.of(context).size.width;
    return fontSize * (w / _baseWidth);
  }
}
