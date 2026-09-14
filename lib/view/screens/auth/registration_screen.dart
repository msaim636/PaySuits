// ignore_for_file: deprecated_member_use
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/screens/auth/widget/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FocusNode _companyNameFocus = FocusNode();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Register user
  void _registerUser() {
    String companyName = _companyNameController.text.trim();
    String email = _emailController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name_key'.tr, isError: true);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name_key'.tr, isError: true);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_your_email_key'.tr, isError: true);
    } else if (companyName.isEmpty) {
      showCustomSnackBar('enter_your_company_name_key'.tr, isError: true);
    } else {
      Get.find<AuthController>()
          .register(
            company_name: companyName,
            first_name: firstName,
            last_name: lastName,
            email: email,
          )
          .then((status) {
            if (status.isSuccess) {
              Get.offAllNamed(RouteHelper.loginScreen);
              showCustomSnackBar(status.message, isError: false);
            } else {
              showCustomSnackBar(status.message, isError: true);
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      // body start
      body: CustomBody(
        showBackButton: true,
        mainWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
            ),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                //  Registration form start
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    return authController.isGoogleAuthLoading ||
                            authController.isAppleAuthLoading
                        ? const LoadingIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Registration heading
                              Text(
                                "sign_up_key".tr,
                                style: googleSansFlexBold.copyWith(
                                  color: LightAppColor.cardColor,
                                  fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE,
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL,
                              ),

                              // Registration description
                              Text(
                                "create_a_new_account_key".tr,
                                textAlign: TextAlign.center,
                                style: googleSansFlexRegular.copyWith(
                                  color: LightAppColor.cardColor,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                ),
                              ),
                              const SizedBox(height: 50),
                              // First Name TextField
                              CustomTextField(
                                header: "first_name_key".tr,
                                headerColor: LightAppColor.cardColor,
                                cursorColor: LightAppColor.cardColor,
                                isRequired: true,
                                hintText: 'enter_your_first_name_key'.tr,
                                controller: _firstNameController,
                                inputType: TextInputType.text,
                                prefixIcon: Images.firstName,
                                prefixIconColor: LightAppColor.cardColor,
                                textColor: LightAppColor.cardColor,
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),
                              // Last Name TextField
                              CustomTextField(
                                header: "last_name_key".tr,
                                headerColor: LightAppColor.cardColor,
                                cursorColor: LightAppColor.cardColor,
                                isRequired: true,
                                hintText: 'enter_your_last_name_key'.tr,
                                controller: _lastNameController,
                                inputType: TextInputType.text,
                                prefixIcon: Images.lastName,
                                prefixIconColor: LightAppColor.cardColor,
                                textColor: LightAppColor.cardColor,
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),
                              // Email TextField
                              CustomTextField(
                                header: "email_key".tr,
                                headerColor: LightAppColor.cardColor,
                                cursorColor: LightAppColor.cardColor,
                                isRequired: true,
                                hintText: 'enter_your_email_key'.tr,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Images.emailIcon,
                                prefixIconColor: LightAppColor.cardColor,
                                textColor: LightAppColor.cardColor,
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),
                              // Address TextField
                              CustomTextField(
                                header: "company_name_key".tr,
                                headerColor: LightAppColor.cardColor,
                                cursorColor: LightAppColor.cardColor,
                                isRequired: true,
                                hintText: 'enter_your_company_name_key'.tr,
                                controller: _companyNameController,
                                focusNode: _companyNameFocus,
                                nextFocus: FocusNode(),
                                inputType: TextInputType.text,
                                prefixIcon: Images.companyIcon,
                                textColor: LightAppColor.cardColor,
                                prefixIconColor: LightAppColor.cardColor,
                              ),

                              const SizedBox(
                                height:
                                    Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE +
                                    20,
                              ),

                              // Registration button
                              CustomButton(
                                buttonTextWidget:
                                    authController.isRegisterLoading
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
                                buttonText: "sign_up_key".tr,
                                textColor: Theme.of(context).indicatorColor,
                                onPressed: authController.isRegisterLoading
                                    ? () {}
                                    : () {
                                        _registerUser();
                                      },
                              ),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT + 5,
                              ),

                              TermConditionWidget(),
                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
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
}
