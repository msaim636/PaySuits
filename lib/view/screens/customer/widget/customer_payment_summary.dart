// ignore_for_file: deprecated_member_use

import 'package:paysuite/data/model/response/customer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../home/widget/custom_horizontal_divider.dart';
import '../../home/widget/dashboard_item.dart';

class CustomerPaymentSummary extends StatelessWidget {
  final CustomerDetailsModel customerDetailsModel;
  const CustomerPaymentSummary({super.key, required this.customerDetailsModel});

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width - 30,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          /// Total Invoice Amount
          Row(
            children: [
              Expanded(
                child: DashBoardItem(
                  icon: Images.totalAmount,
                  title: "total_invoice_key".tr,
                  subTitle: _formatAmount(
                    customerDetailsModel.totalInvoiceAmount,
                  ),
                  color: Theme.of(context).primaryColor,
                  isCenter: true,
                ),
              ),

              /// FIX: Give the divider a fixed width
              const SizedBox(width: 5, child: CustomHorizontalDivider()),
              Expanded(
                child: DashBoardItem(
                  icon: Images.estimatesIcon,
                  title: "total_estimate_key".tr,
                  subTitle: _formatAmount(
                    customerDetailsModel.totalEstimateAmount,
                  ),
                  color: LightAppColor.dodgerBlue,
                  isCenter: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Divider(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          /// Due & Paid
          Row(
            children: [
              Expanded(
                child: DashBoardItem(
                  icon: Images.totalDue,
                  title: "total_due_key".tr,
                  subTitle: _formatAmount(customerDetailsModel.totalDueAmount),
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 5, child: CustomHorizontalDivider()),
              Expanded(
                child: DashBoardItem(
                  icon: Images.paidIcon,
                  title: "total_paid_key".tr,
                  subTitle: _formatAmount(customerDetailsModel.totalPaidAmount),
                  color: LightAppColor.aquamarine,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
