// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../util/dimensions.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.bgColor,
    required this.titleColor,
    required this.title,
    required this.isActive,
    required this.index,
  });

  final Color bgColor;
  final Color titleColor;
  final String title;
  final bool isActive;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      builder: (transactionController) {
        return InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
              vertical: Dimensions.PADDING_SIZE_SMALL - 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: isActive ? bgColor : bgColor.withValues(alpha: .1),
            ),
            child: Text(
              title,
              style: googleSansFlexMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                color: isActive ? Theme.of(context).indicatorColor : titleColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
