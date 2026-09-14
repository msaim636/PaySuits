// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_date_item.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/custom_text_field.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';

class AddExpensesScreen extends StatefulWidget {
  final String isUpdate;
  const AddExpensesScreen({super.key, required this.isUpdate});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  bool _isUpdate = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final expensesController = Get.find<ExpensesController>();
      expensesController.refreshFromData();
      _isUpdate = widget.isUpdate == '1';
      if (_isUpdate) {
        await expensesController.getExpensesDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isUpdate = widget.isUpdate == '1';
    print('object ${Get.find<ExpensesController>().amountController.text}');
    return Scaffold(
      //  Custom App Bar Start
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: _isUpdate ? "update_expenses_key".tr : "add_expenses_key".tr,
      ),

      body: GetBuilder<ExpensesController>(
        builder: (expensesController) {
          return (_isUpdate && expensesController.isExpensesDetailsLoading)
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            header: 'title_key'.tr,
                            isRequired: true,
                            hintText: 'write_your_title_here_key'.tr,
                            controller: expensesController.titleController,
                            focusNode: expensesController.titleFocusNode,
                            fillColor: Theme.of(context).cardColor,
                          ),

                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //  Date
                              Expanded(
                                child: SelectDateItemTextField(
                                  header: 'date_key'.tr,
                                  hintText: 'add_date_key'.tr,
                                  svgImagePath: Images.calender,
                                  controller: expensesController.dateController,
                                  onTap: () {
                                    expensesController.selectDate(context, 2);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: Dimensions.PADDING_SIZE_LARGE,
                              ),

                              Expanded(
                                child: CustomTextField(
                                  header: 'amount_key'.tr,
                                  isRequired: true,
                                  hintText: 'enter_the_amount_key'.tr,
                                  inputType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  isOnlyNumber: true,
                                  inputAction: TextInputAction.done,
                                  controller:
                                      expensesController.amountController,
                                  focusNode: expensesController.amountFocusNode,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          // Ref
                          CustomTextField(
                            header: 'reference_number_key'.tr,
                            isRequired: false,
                            hintText: 'enter_the_reference_number_key'.tr,
                            controller: expensesController.refNumberController,
                            focusNode: expensesController.refNumberFocusNode,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          // Attachments
                          Text(
                            'attachments_key'.tr,
                            style: googleSansFlexRegular.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          InkWell(
                            onTap: expensesController.myFiles.isNotEmpty
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 100,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    expensesController
                                                        .pickedFile();
                                                    Get.back();
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.file_copy,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                      ),
                                                      Text(
                                                        "File",
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    expensesController
                                                        .pickedCamera();
                                                    Get.back();
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                      ),
                                                      Text(
                                                        "Camera",
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              dashPattern: const [6, 6],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(
                                Dimensions.RADIUS_DEFAULT,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 90,
                                width: double.infinity,
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: .05),
                                child: expensesController.myFiles.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            expensesController.myFiles.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              expensesController.myFiles[index];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.all(
                                                  Dimensions.PADDING_SIZE_SMALL,
                                                ).copyWith(
                                                  top: Dimensions
                                                      .PADDING_SIZE_DEFAULT,
                                                  right: Dimensions
                                                      .PADDING_SIZE_DEFAULT,
                                                ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 40,
                                                      width: 40,
                                                      child: SvgPicture.asset(
                                                        data.type == 'png' ||
                                                                data.type ==
                                                                    'jpg' ||
                                                                data.type ==
                                                                    'jpeg' ||
                                                                data.type ==
                                                                    'gif'
                                                            ? Images.imageFile
                                                            : data.type == 'pdf'
                                                            ? Images.pdfFile
                                                            : data.type == 'zip'
                                                            ? Images.zipFile
                                                            : data.type == 'doc'
                                                            ? Images.docxFile
                                                            : data.type == 'xls'
                                                            ? Images.xlsFile
                                                            : Images.imageFile,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: -25,
                                                      top: -25,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          expensesController
                                                              .removePickedFileByIndex(
                                                                index: index,
                                                              );
                                                        },
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          size: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:
                                                      Dimensions
                                                          .PADDING_SIZE_SMALL -
                                                      3,
                                                ),
                                                Text(
                                                  '${data.name}',
                                                  style: googleSansFlexRegular
                                                      .copyWith(
                                                        fontSize: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            Images.upload,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                          const SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ap_here_to_upload_key'.tr,
                                                style: googleSansFlexMedium
                                                    .copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL,
                                                      color: Get.isDarkMode
                                                          ? Theme.of(
                                                              context,
                                                            ).indicatorColor
                                                          : LightAppColor
                                                                .blackGrey,
                                                    ),
                                              ),
                                              const SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                'upload_key'.tr,
                                                style: googleSansFlexBold
                                                    .copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT,
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            'file_details_key'.tr,
                            style: googleSansFlexRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          CustomTextField(
                            header: 'category_key'.tr,
                            isRequired: true,
                            hintText: 'category_name_key'.tr,
                            controller:
                                expensesController.categoryNameController,
                            focusNode: expensesController.categoryFocusNode,
                            nextFocus: expensesController.noteFocusNode,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          // categoryNameController
                          //  Note
                          CustomTextField(
                            header: 'note_key'.tr,
                            isRequired: false,
                            hintText: 'write_here_key'.tr,
                            maxLines: 8,
                            controller: expensesController.noteController,
                            focusNode: expensesController.noteFocusNode,
                            fillColor: Theme.of(context).cardColor,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          //  Bottom button
                          Row(
                            children: [
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
                                width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                              ),
                              Expanded(
                                child: CustomButton(
                                  buttonTextWidget:
                                      expensesController.addExpensesLoading ||
                                          expensesController
                                              .updateExpensesLoading
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
                                      expensesController.addExpensesLoading ||
                                          expensesController
                                              .updateExpensesLoading
                                      ? () {}
                                      : () {
                                          if (expensesController
                                              .titleController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_enter_your_title_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (expensesController
                                              .dateController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_select_expenses_date_key'
                                                  .tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (expensesController
                                              .amountController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_enter_your_amount_key'.tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (expensesController
                                              .categoryNameController
                                              .text
                                              .isEmpty) {
                                            showCustomSnackBar(
                                              'please_enter_your_category_key'
                                                  .tr,
                                              isError: true,
                                            );
                                            return;
                                          }
                                          if (_isUpdate) {
                                            expensesController.updateExpenses();
                                          } else {
                                            expensesController.addExpenses();
                                          }
                                        },
                                  buttonText: _isUpdate
                                      ? "update_key".tr
                                      : "save_key".tr,
                                  radius: Dimensions.RADIUS_DEFAULT - 2,
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
