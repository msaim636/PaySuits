// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:paysuite/controller/customer_controller.dart';
import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/view/base/custom_image.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../data/model/body/update_profile_body.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_country_picker.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  // Existing controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Reset password fields when switching tabs
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // Change Password tab opened
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    });

    final dashBoardCon = Get.find<DashboardController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dashBoardCon.getProfileDetails().then((value) {
        if (value.isSuccess) {
          dashBoardCon.pickImage(true);
          if (dashBoardCon.profileDetailsModel != null) {
            _firstNameController.text =
                dashBoardCon.profileDetailsModel!.firstName ?? "";
            _lastNameController.text =
                dashBoardCon.profileDetailsModel!.lastName ?? "";
            _emailController.text =
                dashBoardCon.profileDetailsModel!.email ?? "";
            _addressController.text =
                dashBoardCon.profileDetailsModel!.address ?? "";
            if (dashBoardCon.profileDetailsModel!.gender != null) {
              Get.find<CustomerController>().setGenderListDropDownValue(
                dashBoardCon.profileDetailsModel!.gender!.toLowerCase(),
              );
            }
            dashBoardCon.setCountryCode(
              dashBoardCon.profileDetailsModel!.phoneCountry ?? "US",
            );
            _phoneController.text =
                dashBoardCon.profileDetailsModel!.phoneNumber != null
                ? dashBoardCon.removeCountryCode(
                    dashBoardCon.profileDetailsModel!.phoneNumber!,
                  )
                : "";
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "edit_profile_key".tr,
      ),
      body: GetBuilder<DashboardController>(
        builder: (dashboardController) {
          if (dashboardController.isProfileDetailsLoading) {
            return const Center(child: LoadingIndicator());
          }
          if (dashboardController.profileDetailsModel == null) {
            return Center(
              child: Text(
                "something_wrong_key".tr,
                style: googleSansFlexMedium.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                ),
              ),
            );
          }

          return Column(
            children: [
              // ---------------- TabBar ----------------
              Container(
                margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(
                    Dimensions.RADIUS_DEFAULT,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_DEFAULT,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Get.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                  tabs: [
                    Tab(text: "personal_info_key".tr),
                    Tab(text: "change_password_key".tr),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ---------------- Personal Info Tab ----------------
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Everything inside your current Personal Info section
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  ClipOval(
                                    child:
                                        dashboardController.pickedImage != null
                                        ? Image.file(
                                            File(
                                              dashboardController
                                                  .pickedImage!
                                                  .path,
                                            ),
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : dashboardController
                                                  .profileDetailsModel!
                                                  .profilePicture !=
                                              null
                                        ? ClipOval(
                                            child: CustomImage(
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                              image: dashboardController
                                                  .profileDetailsModel!
                                                  .profilePicture!,
                                            ),
                                          )
                                        : SizedBox(
                                            height: 120,
                                            width: 120,
                                            child: ClipOval(
                                              child: SvgPicture.asset(
                                                Images.userProfile,
                                                fit: BoxFit.contain,
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        dashboardController.pickImage(false);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL - 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          border: Border.all(
                                            width: 4,
                                            color: Theme.of(context).cardColor,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          Images.editProfile,
                                          color: Theme.of(
                                            context,
                                          ).indicatorColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ... all other personal info fields remain unchanged
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            CustomTextField(
                              header: "first_name_key".tr,
                              isRequired: true,
                              hintText: 'enter_your_first_name_key'.tr,
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              inputType: TextInputType.text,
                              fillColor: Theme.of(context).cardColor,
                              inputAction: TextInputAction.next,
                              nextFocus: _lastNameFocusNode,
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            CustomTextField(
                              header: 'last_name_key'.tr,
                              isRequired: true,
                              hintText: 'enter_your_last_name_key'.tr,
                              controller: _lastNameController,
                              focusNode: _lastNameFocusNode,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              nextFocus: _emailFocusNode,
                              fillColor: Theme.of(context).cardColor,
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            CustomTextField(
                              readOnly: true,
                              header: 'email_address_key'.tr,
                              isRequired: true,
                              hintText: 'enter_your_email_key'.tr,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                              fillColor: Theme.of(context).cardColor,
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            GetBuilder<CustomerController>(
                              builder: (customerController) {
                                return CustomCountryPicker(
                                  header: 'phone_number_key'.tr,
                                  hintText: 'enter_phone_number_key'.tr,
                                  inputAction: TextInputAction.next,
                                  country: dashboardController.country,
                                  fillColor: Theme.of(context).cardColor,
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  prefixIconOnTap: () {
                                    customerController.showPicker(
                                      context,
                                      fromProfile: true,
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            CustomTextField(
                              header: 'address_key'.tr,
                              isRequired: false,
                              hintText: 'address_key'.tr,
                              controller: _addressController,
                              focusNode: _addressFocusNode,
                              inputType: TextInputType.streetAddress,
                              inputAction: TextInputAction.done,
                              fillColor: Theme.of(context).cardColor,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            Obx(() {
                              return CustomDropDown(
                                title: "gender_key".tr,
                                hintText: "select_gender_key".tr,
                                dwItems: Get.find<CustomerController>()
                                    .genderListDropdownList,
                                dwValue: Get.find<CustomerController>()
                                    .selectedGender
                                    .value,
                                borderColor: Colors.transparent,
                                onChange: (val) =>
                                    Get.find<CustomerController>()
                                        .setGenderListDropDownValue(val),
                              );
                            }),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_LARGE,
                            ),

                            // Update and Delete Buttons remain the same
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    onPressed: () => Get.back(),
                                    transparent: true,
                                    buttonText: "cancel_key".tr,
                                    color: Colors.transparent,
                                    textColor: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : Theme.of(context).primaryColor,
                                    radius: Dimensions.RADIUS_DEFAULT - 2,
                                  ),
                                ),
                                const SizedBox(
                                  width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                                ),
                                Expanded(
                                  child: CustomButton(
                                    radius: Dimensions.RADIUS_DEFAULT - 2,
                                    transparent: false,
                                    buttonTextWidget:
                                        dashboardController.updateProfileLoading
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
                                    onPressed: () {
                                      if (_firstNameController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_your_first_name_key'.tr,
                                          isError: true,
                                        );
                                      } else if (_lastNameController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_your_last_name_key'.tr,
                                          isError: true,
                                        );
                                      } else if (_emailController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_email_address_key'.tr,
                                          isError: true,
                                        );
                                      } else {
                                        final profileModel = UpdateProfileBody(
                                          firstName: _firstNameController.text
                                              .trim(),
                                          lastName: _lastNameController.text
                                              .trim(),
                                          email: _emailController.text.trim(),
                                          phoneCountry:
                                              _phoneController.text
                                                  .trim()
                                                  .isNotEmpty
                                              ? dashboardController
                                                    .country
                                                    .countryCode
                                              : "",
                                          phone:
                                              _phoneController.text
                                                  .trim()
                                                  .isNotEmpty
                                              ? "+" +
                                                    dashboardController
                                                        .country
                                                        .phoneCode +
                                                    _phoneController.text
                                              : _phoneController.text.trim(),
                                          address: _addressController.text
                                              .trim(),
                                          gender: Get.find<CustomerController>()
                                              .selectedGender
                                              .value,
                                        );

                                        dashboardController
                                            .updateProfile(profileModel)
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
                                    buttonText: "update_key".tr,
                                    textColor: Theme.of(context).indicatorColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ---------------- Change Password Tab ----------------
                    Column(
                      children: [
                        // Scrollable fields
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                CustomTextField(
                                  header: 'current_password_key'.tr,
                                  isRequired: true,
                                  controller: _currentPasswordController,
                                  isPassword: true,
                                  hintText: 'enter_current_password_key'.tr,
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                CustomTextField(
                                  header: 'new_password_key'.tr,
                                  isRequired: true,
                                  controller: _newPasswordController,
                                  isPassword: true,
                                  hintText: 'enter_new_password_key'.tr,
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                CustomTextField(
                                  header: 'confirm_password_key'.tr,
                                  isRequired: true,
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  hintText: 'confirm_new_password_key'.tr,
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Button always at bottom
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            vertical: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          child: CustomButton(
                            onPressed: () {
                              if (_currentPasswordController.text
                                  .trim()
                                  .isEmpty) {
                                showCustomSnackBar(
                                  'please_enter_your_current_password_key'.tr,
                                  isError: true,
                                );
                              } else if (_newPasswordController.text
                                  .trim()
                                  .isEmpty) {
                                showCustomSnackBar(
                                  'please_enter_your_new_password_key'.tr,
                                  isError: true,
                                );
                              } else if (_confirmPasswordController.text
                                  .trim()
                                  .isEmpty) {
                                showCustomSnackBar(
                                  'please_enter_your_confirm_password_key'.tr,
                                  isError: true,
                                );
                              } else {
                                dashboardController
                                    .changePassword(
                                      _currentPasswordController.text.trim(),
                                      _newPasswordController.text.trim(),
                                      _confirmPasswordController.text.trim(),
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
                            buttonText: 'change_password_key'.tr,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
