// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings
import 'package:paysuite/controller/customer_controller.dart';
import 'package:paysuite/data/model/body/add_customer_body.dart';
import 'package:paysuite/view/base/custom_country_picker.dart';
import 'package:paysuite/view/base/custom_drop_down.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';

class AddCustomerScreen extends StatefulWidget {
  final String isUpdate;
  const AddCustomerScreen({super.key, required this.isUpdate});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Text editing controllers
  final _companyController = TextEditingController();
  final _customerFirstNameController = TextEditingController();

  final _customerLastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _taxController = TextEditingController();

  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _companyFocusNode = FocusNode();
  final _customerFirstNameFocusNode = FocusNode();

  final _customerLastNameFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _phoneFocusNode = FocusNode();

  final _taxFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final customerController = Get.find<CustomerController>();
      customerController.refreshData();
      if (widget.isUpdate == '1') {
        customerController.getCustomerUpdateDetails().then((value) {
          if (customerController.customerUpdateDetailsModel != null) {
            _companyController.text =
                customerController.customerUpdateDetailsModel!.companyName ??
                "";
            _customerFirstNameController.text =
                customerController.customerUpdateDetailsModel!.firstName ?? "";
            _customerLastNameController.text =
                customerController.customerUpdateDetailsModel!.lastName ?? "";
            _emailController.text =
                customerController.customerUpdateDetailsModel!.email ?? "";

            _taxController.text =
                customerController.customerUpdateDetailsModel!.taxNo ?? "";
            customerController.setUpdatePortalAccess(
              customerController.customerUpdateDetailsModel!.portalAccess ??
                  false,
            );
            customerController.setCountryCode(
              customerController.customerUpdateDetailsModel!.phoneCountry ??
                  "US",
            );
            _phoneController.text =
                customerController.customerUpdateDetailsModel!.phoneNumber !=
                    null
                ? customerController.removeCountryCode(
                    customerController.customerUpdateDetailsModel!.phoneNumber!,
                  )
                : "";
            _addressController.text =
                customerController.customerUpdateDetailsModel!.address ?? "";
            customerController.setGenderListDropDownValue(
              customerController.customerUpdateDetailsModel!.gender,
            );
          } else {
            customerController.setCountryCode("US");
          }
        });
      } else {
        customerController.setCountryCode("US");
      }
    });

    return Scaffold(
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: widget.isUpdate == '1'
            ? "update_customer_key".tr
            : "add_customer_key".tr,
        isBackButtonExist: true,
      ),

      body: GetBuilder<CustomerController>(
        builder: (customerController) {
          return widget.isUpdate == '1' &&
                  customerController.isCustomerUpdateDetailsLoading
              ? const Center(child: LoadingIndicator())
              : widget.isUpdate == '1' &&
                    customerController.customerUpdateDetailsModel == null
              ? Center(
                  child: Text(
                    "something_wrong_key".tr,
                    style: googleSansFlexMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer name text field section
                                CustomTextField(
                                  header: 'first_name_key'.tr,
                                  isRequired: true,
                                  hintText: 'enter_customer_first_name_key'.tr,
                                  controller: _customerFirstNameController,
                                  focusNode: _customerFirstNameFocusNode,
                                  nextFocus: _customerLastNameFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Customer name text field section
                                CustomTextField(
                                  header: 'last_name_key'.tr,
                                  isRequired: true,
                                  hintText: 'enter_customer_last_name_key'.tr,
                                  controller: _customerLastNameController,
                                  focusNode: _customerLastNameFocusNode,
                                  nextFocus: _emailFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                // Customer Email text field section
                                CustomTextField(
                                  header: 'email_key'.tr,
                                  isRequired: true,
                                  hintText: 'enter_customer_email_key'.tr,
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  nextFocus: _phoneFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Phone Section Start
                                CustomCountryPicker(
                                  header: 'phone_number_key'.tr,
                                  hintText: 'enter_phone_number_key'.tr,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                  country: customerController.customerCountry,
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  nextFocus: _taxFocusNode,
                                  prefixIconOnTap: () {
                                    customerController.showPicker(context);
                                  },
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                // Tax no field section
                                CustomTextField(
                                  header: 'tax_no_key'.tr,
                                  isRequired: false,
                                  hintText: 'enter_tax_no_key'.tr,
                                  controller: _taxController,
                                  focusNode: _taxFocusNode,
                                  nextFocus: _companyFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                // Company Name Section
                                CustomTextField(
                                  header: 'company_name_key'.tr,
                                  isRequired: false,
                                  hintText:
                                      'enter_customer_company_name_key'.tr,
                                  controller: _companyController,
                                  focusNode: _companyFocusNode,
                                  nextFocus: _addressFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Customer Tax no text field section
                                CustomTextField(
                                  header: 'address_key'.tr,
                                  hintText: 'enter_address_key'.tr,
                                  controller: _addressController,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                // Gender radio button
                                Obx(() {
                                  return CustomDropDown(
                                    title: "gender_key".tr,
                                    hintText: "select_gender_key".tr,
                                    dwItems: customerController
                                        .genderListDropdownList,
                                    dwValue:
                                        customerController.selectedGender.value,
                                    borderColor: Colors.transparent,
                                    onChange: (val) => customerController
                                        .setGenderListDropDownValue(val),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              color: Colors.transparent,
                              transparent: true,
                              radius: Dimensions.RADIUS_DEFAULT - 2,
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
                            width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                          ),
                          Expanded(
                            child: CustomButton(
                              onPressed:
                                  customerController.isCustomerUpdateLoading ||
                                      customerController.isCustomerLoading ||
                                      customerController.isCustomerAddLoading
                                  ? () {}
                                  : () async {
                                      if (_customerFirstNameController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_customer_first_name_key'
                                              .tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (_customerLastNameController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_customer_last_name_key'
                                              .tr,
                                          isError: true,
                                        );
                                        return;
                                      }
                                      if (_emailController.text.isEmpty) {
                                        showCustomSnackBar(
                                          'please_enter_customer_email_key'.tr,
                                          isError: true,
                                        );
                                        return;
                                      }

                                      final customerBody = AddCustomerBody(
                                        companyName: _companyController.text
                                            .trim(),
                                        firstName: _customerFirstNameController
                                            .text
                                            .trim(),
                                        lastName: _customerLastNameController
                                            .text
                                            .trim(),
                                        email: _emailController.text.trim(),
                                        phoneCountry:
                                            _phoneController.text
                                                .trim()
                                                .isNotEmpty
                                            ? customerController
                                                  .customerCountry
                                                  .countryCode
                                            : "",
                                        phone:
                                            _phoneController.text
                                                .trim()
                                                .isNotEmpty
                                            ? "+" +
                                                  customerController
                                                      .customerCountry
                                                      .phoneCode +
                                                  _phoneController.text.trim()
                                            : _phoneController.text.trim(),
                                        taxNo: _taxController.text.trim(),
                                        address: _addressController.text.trim(),
                                        gender: customerController
                                            .selectedGender
                                            .value,
                                        portalAccess:
                                            customerController.allowPortalAccess
                                            ? '1'
                                            : '0',
                                      );

                                      if (widget.isUpdate != '1') {
                                        await customerController
                                            .addCustomer(
                                              addCustomerBody: customerBody,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                customerController
                                                    .getCustomerData();
                                                Get.back();
                                                showCustomSnackBar(
                                                  value.message,
                                                  isError: false,
                                                );
                                              }
                                            });
                                      } else {
                                        await customerController
                                            .customerUpdate(
                                              addCustomerBody: customerBody,
                                            )
                                            .then((value) {
                                              if (value.isSuccess) {
                                                customerController
                                                    .getCustomerData();
                                                Get.back();
                                                showCustomSnackBar(
                                                  value.message,
                                                  isError: false,
                                                );
                                              }
                                            });
                                      }
                                    },
                              buttonText: widget.isUpdate == '1'
                                  ? "update_key".tr
                                  : "save_key".tr,
                              textColor: Theme.of(context).indicatorColor,
                              radius: Dimensions.RADIUS_DEFAULT - 2,
                              buttonTextWidget:
                                  customerController.isCustomerUpdateLoading ||
                                      customerController.isCustomerLoading ||
                                      customerController.isCustomerAddLoading
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
                            ),
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
