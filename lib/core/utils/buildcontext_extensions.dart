import 'package:flutter/material.dart';

extension BuildcontextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);
  TextTheme get texttheme => Theme.of(this).textTheme;
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
