// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/estimate_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:paysuite/view/screens/estimate/widget/estimate_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_appbar_action.dart';

class EstimateScreen extends StatefulWidget {
  final bool? isBackButtonExist;
  const EstimateScreen({super.key, this.isBackButtonExist});

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Scroll Listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<EstimateController>().estimatePaginateLoading &&
          Get.find<EstimateController>().estimateNextPageUrl != null) {
        await Get.find<EstimateController>().getEstimate(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel?.permission;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<EstimateController>().getEstimate();
    });
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isBackButtonExist ?? true,
        title: "estimate_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.createEstimates!)
            CustomAppBarActionButton(
              onPressed: () =>
                  Get.toNamed(RouteHelper.getAddEstimateRoute('1')),
              svgImagePath: Images.addIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
          // Filter button section
          if (permissionData.manageGlobalAccess!)
            CustomAppBarActionButton(
              onPressed: () =>
                  Get.toNamed(RouteHelper.getEstimateFilterRoute()),
              svgImagePath: Images.filterIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),

      //  Body Start
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<EstimateController>().getEstimate();
        },
        child: GetBuilder<EstimateController>(
          builder: (estimateController) {
            return estimateController.estimateListLoading
                ? const Center(child: LoadingIndicator())
                : estimateController.estimateList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      // Estimate List View
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: estimateController.estimateList.length,
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            85,
                          ),
                          itemBuilder: (context, index) => EstimateItem(
                            estimateModel:
                                estimateController.estimateList[index],
                            index: index,
                          ),
                        ),
                      ),

                      // Pagination loading indicator
                      if (estimateController.estimatePaginateLoading)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            Dimensions.PADDING_SIZE_DEFAULT,
                            0,
                            100, // keep above navbar
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
