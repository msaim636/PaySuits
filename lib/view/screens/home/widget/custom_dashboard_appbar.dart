// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/controller/notification_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../controller/theme_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../util/images.dart';

class CustomDashBoardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDashBoardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: GetBuilder<DashboardController>(
        builder: (dashboardController) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // profile Image
              dashboardController.profileDetailsModel != null
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getProfileRoute());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        ),
                        child: ClipOval(
                          child:
                              dashboardController
                                          .profileDetailsModel!
                                          .profilePicture !=
                                      null &&
                                  dashboardController
                                      .profileDetailsModel!
                                      .profilePicture!
                                      .isNotEmpty
                              ? CustomImage(
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  image: dashboardController
                                      .profileDetailsModel!
                                      .profilePicture!,
                                )
                              : SvgPicture.asset(
                                  Images.userProfile,
                                  height: 40,
                                  width: 40,
                                  color: Get.isDarkMode
                                      ? LightAppColor.lightGreen
                                      : Theme.of(context).primaryColor,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Get.isDarkMode
                              ? Theme.of(context).cardColor
                              : Colors.grey.shade200,
                        ),
                      ),
                    ),
              const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              // profile name && email
              dashboardController.profileDetailsModel != null
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getProfileRoute());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Get.find<TransactionController>().capitalizeFirstLetter(
                              "${dashboardController.profileDetailsModel!.firstName ?? ""} ${dashboardController.profileDetailsModel!.lastName ?? ""}",
                            ),
                            textAlign: TextAlign.center,
                            style: googleSansFlexRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: Get.isDarkMode
                                  ? LightAppColor.cardColor
                                  : null,
                            ),
                          ),
                          Text(
                            dashboardController
                                        .profileDetailsModel!
                                        .email!
                                        .length >
                                    20
                                ? dashboardController.formatEmail(
                                    dashboardController
                                        .profileDetailsModel!
                                        .email!,
                                  )
                                : dashboardController
                                      .profileDetailsModel!
                                      .email!,
                            textAlign: TextAlign.center,
                            style: googleSansFlexRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Get.isDarkMode
                                  ? LightAppColor.lightGreen
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Theme.of(context).cardColor
                                  : Colors.grey.shade200,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          ),
                          Container(
                            height: 13,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Theme.of(
                                      context,
                                    ).cardColor.withValues(alpha: 0.5)
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
      actions: [
        // Theme button section
        Row(
          children: [
            // Theme button
            GestureDetector(
              onTap: () {
                Get.find<ThemeController>().toggleTheme();
              },
              child: SvgPicture.asset(
                Get.find<ThemeController>().darkTheme
                    ? Images.light
                    : Images.dark,
                height: 22,
                color: Get.isDarkMode
                    ? LightAppColor.cardColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL - 2),

            // Notification button section
            GetBuilder<NotificationController>(
              builder: (notificationController) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getNotificationRoute());
                      },
                      child: SvgPicture.asset(
                        Images.notification,
                        color: Get.isDarkMode
                            ? LightAppColor.cardColor
                            : Theme.of(context).primaryColor,
                        height: 22,
                      ),
                    ),
                    notificationController.notificationReadStatus
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 5,
                              height: 5,
                              color: Colors.red,
                            ),
                          ),
                  ],
                );
              },
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL - 2),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}
