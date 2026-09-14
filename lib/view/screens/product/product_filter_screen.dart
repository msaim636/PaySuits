// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/controller/product_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_drop_down.dart';

class ProductFilterScreen extends StatelessWidget {
  const ProductFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pro = Get.find<ProductController>();
    final exp = Get.find<ExpensesController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await exp.getCategories(fromProduct: true);
      await pro.getUnits();
    });
    if (exp.categoriesList.isEmpty ||
        pro.unitList.isEmpty ||
        pro.categoriesDWValue == null ||
        pro.unitsDWValue == null) {}

    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(isBackButtonExist: true, title: "filter_key".tr),

      //  Body start
      body: GetBuilder<ProductController>(
        builder: (productController) {
          return GetBuilder<ExpensesController>(
            builder: (expensesController) {
              return GetBuilder<ProductController>(
                builder: (productController) {
                  if (expensesController.categoriesLoading ||
                      productController.unitLoading) {
                    return Center(child: LoadingIndicator());
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FREE SPACE
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),
                              // Payment Method and Date Range section
                              Container(
                                padding: const EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_DEFAULT - 2,
                                  ),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(
                                  children: [
                                    // Category section
                                    GetBuilder<ExpensesController>(
                                      builder: (expensesController) {
                                        return CustomDropDown(
                                          title: 'category_key'.tr,
                                          isRequired: false,
                                          borderColor: Colors.transparent,
                                          dwItems: expensesController
                                              .categoriesStringList,
                                          dwValue: productController
                                              .categoriesDWValue,
                                          hintText: 'choose_a_category_key'.tr,
                                          onChange: (value) {
                                            productController
                                                .setCategoriesDWValue(value);
                                            print('object${value}');
                                          },
                                        );
                                      },
                                    ),

                                    // Free Space
                                    const SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),

                                    // Unit section
                                    CustomDropDown(
                                      isRequired: false,
                                      title: 'unit_key'.tr,
                                      borderColor: Colors.transparent,
                                      dwItems: productController.unitStringList,
                                      dwValue:
                                          productController.unitsFilterDWValue,
                                      hintText: 'choose_a_unit_key'.tr,
                                      onChange: (value) {
                                        productController.setFilterUnitDWValue(
                                          value,
                                        );
                                        print('object${value}');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Button section
                      Padding(
                        padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Row(
                          children: [
                            // Refresh Button
                            InkWell(
                              onTap:
                                  productController.isEmptyFilterForm() == true
                                  ? () {}
                                  : () {
                                      productController.refreshFilterForm();
                                      productController.getProducts();
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_DEFAULT,
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        productController.isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  Images.refresh,
                                  color:
                                      productController.isEmptyFilterForm() ==
                                          true
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),

                            // Free Space
                            const SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Apply Button
                            Expanded(
                              child: CustomButton(
                                onPressed:
                                    productController.applyFilterLoading ||
                                        (productController
                                                .isEmptyFilterForm() ==
                                            true)
                                    ? () {}
                                    : () {
                                        productController
                                            .getProducts(
                                              fromFilter: true,
                                              isApplyFilter: true,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                Get.back();
                                              }
                                            });
                                      },
                                color:
                                    productController.isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).hintColor
                                    : null,
                                buttonText: 'apply_filter_key'.tr,
                                textColor:
                                    productController.isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).indicatorColor,
                                buttonTextWidget:
                                    productController.applyFilterLoading
                                    ? const Center(
                                        child: SizedBox(
                                          height: 23,
                                          width: 23,
                                          child: LoadingIndicator(
                                            isWhiteColor: true,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
