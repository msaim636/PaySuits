// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/confirmation_dialog.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text_field.dart';
import 'widget/expenses_category_item.dart';

class ExpensesCategoryScreen extends StatefulWidget {
  const ExpensesCategoryScreen({super.key});

  @override
  State<ExpensesCategoryScreen> createState() => _ExpensesCategoryScreenState();
}

class _ExpensesCategoryScreenState extends State<ExpensesCategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<ExpensesController>().expensesCategoryPaginateLoading &&
          Get.find<ExpensesController>().expensesCategoryNextPageUrl != null) {
        await Get.find<ExpensesController>().getExpensesCategory(
          isPaginate: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    Get.find<ExpensesController>().getExpensesCategory();
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "expenses_category_key".tr,
        actions: [
          // Add Category button section
          if (permissionData!.createCategories!)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GetBuilder<ExpensesController>(
                      builder: (expensesController) {
                        return ConfirmationDialog(
                          leftBtnTitle: 'cancel_key'.tr,
                          rightBtnTitle: 'save_key'.tr,
                          titleBodyWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'add_expense_category_key'.tr,
                                style: googleSansFlexBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Get.isDarkMode
                                      ? Theme.of(context).indicatorColor
                                      : LightAppColor.blackGrey,
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE,
                              ),
                              CustomTextField(
                                header: 'name_key'.tr,
                                hintText: 'write_category_name_here_key'.tr,
                                fillColor: Theme.of(context).cardColor,
                                controller:
                                    expensesController.addCategoryController,
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE,
                              ),
                            ],
                          ),
                          rightBtnOnTap: () {
                            if (expensesController
                                .addCategoryController
                                .text
                                .isEmpty) {
                              showCustomSnackBar(
                                'please_enter_the_category_name_key'.tr,
                                isError: true,
                              );
                            } else {
                              expensesController.addExpensesCategory();
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                ),
                child: SvgPicture.asset(
                  Images.addCategory,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),

      // Expenses list section
      body: GetBuilder<ExpensesController>(
        builder: (expensesController) {
          return expensesController.expensesCategoryListLoading
              ? const Center(child: LoadingIndicator())
              : expensesController.expensesCategoryList.isEmpty
              ? const NothingToShowHere()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_SMALL,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding:
                                      const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_DEFAULT,
                                      ).copyWith(
                                        top:
                                            Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL -
                                            2,
                                      ),
                                  itemCount: expensesController
                                      .expensesCategoryList
                                      .length,
                                  itemBuilder: (context, index) =>
                                      ExpensesCategoryItem(
                                        data: expensesController
                                            .expensesCategoryList[index],
                                        index: index,
                                      ),
                                ),
                              ),
                              if (expensesController
                                  .expensesCategoryPaginateLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),
                                  child: Center(child: LoadingIndicator()),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
