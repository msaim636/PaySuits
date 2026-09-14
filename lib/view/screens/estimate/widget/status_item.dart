// ignore_for_file: deprecated_member_use

import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import '../../../../util/dimensions.dart';

class StatusItem extends StatelessWidget {
  const StatusItem({
    super.key,
    required this.bgColor,
    required this.titleColor,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final Color bgColor;
  final Color titleColor;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: isActive ? bgColor : bgColor.withValues(alpha: .2),
        ),
        child: Text(
          title,
          style: googleSansFlexMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: isActive ? Theme.of(context).indicatorColor : titleColor,
          ),
        ),
      ),
    );
  }
}
