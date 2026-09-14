// ignore_for_file: deprecated_member_use

import 'package:paysuite/data/model/response/notification_model.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../util/images.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.data});
  final NotificationData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
        ),
        tileColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),

        leading: CircleAvatar(
          radius: Dimensions.RADIUS_EXTRA_LARGE,
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.2),
          child: SvgPicture.asset(
            Images.notificationBox,
            color: Get.isDarkMode
                ? Theme.of(context).indicatorColor
                : Theme.of(context).primaryColor,
            height: 36,
            width: 36,
          ),
        ),

        title: Text(
          data?.title ?? '',
          style: googleSansFlexRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_DEFAULT,
            color: Colors.amber,
          ),
        ),

        subtitle: Text(
          data?.message ?? '',
          style: googleSansFlexRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
