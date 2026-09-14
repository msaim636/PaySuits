// ignore_for_file: deprecated_member_use
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/expenses_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../data/model/body/add_product_body.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class AddProductScreen extends StatelessWidget {
  final String isUpdate;
  const AddProductScreen({super.key, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final expensesController = Get.find<ExpensesController>();
    productController.refreshProductForm();
    // Start fetching data immediately after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Show loading
      productController.setProductDetailsLoading(true);
      productController.update();

      await expensesController.getCategories(fromProduct: true);
      await productController.getUnits();

      if (isUpdate == '1') {
        await productController.getProductDetails();
        await productController.getUnits();

        // Set Unit
        if (productController.productDetailsModel!.unitId != null) {
          final selectedUnit = productController.unitStringList.firstWhere(
            (element) =>
                element['id'] ==
                productController.productDetailsModel!.unitId.toString(),
            orElse: () => {'id': '', 'value': ''},
          );
          if (selectedUnit['id'] != '') {
            productController.setUnitDWValue(selectedUnit['id']);
          }
        }

        // Set Category
        if (productController.productDetailsModel!.categoryId != null) {
          final selectedCategory = expensesController.categoriesStringList
              .firstWhere(
                (element) =>
                    element['id'] ==
                    productController.productDetailsModel!.categoryId
                        .toString(),
                orElse: () => {'id': '', 'value': ''},
              );
          if (selectedCategory['id'] != '') {
            expensesController.setCategoriesDWValue(selectedCategory['id']);
          }
        }
      }

      // Hide loading
      productController.setProductDetailsLoading(false);
      productController.update();
    });

    return Scaffold(
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: isUpdate == '1' ? "edit_product_key".tr : "add_product_key".tr,
        isBackButtonExist: true,
      ),

      // Body Section
      body: GetBuilder<ProductController>(
        builder: (productController) {
          return (productController.suggestedAllItemListLoading ||
                  productController.unitLoading ||
                  Get.find<ExpensesController>().categoriesLoading ||
                  productController.isProductDetailsLoading)
              ? const Center(child: LoadingIndicator())
              : isUpdate == '1' && productController.productDetailsModel == null
              ? Center(
                  child: Text(
                    "something_wrong_key".tr,
                    style: googleSansFlexMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<ProductController>(
                              builder: (productController) {
                                return Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Your Full Form Fields
                                      CustomTextField(
                                        header: 'name_key'.tr,
                                        hintText: 'product_name_key'.tr,
                                        isRequired: true,
                                        controller: productController
                                            .productNameController,
                                        focusNode: productController
                                            .productNameFocusNode,
                                        nextFocus:
                                            productController.priceFocusNode,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        fillColor: Theme.of(context).cardColor,
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                hintText: "price_key".tr,
                                                header: "price_key".tr,
                                                isRequired: true,
                                                controller: productController
                                                    .priceController,
                                                focusNode: productController
                                                    .priceFocusNode,
                                                nextFocus: productController
                                                    .codeFocusNode,
                                                inputType:
                                                    TextInputType.numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                isOnlyNumber: true,
                                                inputAction:
                                                    TextInputAction.done,
                                                fillColor: Theme.of(
                                                  context,
                                                ).cardColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_DEFAULT,
                                            ),
                                            Expanded(
                                              child: CustomTextField(
                                                hintText: 'code_key'.tr,
                                                header: 'code_key'.tr,
                                                controller: productController
                                                    .codeController,
                                                focusNode: productController
                                                    .codeFocusNode,
                                                inputType: TextInputType.text,
                                                inputAction:
                                                    TextInputAction.next,
                                                fillColor: Theme.of(
                                                  context,
                                                ).cardColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Unit
                                      CustomDropDown(
                                        title: "unit_key".tr,
                                        isRequired: false,
                                        hintText: "choose_a_unit_key".tr,
                                        dwItems:
                                            productController.unitStringList,
                                        dwValue: productController.unitsDWValue,
                                        borderColor: Colors.transparent,
                                        onChange: (val) => productController
                                            .setUnitDWValue(val),
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Category
                                      CustomDropDown(
                                        title: "category_key".tr,
                                        isRequired: false,
                                        hintText: "choose_a_category_key".tr,
                                        dwItems: Get.find<ExpensesController>()
                                            .categoriesStringList,

                                        dwValue: Get.find<ExpensesController>()
                                            .categoriesDWValue,
                                        borderColor: Colors.transparent,
                                        onChange: (val) =>
                                            Get.find<ExpensesController>()
                                                .setCategoriesDWValue(val),
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      CustomTextField(
                                        hintText: 'product_details_key'.tr,
                                        controller: productController
                                            .descriptionController,
                                        focusNode: productController
                                            .descriptionFocusNode,
                                        header: "description_key".tr,
                                        maxLines: 5,
                                        inputAction: TextInputAction.done,
                                        fillColor: Theme.of(context).cardColor,
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE,
                                      ),

                                      // (No buttons here)
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Buttons Always at Bottom (NOT sticky)
                    Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              radius: Dimensions.RADIUS_DEFAULT - 2,
                              color: Colors.transparent,
                              transparent: true,
                              onPressed: () => Get.back(),
                              buttonText: "cancel_key".tr,
                              textColor: Get.isDarkMode
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                          ),
                          Expanded(
                            child: CustomButton(
                              buttonTextWidget:
                                  productController.addProductLoading ||
                                      productController.isProductUpdateLoading
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
                              onPressed:
                                  productController.addProductLoading ||
                                      productController.isProductUpdateLoading
                                  ? () {}
                                  : () {
                                      if (productController
                                          .productNameController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_product_name_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (productController
                                          .priceController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'enter_the_price_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      final productModel = AddProductBody(
                                        productName: productController
                                            .productNameController
                                            .text
                                            .trim(),
                                        price: productController
                                            .priceController
                                            .text
                                            .trim(),
                                        code: productController
                                            .codeController
                                            .text
                                            .trim(),
                                        categoryId:
                                            Get.find<ExpensesController>()
                                                .categoriesDWValue ??
                                            "",
                                        unitId:
                                            productController.unitsDWValue ??
                                            "",
                                        description: productController
                                            .descriptionController
                                            .text
                                            .trim(),
                                      );

                                      if (isUpdate == '1') {
                                        productController
                                            .updateProduct(
                                              addProductBody: productModel,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                Get.back();

                                                showCustomSnackBar(
                                                  value.message,
                                                  isError: false,
                                                );
                                              }
                                            });
                                      } else {
                                        productController
                                            .addProduct(
                                              addProductBody: productModel,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                productController.getProducts();
                                                Get.back();
                                                showCustomSnackBar(
                                                  value.message,
                                                  isError: false,
                                                );
                                              }
                                            });
                                      }
                                    },
                              buttonText: isUpdate == '1'
                                  ? "update_key".tr
                                  : "save_key".tr,
                              textColor: Theme.of(context).indicatorColor,
                              radius: Dimensions.RADIUS_DEFAULT - 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
