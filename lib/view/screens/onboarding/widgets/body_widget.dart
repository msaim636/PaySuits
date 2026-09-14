import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const BodyWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(20),
            child: Image.asset(image, height: 240),
          ),
          const SizedBox(height: 30),
          // Title
          Text(
            title.tr,
            textAlign: TextAlign.center,
            style: googleSansFlexMedium.copyWith(
              fontSize: 24,
              color: LightAppColor.cardColor,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description.tr,
            textAlign: TextAlign.center,
            style: googleSansFlexRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              height: 1.6,
              color: LightAppColor.cardColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
