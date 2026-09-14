// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';

class CalculationItem extends StatelessWidget {
  const CalculationItem({
    super.key,
    required this.title,
    this.value,
    this.titleStyle,
    this.valueStyle,
    this.valueWidget,
    this.percent,
    this.index,
    required this.isInvoice,
    required this.isDismissable,
  });

  final String title;
  final TextStyle? titleStyle;
  final String? value;
  final TextStyle? valueStyle;
  final Widget? valueWidget;
  final String? percent;
  final int? index;
  final bool isInvoice;
  final bool isDismissable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (invoiceController) {
        return GetBuilder<EstimateController>(
          builder: (estimateController) {
            return isDismissable
                ? Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.RADIUS_DEFAULT,
                        ),
                        color: Theme.of(context).colorScheme.error,
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      isInvoice
                          ? invoiceController.removeSelectedTaxItem(index!)
                          : estimateController.removeSelectedTaxItem(index!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: Row(
                        children: [
                          // title
                          Text(
                            title,
                            style:
                                titleStyle ??
                                googleSansFlexBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                          SizedBox(
                            width: percent != null
                                ? Dimensions.PADDING_SIZE_SMALL
                                : 0,
                          ),
                          percent != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      percent!,
                                      style: googleSansFlexBold.copyWith(
                                        color: Theme.of(context).cardColor,
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const Spacer(),

                          // value
                          valueWidget ??
                              Text(
                                value ?? '',
                                style:
                                    valueStyle ??
                                    googleSansFlexMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      color: Get.isDarkMode
                                          ? Theme.of(context).indicatorColor
                                          : LightAppColor.blackGrey,
                                    ),
                              ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    child: Row(
                      children: [
                        // title
                        Text(
                          title,
                          style:
                              titleStyle ??
                              googleSansFlexBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                        SizedBox(
                          width: percent != null
                              ? Dimensions.PADDING_SIZE_SMALL
                              : 0,
                        ),

                        // percent
                        percent != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    percent!,
                                    style: googleSansFlexBold.copyWith(
                                      color: Theme.of(context).indicatorColor,
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_SMALL,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),

                        // value
                        valueWidget ??
                            Text(
                              value ?? '',
                              style:
                                  valueStyle ??
                                  googleSansFlexMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : LightAppColor.blackGrey,
                                  ),
                            ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
