// ignore_for_file: deprecated_member_use, unused_field

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/ticket_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class AddTicketScreen extends StatefulWidget {
  final String value;
  const AddTicketScreen({super.key, this.value = '1'});

  @override
  State<AddTicketScreen> createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final String initialHtml = '';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<TicketController>().refreshTicketForm();
      if (int.parse(widget.value) == 2) {
        await Get.find<TicketController>().getDesignationListDropdown();
        await Get.find<TicketController>().getPriorityListDropdown();
        await Get.find<TicketController>().getTicketUpdateDetails();
      } else {
        await Get.find<TicketController>().getDesignationListDropdown();
        await Get.find<TicketController>().getPriorityListDropdown();
      }
    });

    return Scaffold(
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: int.parse(widget.value) == 2
            ? "edit_ticket_key".tr
            : "add_ticket_key".tr,
        isBackButtonExist: true,
      ),

      // Body Section
      body: GetBuilder<TicketController>(
        builder: (ticketController) {
          return ticketController.suggestedAllItemListLoading ||
                  ticketController.isUpdateTicketDetailsLoading
              ? const Center(child: LoadingIndicator())
              : Form(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Dimensions.FREE_SIZE_DEFAULT,
                                ),

                                // Product name text field section
                                CustomTextField(
                                  header: 'subject_key'.tr,
                                  hintText: 'subject_key'.tr,
                                  isRequired: true,
                                  controller:
                                      ticketController.subjectController,
                                  focusNode: ticketController.subjectFocusNode,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                // Free space
                                const SizedBox(
                                  height: Dimensions.FREE_SIZE_LARGE,
                                ),

                                // Department
                                CustomDropDown(
                                  title: 'department_key'.tr,
                                  isRequired: true,
                                  dwItems: ticketController
                                      .departmentDropdownStringList,
                                  dwValue:
                                      ticketController.departmentDropdownValue,
                                  hintText: 'choose_a_department_key'.tr,
                                  borderColor: Colors.transparent,
                                  onChange: (value) {
                                    ticketController.setDepartmentDropDownValue(
                                      value,
                                    );
                                  },
                                ),
                                // Free space
                                const SizedBox(
                                  height: Dimensions.FREE_SIZE_LARGE,
                                ),

                                // Priority
                                CustomDropDown(
                                  title: 'priority_key'.tr,
                                  isRequired: true,
                                  dwItems: ticketController
                                      .priorityDropdownStringList,
                                  dwValue:
                                      ticketController.priorityDropdownValue,
                                  hintText: 'choose_a_priority_key'.tr,
                                  borderColor: Colors.transparent,
                                  onChange: (value) {
                                    ticketController.setPriorityDropDownValue(
                                      value,
                                    );
                                  },
                                ),
                                // Free space
                                const SizedBox(
                                  height: Dimensions.FREE_SIZE_LARGE,
                                ),

                                InkWell(
                                  onTap: ticketController.myFiles.isNotEmpty
                                      ? null
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  height: 100,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          ticketController
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
                                                          ticketController
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
                                      ).primaryColor.withOpacity(.05),
                                      child: ticketController.myFiles.isNotEmpty
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: ticketController
                                                  .myFiles
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final data = ticketController
                                                    .myFiles[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ).copyWith(
                                                        top: Dimensions
                                                            .PADDING_SIZE_DEFAULT,
                                                        right: Dimensions
                                                            .PADDING_SIZE_DEFAULT,
                                                      ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 40,
                                                            width: 40,
                                                            child: SvgPicture.asset(
                                                              data.type ==
                                                                          'png' ||
                                                                      data.type ==
                                                                          'jpg' ||
                                                                      data.type ==
                                                                          'jpeg' ||
                                                                      data.type ==
                                                                          'gif'
                                                                  ? Images
                                                                        .icon_image
                                                                  : data.type ==
                                                                        'pdf'
                                                                  ? Images
                                                                        .icon_pdf
                                                                  : data.type ==
                                                                        'zip'
                                                                  ? Images
                                                                        .icon_zip
                                                                  : data.type ==
                                                                        'doc'
                                                                  ? Images
                                                                        .icon_docs
                                                                  : data.type ==
                                                                        'xls'
                                                                  ? Images
                                                                        .icon_xls
                                                                  : Images
                                                                        .icon_image,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: -25,
                                                            top: -25,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                ticketController
                                                                    .removePickedFileByIndex(
                                                                      index,
                                                                    );
                                                              },
                                                              icon: const Icon(
                                                                Icons.cancel,
                                                                size: 35,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height:
                                                            Dimensions
                                                                .PADDING_SIZE_SMALL -
                                                            3,
                                                      ),
                                                      Text(
                                                        data.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
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
                                                  Images.icon_upload,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                                const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_DEFAULT,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'tap_here_to_upload_key'
                                                          .tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_SMALL,
                                                            color:
                                                                Get.isDarkMode
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
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

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                int.parse(widget.value) == 1
                                    ? CustomHtmlTextField(
                                        header: 'description_key'.tr,
                                        headerStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Get.isDarkMode
                                                  ? LightAppColor.cardColor
                                                  : LightAppColor.blackGrey,
                                            ),
                                        isRequired: true,
                                        controller: ticketController
                                            .descriptionController,
                                        hintText: 'description_key'.tr,
                                        minHeight: 300,
                                        borderRadius: 10,
                                        enabledBorder: Theme.of(
                                          context,
                                        ).disabledColor.withValues(alpha: 0.1),
                                        focusedBorder: Theme.of(
                                          context,
                                        ).disabledColor.withValues(alpha: 0.1),
                                        onEditorCreated: () async {
                                          if (!mounted) return;
                                          await ticketController
                                              .safeSetEditorText(initialHtml);
                                          WidgetsBinding.instance.addPostFrameCallback((
                                            _,
                                          ) async {
                                            int retry = 0;
                                            const maxRetry = 5;

                                            while (retry < maxRetry &&
                                                mounted) {
                                              try {
                                                await Future.delayed(
                                                  const Duration(
                                                    milliseconds: 250,
                                                  ),
                                                );

                                                ticketController
                                                    .descriptionController
                                                    .setText(initialHtml);

                                                // SUCCESS → stop retrying
                                                break;
                                              } catch (e) {
                                                retry++;

                                                if (kDebugMode) {
                                                  debugPrint(
                                                    ' HTML setText retry $retry failed: $e',
                                                  );
                                                }

                                                if (retry == maxRetry &&
                                                    kDebugMode) {
                                                  debugPrint(
                                                    ' HTML editor failed after retries',
                                                  );
                                                }
                                              }
                                            }
                                          });
                                        },
                                      )
                                    : SizedBox.shrink(),
                              ],
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
                            // Cancel button
                            Expanded(
                              child: CustomButton(
                                radius: Dimensions.RADIUS_DEFAULT - 2,
                                color: Colors.transparent,
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

                            // Free space
                            const SizedBox(
                              width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                            ),

                            // Save button
                            Expanded(
                              child: CustomButton(
                                buttonTextWidget:
                                    ticketController.addTicketLoading ||
                                        ticketController.isUpdateTicketLoading
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
                                    ticketController.addTicketLoading ||
                                        ticketController.isUpdateTicketLoading
                                    ? () {}
                                    : () {
                                        if (ticketController
                                            .subjectController
                                            .text
                                            .isEmpty) {
                                          showCustomSnackBar(
                                            'please_enter_subject_key'.tr,
                                            isError: true,
                                          );
                                          return;
                                        }
                                        if (ticketController
                                                .departmentDropdownValue ==
                                            null) {
                                          showCustomSnackBar(
                                            'please_select_a_department_key'.tr,
                                            isError: true,
                                          );
                                          return;
                                        }
                                        if (ticketController
                                                .priorityDropdownValue ==
                                            null) {
                                          showCustomSnackBar(
                                            'please_select_a_priority_key'.tr,
                                            isError: true,
                                          );
                                          return;
                                        }
                                        if (int.parse(widget.value) == 2) {
                                          ticketController.updateTicketData();
                                        } else {
                                          ticketController.addTicket();
                                        }
                                      },
                                buttonText: int.parse(widget.value) == 2
                                    ? "update_key".tr
                                    : "save_key".tr,
                                textColor: Theme.of(context).indicatorColor,
                                radius: Dimensions.RADIUS_DEFAULT - 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class CustomHtmlTextField extends StatefulWidget {
  final String? header;
  final TextStyle? headerStyle;
  final bool isRequired;
  final HtmlEditorController controller;
  final FocusNode? editorFocusNode;
  final Color? focusedBorder;
  final Color? enabledBorder;
  final bool isEnabled;
  final double? borderRadius;
  final bool divider;
  final double minHeight;
  final String? hintText;
  final void Function()? onEditorCreated;

  const CustomHtmlTextField({
    super.key,
    this.header,
    this.headerStyle,
    required this.controller,
    this.isRequired = false,
    this.focusedBorder,
    this.enabledBorder,
    this.isEnabled = true,
    this.borderRadius,
    this.divider = false,
    this.minHeight = 150,
    this.hintText,
    this.onEditorCreated,
    this.editorFocusNode,
  });

  @override
  State<CustomHtmlTextField> createState() => _CustomHtmlTextFieldState();
}

class _CustomHtmlTextFieldState extends State<CustomHtmlTextField> {
  bool _hasFocus = false;
  bool _isInitialized = false;
  int? _localEditorInstanceId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    // invalidate editor instance immediately (prevents pending tasks)
    final ctl = Get.find<TicketController>();
    ctl.markEditorNotReady();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.header != null)
          Row(
            children: [
              Text(
                widget.header!,
                style:
                    widget.headerStyle ??
                    Theme.of(context).textTheme.bodyMedium,
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
            ],
          ),
        if (widget.header != null) const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
            border: Border.all(
              color: _hasFocus
                  ? (widget.focusedBorder ?? Colors.greenAccent.shade400)
                  : (widget.enabledBorder ??
                        (Get.isDarkMode
                            ? Colors.grey[700]!
                            : Colors.grey.shade300)),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              // HtmlEditor includes toolbar via htmlToolbarOptions
              SizedBox(
                height: widget.minHeight,
                child: HtmlEditor(
                  controller: widget.controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: widget.hintText ?? "Write something...",
                    shouldEnsureVisible: false,
                    adjustHeightForKeyboard: false,
                    autoAdjustHeight: false,
                    darkMode: Get.isDarkMode,
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    initiallyExpanded: true,
                    toolbarType: ToolbarType.nativeScrollable,
                    customToolbarButtons: [],
                    defaultToolbarButtons: [
                      // StyleButtons(style: true),
                      ListButtons(ul: true, ol: true, listStyles: false),
                      FontButtons(
                        bold: true,
                        italic: true,
                        underline: true,
                        strikethrough: false,
                        subscript: false,
                        superscript: false,
                        clearAll: false,
                      ),
                      ParagraphButtons(
                        alignLeft: true,
                        alignCenter: true,
                        alignRight: true,
                        alignJustify: true,
                        increaseIndent: false,
                        decreaseIndent: false,
                        textDirection: false,
                        lineHeight: false,
                        caseConverter: false,
                      ),
                      InsertButtons(
                        link: true,
                        audio: false,
                        picture: false,
                        video: false,
                        table: false,
                        hr: false,
                      ),
                    ],
                  ),
                  callbacks: Callbacks(
                    onInit: () async {
                      // increment instance id as earlier
                      Get.find<TicketController>().editorInstanceId++;
                      final int thisInstance =
                          Get.find<TicketController>().editorInstanceId;
                      _localEditorInstanceId = thisInstance;

                      // small delay for iOS
                      await Future.delayed(const Duration(milliseconds: 220));
                      if (!mounted ||
                          _localEditorInstanceId !=
                              Get.find<TicketController>().editorInstanceId) {
                        return;
                      }

                      Get.find<TicketController>().markEditorReady(
                        instanceId: thisInstance,
                      );

                      // Use pendingHtml if set (preferred), else empty string
                      final html =
                          Get.find<TicketController>().pendingHtml ?? '';
                      if (html.isNotEmpty) {
                        await Get.find<TicketController>().safeSetEditorText(
                          html,
                        );
                        Get.find<TicketController>().pendingHtml =
                            null; // consumed
                      }
                      await Future.delayed(const Duration(milliseconds: 350));

                      await widget.controller.evaluateJavascriptWeb("""
  document.querySelector('.note-editable').style.backgroundColor = '#1D1B21';
  document.querySelector('.note-editable').style.color = 'white';

  document.body.style.backgroundColor = '#1D1B21';
  document.body.style.color = 'white';

  var toolbar = document.querySelector('.note-toolbar');
  if (toolbar) {
    toolbar.style.backgroundColor = '#1D1B21';
  }
""");
                    },
                    onFocus: () => setState(() => _hasFocus = true),
                    onBlur: () => setState(() => _hasFocus = false),
                    onChangeContent: (String? changed) {},
                  ),
                  otherOptions: OtherOptions(
                    height: widget.minHeight,
                    decoration: const BoxDecoration(),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.divider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
      ],
    );
  }
}
