// ignore_for_file: constant_identifier_names

import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/data/model/body/add_customer_body.dart';
import 'package:paysuite/data/model/response/customer_details_model.dart';
import 'package:paysuite/data/model/response/customer_invoice_detile_model.dart';
import 'package:paysuite/data/model/response/customer_model.dart';
import 'package:paysuite/data/model/response/customer_update_details_model.dart';
import 'package:paysuite/data/repository/customer_repo.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/customer_estimate_model.dart';
import '../data/model/response/customer_transaction_model.dart';
import '../data/model/response/response_model.dart';
import '../helper/route_helper.dart';
import '../util/dimensions.dart';
import '../util/images.dart';
import '../util/styles.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'permission_controller.dart';

enum CustomerStatus { ACTIVE, INACTIVE }

class CustomerController extends GetxController implements GetxService {
  CustomerRepo customerRepo;
  CustomerController({required this.customerRepo});

  bool _allowPortalAccess = false;
  bool get allowPortalAccess => _allowPortalAccess;

  bool _isCustomerLoading = false;
  bool get isCustomerLoading => _isCustomerLoading;

  bool _isCustomerUpdateLoading = false;
  bool get isCustomerUpdateLoading => _isCustomerUpdateLoading;

  bool _isCustomerAddLoading = false;
  bool get isCustomerAddLoading => _isCustomerAddLoading;

  bool _isCustomerInvoiceLoading = false;
  bool get isCustomerInvoiceLoading => _isCustomerInvoiceLoading;

  bool _isCustomerDetailsLoading = false;
  bool get isCustomerDetailsLoading => _isCustomerDetailsLoading;

  bool _isCustomerUpdateDetailsLoading = false;
  bool get isCustomerUpdateDetailsLoading => _isCustomerUpdateDetailsLoading;

  bool _isPaginateLoading = false;
  bool get isPaginateLoading => _isPaginateLoading;

  bool _isInvoicePaginateLoading = false;
  bool get isInvoicePaginateLoading => _isInvoicePaginateLoading;

  String? _customerNextPageUrl;
  String? get customerNextPageUrl => _customerNextPageUrl;

  String? _customerInvoiceNextPageUrl;
  String? get customerInvoiceNextPageUrl => _customerInvoiceNextPageUrl;

  List<CustomerModel> _customerList = [];
  List<CustomerModel> get customerList => _customerList;

  InvoiceResult? _customerInvoiceList;
  InvoiceResult? get customerInvoiceList => _customerInvoiceList;

  String _countryCodeNumber = '+1';
  String get countryCodeNumber => _countryCodeNumber;

  CustomerDetailsModel? _customerDetailsModel;
  CustomerDetailsModel? get customerDetailsModel => _customerDetailsModel;

  CustomerUpdateDetailsModel? _customerUpdateDetailsModel;
  CustomerUpdateDetailsModel? get customerUpdateDetailsModel =>
      _customerUpdateDetailsModel;

  static int _customerSelectedId = -1;
  static int get customerSelectedId => _customerSelectedId;

  static String _customerSelectedStatus = "active";
  static String get customerSelectedStatus => _customerSelectedStatus;

  CustomerStatus? _customerStatus;
  CustomerStatus? get customerStatus => _customerStatus;

  String? _customerStatusDWValue;
  String? get customerStatusDWValue => _customerStatusDWValue;

  final List<Map<String, String>> _customerStatusList = [
    {'id': '1', 'value': 'Active'},
    {'id': '2', 'value': 'Inactive'},
    {'id': '3', 'value': 'Invited'},
  ];
  List<Map<String, String>> get customerStatusList => _customerStatusList;

  bool _isCustomerFilter = false;
  bool get isCustomerFilter => _isCustomerFilter;

  bool _customerFilter = false;
  bool get customerFilter => _customerFilter;

  // customer country code
  Country _customerCountry = CountryParser.parseCountryCode("US");
  Country get customerCountry => _customerCountry;

  void toggleAllowPortalAccess() {
    _allowPortalAccess = !_allowPortalAccess;
    update();
  }

  // Set update portal access value
  void setUpdatePortalAccess(bool value) {
    _allowPortalAccess = value;
    update();
  }

  final Map<String, String> genderMap = {
    'male': 'male_key',
    'female': 'female_key',
    'others': 'others_key',
  };

