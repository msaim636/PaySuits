// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/ticket_controller.dart';
import 'package:paysuite/data/model/response/ticket_model.dart';
import 'package:paysuite/helper/date_converter.dart';

import '../../../../controller/permission_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/show_custom_popup_menu.dart';

class TicketItem extends StatelessWidget {
  final TicketModel ticketModel;
  final int index;
  const TicketItem({super.key, required this.ticketModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final permissionData =
            Get.find<PermissionController>().myPermissionModel!.permission;
        if (permissionData!.updateTickets! || permissionData.deleteTickets!) {
          Get.find<TicketController>().setTicketSelectedId(id: ticketModel.id!);
          Get.find<TicketController>().createTicketMoreList(ticketModel);
          showPopupMenu(context, Get.find<TicketController>().ticketMoreList);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
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
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          ticketModel.subject ?? "no_subject".tr,
                        ),

                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: googleSansFlexMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            ticketModel.submittedBy?.email ?? "no_email".tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: LightAppColor.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                // STATUS BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),
                  decoration: BoxDecoration(
                    color: ticketModel.status == "open"
                        ? Theme.of(context).primaryColor
                        : ticketModel.status == "pending"
                        ? LightAppColor.lightOrange
                        : LightAppColor.lightGreen,
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_SMALL,
                    ),
                  ),
                  child: Text(
                    ticketModel.status?.toLowerCase().tr ?? "no_status".tr,
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
                          "priority_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          ticketModel.priority?.name?.toLowerCase().tr ??
                              "no_priority".tr,
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
                          "department_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          ticketModel.department?.name?.toLowerCase().tr ??
                              "no_department".tr,
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
                          "date_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          DateConverter.formatStringDate(
                            ticketModel.createdAt ?? "",
                          ),
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
}
