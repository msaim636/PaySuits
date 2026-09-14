import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerListItemInvoice extends StatelessWidget {
  const CustomerListItemInvoice({
    super.key,
    required this.title,
    required this.onTap,
    required this.index,
  });

  final String title;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (invoiceController) {
        return Padding(
          padding: const EdgeInsets.only(
            right: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE + 6,
            left: Dimensions.PADDING_SIZE_DEFAULT,
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              color: invoiceController.customerListSelectedIndex == index
                  ? Theme.of(context).cardColor
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Divider
                      if (invoiceController.customerListSelectedIndex == index)
                        Container(
                          width: 6,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      SizedBox(
                        width:
                            invoiceController.customerListSelectedIndex == index
                            ? Dimensions.PADDING_SIZE_EXTRA_LARGE - 6
                            : Dimensions.PADDING_SIZE_EXTRA_LARGE,
                      ),

                      // Title
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style:
                              invoiceController.customerListSelectedIndex ==
                                  index
                              ? googleSansFlexBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).primaryColor,
                                )
                              : googleSansFlexRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).hintColor,
                                ),
                        ),
                      ),
                    ],
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                    ),
                    child: Container(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).disabledColor.withValues(alpha: .3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
