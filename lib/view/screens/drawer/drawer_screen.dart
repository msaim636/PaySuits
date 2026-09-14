// ignore_for_file: deprecated_member_use, unused_element_parameter
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/controller/settings_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../util/images.dart';
import '../../base/confirmation_dialog.dart';

class MoreScreenDrawer extends StatefulWidget {
  const MoreScreenDrawer({super.key});

  @override
  State<MoreScreenDrawer> createState() => _MoreScreenDrawerState();
}

class _MoreScreenDrawerState extends State<MoreScreenDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.find<PermissionController>().getPermission();
      await Get.find<PermissionController>().getPermissionInfo();
    });
    final theme = Theme.of(context);
    // Detect RTL / LTR automatically
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          // Switch the radius side based on RTL
          left: isRTL
              ? const Radius.circular(Dimensions.RADIUS_EXTRA_LARGE + 5)
              : Radius.zero,
          right: !isRTL
              ? const Radius.circular(Dimensions.RADIUS_EXTRA_LARGE + 5)
              : Radius.zero,
        ),
      ),
      child: Column(
        children: [
          // HEADER
          LayoutBuilder(
            builder: (context, constraints) {
              final theme = Theme.of(context);
              final statusBarHeight = MediaQuery.of(context).padding.top;
              final headerHeight = statusBarHeight + 80;

              return Stack(
                children: [
                  // Background
                  Container(
                    width: double.infinity,
                    height: headerHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor.withOpacity(0.9),
                          theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        // Switch the bottom radius based on RTL
                        bottomLeft: isRTL
                            ? const Radius.circular(
                                Dimensions.RADIUS_EXTRA_LARGE + 5,
                              )
                            : Radius.zero,
                        bottomRight: !isRTL
                            ? const Radius.circular(
                                Dimensions.RADIUS_EXTRA_LARGE + 5,
                              )
                            : Radius.zero,
                      ),
                    ),
                  ),

                  // Content inside SafeArea
                  Positioned(
                    top: statusBarHeight + Dimensions.FREE_SIZE_SMALL,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 220,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: GetBuilder<SettingsController>(
                              builder: (ctrl) {
                                if (ctrl.isCompanyDetailsLoading) {
                                  return const SizedBox(height: 60);
                                }

                                return ctrl.companyDetailsModel?.companyLogo !=
                                            null &&
                                        ctrl
                                            .companyDetailsModel!
                                            .companyLogo!
                                            .isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          "${ctrl.companyDetailsModel?.companyLogo}",
                                          height: 40,
                                          fit: BoxFit.contain,
                                          color: LightAppColor.cardColor,
                                          errorBuilder: (_, _, _) =>
                                              SvgPicture.asset(
                                                Images.splashLogo,
                                                width: 50,
                                                height: 40,
                                                color: LightAppColor.cardColor,
                                              ),
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        Images.splashLogo,
                                        width: 50,
                                        height: 40,
                                        color: LightAppColor.cardColor,
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
          // MENU ITEMS
          Expanded(
            child: GetBuilder<HomeController>(
              builder: (controller) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  itemCount: controller.menuItems.length,
                  itemBuilder: (context, index) {
                    final menu = controller.menuItems[index];
                    final isSelected = controller.menuItemListIndex == index;

                    // Normal menu
                    return _DrawerItem(
                      menu: menu,
                      isSelected: isSelected,
                      onTap: () {
                        Get.back();
                        controller.selectMenuItem(index);
                        menu.onTap.call();
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

          // LOGOUT
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            decoration: BoxDecoration(
              color: LightAppColor.lightRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              onTap: () {
                Get.back();
                Get.dialog(
                  ConfirmationDialog(
                    imageHeight: 60,
                    svgImagePath: Images.logoutIcon,
                    svgImageColor: Theme.of(context).colorScheme.error,
                    title: "are_you_sure_you_want_to_logout_key".tr,
                    leftBtnTitle: 'no_key'.tr,
                    rightBtnTitle: "yes_key".tr,
                    rightBtnOnTap: () {
                      Get.find<AuthController>().clearSharedData();
                      Get.find<PermissionController>()
                              .myPermissionModel!
                              .permission =
                          null;
                      Get.offAllNamed(RouteHelper.getLoginRoute());
                      Get.find<AuthController>().logOutFromGoogleLogin();
                    },
                    leftBtnOnTap: () => Get.back(),
                  ),
                  useSafeArea: false,
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Row(
                children: [
                  SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                  SvgPicture.asset(
                    Images.logoutIcon,
                    width: 22,
                    color: LightAppColor.lightRed,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'logout_key'.tr,
                    style: googleSansFlexMedium.copyWith(
                      color: LightAppColor.lightRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),
    );
  }
}

// Drawer main item
class _DrawerItem extends StatelessWidget {
  final dynamic menu;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showArrow;
  final bool isExpanded;

  const _DrawerItem({
    required this.menu,
    required this.isSelected,
    required this.onTap,
    this.showArrow = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL - 2,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.primaryColor.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        ),
        leading: SvgPicture.asset(
          menu.icon,
          width: 22,
          color: isSelected
              ? Get.isDarkMode
                    ? LightAppColor.cardColor
                    : theme.primaryColor
              : Get.isDarkMode
              ? LightAppColor.cardColor
              : theme.primaryColor,
        ),
        title: Text(
          "${menu.title}".tr,
          style: googleSansFlexMedium.copyWith(
            color: isSelected
                ? Get.isDarkMode
                      ? LightAppColor.cardColor
                      : theme.primaryColor
                : Get.isDarkMode
                ? LightAppColor.cardColor
                : theme.textTheme.displayLarge!.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: showArrow
            ? Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Get.isDarkMode
                    ? LightAppColor.cardColor
                    : theme.disabledColor,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
