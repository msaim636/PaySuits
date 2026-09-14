import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/payment_controller.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/billing_model.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/billing_repo.dart';
import '../util/images.dart';

class BillingController extends GetxController implements GetxService {
  final BillingRepo billingRepo;

  BillingController({required this.billingRepo});

  // ===================================
  // Get Billing Data Section
  // ===================================

  // Ticket More item list
  List<PopupModel> _billingMoreList = [];
  List<PopupModel> get billingMoreList => _billingMoreList;

  void createBillingMoreList({required dynamic method, required dynamic plan}) {
    _billingMoreList = [
      PopupModel(
        image: Images.payment,
        title: 'pay_now_key',
        route: '',
        isRoute: true,
        onTap: () {
          Get.back();

          // Call payment flow here
          Get.find<PaymentController>().startPayment(
            method: method,
            plan: plan,
          );
        },
      ),
    ];
  }

  // Variable

  int? _selectedBillingIndex;

  int? get selectedBillingIndex => _selectedBillingIndex;

  List<BillingModel> _billingList = [];
  List<BillingModel> get billingList => _billingList;

  bool _billingListLoading = false;
  bool get billingListLoading => _billingListLoading;

  bool _isBillingFilter = false;
  bool get isBillingFilter => _isBillingFilter;

  bool _billingPaginateLoading = false;
  bool get billingPaginateLoading => _billingPaginateLoading;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  String? _billingNextPageUrl;
  String? get billingNextPageUrl => _billingNextPageUrl;

  // Get ticket data
  Future<ResponseModel> getBilling({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _billingPaginateLoading = true;
    } else {
      _billingList = [];
      _billingNextPageUrl = null;
      _billingListLoading = true;
      _isBillingFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;

    final response = await billingRepo.getBilling(
      url: billingNextPageUrl,
      fromFilter: _isBillingFilter,
      search: filterController.text.trim(),
    );
    if (response.statusCode == 200) {
      response.body['result']['data'].forEach((item) {
        _billingList.add(BillingModel.fromJson(item));
      });
      _billingNextPageUrl = response.body['result']['links']['next'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _billingPaginateLoading = false;
    } else {
      _billingListLoading = false;
    }
    update();
    return responseModel;
  }

  // ===================================
  // Filter Section
  // ===================================

  // Variable
  final filterController = TextEditingController();

  // ===================================
  // Others Helper Section
  // ===================================

  // Refresh filter form
  void refreshFilterForm() {
    filterController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  // Check if filter form is empty
  bool isEmptyFilterForm() {
    if (filterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Set selected Billing index
  void setSelectedBillinngIndex(int index) {
    _selectedBillingIndex = index;
  }
}
