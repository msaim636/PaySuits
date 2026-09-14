// ignore_for_file: deprecated_member_use, unnecessary_import

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';

class DashBoardItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final Color color;
  final bool isCenter;

  const DashBoardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.color,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                height: 18,
                width: 18,
                color: color,
              ),
            ),
          ),
          SizedBox(width: Dimensions.FREE_SIZE_SMALL),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: googleSansFlexRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: googleSansFlexRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
