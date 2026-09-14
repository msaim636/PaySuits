// ignore_for_file: deprecated_member_use

import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/customer_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_drop_down.dart';
import '../../base/loading_indicator.dart';

class CustomerFilterScreen extends StatelessWidget {
  const CustomerFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(isBackButtonExist: true, title: "filter_key".tr),

      body: GetBuilder<CustomerController>(
        builder: (customerController) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                // Status section
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
                      // Status section
                      CustomDropDown(
                        borderColor: Theme.of(context).disabledColor,
                        title: 'status_key'.tr,
                        isRequired: false,
                        dwItems: customerController.customerStatusList,
                        dwValue: customerController.customerStatusDWValue,
                        hintText: 'choose_a_status_key'.tr,
                        onChange: (value) {
                          customerController.setCustomerStatusDWValue(value);
                        },
                      ),
                    ],
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
                        onTap: customerController.customerStatusDWValue == null
                            ? () {}
                            : () {
                                customerController.refreshFilterForm();
                                customerController.getCustomerData();
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
                                  customerController.customerStatusDWValue ==
                                      null
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          child: SvgPicture.asset(
                            Images.refresh,
                            color:
                                customerController.customerStatusDWValue == null
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: CustomButton(
                          onPressed:
                              customerController.customerFilter ||
                                  customerController.customerStatusDWValue ==
                                      null
                              ? () {}
                              : () {
                                  customerController
                                      .getCustomerData(fromFilter: true)
                                      .then((value) {
                                        if (value.isSuccess) {
                                          Get.back();
                                        }
                                      });
                                },
                          buttonText: 'apply_filter_key'.tr,
                          textColor:
                              customerController.customerStatusDWValue == null
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).indicatorColor,
                          color:
                              customerController.customerStatusDWValue == null
                              ? Theme.of(context).hintColor
                              : null,
                          buttonTextWidget: customerController.customerFilter
                              ? const Center(
                                  child: SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: LoadingIndicator(isWhiteColor: true),
                                  ),
                                )
                              : null,
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
