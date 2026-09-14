// ignore_for_file: deprecated_member_use
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../controller/administrator_role_controller.dart';
import '../../../../controller/administrator_user_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class RoleFilterScreen extends StatelessWidget {
  const RoleFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AdministratorUserController>().getRoleListDropdown();
    });

    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(isBackButtonExist: true, title: "filter_key".tr),

      body: GetBuilder<AdministratorRolesController>(
        builder: (administratorRoleController) {
          return administratorRoleController.suggestedAllItemListLoading
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
                            GetBuilder<AdministratorUserController>(
                              builder: (administratorUserController) {
                                return CustomDropDown(
                                  title: 'roles_key'.tr,
                                  isRequired: false,
                                  dwItems: administratorUserController
                                      .roleDropdownStringList,
                                  dwValue: administratorRoleController
                                      .roleFilterDropdownValue,
                                  hintText: 'choose_a_role_key'.tr,
                                  onChange: (value) {
                                    administratorRoleController
                                        .setRoleFilterDropdownValue(value);
                                  },
                                );
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
                              dwItems: administratorRoleController.statusList,
                              dwValue:
                                  administratorRoleController.statusDWValue,
                              hintText: 'choose_a_status_key'.tr,
                              onChange: (value) {
                                administratorRoleController.setStatusDWValue(
                                  value,
                                );
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
                                  administratorRoleController
                                          .isEmptyFilterForm() ==
                                      true
                                  ? () {}
                                  : () {
                                      administratorRoleController
                                          .refreshFilterForm();
                                      administratorRoleController.getRoles();
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
                                        administratorRoleController
                                                .isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  Images.refresh,
                                  color:
                                      administratorRoleController
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
                                    administratorRoleController
                                            .applyFilterLoading ||
                                        (administratorRoleController
                                                .isEmptyFilterForm() ==
                                            true)
                                    ? () {}
                                    : () {
                                        administratorRoleController
                                            .getRoles(
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
                                    administratorRoleController
                                            .isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).hintColor
                                    : null,
                                buttonTextWidget:
                                    administratorRoleController
                                        .applyFilterLoading
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
                                    administratorRoleController
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
