import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/data/model/response/expenses_category_model.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../base/show_custom_popup_menu.dart';

class ExpensesCategoryItem extends StatelessWidget {
  const ExpensesCategoryItem({
    super.key,
    required this.data,
    required this.index,
  });

  final ExpensesCategoryModel data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(
      builder: (expensesController) {
        return InkWell(
          onTap: () {
            final permissionData =
                Get.find<PermissionController>().myPermissionModel!.permission;
            if (permissionData!.updateCategories! ||
                permissionData.deleteCategories!) {
              expensesController.createExpensesCategoryMoreList();
              expensesController.setSelectedExpensesCategoryIndex(index);
              expensesController.editCategoryController.text = data.name ?? '';
              showPopupMenu(
                context,
                expensesController.expensesCategoryMoreList,
              );
            }
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_DEFAULT - 1,
                ),

                // Category name
                child: Text(data.name ?? '-', style: googleSansFlexRegular),
              ),
              Container(
                height: 1,
                color: Theme.of(context).disabledColor.withValues(alpha: .2),
              ),
            ],
          ),
        );
      },
    );
  }
}
