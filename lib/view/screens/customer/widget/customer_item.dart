// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/customer_controller.dart';
import 'package:paysuite/data/model/response/customer_model.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_image.dart';
import '../../../base/show_custom_popup_menu.dart';

class CustomerItem extends StatelessWidget {
  final CustomerModel customerModel;
  const CustomerItem({super.key, required this.customerModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (customerController) {
        return GestureDetector(
          onTap: () {
            final permissionData =
                Get.find<PermissionController>().myPermissionModel!.permission;

            if (permissionData!.updateCustomers! ||
                permissionData.detailsViewCustomer! ||
                permissionData.deleteCustomers!) {
              customerController.createCustomerMoreList(
                customerModel: customerModel,
              );
              customerController.setCustomerSelectedId(
                id: customerModel.id!,
                status: customerModel.status == "active"
                    ? "status_inactive"
                    : "status_active",
              );
              showPopupMenu(context, customerController.customerMoreList);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
              bottom: Dimensions.PADDING_SIZE_SMALL,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CUSTOMER NAME + INVOICE NUMBER
                    Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Dimensions.RADIUS_EXTRA_LARGE,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.15),
                            child: customerModel.profilePictureUrl != null
                                ? ClipOval(
                                    child: CustomImage(
                                      image: customerModel.profilePictureUrl!,
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 45,
                                    width: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Text(
                                      Get.find<TransactionController>()
                                          .getFirstTwoCapitalLetters(
                                            customerModel.fullName.toString(),
                                          ),
                                      style: googleSansFlexBold.copyWith(
                                        color: Theme.of(context).indicatorColor,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                          Expanded(
                            child: Text(
                              Get.find<TransactionController>()
                                  .capitalizeFirstLetter(
                                    customerModel.fullName.toString(),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: googleSansFlexMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_SMALL,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // LEFT — AMOUNT COLUMN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "email_key".tr,
                                style: googleSansFlexBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                ),
                              ),
                              Text(
                                customerModel.email.toString(),
                                style: googleSansFlexRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // STATUS BADGE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "status_key".tr,
                              style: googleSansFlexBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              ),
                            ),
                            Text(
                              customerModel.status.toString().toLowerCase().tr,
                              style: googleSansFlexRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: customerModel.status == "active"
                                    ? LightAppColor.lightGreen
                                    : customerModel.status == "inactive"
                                    ? Color(0xffff5a3d)
                                    : LightAppColor.lightRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
