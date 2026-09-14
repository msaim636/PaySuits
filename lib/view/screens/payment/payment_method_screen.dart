// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/payment_controller.dart';
import 'package:paysuite/view/base/custom_icon_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:paysuite/view/screens/payment/widget/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import 'widget/add_payment_dialog.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final ScrollController _scrollController = ScrollController();

  // init state
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // scroll listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<PaymentController>().paymentPaginateLoading &&
          Get.find<PaymentController>().paymentNextPageUrl != null) {
        await Get.find<PaymentController>().getPaymentMethods(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get permission data
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<PaymentController>().getPaymentMethods();
    });
    return Scaffold(
      // Payment method app bar
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "payment_method_key".tr,
        actions: [
          // Add Payment button section
          if (permissionData!.createPaymentMethods!)
            CustomIconButton(
              onTap: () => Get.dialog(AddPaymentDialog(isUpdate: false)),
              iconPath: Images.addCategory,
            ),
        ],
      ),

      // Body section
      body: GetBuilder<PaymentController>(
        builder: (paymentController) {
          return paymentController.paymentListLoading
              ? const Center(child: LoadingIndicator())
              : paymentController.paymentMethodsList.isEmpty
              ? const NothingToShowHere()
              : Column(
                  children: [
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // Payment method list show section
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: paymentController.paymentMethodsList.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        itemBuilder: (context, index) {
                          return PaymentMethodItem(
                            data: paymentController.paymentMethodsList[index],
                            index: index,
                          );
                        },
                      ),
                    ),

                    // Payment method loading indicator
                    if (paymentController.paymentPaginateLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Center(child: LoadingIndicator()),
                      ),
                  ],
                );
        },
      ),
    );
  }
}
