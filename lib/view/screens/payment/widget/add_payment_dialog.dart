// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/payment_controller.dart';
import 'package:paysuite/data/model/body/add_payment_method_body.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../../../base/loading_indicator.dart';

class AddPaymentDialog extends StatelessWidget {
  final bool isUpdate;
  AddPaymentDialog({super.key, required this.isUpdate});

  // text editing controllers
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final TextEditingController _apiSecretController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _apiKeyFocusNode = FocusNode();
  final FocusNode _apiSecretFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    //  payment method exicution
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<PaymentController>().refreshForm();
      if (isUpdate) {
        Get.find<PaymentController>().getPaymentMethodDetails().then((value) {
          if (Get.find<PaymentController>().paymentMethodDetailsModel != null) {
            _nameController.text =
                Get.find<PaymentController>().paymentMethodDetailsModel!.name ??
                "";

            if (Get.find<PaymentController>()
                    .paymentMethodDetailsModel!
                    .settings !=
                null) {
              for (var element
                  in Get.find<PaymentController>()
                      .paymentMethodDetailsModel!
                      .settings!) {
                if (element.apiKey == "payment_mode") {
                  Get.find<PaymentController>().setPaymentModeValue(
                    element.apiSecret?.capitalizeFirst,
                  );
                } else if (element.apiKey == "api_key") {
                  _apiKeyController.text = element.apiSecret ?? "";
                } else if (element.apiKey == "api_secret") {
                  _apiSecretController.text = element.apiSecret ?? "";
                }
              }
            }
          }
        });
      }
    });

    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      insetPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<PaymentController>(
        builder: (paymentController) {
          return (isUpdate && paymentController.isPaymentMethodDetailsLoading)
              ? Container(
                  color: Theme.of(context).cardColor,
                  alignment: Alignment.center,
                  height: 300,
                  child: const Center(child: LoadingIndicator()),
                )
              : isUpdate && paymentController.paymentMethodDetailsModel == null
              ? Center(
                  child: Text(
                    "something_wrong_key".tr,
                    style: googleSansFlexMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(
                      Dimensions.PADDING_SIZE_LARGE,
                    ),
                    width: 500,
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),

                          // Title section
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              isUpdate
                                  ? "update_payment_method_key".tr
                                  : "add_payment_method_key".tr,
                              style: googleSansFlexMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.FREE_SIZE_LARGE + 1,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                          ),

                          // Payment Type section dropdown
                          CustomDropDown(
                            title: 'payment_method_type_key'.tr,
                            isRequired: true,
                            dwItems: [],
                            dwValue: paymentController.paymentDropdownValue,
                            hintText: 'choose_a_category_key'.tr,
                            onChange: (value) {
                              paymentController.setPaymentDropdownValue(value);
                            },
                          ),

                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          // Name text field section
                          CustomTextField(
                            header: 'name_key'.tr,
                            isRequired: true,
                            hintText: 'enter_the_name_key'.tr,
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                          ),

                          paymentController.paymentDropdownValue == "Paypal"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),

                                    // Payment Type section dropdown
                                    CustomDropDown(
                                      title: 'payment_mode_key'.tr,
                                      isRequired: true,
                                      dwItems:
                                          paymentController.paymentModeList,
                                      dwValue:
                                          paymentController.paymentModeValue,
                                      hintText: 'choose_a_category_key'.tr,
                                      onChange: (value) {
                                        paymentController.setPaymentModeValue(
                                          value,
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          paymentController.paymentDropdownValue != null &&
                                  paymentController.paymentDropdownValue !=
                                      "Others"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),

                                    // Name text field section
                                    CustomTextField(
                                      header: 'api_key_key'.tr,
                                      isRequired: true,
                                      hintText: 'enter_the_api_key_key'.tr,
                                      controller: _apiKeyController,
                                      focusNode: _apiKeyFocusNode,
                                      inputType: TextInputType.text,
                                      nextFocus: _apiSecretFocus,
                                      inputAction: TextInputAction.next,
                                    ),

                                    const SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),

                                    CustomTextField(
                                      header: 'api_secret_key'.tr,
                                      isRequired: true,
                                      hintText: 'api_secret_key'.tr,
                                      controller: _apiSecretController,
                                      focusNode: _apiSecretFocus,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.visiblePassword,
                                      isPassword: true,
                                      onSubmit: () {},
                                    ),
                                  ],
                                )
                              : const SizedBox(),

                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          // Cancel and save button section
                          Row(
                            children: [
                              // Cancel button
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  transparent: true,
                                  buttonText: "cancel_key".tr,
                                  radius: Dimensions.RADIUS_DEFAULT - 2,
                                  textColor: Get.isDarkMode
                                      ? Theme.of(context).indicatorColor
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                width: Dimensions.PADDING_SIZE_SMALL,
                              ),

                              // Save button
                              Expanded(
                                child: CustomButton(
                                  radius: Dimensions.RADIUS_DEFAULT - 2,
                                  transparent: false,
                                  buttonTextWidget:
                                      paymentController
                                              .addPaymentMethodLoading ||
                                          paymentController
                                              .updatePaymentMethodLoading
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
                                      paymentController
                                              .addPaymentMethodLoading ||
                                          paymentController
                                              .updatePaymentMethodLoading
                                      ? () {}
                                      : () {
                                          if (paymentController
                                                  .paymentDropdownValue ==
                                              null) {
                                            showCustomSnackBar(
                                              "please_select_a_payment_method_key"
                                                  .tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (_nameController.text.isEmpty) {
                                            showCustomSnackBar(
                                              "please_enter_the_name_key".tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (paymentController
                                                      .paymentDropdownValue !=
                                                  "Others" &&
                                              paymentController
                                                      .paymentDropdownValue ==
                                                  "Paypal") {
                                            if (paymentController
                                                    .paymentModeValue ==
                                                null) {
                                              showCustomSnackBar(
                                                "please_select_a_payment_mode_key"
                                                    .tr,
                                                isError: true,
                                              );
                                              return;
                                            }
                                          }
                                          if (paymentController
                                                  .paymentDropdownValue !=
                                              "Others") {
                                            if (_apiKeyController
                                                .text
                                                .isEmpty) {
                                              showCustomSnackBar(
                                                "please_enter_the_api_key_key"
                                                    .tr,
                                                isError: true,
                                              );
                                              return;
                                            }
                                            if (_apiSecretController
                                                .text
                                                .isEmpty) {
                                              showCustomSnackBar(
                                                "please_enter_api_secret_key"
                                                    .tr,
                                                isError: true,
                                              );
                                              return;
                                            }
                                          }

                                          final paymentMethodBody = AddPaymentMethodBody(
                                            name: _nameController.text.trim(),
                                            methodType: paymentController
                                                .paymentDropdownValue!
                                                .toLowerCase(),
                                            apiKey:
                                                paymentController
                                                            .paymentDropdownValue !=
                                                        null &&
                                                    paymentController
                                                            .paymentDropdownValue !=
                                                        "Others"
                                                ? _apiKeyController.text.trim()
                                                : "",
                                            apiSecret:
                                                paymentController
                                                            .paymentDropdownValue !=
                                                        null &&
                                                    paymentController
                                                            .paymentDropdownValue !=
                                                        "Others"
                                                ? _apiSecretController.text
                                                      .trim()
                                                : "",
                                            methodMode:
                                                paymentController
                                                        .paymentDropdownValue ==
                                                    "Paypal"
                                                ? paymentController
                                                      .paymentModeValue!
                                                : "",
                                          );
                                          if (isUpdate) {
                                            paymentController
                                                .updatePaymentMethod(
                                                  addPaymentMethodBody:
                                                      paymentMethodBody,
                                                )
                                                .then((value) {
                                                  if (value.isSuccess) {
                                                    Get.back();
                                                    showCustomSnackBar(
                                                      value.message,
                                                      isError: false,
                                                    );
                                                    if (Get.find<
                                                              DashboardController
                                                            >()
                                                            .bottomNavbarIndex ==
                                                        1) {
                                                      Get.find<
                                                            TransactionController
                                                          >()
                                                          .getTransaction();
                                                    }
                                                  }
                                                });
                                          } else {
                                            paymentController
                                                .addPaymentMethod(
                                                  addPaymentMethodBody:
                                                      paymentMethodBody,
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
                                          }
                                        },
                                  buttonText: isUpdate
                                      ? "update_key".tr
                                      : "save_key".tr,
                                  textColor: Theme.of(context).indicatorColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
