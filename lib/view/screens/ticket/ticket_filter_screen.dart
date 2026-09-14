// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/ticket_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_drop_down.dart';
import '../../base/loading_indicator.dart';

class TicketFilterScreen extends StatelessWidget {
  const TicketFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<EstimateController>().getCustomerListDropdown();
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "ticket_filter_key".tr,
      ),

      body: GetBuilder<TicketController>(
        builder: (ticketController) {
          return GetBuilder<EstimateController>(
            builder: (esimateController) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
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
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Status section
                                CustomDropDown(
                                  title: 'status_key'.tr,
                                  isRequired: false,
                                  borderColor: Colors.transparent,
                                  dwItems: ticketController.ticketStatusList,
                                  dwValue: ticketController.ticketStatusDWValue,
                                  hintText: 'choose_a_status_key'.tr,
                                  onChange: (value) {
                                    ticketController.setTicketStatusDWValue(
                                      value,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Button section
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        // Refresh Button
                        InkWell(
                          onTap: ticketController.isEmptyFilterForm() == true
                              ? () {}
                              : () {
                                  ticketController.refreshFilterForm();
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
                                    ticketController.isEmptyFilterForm() == true
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            child: SvgPicture.asset(
                              Images.refresh,
                              color:
                                  ticketController.isEmptyFilterForm() == true
                                  ? Theme.of(context).hintColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        // Apply Filter Button
                        Expanded(
                          child: CustomButton(
                            onPressed:
                                ticketController.applyFilterLoading ||
                                    (ticketController.isEmptyFilterForm() ==
                                        true)
                                ? () {}
                                : () {
                                    ticketController
                                        .getTicket(
                                          fromFilter: true,
                                          isApplyFilter: true,
                                        )
                                        .then((value) {
                                          if (value.isSuccess) {
                                            Get.back();
                                          }
                                        });
                                  },
                            color: ticketController.isEmptyFilterForm() == true
                                ? Theme.of(context).hintColor
                                : null,
                            buttonTextWidget:
                                ticketController.applyFilterLoading
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
                                ticketController.isEmptyFilterForm() == true
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
