// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/data/model/response/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/helper/date_converter.dart';
import 'package:intl/intl.dart';

import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/show_custom_popup_menu.dart';

class InvoiceItem extends StatelessWidget {
  final InvoiceModel invoiceModel;
  final int index;
  const InvoiceItem({
    super.key,
    required this.invoiceModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final permissionData =
            Get.find<PermissionController>().myPermissionModel!.permission;

        if (permissionData!.cloneInvoice! ||
            permissionData.duePaymentInvoice! ||
            permissionData.updateInvoices! ||
            permissionData.resendMailEstimate! ||
            permissionData.viewInvoices! ||
            permissionData.downloadInvoice! ||
            permissionData.deleteInvoices!) {
          Get.find<InvoiceController>().createInvoiceMoreList(
            invoiceModel: invoiceModel,
          );
          Get.find<InvoiceController>().createInvoiceMoreListWithoutDue(
            invoiceModel: invoiceModel,
          );
          Get.find<InvoiceController>().setSelectedInvoiceIndex(index);

          showPopupMenu(
            context,
            invoiceModel.status == 'due' ||
                    invoiceModel.status == 'partially_paid'
                ? Get.find<InvoiceController>().invoiceMoreList
                : Get.find<InvoiceController>().invoiceMoreListWithoutDue,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                        Get.find<TransactionController>().capitalizeFirstLetter(
                          invoiceModel.customerName ?? '-',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: googleSansFlexMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            invoiceModel.invoiceNumber ?? "_",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: invoiceModel.status == 'due'
                                  ? Color(0xffE85B5B)
                                  : invoiceModel.status == 'partially_paid'
                                  ? LightAppColor.lightOrange
                                  : LightAppColor.lightGreen,
                            ),
                          ),
                          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
                          Text(
                            "${DateConverter.formatStringDate(invoiceModel.issueDate!)} - ${DateConverter.formatStringDate(invoiceModel.dueDate!)}",

                            style: googleSansFlexRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
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
                    color: invoiceModel.status == 'due'
                        ? Color(0xffE85B5B)
                        : invoiceModel.status == 'partially_paid'
                        ? LightAppColor.lightOrange
                        : LightAppColor.lightGreen,
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_SMALL,
                    ),
                  ),
                  child: Text(
                    invoiceModel.status == 'due'
                        ? "due_key".tr
                        : invoiceModel.status == 'partially_paid'
                        ? "partially_paid_key".tr
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
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
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
                          "total_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          invoiceModel.totalAmount ?? '-',
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Paid".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          invoiceModel.paidAmount ?? '-',
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: LightAppColor.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // MIDDLE — DUE AMOUNT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "due_amount_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          invoiceModel.dueAmount ?? '-',
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
      ),
    );
  }

  String formatCustomDateRange(String start, String end) {
    DateTime? s = DateFormat("dd-MMM-yyyy").parse(start);
    DateTime? e = DateFormat("dd-MMM-yyyy").parse(end);

    String startDay = s.day.toString().padLeft(2, '0');
    String startMonth = DateFormat("MMM").format(s);

    String endDay = e.day.toString().padLeft(2, '0');
    String endMonth = DateFormat("MMM").format(e);
    String endYear = e.year.toString();

    return "$startDay - $startMonth to $endDay $endMonth $endYear";
  }
}
