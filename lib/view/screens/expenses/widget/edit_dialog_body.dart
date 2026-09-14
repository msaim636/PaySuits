// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_text_field.dart';

class EditDialogBody extends StatelessWidget {
  const EditDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'update_expense_category_key'.tr,
          style: googleSansFlexBold.copyWith(
            fontSize: Dimensions.FONT_SIZE_LARGE,
            color: Get.isDarkMode
                ? Theme.of(context).indicatorColor
                : LightAppColor.blackGrey,
          ),
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        CustomTextField(
          header: 'name_key'.tr,
          hintText: 'write_category_name_here_key'.tr,
          fillColor: Theme.of(context).cardColor,
          controller: Get.find<ExpensesController>().editCategoryController,
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      ],
    );
  }
}
