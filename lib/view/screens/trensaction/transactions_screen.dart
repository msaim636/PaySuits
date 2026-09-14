// ignore_for_file: deprecated_member_use, unused_local_variable, unused_import

import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import '../../base/custom_icon_button.dart';
import 'widget/transaction_item.dart';

class TransactionsScreen extends StatefulWidget {
  final bool? isCustomerScreen;
  const TransactionsScreen({super.key, this.isCustomerScreen});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  // init state
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // pagination function
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<TransactionController>().transactionPaginateLoading &&
          Get.find<TransactionController>().transactionNextPageUrl != null) {
        await Get.find<TransactionController>().getTransaction(
          isPaginate: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<TransactionController>().getTransaction();
    });
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: widget.isCustomerScreen ?? true,
        title: "transaction_list_key".tr,
        actions: [
          // Filter button section
          if (permissionData!.manageGlobalAccess!)
            CustomAppBarActionButton(
              onPressed: () =>
                  Get.toNamed(RouteHelper.getTransactionFilterRoute()),
              svgImagePath: Images.filterIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),

      // Show transaction list
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<TransactionController>().getTransaction();
        },
        child: GetBuilder<TransactionController>(
          builder: (transactionController) {
            return transactionController.transactionListLoading
                ? const Center(child: LoadingIndicator())
                : transactionController.transactionList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      // transaction list section
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              transactionController.transactionList.length,
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          itemBuilder: (context, index) => TransactionItem(
                            data: transactionController.transactionList[index],
                          ),
                        ),
                      ),

                      // pagination loading indicator
                      if (transactionController.transactionPaginateLoading)
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
      ),
    );
  }
}
