import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  final List<Widget>? actions;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.actions,
    this.title,
    this.isBackButtonExist = false,
    this.onBackPressed,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: isBackButtonExist!
          ? GestureDetector(
              onTap: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
              child: Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Get.isDarkMode
                          ? LightAppColor.lightGray
                          : LightAppColor.primarySwatchValueColor,
                    ),
                  ),
                  child: Padding(
                    padding: Get.locale?.languageCode == 'ar'
                        ? EdgeInsets.only(right: 8.0)
                        : EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Get.isDarkMode
                          ? LightAppColor.cardColor
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),

      actions: actions,
      title: title != null
          ? Text(
              title!,
              style: googleSansFlexRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Get.isDarkMode
                    ? LightAppColor.cardColor
                    : Theme.of(context).textTheme.bodyMedium!.color,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, GetPlatform.isDesktop ? 70 : kToolbarHeight);
}
