// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TabBarItem extends StatelessWidget {
  final String icon;
  final String title;
  final int index;
  final VoidCallback? onTap;

  const TabBarItem({
    super.key,
    required this.icon,
    this.title = '',
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (navbarController) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // icon or image
                SvgPicture.asset(
                  icon,
                  width: title.isNotEmpty ? 25 : 38,
                  height: title.isNotEmpty ? 25 : 38,
                  color: navbarController.bottomNavbarIndex == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
                SizedBox(
                  height: title.isNotEmpty
                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                      : 0,
                ),

                // title or empty
                title.isNotEmpty
                    ? FittedBox(
                        child: Text(
                          title.tr,
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: navbarController.bottomNavbarIndex == index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
