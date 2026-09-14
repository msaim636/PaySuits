// ignore_for_file: deprecated_member_use, unnecessary_import

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/switch_button.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = Get.find<AuthController>().getUserEmail();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        mainWidget: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    if (authController.isGoogleAuthLoading ||
                        authController.isAppleAuthLoading) {
                      return const LoadingIndicator();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Heading
                        Text(
                          "login_key".tr,
                          style: googleSansFlexBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE + 6,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "enter_your_credentials_to_continue_key".tr,
                          textAlign: TextAlign.center,
                          style: googleSansFlexRegular.copyWith(
                            color: Colors.white70,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT + 1,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 80),

                        // Email
                        CustomTextField(
                          header: "email_key".tr,
                          headerColor: LightAppColor.cardColor,
                          cursorColor: LightAppColor.cardColor,
                          isRequired: true,
                          hintText: 'enter_your_email_key'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Images.emailIcon,
                          prefixIconColor: LightAppColor.cardColor,
                          textColor: LightAppColor.cardColor,
                        ),
                        const SizedBox(height: 18),

                        // Password
                        CustomTextField(
                          header: "password_key".tr,
                          headerColor: LightAppColor.cardColor,
                          cursorColor: LightAppColor.cardColor,
                          isRequired: true,
                          hintText: 'enter_your_password_key'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIconColor: LightAppColor.cardColor,
                          prefixIcon: Images.lockIcon,
                          suffixIconColor: LightAppColor.cardColor,
                          isPassword: true,
                          textColor: LightAppColor.cardColor,
                        ),
                        const SizedBox(height: 16),

                        // Remember Me
                        SwitchButton(
                          isButtonActive: authController.isActiveRememberMe,
                          title: "keep_me_logged_in_key".tr,
                          onTap: () {
                            authController.toggleRememberMe();
                          },
                        ),
                        const SizedBox(
                          height: Dimensions.FREE_SIZE_EXTRA_LARGE * 2,
                        ),

                        // Login Button
                        CustomButton(
                          buttonTextWidget: authController.isLoading
                              ? const SizedBox(
                                  height: 23,
                                  width: 23,
                                  child: LoadingIndicator(isWhiteColor: true),
                                )
                              : null,
                          buttonText: "login_key".tr,
                          textColor: Colors.white,
                          onPressed: authController.isLoading
                              ? () {}
                              : () {
                                  if (_emailController.text.trim().isEmpty) {
                                    showCustomSnackBar(
                                      'please_enter_valid_email_key'.tr,
                                      isError: true,
                                    );
                                  } else if (_passwordController.text
                                      .trim()
                                      .isEmpty) {
                                    showCustomSnackBar(
                                      'please_enter_password_key'.tr,
                                      isError: true,
                                    );
                                  } else {
                                    _login(authController);
                                  }
                                },
                        ),
                        const SizedBox(height: Dimensions.FREE_SIZE_LARGE),
                        // Sign Up & Forgot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.getRegistationRoute());
                              },
                              child: Text(
                                "sign_up_key".tr,
                                style: googleSansFlexMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(
                                  RouteHelper.getForgetPasswordRoute(),
                                );
                              },
                              child: Text(
                                "forgot_your_password_key".tr,
                                style: googleSansFlexMedium.copyWith(
                                  color: Colors.white70,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken') ?? "No device token";

    authController
        .login(email: email, password: password, deviceToken: deviceToken)
        .then((status) async {
          if (status.isSuccess) {
            if (authController.isActiveRememberMe) {
              authController.saveUserNumberAndPassword(
                email: email,
                password: password,
              );
              authController.saveKeepMeLoggedIn();
            } else {
              authController.clearUserNumberAndPassword();
              authController.saveKeepMeLoggedIn();
            }
            Get.find<DashboardController>().getProfileDetails();
            Get.offNamed(RouteHelper.getNavbarRoute());
          } else {
            showCustomSnackBar(status.message, isError: true);
          }
        });
  }
}
