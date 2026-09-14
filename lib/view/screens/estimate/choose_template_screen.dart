// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_button.dart';

class ChooseTemplateScreen extends StatelessWidget {
  const ChooseTemplateScreen({super.key, required this.isEstimate});

  final bool isEstimate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Custom App Bar Start
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "select_template_key".tr,
      ),

      body: GetBuilder<EstimateController>(
        builder: (estimateController) {
          return GetBuilder<InvoiceController>(
            builder: (invoiceController) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  vertical: Dimensions.PADDING_SIZE_LARGE,
                ),
                child: Column(
                  children: [
                    //  Image Slider
                    Expanded(
                      child: CarouselSlider(
                        items: [
                          ...List.generate(
                            isEstimate
                                ? estimateController
                                      .templateEstimateImageList
                                      .length
                                : invoiceController
                                      .templateInvoiceImageList
                                      .length,
                            (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL,
                                  ),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: .3),
                                    width: 2.5,
                                  ),
                                ),
                                child: Image.asset(
                                  isEstimate
                                      ? estimateController
                                            .templateEstimateImageList[index]
                                      : invoiceController
                                            .templateInvoiceImageList[index],
                                  fit: BoxFit.fill,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              );
                            },
                          ),
                        ],
                        options: CarouselOptions(
                          aspectRatio: 0.8,
                          viewportFraction: 1.0,
                          initialPage: isEstimate
                              ? estimateController.selectedTemplate != null
                                    ? estimateController.selectedTemplate! - 1
                                    : 0
                              : invoiceController.selectedTemplate != null
                              ? invoiceController.selectedTemplate! - 1
                              : 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.0,
                          onPageChanged: (index, reason) {
                            isEstimate
                                ? estimateController
                                      .setTemplateListCurrentIndex(index)
                                : invoiceController.setTemplateListCurrentIndex(
                                    index,
                                  );
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),

                    //  Bottom button
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    //  Dots custom widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          isEstimate
                              ? estimateController
                                    .templateEstimateImageList
                                    .length
                              : invoiceController
                                    .templateInvoiceImageList
                                    .length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            child: buildDot(index, context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    //  Bottom button
                    Row(
                      children: [
                        //  Cancel button
                        Expanded(
                          child: CustomButton(
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            transparent: true,
                            onPressed: () {
                              Get.back();
                            },
                            buttonText: "cancel_key".tr,
                            textColor: Theme.of(context).indicatorColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),

                        //  Select button
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              isEstimate
                                  ? estimateController.setSelectedTemplate(
                                      estimateController
                                          .estimateTemplateListCurrentIndex,
                                    )
                                  : invoiceController.setSelectedTemplate(
                                      invoiceController
                                          .invoiceTemplateListCurrentIndex,
                                    );
                              Get.back();
                            },
                            buttonText: "select_template_key".tr,
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            textColor: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Dot custom widget
  Widget buildDot(int index, BuildContext context) {
    return GetBuilder<EstimateController>(
      builder: (estimateController) {
        return GetBuilder<InvoiceController>(
          builder: (invoiceController) {
            return Container(
              height: 8,
              width: isEstimate
                  ? estimateController.estimateTemplateListCurrentIndex == index
                        ? 18
                        : 8
                  : invoiceController.invoiceTemplateListCurrentIndex == index
                  ? 18
                  : 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isEstimate
                    ? estimateController.estimateTemplateListCurrentIndex ==
                              index
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withValues(alpha: .6)
                    : invoiceController.invoiceTemplateListCurrentIndex == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withValues(alpha: .6),
              ),
            );
          },
        );
      },
    );
  }
}
