// ignore_for_file: strict_top_level_inference, prefer_final_fields

import 'package:paysuite/controller/billing_controller.dart';
import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/data/api/api_checker.dart';
import 'package:paysuite/data/model/body/add_payment_method_body.dart';
import 'package:paysuite/data/model/response/payment_methods_dropdown_model.dart';
import 'package:paysuite/data/model/response/payment_methods_model.dart';
import 'package:paysuite/data/repository/payment_methods_repo.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/screens/payment/widget/add_payment_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/payment_gateway_model.dart';
import '../data/model/response/payment_method_details_model.dart';
import '../data/model/response/payment_method_model.dart';
import '../data/model/response/response_model.dart';
import '../helper/native_payment_webview.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentMethodsRepo paymentMethodsRepo;
  PaymentController({required this.paymentMethodsRepo});

  List<PaymentMethodsModel> _paymentMethodsList = [];
  List<PaymentMethodsModel> get paymentMethodsList => _paymentMethodsList;

  bool _paymentListLoading = false;
  bool get paymentListLoading => _paymentListLoading;

  int? _selectedPaymentIndex;
  int? get selectedPaymentIndex => _selectedPaymentIndex;

  bool _paymentPaginateLoading = false;
  bool get paymentPaginateLoading => _paymentPaginateLoading;

  String? _paymentNextPageUrl;
  String? get paymentNextPageUrl => _paymentNextPageUrl;

  List<PaymentMethodDropdownModel> _paymentDropdownList = [];
  List<PaymentMethodDropdownModel> get paymentDropdownList =>
      _paymentDropdownList;

  List<PaymentMethodModel> _paymentMethodDropdownList = [];
  List<PaymentMethodModel> get paymentMethodDropdownList =>
      _paymentMethodDropdownList;

  List<PaymentGatewayModel> _paymentGatewayDropdownList = [];
  List<PaymentGatewayModel> get paymentGatewayDropdownList =>
      _paymentGatewayDropdownList;

  PaymentGatewayModel? _paymentGatewayDropdownValue;
  PaymentGatewayModel? get paymentGatewayDropdownValue =>
      _paymentGatewayDropdownValue;

  final List<Map<String, String>> _paymentModeList = [
    {'id': 'Sandbox', 'value': 'Sandbox'},
    {'id': 'Live', 'value': 'Live'},
  ];
  List<Map<String, String>> get paymentModeList => _paymentModeList;

  String? _paymentDropdownValue;
  String? get paymentDropdownValue => _paymentDropdownValue;

  String? _paymentMethodDropdownValue;
  String? get paymentMethodDropdownValue => _paymentMethodDropdownValue;

  String? _paymentModeValue;
  String? get paymentModeValue => _paymentModeValue;

  bool _addPaymentMethodLoading = false;
  bool get addPaymentMethodLoading => _addPaymentMethodLoading;

  bool _updatePaymentMethodLoading = false;
  bool get updatePaymentMethodLoading => _updatePaymentMethodLoading;

  bool _isPaymentMethodDetailsLoading = false;
  bool get isPaymentMethodDetailsLoading => _isPaymentMethodDetailsLoading;

  PaymentMethodDetailsModel? _paymentMethodDetailsModel;
  PaymentMethodDetailsModel? get paymentMethodDetailsModel =>
      _paymentMethodDetailsModel;

  // Payment More item list
  List<PopupModel> _paymentMoreList = [];
  List<PopupModel> get paymentMoreList => _paymentMoreList;
  void createPaymentMethodMoreList() {
    _paymentMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updatePaymentMethods!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: '',
          widget: AddPaymentDialog(isUpdate: true),
          isRoute: false,
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deletePaymentMethods!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteIcon,
            description: 'this_content_will_be_deleted_key',
            title: "you_want_to_delete_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<PaymentController>().deletePaymentMethods();
            },
          ),
        ),
    ];
  }

  Future<void> getPaymentMethods({bool isPaginate = false}) async {
    _paymentListLoading = true;
    update();

    final response = await paymentMethodsRepo.getPaymentMethods(
      url: paymentNextPageUrl,
    );

    if (response.statusCode == 200 && response.body is List) {
      _paymentMethodsList = [];

      for (var item in response.body) {
        _paymentMethodsList.add(PaymentMethodsModel.fromJson(item));
      }
    } else {
      ApiChecker.checkApi(response);
    }

    _paymentListLoading = false;
    update();
  }

  void refreshForm() {
    _paymentDropdownValue = null;
    _paymentModeValue = null;
    if (kDebugMode) {
      print("Dropdown value:  $_paymentModeValue");
    }
    update();
  }

  // Set category dw value
  setPaymentDropdownValue(String? value) {
    _paymentDropdownValue = value;
    update();
  }

  // Set payment mode dw value
  setPaymentModeValue(String? value) {
    _paymentModeValue = value;
    update();
  }

  setSelectedPaymentIndex(int index) {
    _selectedPaymentIndex = index;
  }

  // Delete Payment Methods data
  Future<void> deletePaymentMethods() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await paymentMethodsRepo.deletePaymentMethods(
      id: _paymentMethodsList[_selectedPaymentIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getPaymentMethods();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Add Payment Method
  Future<ResponseModel> addPaymentMethod({
    required AddPaymentMethodBody addPaymentMethodBody,
  }) async {
    _addPaymentMethodLoading = true;
    update();
    Response response = await paymentMethodsRepo.addPaymentMethod(
      addPaymentMethodBody: addPaymentMethodBody,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      getPaymentMethods();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _addPaymentMethodLoading = false;
    update();
    return responseModel;
  }

  // get Payment Method Details
  Future<void> getPaymentMethodDetails() async {
    _isPaymentMethodDetailsLoading = true;
    _paymentMethodDetailsModel = null;
    update();

    Response response = await paymentMethodsRepo.getPaymentMethodDetails(
      id: _paymentMethodsList[_selectedPaymentIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      _paymentMethodDetailsModel = PaymentMethodDetailsModel.fromJson(
        response.body["result"],
      );
      _paymentDropdownValue = _paymentMethodDetailsModel!.type!.capitalizeFirst;
    } else {
      ApiChecker.checkApi(response);
    }
    _isPaymentMethodDetailsLoading = false;
    update();
  }

  // Update Payment Method
  Future<ResponseModel> updatePaymentMethod({
    required AddPaymentMethodBody addPaymentMethodBody,
  }) async {
    _updatePaymentMethodLoading = true;
    update();
    Response response = await paymentMethodsRepo.updatePaymentMethod(
      addPaymentMethodBody: addPaymentMethodBody,
      id: _paymentMethodsList[_selectedPaymentIndex!].id!,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      getPaymentMethods();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _updatePaymentMethodLoading = false;
    update();
    return responseModel;
  }

  String? getPaymentMethodId(String value) {
    String? id;
    for (var element in _paymentDropdownList) {
      if (element.name == value) {
        id = element.id!;
      }
    }
    return id;
  }

  dynamic getPaymentMethodIdFromList(String value) {
    String? id;
    for (var element in _paymentMethodDropdownList) {
      if (element.name == value) {
        id = element.id.toString();
      }
    }
    return id;
  }

  void startPayment({
    required PaymentMethodsModel method,
    required dynamic plan,
  }) {
    switch (method.type) {
      case 'stripe':
        buyPlanWithStripe(plan);
        break;

      case 'paypal':
        buyPlanWithPaypal(plan);
        break;

      default:
        showCustomSnackBar(isError: true, 'unsupported_payment_method_key'.tr);
    }
  }

  void startRenewPayment({
    required PaymentMethodsModel method,
    required dynamic plan,
  }) {
    switch (method.type) {
      case 'stripe':
        renewPlanWithStrip(
          plan,
          billingId: Get.find<BillingController>().selectedBillingIndex!,
        );
        break;

      case 'paypal':
        renewPlanWithPaypal(
          plan,
          billingId: Get.find<BillingController>().selectedBillingIndex!,
        );
        break;

      default:
        showCustomSnackBar('unsupported_payment_method_key'.tr);
    }
  }

  // Variable
  bool _paymentLoading = false;
  bool get paymentLoading => _paymentLoading;

  Future<void> buyPlanWithStripe(dynamic plan) async {
    try {
      _paymentLoading = true;
      update();

      final response = await paymentMethodsRepo.buyPlan(
        map: {"plan_id": plan.id, "payment_method": "stripe"},
      );

      if (response.statusCode == 200) {
        final checkoutUrl = response.body;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          await NativePaymentWebView.open(checkoutUrl, "Stripe");
          return;
        }
      } else {
        showCustomSnackBar(
          isError: true,
          response.body['message'] ?? 'plan_purchase_failed_key'.tr,
        );
      }
    } catch (e) {
      showCustomSnackBar(isError: true, e.toString());
      debugPrint("========> Error $e");
    } finally {
      _paymentLoading = false;
      update();
    }
  } // Variable

  Future<void> buyPlanWithPaypal(dynamic plan) async {
    try {
      _paymentLoading = true;
      update();

      final response = await paymentMethodsRepo.buyPlan(
        map: {"plan_id": plan.id, "payment_method": "paypal"},
      );

      if (response.statusCode == 200) {
        final checkoutUrl = response.body;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          await NativePaymentWebView.open(checkoutUrl, "Paypal");
          return;
        }
      } else {
        showCustomSnackBar(
          isError: true,
          response.body['message'] ?? 'plan_purchase_failed_key'.tr,
        );
      }
    } catch (e) {
      showCustomSnackBar(isError: true, e.toString());
    } finally {
      _paymentLoading = false;
      update();
    }
  }

  Future<void> renewPlanWithStrip(
    dynamic plan, {
    required int billingId,
  }) async {
    try {
      _paymentLoading = true;
      update();

      final response = await paymentMethodsRepo.renewPlan(
        billingId: billingId,
        map: {"payment_method": "stripe"},
      );
      if (response.statusCode == 200) {
        final checkoutUrl = response.body;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          await NativePaymentWebView.open(checkoutUrl, "Stripe");
          return;
        }
      } else {
        showCustomSnackBar(
          isError: true,
          response.body['message'] ?? 'plan_purchase_failed_key',
        );
      }
    } catch (e) {
      showCustomSnackBar(isError: true, e.toString());
    } finally {
      _paymentLoading = false;
      update();
    }
  }

  Future<void> renewPlanWithPaypal(
    dynamic plan, {
    required int billingId,
  }) async {
    try {
      _paymentLoading = true;
      update();

      final response = await paymentMethodsRepo.renewPlan(
        billingId: billingId,
        map: {"payment_method": "paypal"},
      );

      if (response.statusCode == 200) {
        final checkoutUrl = response.body;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          await NativePaymentWebView.open(checkoutUrl, "Paypal");
          return;
        }
      } else {
        showCustomSnackBar(
          isError: true,
          response.body['message'] ?? 'plan_purchase_failed_key',
        );
      }
    } catch (e) {
      showCustomSnackBar(isError: true, e.toString());
    } finally {
      _paymentLoading = false;
      update();
    }
  }
}
