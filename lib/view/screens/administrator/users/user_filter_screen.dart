// ignore_for_file: deprecated_member_use

import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../controller/administrator_user_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class UserFilterScreen extends StatelessWidget {
  const UserFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AdministratorUserController>().getRoleListDropdown();
    });

    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(isBackButtonExist: true, title: "filter_key".tr),

      body: GetBuilder<AdministratorUserController>(
        builder: (administratorController) {
          return administratorController.suggestedAllItemListLoading
              ? LoadingIndicator()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
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
                            CustomDropDown(
                              title: 'roles_key'.tr,
                              isRequired: false,
                              dwItems: administratorController
                                  .roleDropdownStringList,
                              dwValue: administratorController
                                  .roleFilterDropdownValue,
                              hintText: 'choose_a_role_key'.tr,
                              onChange: (value) {
                                administratorController
                                    .setRoleFilterDropdownValue(value);
                              },
                            ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),

                            // Status section
                            CustomDropDown(
                              title: 'status_key'.tr,
                              isRequired: false,
                              borderColor: Theme.of(context).disabledColor,
                              dwItems: administratorController.statusList,
                              dwValue: administratorController.statusDWValue,
                              hintText: 'choose_a_status_key'.tr,
                              onChange: (value) {
                                administratorController.setStatusDWValue(value);
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
                            // Refresh Button
                            InkWell(
                              onTap:
                                  administratorController.isEmptyFilterForm() ==
                                      true
                                  ? () {}
                                  : () {
                                      administratorController
                                          .refreshFilterForm();
                                      administratorController.getUsers();
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
                                        administratorController
                                                .isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  Images.refresh,
                                  color:
                                      administratorController
                                              .isEmptyFilterForm() ==
                                          true
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Apply Button
                            Expanded(
                              child: CustomButton(
                                onPressed:
                                    administratorController
                                            .applyFilterLoading ||
                                        (administratorController
                                                .isEmptyFilterForm() ==
                                            true)
                                    ? () {}
                                    : () {
                                        administratorController
                                            .getUsers(
                                              fromFilter: true,
                                              isApplyFilter: true,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                Get.back();
                                              }
                                            });
                                      },
                                color:
                                    administratorController
                                            .isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).hintColor
                                    : null,
                                buttonTextWidget:
                                    administratorController.applyFilterLoading
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
                                    administratorController
                                            .isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).indicatorColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.FREE_SIZE_LARGE),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
