import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/payment_controller.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';

import '../../../controller/plan_controller.dart';
import '../../../data/model/response/subscription_my_plan_model.dart';

class SmoothHorizontalSubscriptionPlansScreen extends StatefulWidget {
  const SmoothHorizontalSubscriptionPlansScreen({super.key});

  @override
  State<SmoothHorizontalSubscriptionPlansScreen> createState() =>
      _SmoothHorizontalSubscriptionPlansScreenState();
}

class _SmoothHorizontalSubscriptionPlansScreenState
    extends State<SmoothHorizontalSubscriptionPlansScreen>
    with SingleTickerProviderStateMixin {
  late final PlanController controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PlanController>();

    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _filterPlans(isInitial: false);
      }
    });

    // Load plans after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getSubscriptionMyPlan();
      _filterPlans(isInitial: true);
    });
  }

  void _filterPlans({bool isInitial = false}) {
    final currentPlan = controller.subscriptionMyPlanList.firstWhereOrNull(
      (plan) => plan.id == controller.currentPlanId,
    );

    if (isInitial && currentPlan != null) {
      final tabIndex = currentPlan.frequency == "monthly" ? 0 : 1;
      if (_tabController.index != tabIndex) {
        _tabController.animateTo(tabIndex);
      }
    }

    final tabFrequency = _tabController.index == 0 ? "monthly" : "yearly";

    controller.filteredPlans = controller.subscriptionMyPlanList
        .where((plan) => plan.frequency == tabFrequency)
        .toList();

    // Ensure selectedPlanIndex is always valid
    if (controller.filteredPlans.isEmpty) {
      controller.selectedPlanIndex = 0;
    } else {
      int currentIndex = controller.filteredPlans.indexWhere(
        (plan) => plan.id == controller.currentPlanId,
      );
      controller.selectedPlanIndex = currentIndex >= 0
          ? currentIndex
          : 0; // default to 0 if not found
    }

    // PageView safe jump
    if (controller.pageController.hasClients &&
        controller.filteredPlans.isNotEmpty) {
      controller.pageController.jumpToPage(controller.selectedPlanIndex);
    }

    controller.update();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "choose_a_plan_key".tr,
        centerTitle: true,
        isBackButtonExist: true,
      ),
      body: GetBuilder<PlanController>(
        builder: (controller) {
          // Loading state
          if (controller.isSubscriptionMyPlanLoading) {
            return const Center(child: LoadingIndicator());
          }

          // Empty state
          if (controller.filteredPlans.isEmpty) {
            return Center(
              child: Text(
                'no_plans_available_key'.tr,
                style: googleSansFlexMedium.copyWith(),
              ),
            );
          }

          // Data loaded
          return Column(
            children: [
              // ---------------- Full Width Rounded TabBar ----------------
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  vertical: Dimensions.PADDING_SIZE_SMALL,
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(
                    Dimensions.RADIUS_DEFAULT,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.RADIUS_DEFAULT,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Get.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                  labelStyle: googleSansFlexMedium.copyWith(fontSize: 14),
                  unselectedLabelStyle: googleSansFlexRegular.copyWith(
                    fontSize: 14,
                  ),
                  isScrollable: false,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: 'monthly_key'.tr),
                    Tab(text: 'yearly_key'.tr),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.FREE_SIZE_SMALL),

              // Instruction text
              Text(
                'swipe_to_see_all_options_key'.tr,
                style: googleSansFlexRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: Get.isDarkMode
                      ? Colors.grey.shade300
                      : LightAppColor.blackGrey,
                ),
              ),

              // ---------------- PageView ----------------
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.filteredPlans.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final plan = controller.filteredPlans[index];

                    return AnimatedBuilder(
                      animation: controller.pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (controller.pageController.position.haveDimensions) {
                          value = (controller.pageController.page! - index)
                              .clamp(-1, 1);
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value.clamp(0.7, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: SmoothPlanCard(
                          plan: plan,
                          isSelected: controller.selectedPlanIndex == index,
                          onTap: () {
                            controller.pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ---------------- Page indicators ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.filteredPlans.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.selectedPlanIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),

              // ---------------- Get Button ----------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  vertical: Dimensions.FREE_SIZE_DEFAULT,
                ),
                child: CustomButton(
                  onPressed: () {
                    final plan =
                        controller.filteredPlans[controller.selectedPlanIndex];

                    Get.bottomSheet(
                      PaymentMethodBottomSheet(plan: plan),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  buttonText:
                      '${"get_key".tr} ${controller.filteredPlans[controller.selectedPlanIndex].name?.toLowerCase().tr}',
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class SmoothPlanCard extends StatelessWidget {
  final SubscriptionMyPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const SmoothPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final features = plan.planFeatures?.toFeatureMap() ?? {};

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade200,
            width: isSelected ? 5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                plan.name?.toLowerCase().tr ?? '',
                style: const TextStyle(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              // Price
              Text(
                plan.price ?? '',
                style: googleSansFlexBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE,
                ),
              ),

              const SizedBox(height: 8),

              // Current plan
              if (plan.id == Get.find<PlanController>().currentPlanId)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(
                            alpha: Get.isDarkMode ? 0.3 : 0.6,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'your_current_plan_key'.tr,
                          style: googleSansFlexMedium.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const Divider(),
              const SizedBox(height: 8),

              // Features
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: features.entries
                        .where((e) => e.value)
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.key.toLowerCase().tr,
                                    style: googleSansFlexRegular.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension PlanFeatureMapper on PlanFeatures {
  Map<String, bool> toFeatureMap() {
    return {
      'Global Access': global ?? false,
      'Dashboard': dashboard ?? false,
      'Customers': customers ?? false,
      'Invoices': invoices ?? false,
      'Estimates': estimates ?? false,
      'Transactions': transactions ?? false,
      'Product Categories': productCategories ?? false,
      'Product Units': productUnits ?? false,
      'Products': products ?? false,
      'Expense Categories': expenseCategories ?? false,
      'Expenses': expenses ?? false,
      'Reports': reports ?? false,
      'Taxes': taxes ?? false,
      'Notes': notes ?? false,
      'Payment Methods': paymentMethods ?? false,
      'Customizations': customizations ?? false,
      'Users': users ?? false,
      'Roles': roles ?? false,
      'Exports': exports ?? false,
      'Tickets': tickets ?? false,
      'Settings': settings ?? false,
    };
  }
}

class PaymentMethodBottomSheet extends StatelessWidget {
  final dynamic plan;
  const PaymentMethodBottomSheet({super.key, this.plan});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      initState: (_) {
        Get.find<PaymentController>().getPaymentMethods();
      },
      builder: (paymentController) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                'select_payment_method_key'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              /// Loading
              if (paymentController.paymentListLoading)
                const Center(child: CircularProgressIndicator()),

              /// List
              if (!paymentController.paymentListLoading)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentController.paymentMethodsList.length,
                  itemBuilder: (context, index) {
                    final method = paymentController.paymentMethodsList[index];

                    return ListTile(
                      leading: const Icon(Icons.payment),
                      title: Text(method.name?.toLowerCase().tr ?? ''),
                      onTap: () {
                        Get.back();

                        /// Call payment flow here
                        paymentController.startPayment(
                          method: method,
                          plan: plan,
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
