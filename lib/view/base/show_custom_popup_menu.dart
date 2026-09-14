// ignore_for_file: deprecated_member_use, overridden_fields, annotate_overrides

import 'package:paysuite/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../data/model/body/popup_model.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

void showPopupMenu(
  BuildContext context,
  List<PopupModel> list, {
  bool isGridView = false,
  double addTopHeight = 0.0,
}) async {
  final RenderBox cardRenderBox = context.findRenderObject() as RenderBox;
  final Offset cardPosition = cardRenderBox.localToGlobal(Offset.zero);

  // Detect RTL / LTR automatically
  final bool isRTL = Directionality.of(context) == TextDirection.rtl;

  await showMenu(
    context: context,
    color: Theme.of(context).cardColor,
    surfaceTintColor: Get.isDarkMode
        ? LightAppColor.blackGrey
        : LightAppColor.cardColor,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
    ),

    //  RTL / LTR aware position
    position: RelativeRect.fromLTRB(
      isRTL
          // RTL: popup opens from LEFT
          ? cardPosition.dx - 160
          // LTR: popup opens from RIGHT
          : (isGridView
                ? cardPosition.dx + (cardRenderBox.size.width / 2 - 20)
                : cardPosition.dx + cardRenderBox.size.width + 20),

      cardPosition.dy + addTopHeight,

      isRTL
          ? cardPosition.dx + cardRenderBox.size.width
          : cardPosition.dx + cardRenderBox.size.width + 50,

      cardPosition.dy + cardRenderBox.size.height + addTopHeight,
    ),

    items: List.generate(
      list.length,
      (index) => PopupMenuItem(
        padding: EdgeInsets.zero,
        enabled: true,
        onTap: () {
          if (list[index].isRoute) {
            if (list[index].route.isNotEmpty) {
              Get.toNamed(list[index].route);
            }
          } else if (list[index].onTap != null) {
            list[index].onTap!();
          } else if (list[index].widget != null) {
            Get.dialog(list[index].widget!);
          }
        },

        child: SizedBox(
          width: isRTL ? 160 : 200,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // Icon
                    SvgPicture.asset(
                      list[index].image,
                      width: 20,
                      height: 20,
                      color: Get.isDarkMode
                          ? Theme.of(context).indicatorColor
                          : const Color(0xff1F2A37),
                    ),

                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    // Title
                    Expanded(
                      child: Text(
                        list[index].title.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: googleSansFlexRegular.copyWith(
                          // fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          color: Get.isDarkMode
                              ? Theme.of(context).indicatorColor
                              : const Color(0xff1F2A37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              if (index != list.length - 1)
                Divider(
                  height: 0.3,
                  thickness: 0.3,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
