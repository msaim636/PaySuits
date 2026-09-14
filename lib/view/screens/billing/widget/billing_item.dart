import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/billing_controller.dart';
import 'package:paysuite/view/screens/home/widget/custom_horizontal_divider.dart';

import '../../../../controller/payment_controller.dart';
import '../../../../data/model/response/billing_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class BillingItem extends StatelessWidget {
  final BillingModel billingModel;
  const BillingItem({super.key, required this.billingModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: billingModel.status == "due" || billingModel.status == "cancelled"
          ? () {
              Get.find<BillingController>().setSelectedBillinngIndex(
                billingModel.id!,
              );
              Get.bottomSheet(
                RenewPaymentMethodBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            }
          : () {},
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
                        billingModel.plan?.name?.toLowerCase().tr ?? "".tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: googleSansFlexMedium.copyWith(
                          color: Get.isDarkMode
                              ? LightAppColor.cardColor
                              : null,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            billingModel.invoiceNumber ?? "--".tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          CustomHorizontalDivider(
                            height: 10,
                            color: Theme.of(context).disabledColor,
                          ),
                          Text(
                            DateConverter.estimatedDateFromApi(
                              billingModel.createdAt ?? "",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: googleSansFlexMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).disabledColor,
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
                    color: billingModel.status == "paid"
                        ? LightAppColor.lightGreen
                        : LightAppColor.lightRed,
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_SMALL,
                    ),
                  ),
                  child: Text(
                    billingModel.status?.toLowerCase().tr ?? "".tr,

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
                          "company_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          billingModel.tenant?.name?.toLowerCase().tr ?? "".tr,
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
                          "payment_by_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          billingModel.paymentMethod?.name?.toLowerCase().tr ??
                              "--".tr,
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
                          "total_key".tr,
                          style: googleSansFlexBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          billingModel.amount ?? "".tr,
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

class RenewPaymentMethodBottomSheet extends StatelessWidget {
  final dynamic plan;
  const RenewPaymentMethodBottomSheet({super.key, this.plan});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      initState: (_) {
        Get.find<PaymentController>().getPaymentMethods();
      },
      builder: (paymentController) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                'select_payment_method_key'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              // Loading
              if (paymentController.paymentListLoading)
                const Center(child: CircularProgressIndicator()),

              // List
              if (!paymentController.paymentListLoading)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentController.paymentMethodsList.length,
                  itemBuilder: (context, index) {
                    final method = paymentController.paymentMethodsList[index];

                    return ListTile(
                      leading: const Icon(Icons.payment),
                      title: Text(method.name ?? ''),
                      onTap: () {
                        Get.back();

                        // Call payment flow here
                        paymentController.startRenewPayment(
                          method: method,
                          plan: plan,
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
