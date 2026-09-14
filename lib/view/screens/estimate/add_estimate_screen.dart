// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_text_field.dart';
import 'package:paysuite/view/screens/estimate/widget/calculation_item.dart';
import 'package:paysuite/view/base/custom_date_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_snackbar.dart';
import '../../base/loading_indicator.dart';
import '../invoice/widget/product_item_box.dart';

class AddEstimateScreen extends StatelessWidget {
  final String value;
  const AddEstimateScreen({super.key, this.value = '1'});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (int.parse(value) == 2) {
        Get.find<EstimateController>().clearEstimateData();
        await Get.find<EstimateController>().getSuggestedTaxes();
        await Get.find<EstimateController>().getCustomerListDropdown();
        await Get.find<EstimateController>().getProductListDropdown();
        await Get.find<EstimateController>().getEstimateDetails();
      } else {
        Get.find<EstimateController>().clearEstimateData();
        await Get.find<EstimateController>().getSuggestedTaxes();
        await Get.find<EstimateController>().getCustomerListDropdown();
        await Get.find<EstimateController>().getProductListDropdown();
        Get.find<EstimateController>().setSelectedTemplate(0);
        Get.find<EstimateController>().setTemplateListCurrentIndex(0);
      }
    });
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: int.parse(value) == 2 ? "edit_key".tr : "add_estimate_key".tr,
      ),

      //  Body Start
      body: GetBuilder<EstimateController>(
        builder: (estimateController) {
          return estimateController.suggestedAllItemListLoading ||
                  estimateController.getEstimateDetailsLoading
              ? const Center(child: LoadingIndicator())
              : Form(
                  key: estimateController.createEstimateFormKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                //  Customer
                                CustomDropDown(
                                  title: "customer_key".tr,
                                  isRequired: true,
                                  hintText: "choose_a_customer_key".tr,
                                  dwItems: estimateController
                                      .customerDropdownStringList,
                                  dwValue:
                                      estimateController.customerDropdownValue,
                                  borderColor: Colors.transparent,
                                  onChange: (val) => estimateController
                                      .setCustomerDropdownValue(val),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Date
                                    Expanded(
                                      child: SelectDateItemTextField(
                                        header: 'date_key'.tr,
                                        hintText: 'add_date_key'.tr,
                                        svgImagePath: Images.calender,
                                        controller:
                                            estimateController.dateController,
                                        onTap: () {
                                          estimateController.selectDate(
                                            context,
                                            2,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Dimensions.PADDING_SIZE_LARGE,
                                    ),
                                    //  Template
                                    Expanded(
                                      child: SelectDateItemTextField(
                                        header: 'select_template_key'.tr,
                                        hintText: 'select_template_key'.tr,
                                        svgImagePath: Images.template,
                                        fillColor: Theme.of(
                                          context,
                                        ).primaryColor,
                                        hintColorEnable: true,
                                        controller: estimateController
                                            .templateController,
                                        onTap: () {
                                          Get.toNamed(
                                            RouteHelper.getChooseTemplateRoute(
                                              'estimate',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                //  Product
                                CustomDropDown(
                                  title: "product_key".tr,
                                  isRequired: true,
                                  hintText: "choose_a_product_key".tr,
                                  dwItems: estimateController
                                      .productDropdownStringList,
                                  dwValue:
                                      estimateController.productDropdownValue,
                                  borderColor: Colors.transparent,
                                  onChange: (val) => estimateController
                                      .setProductDropdownValue(val!),
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                //  Product item box
                                estimateController
                                        .selectedProductItemList
                                        .isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: estimateController
                                            .selectedProductItemList
                                            .length,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ProductItemBox(
                                            index: index,
                                            selectedProductItemModel:
                                                estimateController
                                                    .selectedProductItemList[index],
                                            isInvoice: false,
                                          );
                                        },
                                      ),
                                SizedBox(
                                  height:
                                      estimateController
                                          .selectedProductItemList
                                          .isEmpty
                                      ? 0
                                      : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //  Discount type
                                    Expanded(
                                      child: CustomDropDown(
                                        title: "discount_type_key".tr,
                                        isRequired: false,
                                        hintText: "choose_a_discount_key".tr,
                                        dwItems: estimateController
                                            .discountListDropdownList,
                                        dwValue: estimateController
                                            .selectedDiscount
                                            .value,
                                        borderColor: Colors.transparent,
                                        onChange: (val) => estimateController
                                            .setDiscountListDropDownValue(val),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL,
                                    ),

                                    //  Discount amount
                                    Expanded(
                                      child: Obx(() {
                                        final isNone =
                                            estimateController
                                                .selectedDiscount
                                                .value ==
                                            'none';
                                        return CustomTextField(
                                          header:
                                              estimateController
                                                      .selectedDiscount
                                                      .value ==
                                                  'percentage'
                                              ? 'discount_percentage_key'.tr
                                              : 'discount_amount_key'.tr,
                                          readOnly: isNone,

                                          isRequired: false,
                                          hintText: '0.00',
                                          inputType:
                                              TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          isOnlyNumber: true,
                                          inputAction: TextInputAction.done,
                                          controller: estimateController
                                              .discountAmountController,
                                          fillColor: Theme.of(
                                            context,
                                          ).cardColor,
                                          onChanged: isNone
                                              ? null
                                              : (value) {
                                                  final amount = value.isEmpty
                                                      ? 0.0
                                                      : double.tryParse(
                                                              value,
                                                            ) ??
                                                            0.0;

                                                  estimateController
                                                      .setDiscount(amount);
                                                  estimateController
                                                      .subTotalCalculation();
                                                  estimateController
                                                      .discountAmountCalculation();
                                                  estimateController
                                                      .totalTaxCalculation();
                                                  estimateController
                                                      .grandTotalCalculation();
                                                },
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                CalculationItem(
                                  title: 'subtotal_key'.tr,
                                  value: estimateController.subTotal
                                      ?.toStringAsFixed(2),
                                  isDismissable: false,
                                  isInvoice: false,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                //  Discount
                                CalculationItem(
                                  title: 'discount_key'.tr,
                                  value:
                                      estimateController.discountAmount == null
                                      ? '0.00'
                                      : estimateController.discountAmount!
                                            .toStringAsFixed(2),
                                  percent:
                                      estimateController
                                              .selectedDiscount
                                              .value ==
                                          'Percentage'
                                      ? "${estimateController.discount} %"
                                      : "${estimateController.discount}",
                                  isDismissable: false,
                                  isInvoice: false,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(
                                    context,
                                  ).disabledColor.withValues(alpha: .3),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                //  Tax
                                CalculationItem(
                                  title: 'tax_key'.tr,
                                  valueWidget: Expanded(
                                    child: CustomDropDown(
                                      isRequired: false,
                                      hintText: "choose_a_taxes_key".tr,
                                      dwItems: estimateController
                                          .suggestedTaxesTitleList,
                                      dwValue: estimateController
                                          .suggestedTaxesDWValue,
                                      borderColor: Colors.transparent,
                                      onChange: (val) => estimateController
                                          .setTaxesDWValue(val!),
                                    ),
                                  ),
                                  isDismissable: false,
                                  isInvoice: false,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                //  Tax Item
                                ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: estimateController
                                      .selectedTaxItemList
                                      .length,
                                  itemBuilder: (context, index) {
                                    final data = estimateController
                                        .selectedTaxItemList[index];
                                    return CalculationItem(
                                      title: "${data.name} (${data.rate})",
                                      titleStyle: googleSansFlexMedium.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: LightAppColor.blackGrey,
                                      ),
                                      value: data.totalTax.toStringAsFixed(2),
                                      index: index,
                                      isInvoice: false,
                                      isDismissable: true,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(
                                    context,
                                  ).disabledColor.withValues(alpha: .3),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                //  Grand Total
                                CalculationItem(
                                  title: 'grand_total_key'.tr,
                                  value: estimateController.grandTotal!
                                      .toStringAsFixed(2),
                                  titleStyle: googleSansFlexBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: LightAppColor.lightOrange,
                                  ),
                                  valueStyle: googleSansFlexBold.copyWith(),
                                  isDismissable: false,
                                  isInvoice: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  Bottom button
                      Padding(
                        padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Row(
                          children: [
                            //  Save Button
                            Expanded(
                              child: CustomButton(
                                radius: Dimensions.RADIUS_DEFAULT - 2,
                                transparent: true,
                                onPressed:
                                    estimateController
                                            .createEstimateSaveLoading ||
                                        estimateController
                                            .updateEstimateSaveLoading
                                    ? () {}
                                    : () async {
                                        if (estimateController
                                            .createEstimateFormKey
                                            .currentState!
                                            .validate()) {
                                          if (estimateController
                                                  .customerDropdownValue ==
                                              null) {
                                            showCustomSnackBar(
                                              'please_select_a_customer_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                              .dateController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_select_a_date_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                                  .selectedTemplate ==
                                              null) {
                                            showCustomSnackBar(
                                              'please_select_a_template_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                              .selectedProductItemList
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_select_your_product_key'
                                                  .tr,
                                              isError: true,
                                            );
                                            return;
                                          }

                                          double da = 0;
                                          if (estimateController
                                              .discountAmountController
                                              .text
                                              .isNotEmpty) {
                                            da = estimateController
                                                .discountAmount!;
                                          }
                                          if (da >
                                              estimateController.subTotal!) {
                                            showCustomSnackBar(
                                              'large_discount_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (int.parse(value) == 2) {
                                            estimateController.updateEstimate(
                                              submitType: 'save',
                                            );
                                          } else {
                                            estimateController.createEstimate(
                                              submitType: 'save',
                                            );
                                          }
                                        }
                                      },
                                buttonTextWidget:
                                    estimateController
                                            .createEstimateSaveLoading ||
                                        estimateController
                                            .updateEstimateSaveLoading
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
                                buttonText: "save_key".tr,
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Send Button
                            Expanded(
                              child: CustomButton(
                                onPressed:
                                    estimateController
                                            .createEstimateSendLoading ||
                                        estimateController
                                            .updateEstimateSendLoading
                                    ? () {}
                                    : () async {
                                        if (estimateController
                                            .createEstimateFormKey
                                            .currentState!
                                            .validate()) {
                                          if (estimateController
                                                  .customerDropdownValue ==
                                              null) {
                                            showCustomSnackBar(
                                              'please_select_a_customer_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                              .dateController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_select_a_date_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                                  .selectedTemplate ==
                                              null) {
                                            showCustomSnackBar(
                                              'please_select_a_template_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (estimateController
                                              .selectedProductItemList
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_select_your_product_key'
                                                  .tr,
                                              isError: true,
                                            );
                                            return;
                                          }

                                          double da = 0;
                                          if (estimateController
                                              .discountAmountController
                                              .text
                                              .isNotEmpty) {
                                            da = estimateController
                                                .discountAmount!;
                                          }
                                          if (da >
                                              estimateController.subTotal!) {
                                            showCustomSnackBar(
                                              'large_discount_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (int.parse(value) == 2) {
                                            estimateController.updateEstimate(
                                              submitType: 'send',
                                            );
                                          } else {
                                            estimateController.createEstimate(
                                              submitType: 'send',
                                            );
                                          }
                                        }
                                      },
                                buttonTextWidget:
                                    estimateController
                                            .createEstimateSendLoading ||
                                        estimateController
                                            .updateEstimateSendLoading
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
                                buttonText: "save_and_send_key".tr,
                                radius: Dimensions.RADIUS_DEFAULT - 2,
                                textColor: Theme.of(context).indicatorColor,
                              ),
                            ),
                          ],
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
