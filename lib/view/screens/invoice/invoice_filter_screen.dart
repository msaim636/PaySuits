// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_date_range_picker.dart';
import '../../base/custom_drop_down.dart';
import '../../base/loading_indicator.dart';

class InvoiceFilterScreen extends StatelessWidget {
  const InvoiceFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<EstimateController>().getCustomerListDropdown();
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "invoice_filter_key".tr,
      ),

      body: GetBuilder<InvoiceController>(
        builder: (invoiceController) {
          return GetBuilder<EstimateController>(
            builder: (estimateController) {
              return estimateController.suggestedAllItemListLoading
                  ? Center(child: LoadingIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
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
                                      // Customer section
                                      GetBuilder<EstimateController>(
                                        builder: (estimateController) {
                                          return CustomDropDown(
                                            title: 'customers_key'.tr,
                                            isRequired: false,
                                            borderColor: Colors.transparent,
                                            dwItems: estimateController
                                                .customerDropdownStringList,
                                            dwValue: invoiceController
                                                .customerDropdownValue,
                                            hintText:
                                                'choose_a_customer_key'.tr,
                                            onChange: (value) {
                                              invoiceController
                                                  .setCustomerDropdownValue(
                                                    value,
                                                  );
                                            },
                                          );
                                        },
                                      ),

                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Status section
                                      CustomDropDown(
                                        title: 'status_key'.tr,
                                        isRequired: false,
                                        borderColor: Colors.transparent,
                                        dwItems: invoiceController
                                            .customerStatusList,
                                        dwValue: invoiceController
                                            .customerStatusDWValue,
                                        hintText: 'choose_a_status_key'.tr,
                                        onChange: (value) {
                                          invoiceController
                                              .setCustomerStatusDWValue(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Issue Date Range section
                                      CustomDateRangePicker(
                                        isRequired: false,
                                        header: 'issue_date_range_key'.tr,
                                        hintText: 'select_date_range_key'.tr,
                                        svgImagePath: Images.calender,
                                        controller: invoiceController
                                            .issueFilterController,
                                        onStartTime: (startDate) {
                                          invoiceController
                                              .setFilterIssueStartDate(
                                                startDate,
                                              );
                                        },
                                        onEndTime: (endDate) {
                                          invoiceController
                                              .setFilterIssueEndDate(endDate);
                                        },
                                      ),
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Due Date Range section
                                      CustomDateRangePicker(
                                        isRequired: false,
                                        header: 'due_date_range_key'.tr,
                                        hintText: 'select_date_range_key'.tr,
                                        svgImagePath: Images.calender,
                                        controller: invoiceController
                                            .dueFilterController,
                                        onStartTime: (startDate) {
                                          invoiceController
                                              .setFilterDueStartDate(startDate);
                                        },
                                        onEndTime: (endDate) {
                                          invoiceController.setFilterDueEndDate(
                                            endDate,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          child: Row(
                            children: [
                              // Refresh Button
                              InkWell(
                                onTap:
                                    invoiceController.isEmptyFilterForm() ==
                                        true
                                    ? () {}
                                    : () {
                                        invoiceController.refreshFilterForm();
                                        invoiceController.getInvoice();
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
                                          invoiceController
                                                  .isEmptyFilterForm() ==
                                              true
                                          ? Theme.of(context).hintColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    Images.refresh,
                                    color:
                                        invoiceController.isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: Dimensions.PADDING_SIZE_SMALL,
                              ),

                              // Apply Filter Button
                              Expanded(
                                child: CustomButton(
                                  onPressed:
                                      invoiceController.applyFilterLoading ||
                                          (invoiceController
                                                  .isEmptyFilterForm() ==
                                              true)
                                      ? () {}
                                      : () {
                                          invoiceController
                                              .getInvoice(
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
                                      invoiceController.isEmptyFilterForm() ==
                                          true
                                      ? Theme.of(context).hintColor
                                      : null,
                                  buttonTextWidget:
                                      invoiceController.applyFilterLoading
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
                                  buttonText: 'apply_filter_key'.tr,
                                  textColor:
                                      invoiceController.isEmptyFilterForm() ==
                                          true
                                      ? Theme.of(context).disabledColor
                                      : Theme.of(context).indicatorColor,
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
      ),
    );
  }
}
