// ignore_for_file: deprecated_member_use, unused_local_variable, unused_import

import 'package:flutter_svg/flutter_svg.dart';
import 'package:paysuite/controller/product_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import '../../base/custom_icon_button.dart';
import 'widget/product_item.dart';

class ProductScreen extends StatefulWidget {
  final bool? isBackButtonExist;
  const ProductScreen({super.key, this.isBackButtonExist});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
      if (!Get.find<ProductController>().isPaginateLoading &&
          Get.find<ProductController>().productsNextPageUrl != null) {
        await Get.find<ProductController>().getProducts(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get permission data
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ProductController>().getProducts();
    });
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Scaffold(
          // App Bar Start  If product available then Appbar visible otherwise invisible
          appBar: CustomAppBar(
            isBackButtonExist: widget.isBackButtonExist ?? true,
            title: "product_list_key".tr,
            actions: [
              // Add button section
              if (permissionData!.createProducts!)
                CustomAppBarActionButton(
                  onPressed: () =>
                      Get.toNamed(RouteHelper.getAddProductRoute('0')),
                  svgImagePath: Images.addIcon,
                ),
              SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
              // Filter button section
              if (permissionData.manageGlobalAccess!)
                CustomAppBarActionButton(
                  onPressed: () =>
                      Get.toNamed(RouteHelper.getProductFilterRoute()),
                  svgImagePath: Images.filterIcon,
                ),
              SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
            ],
          ),

          // Body start
          body: RefreshIndicator(
            onRefresh: () async {
              Get.find<ProductController>().getProducts();
            },
            child: productController.isProductsLoading
                ? const Center(child: LoadingIndicator())
                : productController.productList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      // Product List Section
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            Dimensions.PADDING_SIZE_SMALL,
                            85,
                          ),
                          controller: _scrollController,
                          itemCount: productController.productList.length,
                          itemBuilder: (context, index) => ProductItem(
                            productModel: productController.productList[index],
                          ),
                        ),
                      ),

                      // Paginate Section
                      if (productController.isPaginateLoading)
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
                  ),
          ),
        );
      },
    );
  }
}
