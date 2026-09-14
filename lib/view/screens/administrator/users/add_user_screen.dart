// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/administrator_user_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../../../base/loading_indicator.dart';

class AddUsersScreen extends StatelessWidget {
  const AddUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<AdministratorUserController>().clearUsersData();
      await Get.find<AdministratorUserController>().getRoleListDropdown();
    });
    return Scaffold(
      //  Custom App Bar Start
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(isBackButtonExist: true, title: "add_users".tr),

      //  Body Start
      body: GetBuilder<AdministratorUserController>(
        builder: (administratorUserController) {
          return administratorUserController.suggestedAllItemListLoading ||
                  administratorUserController.getUserDetailsLoading
              ? const Center(child: LoadingIndicator())
              : Form(
                  key: administratorUserController.createFormKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //  Customer
                          CustomDropDown(
                            title: 'roles_key'.tr,
                            isRequired: true,
                            dwItems: administratorUserController
                                .roleDropdownStringList,
                            dwValue:
                                administratorUserController.userRoleDWValue,
                            hintText: 'choose_a_role_key'.tr,
                            onChange: (value) {
                              administratorUserController.setUserRoleDWValue(
                                value,
                              );
                            },
                          ),

                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          CustomTextField(
                            header: 'email_key'.tr,
                            isRequired: true,
                            hintText: 'enter_your_email_key'.tr,
                            controller:
                                administratorUserController.emailController,
                            focusNode:
                                administratorUserController.emailFocusNode,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //  Bottom button
                          Row(
                            children: [
                              //  Cancel Button
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
                              const SizedBox(
                                width: Dimensions.PADDING_SIZE_SMALL,
                              ),

                              // Save Button
                              Expanded(
                                child: CustomButton(
                                  radius: Dimensions.RADIUS_DEFAULT - 2,

                                  onPressed:
                                      administratorUserController
                                          .createUserSaveLoading
                                      ? () {}
                                      : () async {
                                          if (administratorUserController
                                              .createFormKey
                                              .currentState!
                                              .validate()) {
                                            if (administratorUserController
                                                    .userRoleDWValue ==
                                                null) {
                                              showCustomSnackBar(
                                                'Please select a role'.tr,
                                                isError: true,
                                              );
                                              return;
                                            }
                                            administratorUserController
                                                .createUserInvite();
                                          }
                                        },
                                  buttonTextWidget:
                                      administratorUserController
                                          .createUserSaveLoading
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
                                  buttonText: "save_key".tr,
                                  textColor: Theme.of(context).indicatorColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
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
