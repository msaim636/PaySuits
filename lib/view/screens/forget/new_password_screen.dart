// ignore_for_file: deprecated_member_use

import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class NewPasswordScreen extends StatelessWidget {
  final String resetToken;
  final String email;
  NewPasswordScreen({super.key, required this.resetToken, required this.email});

  // TexteditingControllers
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      //  Body start
      body: CustomBody(
        showBackButton: true,
        mainWidget: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
          ),
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  // Show forget password form
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Forget password heading
                            Text(
                              "reset_password_key".tr,
                              style: googleSansFlexMedium.copyWith(
                                color: LightAppColor.cardColor,
                                fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Forget password description
                            Text(
                              "set_password_key".tr,
                              textAlign: TextAlign.center,
                              style: googleSansFlexRegular.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).disabledColor,
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT * 3,
                            ),

                            // Form
                            Column(
                              children: [
                                // New password
                                CustomTextField(
                                  header: "new_password_key".tr,
                                  headerColor: LightAppColor.cardColor,
                                  isRequired: true,
                                  hintText: 'new_password_key'.tr,
                                  controller: _newPasswordController,
                                  focusNode: _newPasswordFocus,
                                  inputAction: TextInputAction.next,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Images.lockIcon,
                                  isPassword: true,
                                  nextFocus: _confirmPasswordFocus,
                                  textColor: LightAppColor.cardColor,
                                  prefixIconColor: LightAppColor.cardColor,
                                  onSubmit: () {},
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Confirm password
                                CustomTextField(
                                  header: "confirm_password_key".tr,
                                  headerColor: LightAppColor.cardColor,
                                  isRequired: true,
                                  hintText: 'confirm_password_key'.tr,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Images.lockIcon,
                                  textColor: LightAppColor.cardColor,
                                  prefixIconColor: LightAppColor.cardColor,
                                  isPassword: true,
                                  onSubmit: () {},
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT * 3,
                            ),

                            // Button to reset password
                            authController.isLoading
                                ? const Center(child: LoadingIndicator())
                                : CustomButton(
                                    buttonTextWidget:
                                        authController.isResetPasswordLoading
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
                                    buttonText: 'reset_password_key'.tr,
                                    textColor: Theme.of(context).indicatorColor,
                                    onPressed: () {
                                      if (_newPasswordController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          "please_enter_new_password_key".tr,
                                          isError: true,
                                        );
                                      } else if (_confirmPasswordController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          "please_enter_confirm_password_key"
                                              .tr,
                                          isError: true,
                                        );
                                      } else if (_confirmPasswordController.text
                                              .trim() !=
                                          _newPasswordController.text.trim()) {
                                        showCustomSnackBar(
                                          "password_not_match_key".tr,
                                          isError: true,
                                        );
                                      } else {
                                        _resetPassword();
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to reset password
  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    Get.find<AuthController>()
        .resetPassword(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        )
        .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().saveUserNumberAndPassword(
              email: email,
              password: password,
            );
            showCustomSnackBar(value.message, isError: false);
            Get.offAllNamed(RouteHelper.getLoginRoute());
          } else {
            showCustomSnackBar(value.message);
          }
        });
  }
}
