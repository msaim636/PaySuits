// ignore_for_file: deprecated_member_use

import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_drop_down.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/custom_text_field.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/screens/estimate/widget/calculation_item.dart';
import 'package:paysuite/view/base/custom_date_item.dart';
import 'package:paysuite/view/screens/invoice/widget/product_item_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/invoice_controller.dart';
import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';

class CreateInvoiceScreen extends StatelessWidget {
  final String value;
  const CreateInvoiceScreen({super.key, this.value = '1'});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (int.parse(value) == 2) {
        Get.find<InvoiceController>().clearInvoiceData();
        await Get.find<InvoiceController>().getSuggestedTaxes();
        await Get.find<InvoiceController>().getCustomerListDropdown();
        await Get.find<InvoiceController>().getProductListDropdown();
        await Get.find<InvoiceController>().getInvoiceDetails();
      } else {
        Get.find<InvoiceController>().clearInvoiceData();
        await Get.find<InvoiceController>().getSuggestedTaxes();
        await Get.find<InvoiceController>().getCustomerListDropdown();
        await Get.find<InvoiceController>().getProductListDropdown();
        Get.find<InvoiceController>().setSelectedTemplate(0);
        Get.find<InvoiceController>().setTemplateListCurrentIndex(0);
      }
    });
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: int.parse(value) == 2 ? "edit_key".tr : "create_invoice_key".tr,
      ),

      body: GetBuilder<InvoiceController>(
        builder: (invoiceController) {
          if (invoiceController.suggestedAllItemListLoading ||
              invoiceController.getInvoiceDetailsLoading) {
            return const Center(child: LoadingIndicator());
          } else {
            return Form(
              key: invoiceController.createInvoiceFormKey,
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

                            // Customer
                            CustomDropDown(
                              title: 'customer_key'.tr,
                              isRequired: true,
                              dwItems:
                                  invoiceController.customerDropdownStringList,
                              dwValue: invoiceController.customerDropdownValue,
                              hintText: 'choose_a_customer_key'.tr,
                              borderColor: Colors.transparent,
                              onChange: (value) {
                                invoiceController.setCustomerDropdownValue(
                                  value,
                                );
                              },
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            Row(
                              children: [
                                //  Issue Date
                                Expanded(
                                  child: SelectDateItemTextField(
                                    header: 'issue_date_key'.tr,
                                    hintText: 'issue_date_key'.tr,
                                    svgImagePath: Images.calender,
                                    controller:
                                        invoiceController.issueDateController,
                                    onTap: () {
                                      invoiceController.selectDate(context, 2);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: Dimensions.PADDING_SIZE_LARGE,
                                ),

                                //  Due Date
                                Expanded(
                                  child: SelectDateItemTextField(
                                    header: 'due_date_key'.tr,
                                    hintText: 'due_date_key'.tr,
                                    svgImagePath: Images.calender,
                                    controller:
                                        invoiceController.dueDateController,
                                    onTap: () {
                                      if (invoiceController
                                          .issueDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_issue_date_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      invoiceController.selectDate(context, 3);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            //  Reference number
                            CustomTextField(
                              header: 'reference_number_key'.tr,
                              isRequired: false,
                              hintText: 'type_reference_number_key'.tr,
                              controller: invoiceController.refNumberController,
                              focusNode: invoiceController.refNumberFocusNode,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            //  Template
                            SelectDateItemTextField(
                              header: 'select_template_key'.tr,
                              hintText: 'select_template_key'.tr,
                              svgImagePath: Images.template,
                              fillColor: Theme.of(context).primaryColor,
                              hintColorEnable: true,
                              controller: invoiceController.templateController,
                              onTap: () {
                                Get.toNamed(
                                  RouteHelper.getChooseTemplateRoute('invoice'),
                                );
                              },
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            //  Product
                            CustomDropDown(
                              title: 'product_key'.tr,
                              isRequired: true,
                              dwItems:
                                  invoiceController.productDropdownStringList,
                              dwValue: invoiceController.productDropdownValue,
                              hintText: 'choose_a_product_key'.tr,
                              borderColor: Colors.transparent,
                              onChange: (value) {
                                print("object $value");
                                invoiceController.setProductDropdownValue(
                                  value,
                                );
                              },
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            // Product item box
                            invoiceController.selectedProductItemList.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    itemCount: invoiceController
                                        .selectedProductItemList
                                        .length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return ProductItemBox(
                                        index: index,
                                        selectedProductItemModel:
                                            invoiceController
                                                .selectedProductItemList[index],
                                        isInvoice: true,
                                      );
                                    },
                                  ),
                            SizedBox(
                              height:
                                  invoiceController
                                      .selectedProductItemList
                                      .isEmpty
                                  ? 0
                                  : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            Row(
                              children: [
                                //  Discount type
                                Expanded(
                                  child: CustomDropDown(
                                    title: 'discount_type_key'.tr,
                                    isRequired: false,
                                    dwItems: invoiceController
                                        .discountListDropdownList,
                                    dwValue: invoiceController
                                        .selectedDiscount
                                        .value,
                                    hintText: 'choose_a_discount_key'.tr,
                                    borderColor: Colors.transparent,
                                    onChange: (val) {
                                      invoiceController
                                          .setDiscountListDropDownValue(val);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: Dimensions.PADDING_SIZE_LARGE,
                                ),

                                //  Discount amount
                                Expanded(
                                  child: Obx(() {
                                    final isNone =
                                        invoiceController
                                            .selectedDiscount
                                            .value ==
                                        'none';
                                    return CustomTextField(
                                      header: 'discount_amount_key'.tr,
                                      isRequired: false,
                                      readOnly: isNone,
                                      hintText: '0.00',
                                      inputType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      isOnlyNumber: true,
                                      inputAction: TextInputAction.done,
                                      controller: invoiceController
                                          .discountAmountController,
                                      fillColor: Theme.of(context).cardColor,
                                      onChanged: isNone
                                          ? null
                                          : (value) {
                                              final amount = value.isEmpty
                                                  ? 0.0
                                                  : double.tryParse(value) ??
                                                        0.0;
                                              invoiceController.setDiscount(
                                                amount,
                                              );
                                              invoiceController
                                                  .subTotalCalculation();
                                              invoiceController
                                                  .discountAmountCalculation();
                                              invoiceController
                                                  .totalTaxCalculation();
                                              invoiceController
                                                  .grandTotalCalculation();
                                              invoiceController
                                                  .dueAmountCalculation();
                                            },
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            // Sub Total
                            CalculationItem(
                              title: 'subtotal_key'.tr,
                              value: invoiceController.subTotal.toString(),
                              isDismissable: false,
                              isInvoice: true,
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Discount
                            CalculationItem(
                              title: 'discount_key'.tr,
                              value: invoiceController.discountAmount == null
                                  ? '0.00'
                                  : invoiceController.discountAmount!
                                        .toStringAsFixed(2),
                              percent:
                                  invoiceController.selectedDiscount.value ==
                                      'Percentage'
                                  ? "${invoiceController.discount} %"
                                  : "${invoiceController.discount}",
                              isDismissable: false,
                              isInvoice: true,
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
                              titleStyle: googleSansFlexRegular.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color,
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              ),
                              valueWidget: Expanded(
                                child: CustomDropDown(
                                  isRequired: false,
                                  dwItems:
                                      invoiceController.suggestedTaxesTitleList,
                                  dwValue:
                                      invoiceController.suggestedTaxesDWValue,
                                  hintText: 'choose_a_taxes_key'.tr,
                                  borderColor: Colors.transparent,
                                  onChange: (val) {
                                    invoiceController.setTaxesDWValue(val!);
                                  },
                                ),
                              ),
                              isDismissable: false,
                              isInvoice: true,
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            //  Tax amount
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount:
                                  invoiceController.selectedTaxItemList.length,
                              itemBuilder: (context, index) {
                                final data = invoiceController
                                    .selectedTaxItemList[index];
                                return CalculationItem(
                                  title: "${data.name} (${data.rate})",
                                  titleStyle: googleSansFlexMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                    color: LightAppColor.blackGrey,
                                  ),
                                  value: data.totalTax.toStringAsFixed(2),
                                  index: index,
                                  isDismissable: true,
                                  isInvoice: true,
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

                            // Grand Total
                            CalculationItem(
                              title: 'grand_total_key'.tr,
                              value: invoiceController.grandTotal!
                                  .toStringAsFixed(2),
                              titleStyle: googleSansFlexBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: LightAppColor.lightOrange,
                              ),
                              valueStyle: googleSansFlexBold.copyWith(),
                              isDismissable: false,
                              isInvoice: true,
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Received Amount
                            CustomTextField(
                              header: 'received_amount_key'.tr,
                              isRequired: false,
                              hintText: 'received_amount_key'.tr,
                              inputType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              isOnlyNumber: true,
                              inputAction: TextInputAction.done,
                              controller:
                                  invoiceController.receivedAmountController,
                              focusNode:
                                  invoiceController.receivedAmountFocusNode,
                              fillColor: Theme.of(context).cardColor,
                              onChanged: (value) {
                                invoiceController.dueAmountCalculation();
                              },
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Due Amount
                            CalculationItem(
                              title: 'due_amount_key'.tr,
                              value: invoiceController.dueAmount!
                                  .toStringAsFixed(2),
                              valueStyle: googleSansFlexBold.copyWith(),
                              isDismissable: false,
                              isInvoice: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            transparent: true,
                            onPressed:
                                invoiceController.createInvoiceSaveLoading ||
                                    invoiceController.updateInvoiceSaveLoading
                                ? () {}
                                : () async {
                                    if (invoiceController
                                        .createInvoiceFormKey
                                        .currentState!
                                        .validate()) {
                                      if (invoiceController
                                              .customerDropdownValue ==
                                          null) {
                                        showCustomSnackBar(
                                          'please_select_a_customer_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .issueDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_issue_date_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .dueDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_due_date_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController.selectedTemplate ==
                                          null) {
                                        showCustomSnackBar(
                                          'please_select_a_template_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .selectedProductItemList
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_your_product_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }

                                      double da = 0;
                                      if (invoiceController
                                          .discountAmountController
                                          .text
                                          .isNotEmpty) {
                                        da = invoiceController.discountAmount!;
                                      }
                                      if (da > invoiceController.subTotal!) {
                                        showCustomSnackBar(
                                          'large_discount_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (int.parse(value) == 2) {
                                        invoiceController.updateInvoice(
                                          submitType: 'save',
                                        );
                                      } else {
                                        invoiceController.createInvoice(
                                          submitType: 'save',
                                        );
                                      }
                                    }
                                  },
                            buttonTextWidget:
                                invoiceController.createInvoiceSaveLoading ||
                                    invoiceController.updateInvoiceSaveLoading
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
                            textColor: Get.isDarkMode
                                ? Theme.of(context).indicatorColor
                                : LightAppColor.cardColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.FREE_SIZE_EXTRA_LARGE),
                        Expanded(
                          child: CustomButton(
                            onPressed:
                                invoiceController.createInvoiceSendLoading ||
                                    invoiceController.updateInvoiceSendLoading
                                ? () {}
                                : () async {
                                    if (invoiceController
                                        .createInvoiceFormKey
                                        .currentState!
                                        .validate()) {
                                      if (invoiceController
                                              .customerDropdownValue ==
                                          null) {
                                        showCustomSnackBar(
                                          'please_select_a_customer_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .issueDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_issue_date_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .dueDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_due_date_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController.selectedTemplate ==
                                          null) {
                                        showCustomSnackBar(
                                          'please_select_a_template_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .selectedProductItemList
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_select_your_product_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (invoiceController
                                          .selectedDiscount
                                          .value
                                          .isNotEmpty) {
                                        if (invoiceController
                                            .discountAmountController
                                            .text
                                            .isEmpty) {
                                          showCustomSnackBar(
                                            'please_enter_discount_amount_key'
                                                .tr,
                                            isError: true,
                                          );
                                          return;
                                        }
                                      }
                                      double da = 0;
                                      if (invoiceController
                                          .discountAmountController
                                          .text
                                          .isNotEmpty) {
                                        da = invoiceController.discountAmount!;
                                      }
                                      if (da > invoiceController.subTotal!) {
                                        showCustomSnackBar(
                                          'large_discount_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (int.parse(value) == 2) {
                                        invoiceController.updateInvoice(
                                          submitType: 'send',
                                        );
                                      } else {
                                        invoiceController.createInvoice(
                                          submitType: 'send',
                                        );
                                      }
                                    }
                                  },
                            buttonTextWidget:
                                invoiceController.createInvoiceSendLoading ||
                                    invoiceController.updateInvoiceSendLoading
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
                            textColor: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
