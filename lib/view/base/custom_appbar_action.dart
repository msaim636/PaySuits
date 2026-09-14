// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';

class CustomAppBarActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? boxSize;
  final double? imagePaddingSize;
  final String? svgImagePath;
  final IconData? icon;
  final Color? bgColor;
  final double? padding;
  const CustomAppBarActionButton({
    super.key,
    required this.onPressed,
    this.boxSize,
    this.imagePaddingSize,
    this.svgImagePath,
    this.icon,
    this.bgColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: padding ?? 0.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: boxSize ?? 36,
          width: boxSize ?? 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Get.isDarkMode
                  ? LightAppColor.lightGrey
                  : Theme.of(context).primaryColor,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(imagePaddingSize ?? 0.0),
              child: svgImagePath != null
                  ? SvgPicture.asset(
                      svgImagePath!,
                      colorFilter: ColorFilter.mode(
                        Get.isDarkMode
                            ? LightAppColor.cardColor
                            : Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(icon, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
