// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/payment_controller.dart';
import 'package:paysuite/data/model/response/payment_methods_model.dart';
import 'package:paysuite/util/images.dart';
import 'package:paysuite/view/base/show_custom_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethodsModel data;
  final int index;
  const PaymentMethodItem({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      builder: (paymentController) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          child: GestureDetector(
            onTap: () {
              final permissionData = Get.find<PermissionController>()
                  .myPermissionModel!
                  .permission;
              if (permissionData!.updatePaymentMethods! ||
                  permissionData.deletePaymentMethods!) {
                paymentController.createPaymentMethodMoreList();
                paymentController.setSelectedPaymentIndex(index);
                showPopupMenu(context, paymentController.paymentMoreList);
              }
            },
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              ),
              tileColor: Theme.of(context).cardColor,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL,
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              ),
              horizontalTitleGap: Dimensions.PADDING_SIZE_SMALL,

              // Title
              title: Text(
                data.name.toString(),
                style: googleSansFlexMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                ),
              ),

              // Leading
              leading: CircleAvatar(
                radius: Dimensions.RADIUS_EXTRA_LARGE,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.15),
                child: SvgPicture.asset(
                  Images.payment,
                  color: Theme.of(context).primaryColor,
                  height: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
