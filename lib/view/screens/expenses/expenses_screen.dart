// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import 'widget/expenses_item.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<ExpensesController>().expensesPaginateLoading &&
          Get.find<ExpensesController>().expensesNextPageUrl != null) {
        await Get.find<ExpensesController>().getExpenses(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ExpensesController>().getExpenses();
    });
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "all_expenses_key".tr,
        actions: [
          // Add button section
          if (permissionData!.createExpenses!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAddExpensesRoute("0"));
              },
              icon: SvgPicture.asset(
                Images.addCategory,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),

          // Filter button section
          if (permissionData.manageGlobalAccess!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getExpansesFilterRoute());
              },
              icon: SvgPicture.asset(
                Images.filter,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      // All Expenses list section
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<ExpensesController>().getExpenses();
        },
        child: GetBuilder<ExpensesController>(
          builder: (expensesController) {
            return expensesController.expensesListLoading
                ? const Center(child: LoadingIndicator())
                : expensesController.expensesList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          controller: _scrollController,
                          itemCount: expensesController.expensesList.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          itemBuilder: (context, index) => ExpensesItem(
                            data: expensesController.expensesList[index],
                            index: index,
                          ),
                        ),
                      ),
                      if (expensesController.expensesPaginateLoading)
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
