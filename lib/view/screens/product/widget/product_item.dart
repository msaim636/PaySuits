// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/product_controller.dart';
import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/data/model/response/product_model.dart';
import 'package:paysuite/view/base/show_custom_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return GestureDetector(
          onTap: () {
            final permissionData =
                Get.find<PermissionController>().myPermissionModel!.permission;
            if (permissionData!.updateProducts! ||
                permissionData.deleteProducts!) {
              productController.createProductMoreList();
              productController.setProductSelectedId(id: productModel.id!);
              showPopupMenu(context, productController.productMoreList);
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: Dimensions.PADDING_SIZE_SMALL,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
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
                // Product Name + Product Number
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Get.find<TransactionController>()
                                .capitalizeFirstLetter(
                                  productModel.name.toString(),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // STATUS BADGE
                    if (productModel.categoryName != null)
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          decoration: BoxDecoration(
                            color: LightAppColor.lightOrange,
                            borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_SMALL,
                            ),
                          ),
                          child: Text(
                            "${productModel.categoryName?.toLowerCase().tr}",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              color: LightAppColor.cardColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                            ),
                          ),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT — AMOUNT COLUMN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "product_no_key".tr,
                              style: googleSansFlexBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              ),
                            ),
                            productModel.code != null
                                ? Text(
                                    productModel.code.toString(),
                                    style: googleSansFlexRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                      // MIDDLE — DUE AMOUNT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "amount_key".tr,
                            style: googleSansFlexBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            ),
                          ),
                          Text(
                            productModel.price.toString(),
                            style: googleSansFlexRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(
                                context,
                              ).colorScheme.error.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //
              ],
            ),
          ),
        );
      },
    );
  }
}
