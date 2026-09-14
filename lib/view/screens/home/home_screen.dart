// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_null_comparison, unnecessary_type_check, unnecessary_cast, dead_code

import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/dashboard_helper.dart';
import 'widget/custom_dashboard_appbar.dart';
import 'widget/dashboard_card.dart';
import 'widget/income_expenses_overview.dart';
import 'widget/payment_overview.dart';
import 'widget/ticket_overview.dart';
import 'widget/top_five_customer_overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  init state
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DashboardController>().loadInitialDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().myPermissionModel;

    final theme = Theme.of(context);
    return Scaffold(
      // Custom Dash Board Appbar Section
      appBar: const CustomDashBoardAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<DashboardController>().loadInitialDashboardData();
        },
        child: GetBuilder<PermissionController>(
          builder: (permissionController) {
            return GetBuilder<DashboardController>(
              builder: (dashboardController) {
                return permissionController.permissionLoading ||
                        dashboardController.isInitialDashboardLoading ||
                        dashboardController.dashboardInfoModel == null
                    ? const Center(child: LoadingIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 85),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2.2,

                                children: [
                                  DashboardStatCard(
                                    title: 'total_amount_key'.tr,
                                    amount: formatAmount(
                                      parseCurrency(
                                        dashboardController
                                                .dashboardInfoModel
                                                ?.totalAmount
                                                .toString() ??
                                            '0',
                                      ),
                                    ),
                                    color: Color(0xFFFF5A1F),
                                    icon: Icons.bar_chart_rounded,
                                  ),
                                  DashboardStatCard(
                                    title: 'total_paid_key'.tr,
                                    amount: formatAmount(
                                      parseCurrency(
                                        dashboardController
                                                .dashboardInfoModel
                                                ?.totalPaidAmount
                                                .toString() ??
                                            '0',
                                      ),
                                    ),
                                    color: Color(0xFF1F8B4C),
                                    icon: Icons.check_circle_rounded,
                                  ),
                                  DashboardStatCard(
                                    title: 'total_due_key'.tr,
                                    amount: formatAmount(
                                      parseCurrency(
                                        dashboardController
                                                .dashboardInfoModel
                                                ?.totalDueAmount
                                                .toString() ??
                                            '0',
                                      ),
                                    ),
                                    color: Color(0xFF2563EB),
                                    icon: Icons.error_outline_rounded,
                                  ),
                                  DashboardStatCard(
                                    title: 'total_expense_key'.tr,
                                    amount: formatAmount(
                                      parseCurrency(
                                        dashboardController
                                                .dashboardInfoModel
                                                ?.totalExpenseAmount
                                                .toString() ??
                                            '0',
                                      ),
                                    ),
                                    color: Color(0xFF5246a0),
                                    icon: Icons.remove_circle_outline,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimensions.FREE_SIZE_DEFAULT,
                              ),
                              IncomeExpensesOverview(theme: theme),
                              SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

                              PaymentOverview(theme: theme),
                              SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

                              TopFIveCustomerOverview(),
                              SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
                              TicketOverview(),
                            ],
                          ),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
