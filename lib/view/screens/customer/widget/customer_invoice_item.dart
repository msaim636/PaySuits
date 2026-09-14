// ignore_for_file: deprecated_member_use

import 'package:paysuite/data/model/response/customer_invoice_detile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/date_converter.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class CustomerInvoiceItem extends StatelessWidget {
  final CustomerInvoiceDetilesModel customerInvoiceDetailsModel;
  const CustomerInvoiceItem({
    super.key,
    required this.customerInvoiceDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CUSTOMER NAME + INVOICE NUMBER
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      customerInvoiceDetailsModel.invoiceNumber ?? '-',

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: googleSansFlexMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "${DateConverter.formatStringDate(customerInvoiceDetailsModel.issueDate!)} - ${DateConverter.formatStringDate(customerInvoiceDetailsModel.dueDate!)}",

                      style: googleSansFlexRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),

              // STATUS BADGE
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                decoration: BoxDecoration(
                  color: customerInvoiceDetailsModel.status == 'due'
                      ? Color(0xffE85B5B)
                      : LightAppColor.lightGreen,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text(
                  customerInvoiceDetailsModel.status == 'Due'
                      ? "Due".tr
                      : "Paid".tr,
                  style: googleSansFlexMedium.copyWith(
                    color: LightAppColor.cardColor,
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: theme.hintColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT — AMOUNT COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "received_key".tr,
                        style: googleSansFlexBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                      ),
                      Text(
                        customerInvoiceDetailsModel.receivedAmount ?? '-',
                        style: googleSansFlexRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // MIDDLE — AMOUNT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "due_key".tr,
                        style: googleSansFlexBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                      ),
                      Text(
                        customerInvoiceDetailsModel.dueAmount ?? '-',

                        style: googleSansFlexRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "amount_key".tr,
                        style: googleSansFlexBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                      ),
                      Text(
                        customerInvoiceDetailsModel.totalAmount ?? '-',
                        style: googleSansFlexRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
