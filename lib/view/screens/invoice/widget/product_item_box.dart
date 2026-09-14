// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/view/base/product_amount_text_field.dart';
import '../../../../controller/invoice_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../estimate/widget/calculation_item.dart';

class ProductItemBox extends StatelessWidget {
  const ProductItemBox({
    super.key,
    required this.selectedProductItemModel,
    required this.index,
    required this.isInvoice,
  });

  final SelectedProductItemModel selectedProductItemModel;
  final int index;
  final bool isInvoice;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (invoiceController) {
        return GetBuilder<EstimateController>(
          builder: (estimateController) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Dismissible(
                key: Key(selectedProductItemModel.productId.toString()),
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
                  if (isInvoice) {
                    invoiceController.removeSelectedProductItem(index);
                    invoiceController.update();
                  } else {
                    estimateController.removeSelectedProductItem(index);
                    estimateController.update();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_DEFAULT,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  Product name
                          Expanded(
                            flex: 3,
                            child: Text(
                              selectedProductItemModel.name,
                              style: googleSansFlexMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Get.isDarkMode
                                    ? Theme.of(context).indicatorColor
                                    : LightAppColor.blackGrey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),

                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //  Remove button
                                InkWell(
                                  onTap: () {
                                    isInvoice
                                        ? invoiceController
                                              .invoiceQuantityDecrement(
                                                index: index,
                                              )
                                        : estimateController
                                              .estimateQuantityDecrement(
                                                index: index,
                                              );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).disabledColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.remove,
                                        color: Theme.of(context).disabledColor,
                                        size: Dimensions.PADDING_SIZE_SMALL * 2,
                                      ),
                                    ),
                                  ),
                                ),

                                //  Quantity
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  child: ProductAmountCustomTextField(
                                    width: 50,
                                    hintText: '',
                                    textAlign: TextAlign.center,
                                    inputType: TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    isOnlyNumber: true,
                                    inputAction: TextInputAction.done,
                                    controller:
                                        selectedProductItemModel.quantity,
                                    fillColor: Theme.of(context).cardColor,
                                    onChanged: (value) {
                                      isInvoice
                                          ? invoiceController
                                                .quantityChangeCalculation(
                                                  index: index,
                                                  quantity: value.isEmpty
                                                      ? null
                                                      : int.parse(value),
                                                )
                                          : estimateController
                                                .quantityChangeCalculation(
                                                  index: index,
                                                  quantity: value.isEmpty
                                                      ? null
                                                      : int.parse(value),
                                                );
                                      invoiceController.update();
                                      estimateController.update();
                                    },
                                  ),
                                ),

                                //  Add button
                                InkWell(
                                  onTap: () {
                                    isInvoice
                                        ? invoiceController
                                              .invoiceQuantityIncrement(
                                                index: index,
                                              )
                                        : estimateController
                                              .estimateQuantityIncrement(
                                                index: index,
                                              );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).disabledColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context).disabledColor,
                                        size: Dimensions.PADDING_SIZE_SMALL * 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //  Unit price
                                Text(
                                  'unit_price_key'.tr,
                                  textAlign: TextAlign.end,
                                  style: googleSansFlexMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : LightAppColor.blackGrey,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                // Unit price
                                Text(
                                  selectedProductItemModel.price.toString(),
                                  style: googleSansFlexMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : LightAppColor.blackGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(
                          context,
                        ).disabledColor.withValues(alpha: .3),
                      ),
                      //  Total amount
                      CalculationItem(
                        title: 'total_amount_key'.tr,
                        value: selectedProductItemModel.totalPrice
                            .toStringAsFixed(2),
                        valueStyle: googleSansFlexBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Get.isDarkMode
                              ? Theme.of(context).indicatorColor
                              : LightAppColor.blackGrey,
                        ),
                        isDismissable: false,
                        isInvoice: false,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
