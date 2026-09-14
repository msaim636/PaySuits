// controllers/plan_controller.dart
// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/data/api/api_checker.dart';
import 'package:paysuite/data/model/response/my_plan_model.dart';
import 'package:paysuite/data/repository/plan_repo.dart';

import '../data/model/response/subscription_my_plan_model.dart';

class PlanController extends GetxController implements GetxService {
  final PlanRepo planRepo;
  PlanController({required this.planRepo});

  /* --------------------------------------------------------------------------
   * DATE HANDLING
   * --------------------------------------------------------------------------*/

  String startDateString = '';
  String endDateString = '';
  String purchaseDateString = '';

  DateTime get startDate => _parseDate(startDateString);
  DateTime get endDate => _parseDate(endDateString);
  DateTime get purchaseDate => _parseDate(purchaseDateString);

  DateTime _parseDate(String value) {
    try {
      final parts = value.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return DateTime.now();
    }
  }

  int get totalDays => endDate.difference(startDate).inDays.clamp(0, 9999);

  int get daysUsed {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0;
    if (now.isAfter(endDate)) return totalDays;
    return now.difference(startDate).inDays.clamp(0, totalDays);
  }

  int get daysLeft => (totalDays - daysUsed).clamp(0, totalDays);

  double get percentage => totalDays == 0 ? 0 : (daysLeft / totalDays) * 100;

  /* --------------------------------------------------------------------------
   * MY PLAN
   * --------------------------------------------------------------------------*/

  bool _isMyPlanLoading = false;
  bool get isMyPlanLoading => _isMyPlanLoading;

  MyPlanModel? myPlan;
  int? currentPlanId;

  Future<void> getMyPlan() async {
    _isMyPlanLoading = true;
    update();

    final response = await planRepo.getMyPlan();
    if (response.statusCode == 200) {
      myPlan = MyPlanModel.fromJson(response.body['result']);

      startDateString = myPlan?.startDate ?? '';
      endDateString = myPlan?.endDate ?? '';
      purchaseDateString = myPlan?.startDate ?? '';

      currentPlanId = myPlan?.plan?.id;
    } else {
      ApiChecker.checkApi(response);
    }

    _isMyPlanLoading = false;
    update();
  }

  /* --------------------------------------------------------------------------
   * SUBSCRIPTION PLANS
   * --------------------------------------------------------------------------*/

  bool _isSubscriptionMyPlanLoading = false;
  bool get isSubscriptionMyPlanLoading => _isSubscriptionMyPlanLoading;

  final List<SubscriptionMyPlanModel> _subscriptionMyPlanList = [];
  List<SubscriptionMyPlanModel> get subscriptionMyPlanList =>
      _subscriptionMyPlanList;

  int selectedPlanIndex = 0;
  late final PageController pageController;

  List<SubscriptionMyPlanModel> filteredPlans = [];

  Future<void> getSubscriptionMyPlan() async {
    _isSubscriptionMyPlanLoading = true;
    update();

    final response = await planRepo.getSubscriptionMyPlan();

    if (response.statusCode == 200) {
      _subscriptionMyPlanList.clear();

      for (final item in response.body['result']) {
        final plan = SubscriptionMyPlanModel.fromJson(item);
        _subscriptionMyPlanList.add(plan);

        // Detect current plan by backend field
        if (item['is_current'] == true) {
          currentPlanId = plan.id;
        }
      }

      // Filter monthly by default
      filteredPlans = _subscriptionMyPlanList
          .where((plan) => plan.frequency == 'monthly')
          .toList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncCurrentPlanIndex();
      });
    } else {
      ApiChecker.checkApi(response);
    }

    _isSubscriptionMyPlanLoading = false;
    update(); // UI rebuilds with filteredPlans populated
  }

  /* --------------------------------------------------------------------------
   * SYNC CURRENT PLAN → PAGEVIEW
   * --------------------------------------------------------------------------*/

  void _syncCurrentPlanIndex() {
    if (currentPlanId == null || _subscriptionMyPlanList.isEmpty) return;

    final index = _subscriptionMyPlanList.indexWhere(
      (plan) => plan.id == currentPlanId,
    );

    if (index == -1) return;

    selectedPlanIndex = index;

    ///  WAIT until PageView is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
    });
  }

  SubscriptionMyPlanModel? get selectedPlan => _subscriptionMyPlanList.isEmpty
      ? null
      : _subscriptionMyPlanList[selectedPlanIndex];

  void onPageChanged(int index) {
    if (index < 0 || index >= _subscriptionMyPlanList.length) return;
    selectedPlanIndex = index;
    update();
  }

  /* --------------------------------------------------------------------------
   * LIFECYCLE
   * --------------------------------------------------------------------------*/

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.85);

    // Load APIs in correct order
    getMyPlan().then((_) {
      getSubscriptionMyPlan();
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
