// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_date_range_picker.dart';
import '../../base/loading_indicator.dart';

class ExpensesFilterScreen extends StatelessWidget {
  const ExpensesFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(isBackButtonExist: true, title: "filter_key".tr),

      body: GetBuilder<ExpensesController>(
        builder: (expensesController) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.RADIUS_DEFAULT - 2,
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        // Date Range section
                        CustomDateRangePicker(
                          isRequired: false,
                          header: 'date_range_key'.tr,
                          hintText: 'select_date_range_key'.tr,
                          svgImagePath: Images.calender,
                          controller: expensesController.filterController,
                          onStartTime: (startDate) {
                            expensesController.setFilterStartDate(startDate);
                          },
                          onEndTime: (endDate) {
                            expensesController.setFilterEndDate(endDate);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                // Button section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: expensesController.isEmptyFilterForm() == true
                            ? () {}
                            : () {
                                expensesController.refreshFilterForm();
                                expensesController.getExpenses();
                              },
                        child: Container(
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_DEFAULT,
                            ),
                            border: Border.all(
                              width: 1,
                              color:
                                  expensesController.isEmptyFilterForm() == true
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          child: SvgPicture.asset(
                            Images.refresh,
                            color:
                                expensesController.isEmptyFilterForm() == true
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: CustomButton(
                          onPressed:
                              expensesController.applyFilterLoading ||
                                  (expensesController.isEmptyFilterForm() ==
                                      true)
                              ? () {}
                              : () {
                                  expensesController
                                      .getExpenses(
                                        fromFilter: true,
                                        isApplyFilter: true,
                                      )
                                      .then((value) {
                                        if (value.isSuccess) {
                                          Get.back();
                                        }
                                      });
                                },
                          buttonTextWidget:
                              expensesController.applyFilterLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: LoadingIndicator(isWhiteColor: true),
                                  ),
                                )
                              : null,
                          color: expensesController.isEmptyFilterForm() == true
                              ? Theme.of(context).hintColor
                              : null,
                          buttonText: 'apply_filter_key'.tr,
                          textColor:
                              expensesController.isEmptyFilterForm() == true
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).indicatorColor,
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
