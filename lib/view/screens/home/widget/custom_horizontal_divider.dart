import 'package:flutter/material.dart';
import '../../../../util/dimensions.dart';

class CustomHorizontalDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const CustomHorizontalDivider({
    super.key,
    this.height,
    this.color,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width,
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
      ),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).disabledColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
