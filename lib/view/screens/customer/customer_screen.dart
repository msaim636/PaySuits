// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/customer_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_appbar_action.dart';
import 'widget/customer_item.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<CustomerController>().isPaginateLoading &&
          Get.find<CustomerController>().customerNextPageUrl != null) {
        await Get.find<CustomerController>().getCustomerData(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CustomerController>().getCustomerData();
    });
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "customer_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.createCustomers!)
            CustomAppBarActionButton(
              onPressed: () =>
                  Get.toNamed(RouteHelper.getAddCustomerRoute('0')),
              svgImagePath: Images.addIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<CustomerController>().getCustomerData();
        },
        child: GetBuilder<CustomerController>(
          builder: (customerController) {
            return customerController.isCustomerLoading
                ? const Center(child: LoadingIndicator())
                : customerController.customerList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: customerController.customerList.length,
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          itemBuilder: (context, index) => CustomerItem(
                            customerModel:
                                customerController.customerList[index],
                          ),
                        ),
                      ),
                      if (customerController.isPaginateLoading)
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
