import 'package:flutter/material.dart';

enum ScreenType { phone, tablet, desktop }

enum OrientationType { portrait, landscape }

class ResponsiveHelper {
  // Get screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return ScreenType.desktop;
    } else if (width >= 600) {
      return ScreenType.tablet;
    } else {
      return ScreenType.phone;
    }
  }

  // Get orientation type
  static OrientationType getOrientationType(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return OrientationType.portrait;
    } else {
      return OrientationType.landscape;
    }
  }

  // Get responsive value based on screen type
  static double getResponsiveValue({
    required BuildContext context,
    required double phone,
    double? tablet,
    double? desktop,
  }) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.tablet:
        return tablet ?? phone;
      case ScreenType.desktop:
        return desktop ?? tablet ?? phone;
      default:
        return phone;
    }
  }

  // Check if device is phone
  static bool isPhone(BuildContext context) =>
      getScreenType(context) == ScreenType.phone;
  // Check if device is tablet
  static bool isTablet(BuildContext context) =>
      getScreenType(context) == ScreenType.tablet;
  // Check if device is desktop
  static bool isDesktop(BuildContext context) =>
      getScreenType(context) == ScreenType.desktop;
  // Check if orientation is portrait
  static bool isPortrait(BuildContext context) =>
      getOrientationType(context) == OrientationType.portrait;
  // Check if orientation is landscape
  static bool isLandscape(BuildContext context) =>
      getOrientationType(context) == OrientationType.landscape;
  // Get screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get text size based on screen width and user-defined text scaling
  static double getTextSize(BuildContext context, {double scale = 0.03}) {
    final screenWidth = getWidth(context);
    return screenWidth * scale;
  }

  // New Methods for Scaling Dimensions

  // Scale width based on reference screen width
  static double scaleWidth(
    BuildContext context,
    double referenceWidth, {
    double baseWidth = 393.0,
  }) {
    double screenWidth = getWidth(context);
    return (referenceWidth / baseWidth) * screenWidth;
  }

  // Scale height based on reference screen height
  static double scaleHeight(
    BuildContext context,
    double referenceHeight, {
    double baseHeight = 852.0,
  }) {
    double screenHeight = getHeight(context);
    return (referenceHeight / baseHeight) * screenHeight;
  }

  // Scale padding
  static EdgeInsets scalePadding(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: scaleWidth(context, horizontal),
      vertical: scaleHeight(context, vertical),
    );
  }

  //Scale Margin
  static EdgeInsets scaleMargin(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.only(
      left:
          left > 0
              ? scaleWidth(context, left)
              : scaleWidth(context, horizontal),
      right:
          right > 0
              ? scaleWidth(context, right)
              : scaleWidth(context, horizontal),
      top: top > 0 ? scaleHeight(context, top) : scaleHeight(context, vertical),
      bottom:
          bottom > 0
              ? scaleHeight(context, bottom)
              : scaleHeight(context, vertical),
    );
  }

  // Scale gaps (vertical spacing)
  static double scaleGap(
    BuildContext context,
    double referenceGap, {
    double baseHeight = 852.0,
  }) {
    return scaleHeight(context, referenceGap, baseHeight: baseHeight);
  }

  // Scale radius for rounded corners
  static double scaleRadius(
    BuildContext context,
    double referenceRadius, {
    double baseWidth = 393.0,
  }) {
    return scaleWidth(context, referenceRadius, baseWidth: baseWidth);
  }
}