  // Selected backend key
  final selectedGender = ''.obs;

  // Convert map to List<Map<String, dynamic>> for FancyDropdown

  List<Map<String, dynamic>> get genderListDropdownList =>
      genderMap.entries.map((e) => {'id': e.key, 'value': e.value.tr}).toList();

  // Set selected gender using the backend key (id)
  void setGenderListDropDownValue(String? key) {
    if (key == null || !genderMap.containsKey(key)) return;
    selectedGender.value = key;
  }

  // Get display value for UI
  String get selectedGenderDurationDisplayValue =>
      genderMap[selectedGender.value] ?? '';

  // Customer More item list
  List<PopupModel> _customerMoreList = [];
  List<PopupModel> get customerMoreList => _customerMoreList;
  void createCustomerMoreList({required CustomerModel customerModel}) {
    _customerMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updateCustomers!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getAddCustomerRoute('1'),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .detailsViewCustomer!)
        PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getCustomerDetailsRoute(),
        ),

      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteCustomers!)
        PopupModel(
          image: customerModel.status == "active"
              ? Images.reject
              : Images.solved,
          title: customerModel.status == "active"
              ? 'inactive_key'.tr
              : 'active_key'.tr,
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: customerModel.status == "active"
                ? Images.reject
                : Images.solved,
            title: 'are_you_sure_key'.tr,
            description: customerModel.status == "active"
                ? 'inactive_customer_question_key'.tr
                : 'active_customer_question_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: customerModel.status == "active"
                ? 'inactive_key'.tr
                : 'active_key'.tr,
            rightBtnOnTap: () {
              Get.find<CustomerController>().inactiveCustomer(
                status: customerModel.status == "active"
                    ? "inactive"
                    : "active",
              );
            },
          ),
        ),

      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteCustomers!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteIcon,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key',
            rightBtnTitle: 'delete_key',
            rightBtnOnTap: () {
              Get.find<CustomerController>().deleteCustomer();
            },
          ),
        ),
    ];
  }

  // Get Customer data
  Future<ResponseModel> getCustomerData({
    bool isPaginate = false,
    bool fromFilter = false,
  }) async {
    if (isPaginate) {
      _isPaginateLoading = true;
    } else {
      _customerList = [];
      _customerNextPageUrl = null;
      _isCustomerLoading = true;
      _isCustomerFilter = fromFilter;
      if (!fromFilter) {
        _customerStatusDWValue = null;
      } else {
        _customerFilter = true;
      }
    }
    update();

    ResponseModel responseModel;

    final response = await customerRepo.getCustomerData(
      url: customerNextPageUrl,
      fromFilter: _isCustomerFilter,
      status: _customerStatusDWValue ?? '',
    );

    print("check Response status: ${response.body['status']}");
    if (response.statusCode == 200) {
      response.body['result']['data'].forEach((item) {
        _customerList.add(CustomerModel.fromJson(item));
      });

      _customerNextPageUrl = response.body['result']['links']['next'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    if (isPaginate) {
      _isPaginateLoading = false;
    } else {
      _isCustomerLoading = false;
      _customerFilter = false;
    }
    update();
    return responseModel;
  }

  // Add Customer
  Future<ResponseModel> addCustomer({
    required AddCustomerBody addCustomerBody,
  }) async {
    _isCustomerAddLoading = true;
    update();
    Response response = await customerRepo.addCustomer(
      addCustomerBody: addCustomerBody,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }

    _isCustomerAddLoading = false;
    update();
    return responseModel;
  }

  // Set customer country code
  void setCountryCode(String code) {
    _customerCountry = CountryParser.parseCountryCode(code);
    update();
  }

  // refresh data
  void refreshData() {
    _countryCodeNumber = '+1';
    _allowPortalAccess = false;
    selectedGender.value = '';
    update();
  }

  // Get customer details method
  Future<void> getCustomerDetails() async {
    _isCustomerDetailsLoading = true;
    update();
    Response response = await customerRepo.getCustomerDetails(
      id: _customerSelectedId.toString(),
    );
    if (response.statusCode == 200) {
      _customerDetailsModel = null;
      _customerDetailsModel = CustomerDetailsModel.fromJson(
        response.body['result'],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    _isCustomerDetailsLoading = false;
    update();
  }

  // Set customer on tap id
  void setCustomerSelectedId({required int id, required String status}) {
    _customerSelectedId = id;
    _customerSelectedStatus = status;

    for (int i = 0; i < _customerMoreList.length; i++) {
      if (_customerMoreList[i].image == Images.inactiveUser) {
        _customerMoreList[i] = PopupModel(
          image: Images.inactiveUser,
          title: _customerSelectedStatus == "status_active"
              ? 'active_key'
              : "inactive_key",
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            description:
                'are_you_sure_you_want_to_change_customer_status_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              customerUpdateStatus();
            },
          ),
        );
      }
    }

    update();
  }

  // Get Customer Invoice Details
  Future<void> getCustomerInvoiceDetails({bool isPaginate = false}) async {
    if (isPaginate) {
      _isInvoicePaginateLoading = true;
    } else {
      _customerInvoiceList = null;
      _customerInvoiceNextPageUrl = null;
      _isCustomerInvoiceLoading = true;
    }
    update();

    final response = await customerRepo.getCustomerInvoiceDetails(
      url: _customerInvoiceNextPageUrl,
      id: _customerSelectedId.toString(),
    );

    if (response.statusCode == 200) {
      final resultJson = response.body['result'];

      if (!isPaginate) {
        // First page
        _customerInvoiceList = InvoiceResult.fromJson(resultJson);
      } else {
        // Pagination
        final List newData = resultJson['data'] ?? [];
        _customerInvoiceList?.data ??= [];
        for (var item in newData) {
          _customerInvoiceList!.data!.add(
            CustomerInvoiceDetilesModel.fromJson(item),
          );
        }
      }

      _customerInvoiceNextPageUrl = resultJson['links']?['next'];
    } else {
      ApiChecker.checkApi(response);
    }

    if (isPaginate) {
      _isInvoicePaginateLoading = false;
    } else {
      _isCustomerInvoiceLoading = false;
    }

    update();
  }

  // Delete Customer
  Future<void> deleteCustomer() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await customerRepo.deleteCustomer(id: _customerSelectedId);
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getCustomerData();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Inactive Customer
  Future<void> inactiveCustomer({required String status}) async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await customerRepo.inactiveCustomer(
      id: _customerSelectedId,
      map: {"status": status},
    );
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getCustomerData();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Customer resend portal access method
  Future<void> customerResendPortalAccess() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    Response response = await customerRepo.customerResendPortalAccess(
      id: _customerSelectedId.toString(),
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Customer Update Status
  Future<void> customerUpdateStatus() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    Response response = await customerRepo.customerUpdateStatus(
      id: _customerSelectedId.toString(),
      status: _customerSelectedStatus,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.isSnackbarOpen ? Get.back() : null;
      Get.back();

      getCustomerData();

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Get customer update details method
  Future<void> getCustomerUpdateDetails() async {
    _isCustomerUpdateDetailsLoading = true;
    update();
    Response response = await customerRepo.getCustomerUpdateDetails(
      id: _customerSelectedId.toString(),
    );
    if (response.statusCode == 200) {
      _customerUpdateDetailsModel = null;
      _customerUpdateDetailsModel = CustomerUpdateDetailsModel.fromJson(
        response.body['result'],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    _isCustomerUpdateDetailsLoading = false;
    update();
  }

  // Update Customer
  Future<ResponseModel> customerUpdate({
    required AddCustomerBody addCustomerBody,
  }) async {
    _isCustomerUpdateLoading = true;
    update();
    Response response = await customerRepo.customerUpdate(
      id: _customerSelectedId.toString(),
      addCustomerBody: addCustomerBody,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isCustomerUpdateLoading = false;
    update();
    return responseModel;
  }

  //  Set customer status
  void setCustomerStatus(CustomerStatus value) {
    _customerStatus = value;
    update();
  }

  // Set customer status dw value
  void setCustomerStatusDWValue(String? value) {
    _customerStatusDWValue = value;

    update();
  }

  void refreshFilterForm() {
    _customerStatusDWValue = null;
    update();
  }

  // Show country bottom sheet
  void showPicker(BuildContext context, {bool fromProfile = false}) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        searchTextStyle: googleSansFlexMedium.copyWith(
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
        ),
        bottomSheetHeight: Get.size.height * 0.80,
        backgroundColor: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        inputDecoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          hintText: 'search_your_country_here_key'.tr,
          hintStyle: googleSansFlexRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_DEFAULT,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).disabledColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error.withValues(alpha: .7),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error.withValues(alpha: .7),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor.withValues(alpha: .3),
              width: 1,
            ),
          ),
        ),
      ),
      onSelect: (country) {
        if (fromProfile) {
          Get.find<DashboardController>().setCountry(country);
        } else {
          _customerCountry = country;
          update();
        }
      },
    );
  }

  // Remove country code from customer phone number
  String removeCountryCode(String phoneNumber) {
    return phoneNumber.replaceAll("+${_customerCountry.phoneCode}", '');
  }

  // Variable

  bool _isCustomerEstimateLoading = false;
  bool get isCustomerEstimateLoading => _isCustomerEstimateLoading;

  bool _isEstimatePaginateLoading = false;
  bool get isEstimatePaginateLoading => _isEstimatePaginateLoading;

  EstimateResult? _customerEstimateList;
  EstimateResult? get customerEstimateList => _customerEstimateList;

  String? _customerEstimateNextPageUrl;
  String? get customerEstimateNextPageUrl => _customerEstimateNextPageUrl;

  // Get Customer Estimate Details
  Future<void> getCustomerEstimateDetails({bool isPaginate = false}) async {
    try {
      // Set loading states
      if (isPaginate) {
        _isEstimatePaginateLoading = true;
      } else {
        _customerEstimateList = null;
        _customerEstimateNextPageUrl = null;
        _isCustomerEstimateLoading = true;
      }
      update();

      // Make API call
      final response = await customerRepo.getCustomerEstimateDetails(
        url: isPaginate ? customerEstimateNextPageUrl : null,
        id: _customerSelectedId.toString(),
      );

      if (response.statusCode == 200) {
        final resultJson = response.body['result'];

        if (!isPaginate) {
          _customerEstimateList = EstimateResult.fromJson(resultJson);
        } else {
          final List newData = resultJson['data'] ?? [];
          _customerEstimateList?.data ?? [];
          for (var item in newData) {
            _customerEstimateList!.data!.add(
              CustomerEstimateModel.fromJson(item),
            );
          }
        }

        // Update pagination URL
        _customerEstimateNextPageUrl =
            response.body['result']['pagination']['next_page_url'];
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Error in getCustomerEstimateDetails: $e');
    } finally {
      // Reset loading states
      _isEstimatePaginateLoading = false;
      _isCustomerEstimateLoading = false;
      update();
    }
  }

  // variable

  bool _isTransactionPaginateLoading = false;
  bool get isTransactionPaginateLoading => _isTransactionPaginateLoading;
  TransactionResult? _customerTransactionList;
  TransactionResult? get customerTransactionList => _customerTransactionList;
  String? _customerTransactionNextPageUrl;
  String? get customerTransactionNextPageUrl => _customerTransactionNextPageUrl;

  bool _isCustomerTransactionLoading = false;
  bool get isCustomerTransactionLoading => _isCustomerTransactionLoading;

  // Get Customer Transaction Details
  Future<void> getCustomerTransactionDetails({bool isPaginate = false}) async {
    try {
      // Set loading states
      if (isPaginate) {
        _isTransactionPaginateLoading = true;
      } else {
        _customerTransactionList = null; // Clear list for fresh load
        _customerTransactionNextPageUrl = null;
        _isCustomerTransactionLoading = true;
      }
      update();

      // Make API call
      final response = await customerRepo.getCustomerTransactionDetails(
        url: isPaginate ? customerTransactionNextPageUrl : null,
        id: _customerSelectedId.toString(),
      );

      if (response.statusCode == 200) {
        final resultJson = response.body['result'];

        if (!isPaginate) {
          _customerTransactionList = TransactionResult.fromJson(resultJson);
        } else {
          final List newData = resultJson['data'] ?? [];
          _customerTransactionList?.data ?? [];
          for (var item in newData) {
            _customerTransactionList!.data!.add(
              CustomerTransactionModel.fromJson(item),
            );
          }
        }

        // Update pagination URL
        _customerTransactionNextPageUrl =
            response.body['result']['pagination']['next_page_url'];
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Error in getTransactionDetails: $e');
    } finally {
      // Reset loading states
      _isTransactionPaginateLoading = false;
      _isCustomerTransactionLoading = false;
      update();
    }
  }
}
