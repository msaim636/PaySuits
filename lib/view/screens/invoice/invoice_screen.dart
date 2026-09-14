// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:paysuite/controller/invoice_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:paysuite/view/screens/invoice/widget/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';

class InvoiceScreen extends StatefulWidget {
  final bool? isBackButtonExist;
  const InvoiceScreen({super.key, this.isBackButtonExist});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
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
      if (!Get.find<InvoiceController>().invoicePaginateLoading &&
          Get.find<InvoiceController>().invoiceNextPageUrl != null) {
        await Get.find<InvoiceController>().getInvoice(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Permission Controller
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<InvoiceController>().getInvoice();
    });
    debugPrint("==========> ${permissionData.toString()}");
    return Scaffold(
      // App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isBackButtonExist ?? true,
        title: "invoice_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.createInvoices!)
            CustomAppBarActionButton(
              onPressed: () =>
                  Get.toNamed(RouteHelper.getCreateInvoiceRoute('1')),
              svgImagePath: Images.addIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
          // Filter button section
          if (permissionData.manageGlobalAccess!)
            CustomAppBarActionButton(
              onPressed: () => Get.toNamed(RouteHelper.getInvoiceFilterRoute()),
              svgImagePath: Images.filterIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),

      // Body Section
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<InvoiceController>().getInvoice();
        },
        child: GetBuilder<InvoiceController>(
          builder: (invoiceController) {
            return invoiceController.invoiceListLoading
                ? const Center(child: LoadingIndicator())
                : invoiceController.invoiceList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      // Invoice List Section
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: invoiceController.invoiceList.length,
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            85,
                          ),
                          itemBuilder: (context, index) => InvoiceItem(
                            invoiceModel: invoiceController.invoiceList[index],
                            index: index,
                          ),
                        ),
                      ),

                      // Load More Section
                      if (invoiceController.invoicePaginateLoading)
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
