// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/view/base/custom_image.dart';
import 'package:paysuite/view/screens/trensaction/widget/note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/transaction_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.data});

  final TransactionModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (data.note == null || data.note!.trim().isEmpty)
          ? () {}
          : () {
              Get.dialog(NoteDialog(body: data.note ?? ''));
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
                  child: Row(
                    children: [
                      data.profilePicture != null
                          ? ClipOval(
                              child: CustomImage(
                                image: data.profilePicture!,
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 45,
                              width: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                Get.find<TransactionController>()
                                    .getFirstTwoCapitalLetters(
                                      data.customerName!,
                                    ),
                                style: googleSansFlexBold.copyWith(
                                  color: Theme.of(context).indicatorColor,
                                ),
                              ),
                            ),
                      SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Get.find<TransactionController>()
                                  .capitalizeFirstLetter(
                                    data.customerName.toString(),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: googleSansFlexMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  data.invoiceFullNumber ?? "_",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: googleSansFlexMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: LightAppColor.lightGreen,
                                  ),
                                ),
                                SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
                                Text(
                                  DateConverter.formatStringDate(
                                    data.receivedOn ?? "",
                                  ),
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
                    color: LightAppColor.lightGreen,
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_SMALL,
                    ),
                  ),
                  child: Text(
                    data.paymentMethod?.toLowerCase().tr ?? "-",
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "transaction_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          data.transactionFullNumber ?? '-',
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
                          "amount_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          data.amount ?? '-',
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
