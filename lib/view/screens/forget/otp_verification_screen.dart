// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:paysuite/controller/auth_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _seconds = 0;
  final _otpController = TextEditingController();

  // timer function
  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer.cancel();
      }
      setState(() {});
    });
  }

  // dispose function
  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  // init function
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      // body section
      body: CustomBody(
        showBackButton: true,
        mainWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                // Otp verification
                Expanded(
                  child: GetBuilder<AuthController>(
                    builder: (authController) {
                      return SafeArea(
                        child: Container(
                          width: 1170,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Otp verification heading
                                Text(
                                  "otp_verification_key".tr,
                                  style: googleSansFlexMedium.copyWith(
                                    color: LightAppColor.cardColor,
                                    fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),

                                // Otp verification description
                                Text(
                                  "enter_the_verification_code_sent_key".tr +
                                      " ${widget.email}".tr,
                                  textAlign: TextAlign.center,
                                  style: googleSansFlexRegular.copyWith(
                                    color: LightAppColor.cardColor,
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT * 3,
                                ),

                                // Otp verification form
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                    vertical: 25,
                                  ),
                                  child: PinCodeTextField(
                                    controller: _otpController,
                                    length: 6,
                                    textStyle: googleSansFlexMedium,
                                    appContext: context,
                                    keyboardType: TextInputType.number,
                                    animationType: AnimationType.slide,
                                    autoDisposeControllers: false,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      fieldHeight: 40,
                                      fieldWidth: 40,
                                      borderWidth: 1,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL + 100,
                                      ),
                                      selectedColor: Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.2),
                                      selectedFillColor: Theme.of(
                                        context,
                                      ).cardColor.withValues(alpha: 0.5),
                                      inactiveFillColor: Theme.of(
                                        context,
                                      ).cardColor.withValues(alpha: 0.2),
                                      inactiveColor: Get.isDarkMode
                                          ? Theme.of(context).indicatorColor
                                                .withValues(alpha: 0.4)
                                          : Theme.of(context).disabledColor
                                                .withValues(alpha: 0.2),
                                      activeColor: Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.5),
                                      activeFillColor: Theme.of(
                                        context,
                                      ).cardColor,
                                    ),
                                    animationDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    enableActiveFill: true,
                                    onChanged:
                                        authController.updateVerificationCode,
                                    beforeTextPaste: (text) => true,
                                  ),
                                ),

                                // Resend code
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "didn't_receive_the_code_key".tr,
                                      style: googleSansFlexRegular.copyWith(
                                        color: LightAppColor.cardColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          authController.isGenerateOtpLoading
                                          ? () {}
                                          : _seconds < 1
                                          ? () {
                                              _otpController.text = '';
                                              authController
                                                  .generateOtp(
                                                    email: widget.email,
                                                  )
                                                  .then((value) {
                                                    if (value.isSuccess) {
                                                      _startTimer();
                                                      showCustomSnackBar(
                                                        'resend_code_successfully_key'
                                                            .tr,
                                                        isError: false,
                                                      );
                                                    } else {
                                                      showCustomSnackBar(
                                                        value.message,
                                                      );
                                                    }
                                                  });
                                            }
                                          : null,
                                      child: authController.isGenerateOtpLoading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: LoadingIndicator(
                                                  isWhiteColor: true,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${'resend_key'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}',
                                              style: googleSansFlexMedium
                                                  .copyWith(
                                                    color: _seconds < 1
                                                        ? Theme.of(
                                                            context,
                                                          ).primaryColor
                                                        : Theme.of(
                                                            context,
                                                          ).colorScheme.error,
                                                  ),
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT * 2,
                                ),

                                // Verify button or progress indicator
                                authController.verificationCode.length == 6
                                    ? authController.isLoading
                                          ? const Center(
                                              child: LoadingIndicator(),
                                            )
                                          : CustomButton(
                                              buttonTextWidget:
                                                  authController
                                                      .isOtpVerificationLoading
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
                                              buttonText: 'verify_key'.tr,
                                              textColor: Theme.of(
                                                context,
                                              ).indicatorColor,
                                              onPressed:
                                                  authController
                                                      .isOtpVerificationLoading
                                                  ? () {}
                                                  : () {
                                                      _verifyToken();
                                                    },
                                            )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Verify token function
  void _verifyToken() {
    Get.find<AuthController>().otpVerification(email: widget.email).then((
      value,
    ) {
      if (value.isSuccess) {
        _timer.cancel();
        Get.toNamed(
          RouteHelper.getNewPasswordRoute(
            widget.email,
            Get.find<AuthController>().verificationCode,
          ),
        );
      } else {
        showCustomSnackBar(value.message);
      }
    });
  }
}
