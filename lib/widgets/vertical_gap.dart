import 'package:flutter/material.dart';
import 'package:inovant/core/util/responsive_helper.dart';

class VerticalGap extends StatelessWidget {
  final double gap;
  const VerticalGap(this.gap, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: ResponsiveHelper.scaleGap(context, gap));
  }
}
