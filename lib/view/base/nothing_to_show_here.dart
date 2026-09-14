import 'package:paysuite/util/images.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../util/dimensions.dart';

class NothingToShowHere extends StatelessWidget {
  const NothingToShowHere({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Get.isDarkMode
                ? Images.nothing_to_show_here_dark
                : Images.nothing_to_show_here,
            width: 130,
            height: 130,
          ),
          SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
          Text(
            "no_records_available_key".tr,
            style: googleSansFlexMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Get.isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
