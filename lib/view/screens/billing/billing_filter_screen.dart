// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/billing_controller.dart';
import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_text_field.dart';
import '../../base/loading_indicator.dart';

class BillingFilterScreen extends StatelessWidget {
  const BillingFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "billing_filter_key".tr,
      ),

      body: GetBuilder<BillingController>(
        builder: (billingController) {
          return GetBuilder<EstimateController>(
            builder: (esimateController) {
              return Column(
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
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Status section
                                CustomTextField(
                                  controller:
                                      billingController.filterController,
                                  isRequired: false,
                                  header: "search_key".tr,
                                  hintText: "search_key".tr,
                                  prefixIcon: Images.invoice,
                                  prefixIconColor: Get.isDarkMode
                                      ? LightAppColor.cardColor
                                      : Theme.of(context).primaryColor,
                                  onChanged: (value) =>
                                      billingController.update(),
                                  isEnabled: true,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
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
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        // Refresh Button
                        InkWell(
                          onTap: billingController.isEmptyFilterForm() == true
                              ? () {}
                              : () {
                                  billingController.refreshFilterForm();
                                  billingController.getBilling();
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
                                    billingController.isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            child: SvgPicture.asset(
                              Images.refresh,
                              color:
                                  billingController.isEmptyFilterForm() == true
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        // Apply Filter Button
                        Expanded(
                          child: CustomButton(
                            onPressed:
                                billingController.applyFilterLoading ||
                                    (billingController.isEmptyFilterForm() ==
                                        true)
                                ? () {}
                                : () {
                                    billingController
                                        .getBilling(
                                          fromFilter: true,
                                          isApplyFilter: true,
                                        )
                                        .then((value) {
                                          if (value.isSuccess) {
                                            Get.back();
                                          }
                                        });
                                  },
                            color: billingController.isEmptyFilterForm() == true
                                ? Theme.of(context).hintColor
                                : null,
                            buttonTextWidget:
                                billingController.applyFilterLoading
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
                                billingController.isEmptyFilterForm() == true
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
