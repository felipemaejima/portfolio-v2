import 'package:flutter/widgets.dart';

/// APP.md §6: < 600 coluna única; ≥ 900 layout do artboard.
abstract final class Breakpoints {
  static const double compact = 600;
  static const double wide = 900;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compact;
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wide;

  /// Padding lateral das seções: 64 no desktop, 20 no mobile.
  static EdgeInsets pagePadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: isWide(context) ? 64 : 20,
    vertical: isWide(context) ? 72 : 40,
  );
}
