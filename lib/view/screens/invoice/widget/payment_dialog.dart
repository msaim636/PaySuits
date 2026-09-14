// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/payment_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class PaymentDialog extends StatelessWidget {
  final String previousRoute;
  const PaymentDialog({super.key, required this.previousRoute});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<InvoiceController>().refreshData();
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      insetPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          width: 500,
          child: GetBuilder<InvoiceController>(
            builder: (invoiceController) {
              // Due payment & Paying amount section
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "customer_due_invoice_payment".tr,
                        style: googleSansFlexMedium.copyWith(
                          fontSize: Dimensions.FREE_SIZE_EXTRA_LARGE,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    // Payment Method section dropdown field
                    GetBuilder<PaymentController>(
                      builder: (paymentController) {
                        return CustomDropDown(
                          title: 'payment_method_key'.tr,
                          isRequired: true,
                          borderColor: Theme.of(context).disabledColor,
                          dwItems: [],
                          dwValue: invoiceController.paymentGatewayDWValue,
                          hintText: 'choose_a_payment_method_key'.tr,
                          onChange: (value) {},
                        );
                      },
                    ),

                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    // Cancel and Save Button Section
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: CustomButton(
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            transparent: true,
                            onPressed: () {
                              Get.back();
                            },
                            buttonText: "cancel_key".tr,
                            textColor: Get.isDarkMode
                                ? Theme.of(context).indicatorColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.FREE_SIZE_EXTRA_LARGE),
                        // Save Button
                        Expanded(
                          child: CustomButton(
                            onPressed: invoiceController.duePaymentLoading
                                ? () {}
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      if (invoiceController
                                              .paymentGatewayDWValue ==
                                          null) {
                                        showCustomSnackBar(
                                          "choose_a_payment_method_key".tr,
                                          isError: true,
                                        );
                                      } else {
                                        showCustomSnackBar(
                                          "Loading.....",
                                          isError: false,
                                        );
                                      }
                                    }
                                  },
                            buttonTextWidget:
                                invoiceController.duePaymentLoading
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
                            buttonText: "pay_now".tr,
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            textColor: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
