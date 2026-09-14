// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/view/base/loading_indicator.dart';

import '../../../controller/transaction_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import '../../base/custom_image.dart';
import '../../base/show_custom_popup_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "profile_key".tr,
        actions: [
          CustomAppBarActionButton(
            svgImagePath: Images.moreHorizontal,
            onPressed: () {
              Get.find<DashboardController>().createProfileMoreList(context);
              showPopupMenu(
                context,
                Get.find<DashboardController>().profileMoreList,
                addTopHeight: 60,
              );
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          if (controller.isProfileDetailsLoading) {
            return const Center(child: LoadingIndicator());
          }

          final profile = controller.profileDetailsModel;
          if (profile == null) {
            return Center(
              child: Text(
                "something_wrong_key".tr,
                style: googleSansFlexMedium.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: profile.profilePicture != null
                            ? ClipOval(
                                child: CustomImage(
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  image: profile.profilePicture!,
                                ),
                              )
                            : SizedBox(
                                height: 120,
                                width: 120,
                                child: ClipOval(
                                  child: SvgPicture.asset(
                                    Images.userProfile,
                                    fit: BoxFit.contain,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT + 2),
                      Text(
                        profile.fullName ?? "",
                        style: googleSansFlexMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email ?? "",
                        style: googleSansFlexRegular.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Subscriber badge
                      if (profile.isSubscriber == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? LightAppColor.lightGreen.withOpacity(0.1)
                                : Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "subscriber_key".tr,
                            style: googleSansFlexMedium.copyWith(
                              color: Get.isDarkMode
                                  ? LightAppColor.lightGreen
                                  : Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= PERSONAL INFO =================
                _sectionTitle("personal_information_key".tr),

                _infoTile(
                  context: context,
                  icon: Images.firstName,
                  title: "first_name_key".tr,
                  value: Get.find<TransactionController>()
                      .capitalizeFirstLetter(
                        profile.firstName ?? "not_set_key".tr,
                      ),
                ),
                _infoTile(
                  context: context,
                  icon: Images.lastName,
                  title: "last_name_key".tr,
                  value: Get.find<TransactionController>()
                      .capitalizeFirstLetter(
                        profile.lastName ?? "not_set_key".tr,
                      ),
                ),
                _infoTile(
                  context: context,
                  icon: Images.gender,
                  title: "gender_key".tr,
                  value: profile.gender?.toLowerCase().tr ?? "not_set_key".tr,
                ),
                _infoTile(
                  context: context,
                  icon: Images.phone,
                  title: "phone_key".tr,
                  value: profile.phoneNumber != null
                      ? "${profile.phoneCountry ?? ""} ${profile.phoneNumber}"
                      : "not_set_key".tr,
                ),
                _infoTile(
                  context: context,
                  icon: Images.addressIcon,
                  title: "address_key".tr,
                  value: Get.find<TransactionController>()
                      .capitalizeFirstLetter(
                        profile.address ?? "not_set_key".tr,
                      ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: googleSansFlexMedium.copyWith(
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
        ),
      ),
    );
  }

  Widget _infoTile({
    required BuildContext context,
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              Get.isDarkMode
                  ? LightAppColor.cardColor
                  : LightAppColor.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: googleSansFlexRegular.copyWith(
                    color: Colors.grey,
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: googleSansFlexMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
