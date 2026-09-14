import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/billing_controller.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';

import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import 'widget/billing_item.dart';

class BillingHistory extends StatefulWidget {
  const BillingHistory({super.key});

  @override
  State<BillingHistory> createState() => _BillingHistoryState();
}

class _BillingHistoryState extends State<BillingHistory> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BillingController>().getBilling();
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Scroll Listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<BillingController>().billingPaginateLoading &&
          Get.find<BillingController>().billingNextPageUrl != null) {
        await Get.find<BillingController>().getBilling(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "billing_history_key".tr,
        actions: [
          CustomAppBarActionButton(
            onPressed: () => Get.toNamed(RouteHelper.getBillingFilterRoute()),
            svgImagePath: Images.filterIcon,
          ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<BillingController>().getBilling();
        },
        child: GetBuilder<BillingController>(
          builder: (billingController) {
            return billingController.billingListLoading
                ? const Center(child: LoadingIndicator())
                : billingController.billingList.isEmpty
                ? Center(child: const NothingToShowHere())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: billingController.billingList.length,
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          itemBuilder: (context, index) => BillingItem(
                            billingModel: billingController.billingList[index],
                          ),
                        ),
                      ),

                      // Pagination loading indicator
                      if (billingController.billingPaginateLoading)
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
