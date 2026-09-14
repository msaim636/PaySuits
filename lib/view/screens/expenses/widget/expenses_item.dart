// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/data/model/response/exexpenses_model.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/screens/home/widget/custom_horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../base/show_custom_popup_menu.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem({super.key, required this.data, required this.index});

  final ExpensesModel data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(
      builder: (expensesController) {
        return GestureDetector(
          onTap: () {
            final permissionData =
                Get.find<PermissionController>().myPermissionModel!.permission;
            if (permissionData!.updateExpenses! ||
                permissionData.deleteExpenses!) {
              expensesController.createExpensesMoreList();
              expensesController.setSelectedExpensesIndex(index);
              showPopupMenu(context, expensesController.expensesMoreList);
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
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
              vertical: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Get.find<TransactionController>().capitalizeFirstLetter(
                          data.title ?? '-',
                        ),
                        style: googleSansFlexRegular,
                      ),
                      const SizedBox(height: Dimensions.FREE_SIZE_SMALL / 2),
                      RichText(
                        text: TextSpan(
                          text: '${"date_key".tr} : ',
                          style: googleSansFlexRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          ),
                          children: [
                            TextSpan(
                              text: data.date ?? '-',
                              style: googleSansFlexMedium.copyWith(
                                color: LightAppColor.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
                      Container(
                        height: 25,
                        width: 140,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL - 3,
                        ),
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_EXTRA_LARGE,
                          ),
                          color: LightAppColor.lightGreen,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          data.categoryName ?? '-',
                          style: googleSansFlexMedium.copyWith(
                            color: Theme.of(context).indicatorColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Custom divider section
                const CustomHorizontalDivider(height: 60, width: 2),

                // Expenses amount section
                Expanded(
                  flex: 2,
                  child: Text(
                    data.amount ?? '-',
                    textAlign: TextAlign.end,
                    style: googleSansFlexMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
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
