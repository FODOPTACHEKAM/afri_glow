import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static double width(BuildContext ctx) => MediaQuery.sizeOf(ctx).width;
  static double height(BuildContext ctx) => MediaQuery.sizeOf(ctx).height;

  static bool isTablet(BuildContext ctx) => width(ctx) >= 600;
  static bool isLargePhone(BuildContext ctx) => width(ctx) >= 400;
  static bool isSmallPhone(BuildContext ctx) => width(ctx) < 360;

  /// Number of grid columns — 2 on phones, 3 on tablets.
  static int gridCols(BuildContext ctx, {int phone = 2, int tablet = 3}) =>
      isTablet(ctx) ? tablet : phone;

  /// Scale a font size relative to screen width (360dp baseline).
  static double sp(BuildContext ctx, double base) {
    final w = width(ctx);
    final scale = (w / 360).clamp(0.85, 1.4);
    return base * scale;
  }

  /// Horizontal screen padding — wider on tablets.
  static double hp(BuildContext ctx) {
    if (isTablet(ctx)) return 40.0;
    if (isLargePhone(ctx)) return 24.0;
    return 18.0;
  }

  /// Vertical padding scaled to screen height.
  static double vp(BuildContext ctx, double base) =>
      base * (height(ctx) / 800).clamp(0.8, 1.3);

  /// Full-width symmetric padding.
  static EdgeInsets pagePadding(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: hp(ctx));

  /// Card aspect ratio — slightly taller on tablets.
  static double cardAspect(BuildContext ctx,
          {double phone = 0.82, double tablet = 0.88}) =>
      isTablet(ctx) ? tablet : phone;

  /// Proportional fraction of screen height.
  static double pctH(BuildContext ctx, double pct) => height(ctx) * pct;

  /// Proportional fraction of screen width.
  static double pctW(BuildContext ctx, double pct) => width(ctx) * pct;

  /// Button height scaled to screen.
  static double buttonH(BuildContext ctx) =>
      isSmallPhone(ctx) ? 48.0 : (isTablet(ctx) ? 60.0 : 54.0);

  /// Icon size scaled to screen.
  static double iconSize(BuildContext ctx, {double base = 24}) =>
      isTablet(ctx) ? base * 1.2 : (isSmallPhone(ctx) ? base * 0.9 : base);
}
