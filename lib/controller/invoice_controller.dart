// ignore_for_file: constant_identifier_names, strict_top_level_inference, non_constant_identifier_names, unnecessary_brace_in_string_interps, prefer_if_null_operators, deprecated_member_use, await_only_futures
import 'dart:convert';
import 'dart:io';
import 'package:paysuite/controller/expenses_controller.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/data/model/body/due_payment_body.dart';
import 'package:paysuite/data/model/body/popup_model.dart';
import 'package:paysuite/data/model/response/invoice_model.dart';
import 'package:paysuite/data/repository/invoice_repo.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/screens/invoice/widget/due_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/customer_list_model.dart';
import '../data/model/response/product_list_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/suggested_taxes_model.dart';
import '../helper/date_converter.dart';
import '../helper/download_file.dart';
import '../util/app_constants.dart';
import 'package:http/http.dart' as http;
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';

enum InvoiceStatus { PAID, DUE }

class InvoiceController extends GetxController implements GetxService {
  final InvoiceRepo invoiceRepo;

  InvoiceController({required this.invoiceRepo});

  final createInvoiceFormKey = GlobalKey<FormState>();

  final chooseCustomerController = TextEditingController();
  final chooseProductController = TextEditingController();
  final refNumberController = TextEditingController();
  final discountAmountController = TextEditingController();
  final receivedAmountController = TextEditingController();
  final issueDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final duePaymentDateController = TextEditingController();
  final templateController = TextEditingController();
  final issueFilterController = TextEditingController();
  final dueFilterController = TextEditingController();

  final chooseCustomerFocusNode = FocusNode();
  final chooseProductFocusNode = FocusNode();
  final refNumberFocusNode = FocusNode();
  final discountAmountFocusNode = FocusNode();
  final receivedAmountFocusNode = FocusNode();
  final productAmountFocusNode = FocusNode();

  InvoiceStatus? _invoiceStatus;

  InvoiceStatus? get invoiceStatus => _invoiceStatus;

  String? _dateRangeStartDate;

  String? get dateRangeStartDate => _dateRangeStartDate;

  String? _dateRangeEndDate;

  String? get dateRangeEndDate => _dateRangeEndDate;

  int? _selectedTemplate;

  int? get selectedTemplate => _selectedTemplate;

  int? _customerListSelectedIndex;

  int? get customerListSelectedIndex => _customerListSelectedIndex;

  int _invoiceTemplateListCurrentIndex = 0;

  int get invoiceTemplateListCurrentIndex => _invoiceTemplateListCurrentIndex;

  final int _invoiceQuantity = 1;

  int get invoiceQuantity => _invoiceQuantity;

  List<InvoiceModel> _invoiceList = [];

  List<InvoiceModel> get invoiceList => _invoiceList;

  bool _invoiceListLoading = false;

  bool get invoiceListLoading => _invoiceListLoading;

  bool _applyFilterLoading = false;

  bool get applyFilterLoading => _applyFilterLoading;

  bool _createInvoiceSaveLoading = false;

  bool get createInvoiceSaveLoading => _createInvoiceSaveLoading;

  bool _createInvoiceSendLoading = false;

  bool get createInvoiceSendLoading => _createInvoiceSendLoading;

  bool _getInvoiceDetailsLoading = false;

  bool get getInvoiceDetailsLoading => _getInvoiceDetailsLoading;

  bool _updateInvoiceSaveLoading = false;

  bool get updateInvoiceSaveLoading => _updateInvoiceSaveLoading;

  bool _updateInvoiceSendLoading = false;

  bool get updateInvoiceSendLoading => _updateInvoiceSendLoading;

  bool _invoicePaginateLoading = false;

  bool get invoicePaginateLoading => _invoicePaginateLoading;

  String? _invoiceNextPageUrl;

  String? get invoiceNextPageUrl => _invoiceNextPageUrl;

  int? _selectedInvoiceIndex;

  int? get selectedInvoiceIndex => _selectedInvoiceIndex;

  final Map<String, String> discountMap = {
    'fixed': 'Fixed',
    'percentage': 'Percentage',
    'none': 'None',
  };
  // Selected backend key
  final selectedDiscount = ''.obs;

  List<Map<String, dynamic>> get discountListDropdownList => discountMap.entries
      .map((e) => {'id': e.key, 'value': e.value.tr})
      .toList();

  // Set selected value using the backend key (id)
  void setDiscountListDropDownValue(String? key) {
    if (key == null) return;

    // normalize value
    final normalizedKey = key.toLowerCase();

    if (!discountMap.containsKey(normalizedKey)) return;

    selectedDiscount.value = normalizedKey;

    if (normalizedKey == 'none') {
      discountAmountController.text = '0.0';
      setDiscount(0.0);

      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
    }
  }

  List<SuggestedTaxesModel> _suggestedTaxesList = [];

  List<SuggestedTaxesModel> get suggestedTaxesList => _suggestedTaxesList;

  List<Map<String, String>> _suggestedTaxesTitleList = [];

  List<Map<String, String>> get suggestedTaxesTitleList =>
      _suggestedTaxesTitleList.map((e)=> {
        'id': e['id']!,
        'value': e['value']!.toLowerCase().tr,
      }).toList();

  String? _suggestedTaxesDWValue;

  String? get suggestedTaxesDWValue => _suggestedTaxesDWValue;

  bool _suggestedAllItemListLoading = false;

  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  bool _duePaymentLoading = false;
  bool get duePaymentLoading => _duePaymentLoading;

  List<int> _getDBInvoiceIdList = [];

  List<int> _getDBTaxesIdList = [];

  List<SelectedProductItemModel> _selectedProductItemList = [];

  List<SelectedProductItemModel> get selectedProductItemList =>
      _selectedProductItemList;

  List<SelectedTaxItemModel> _selectedTaxItemList = [];

  List<SelectedTaxItemModel> get selectedTaxItemList => _selectedTaxItemList;

  String? _noteTxt;

  String? get noteTxt => _noteTxt;

  double? _subTotal = 0.0;

  double? get subTotal => _subTotal;

  double? _discount = 0.0;

  double? get discount => _discount;

  double? _discountAmount = 0.0;

  double? get discountAmount => _discountAmount;

  double? _grandTotal = 0.0;

  double? get grandTotal => _grandTotal;

  double? _dueAmount = 0.0;

  double? get dueAmount => _dueAmount;

  double _receivedAmountFromApi = 0.0;

  String? _filterIssueStartDate;

  String? get filterIssueStartDate => _filterIssueStartDate;

  String? _filterIssueStartDateValue;

  String? get filterIssueStartDateValue => _filterIssueStartDateValue;

  String? _filterIssueEndDate;

  String? get filterIssueEndDate => _filterIssueEndDate;

  String? _filterIssueEndDateValue;

  String? get filterIssueEndDateValue => _filterIssueEndDateValue;

  String? _filterDueStartDate;

  String? get filterDueStartDate => _filterDueStartDate;

  String? _filterDueStartDateValue;

  String? get filterDueStartDateValue => _filterDueStartDateValue;

  String? _filterDueEndDate;

  String? get filterDueEndDate => _filterDueEndDate;

  String? _filterDueEndDateValue;

  String? get filterDueEndDateValue => _filterDueEndDateValue;

  bool _isInvoiceFilter = false;

  bool get isInvoiceFilter => _isInvoiceFilter;

  String? _customerStatusDWValue;

  String? get customerStatusDWValue => _customerStatusDWValue;

  final List<Map<String, String>> _customerStatusList = [
    {'id': 'paid', 'value': 'Paid'},
    {'id': 'due', 'value': 'Due'},
    {'id': 'partially_paid', 'value': 'partially_paid_key'},
  ];

  List<Map<String, String>> get customerStatusList => _customerStatusList
      .map((e) => {'id': e['id']!, 'value': e['value']!.tr})
      .toList();

  String? _customerStatusId;

  String? get customerStatusId => _customerStatusId;

  Map<String, dynamic>? _selectedFilterCustomerItem;

  Map<String, dynamic>? get selectedFilterCustomerItem =>
      _selectedFilterCustomerItem;

  void setSelectedFilterCustomerItem(Map<String, dynamic> map) {
    _selectedFilterCustomerItem = map;
    update();
  }

  List<String> templateInvoiceImageList = [
    Images.invoiceTemplate4,
    Images.invoiceTemplate5,
    Images.invoiceTemplate6,
  ];

  final Map<String, String> paymentMethodMap = {
    '1': 'cash_key',
    '2': 'bank_key',
  };

  // Selected backend key
  final selectedMethod = ''.obs;

  // Convert map to List<Map<String, dynamic>> for FancyDropdown

  List<Map<String, dynamic>> get paymentMethodListDropdownList =>
      paymentMethodMap.entries
          .map((e) => {'id': e.key, 'value': e.value.tr})
          .toList();

  // Set selected Method using the backend key (id)
  void setMethodListDropDownValue(String? key) {
    if (key == null || !paymentMethodMap.containsKey(key)) return;
    selectedMethod.value = key;
  }

  String? _paymentGatewayDWValue;
  String? get paymentGatewayDWValue => _paymentGatewayDWValue;

  String? _paymentGatewayType;
  String? get paymentGatewayType => _paymentGatewayType;

  String? _paymentGatewayApiKey;
  String? get paymentGatewayApiKey => _paymentGatewayApiKey;

  String? _paymentGatewayApiSecret;
  String? get paymentGatewayApiSecret => _paymentGatewayApiSecret;

  // Invoice More item list
  List<PopupModel> _invoiceMoreList = [];
  List<PopupModel> get invoiceMoreList => _invoiceMoreList;

  void createInvoiceMoreList({required InvoiceModel invoiceModel}) {
    _invoiceMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .duePaymentInvoice!)
        PopupModel(
          image: Images.duePayment,
          title: 'due_payment_key',
          route: '',
          widget: DuePaymentDialog(previousRoute: Get.previousRoute),
          isRoute: false,
        ),

      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updateInvoices!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getCreateInvoiceRoute('2'),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .viewInvoices!)
        PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getInvoiceDetailsRoute(),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .sendAttachmentInvoice!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendImage,
            description: 'send_invoice_attachment_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().resendInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .cloneInvoice!)
        PopupModel(
          image: Images.convertToInvoice,
          title: 'clone_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.clonedInvoice,
            description: 'this_invoice_will_be_cloned_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().cloneInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .downloadInvoice!)
        PopupModel(
          image: Images.downloadEstimate,
          title: 'download_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadInvoice,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_invoice',
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>()
              .myPermissionModel!
              .permission!
              .deleteInvoices! &&
          invoiceModel.status != 'paid' &&
          invoiceModel.status != 'partially_paid')
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
              Get.find<InvoiceController>().deleteInvoice();
            },
          ),
        ),
    ];
  }

  // Invoice More item list
  List<PopupModel> _invoiceMoreListWithoutDue = [];

  List<PopupModel> get invoiceMoreListWithoutDue => _invoiceMoreListWithoutDue;

  void createInvoiceMoreListWithoutDue({required InvoiceModel invoiceModel}) {
    _invoiceMoreListWithoutDue = [
      if (Get.find<PermissionController>()
              .myPermissionModel!
              .permission!
              .updateInvoices! &&
          invoiceModel.status != 'paid')
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getCreateInvoiceRoute('2'),
        ),
      PopupModel(
        image: Images.viewDetails,
        title: 'view_details_key',
        route: RouteHelper.getInvoiceDetailsRoute(),
      ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .sendAttachmentInvoice!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendImage,
            description: 'send_invoice_attachment_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().resendInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .cloneInvoice!)
        PopupModel(
          image: Images.convertToInvoice,
          title: 'clone_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.clonedInvoice,
            description: 'this_invoice_will_be_cloned_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().cloneInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .downloadInvoice!)
        PopupModel(
          image: Images.downloadEstimate,
          title: 'download_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.downloadInvoice,
            imageHeight: 65,
            title: "are_you_sure_key",
            description: "you_want_to_download_this_invoice",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>()
              .myPermissionModel!
              .permission!
              .deleteInvoices! &&
          invoiceModel.status != 'paid' &&
          invoiceModel.status != 'partially_paid')
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
              Get.find<InvoiceController>().deleteInvoice();
            },
          ),
        ),
    ];
  }

  //  Set template list current index
  void setTemplateListCurrentIndex(int value) {
    _invoiceTemplateListCurrentIndex = value;
    update();
  }

  //  Set customer list selected index
  void setCustomerListSelectedIndex(int index) {
    _customerListSelectedIndex = index;
    update();
  }

  //  Set estimate status
  void setInvoiceStatus(InvoiceStatus value) {
    _invoiceStatus = value;
    update();
  }

  // Set selected template
  void setSelectedTemplate(int value) {
    _selectedTemplate = value + 1;
    if (_selectedTemplate == 1) {
      templateController.text = 'template_one_key'.tr;
    } else if (_selectedTemplate == 2) {
      templateController.text = 'template_two_key'.tr;
    } else if (_selectedTemplate == 3) {
      templateController.text = 'template_three_key'.tr;
    }
    update();
  }

  // Set discount
  void setDiscount(double value) {
    _discount = value;
    discountAmountCalculation();
    grandTotalCalculation();
    dueAmountCalculation();
    update();
  }

  //  Date select
  Future<void> selectDate(BuildContext context, int contain) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      print(picked);
      final val = DateConverter.estimatedDate(picked);
      if (contain == 0) {
        _dateRangeStartDate = val;
      } else if (contain == 1) {
        _dateRangeEndDate = val;
      } else if (contain == 2) {
        issueDateController.text = val;
      } else if (contain == 3) {
        if (issueDateController.text.compareTo(val) > 0) {
          showCustomSnackBar('wrong_date_key'.tr, isError: true);
        } else {
          dueDateController.text = val;
        }
      } else if (contain == 4) {
        duePaymentDateController.text = val;
      }
      update();
    }
  }

  // Invoice Quantity increment
  void invoiceQuantityIncrement({required int index}) {
    int quantity = int.parse(_selectedProductItemList[index].quantity.text);
    double price = _selectedProductItemList[index].price;
    quantity++;
    double totalPrice = 0.0;
    totalPrice = quantity * price;
    _selectedProductItemList[index].quantity.text = quantity.toString();
    _selectedProductItemList[index].totalPrice = double.parse(
      totalPrice.toStringAsFixed(2),
    );
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    dueAmountCalculation();
    update();
  }

  // Invoice Quantity decrement
  void invoiceQuantityDecrement({required int index}) {
    int quantity = int.parse(_selectedProductItemList[index].quantity.text);
    double price = _selectedProductItemList[index].price;
    if (quantity != 1) {
      quantity--;
      double totalPrice = 0.0;
      totalPrice = quantity * price;
      _selectedProductItemList[index].quantity.text = quantity.toString();
      _selectedProductItemList[index].totalPrice = double.parse(
        totalPrice.toStringAsFixed(2),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
      update();
    }
  }

  // Quantity change calculation
  void quantityChangeCalculation({required int index, required int? quantity}) {
    if (quantity == null) {
      _selectedProductItemList[index].totalPrice = double.parse(
        _selectedProductItemList[index].price.toStringAsFixed(2),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
    } else if (quantity <= 0) {
      _selectedProductItemList[index].quantity.text = '1';
      _selectedProductItemList[index].totalPrice = double.parse(
        _selectedProductItemList[index].price.toStringAsFixed(2),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
    } else {
      double price = _selectedProductItemList[index].price;
      double totalPrice = 0.0;
      totalPrice = (quantity * price);
      _selectedProductItemList[index].totalPrice = double.parse(
        totalPrice.toStringAsFixed(2),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
    }
    update();
  }

  // Set payment gateway dw value
  void setPaymentGatewayDWValue(type, api_key, api_secret, value) {
    _paymentGatewayType = type;
    _paymentGatewayApiKey = api_key;
    _paymentGatewayApiSecret = api_secret;
    _paymentGatewayDWValue = value;

    update();
  }

  @override
  void onInit() {
    //razorpay...............
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //razorpay...............

    super.onInit();
  }

  @override
  void dispose() {
    _razorpay.clear();
    paymentIntentData?.clear();
    super.dispose();
  }

  //razorpay...............

  late Razorpay _razorpay;

  void openCheckout(dynamic amount, dynamic invoiceNumberController) {
    final price = double.tryParse(amount)! * 100;

    var options = {
      // 'key': 'rzp_test_lGm5FLE0Ty9evM', //<YOUR_KEY_ID>
      'key': '${_paymentGatewayApiKey}', //<YOUR_KEY_ID>
      "id": "$invoiceNumberController",
      "entity": "Due invoice",
      "amount": price,
      "currency": "INR",
      "receipt": "Due invoice number${invoiceNumberController}",
      "attempts": 0,
      "notes": [],
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showCustomSnackBar("Payment Failure\n\n${response.message}", isError: true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    showCustomSnackBar(
      "External wallet \n\n${response.walletName}",
      isError: false,
    );
  }

  //razorpay...............

  //stripe

  Map<dynamic, dynamic>? paymentIntentData;

  Future createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer $_paymentGatewayApiSecret",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("CONNECT YOUR INTERNET CONNECTION..error charging user$e");
      showCustomSnackBar("$e", isError: true);
      // EasyLoading.showError("CONNECT YOUR INTERNET CONNECTION.. exception error charging user $e");
    }
  }

  //stripe

  // Get invoice data
  Future<ResponseModel> getInvoice({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _invoicePaginateLoading = true;
    } else {
      _invoiceList = [];
      _invoiceNextPageUrl = null;
      _invoiceListLoading = true;
      _isInvoiceFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _selectedCustomerIdValue = _customerDropdownValue != null
          ? _customerDropdownValue
          : null;
      _filterIssueStartDateValue = _filterIssueStartDate;
      _filterDueStartDateValue = _filterDueStartDate;
      _filterIssueEndDateValue = filterIssueEndDate;
      _filterDueEndDateValue = filterDueEndDate;
    }
    final response = await invoiceRepo.getInvoice(
      url: invoiceNextPageUrl,
      customerId: _selectedCustomerIdValue != null
          ? _selectedCustomerIdValue.toString()
          : "",
      fromFilter: _isInvoiceFilter,
      status: _customerStatusId ?? "",
      issueStartDate: _filterIssueStartDateValue == null
          ? ""
          : DateConverter.apiDateFormat(_filterIssueStartDateValue ?? ""),
      issueEndDate: _filterIssueEndDateValue == null
          ? ""
          : DateConverter.apiDateFormat(_filterIssueEndDateValue ?? ""),
      dueStartDate: _filterDueStartDateValue == null
          ? ""
          : DateConverter.apiDateFormat(_filterDueStartDateValue ?? ""),
      dueEndDate: _filterDueEndDateValue == null
          ? ""
          : DateConverter.apiDateFormat(_filterDueEndDateValue ?? ""),
    );
    if (response.statusCode == 200) {
      response.body['result']['data'].forEach((item) {
        _invoiceList.add(InvoiceModel.fromJson(item));
      });
      _invoiceNextPageUrl = response.body['result']['links']['next'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _invoicePaginateLoading = false;
    } else {
      _invoiceListLoading = false;
    }
    update();
    return responseModel;
  }

  // Add value selected product item list
  void addSelectedProductItemList({
    required int productId,
    required String name,
    required double price,
    required String quantity,
    required double totalPrice,
  }) {
    bool isExist = false;
    for (var item in _selectedProductItemList) {
      if (item.productId == productId) {
        isExist = true;
        break;
      }
    }
    if (isExist) {
      showCustomSnackBar('this_product_is_already_added_key'.tr);
    } else {
      _selectedProductItemList.add(
        SelectedProductItemModel(
          productId: productId,
          name: name,
          price: price,
          quantity: TextEditingController(text: quantity),
          totalPrice: totalPrice,
        ),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
      update();
    }
  }

  void removeSelectedProductItem(int index) {
    _selectedProductItemList.removeAt(index);
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    dueAmountCalculation();
    update();
  }

  // Sub total calculation
  void subTotalCalculation() {
    double sum = 0.0;

    for (var data in _selectedProductItemList) {
      sum += data.totalPrice;
    }

    _subTotal = double.parse(sum.toStringAsFixed(2));
  }

  // Discount amount calculation
  void discountAmountCalculation() {
    if (discountAmountController.text.isNotEmpty) {
      _discountAmount = 0.0;
      double value = double.tryParse(discountAmountController.text) ?? 0.0;
      if (selectedDiscount.value == 'percentage') {
        _discountAmount = ((_subTotal! / 100) * value);
      } else if (selectedDiscount.value == 'fixed') {
        _discountAmount = value;
      }
    } else {
      _discountAmount = 0.0;
    }
    update();
  }

  // Get suggested taxes data
  Future<void> getSuggestedTaxes() async {
    _suggestedAllItemListLoading = true;
    _suggestedTaxesList = [];
    _suggestedTaxesTitleList = [];
    update();
    final response = await invoiceRepo.getSuggestedTaxes();
    if (response.statusCode == 200) {
      response.body['result'].forEach((item) {
        _suggestedTaxesList.add(SuggestedTaxesModel.fromJson(item));
        _suggestedTaxesTitleList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  // Set dropdown value
  void setTaxesDWValue(String value) {
    _suggestedTaxesDWValue = value;
    addSelectedTaxItemList(id: value);
    update();
  }

  // Add value selected tax item list
  void addSelectedTaxItemList({required String id}) {
    for (var data in _suggestedTaxesList) {
      if (data.id.toString() == id) {
        for (var info in _selectedTaxItemList) {
          if (info.taxId == data.id) {
            showCustomSnackBar(
              'already_added_this_taxes_key'.tr,
              isError: true,
            );
            return;
          }
        }
        _selectedTaxItemList.add(
          SelectedTaxItemModel(
            name: data.name ?? '',
            rate: (data.rate is double)
                ? data.rate
                : double.parse(data.rate.toString()),
            taxId: data.id!,
            totalTax: _discountAmount != null
                ? (((_subTotal! - _discountAmount!) / 100) * data.rate)
                : ((_subTotal! / 100) * data.rate),
          ),
        );
        grandTotalCalculation();
        dueAmountCalculation();
        break;
      }
    }
    update();
  }

  void removeSelectedTaxItem(int index) {
    _selectedTaxItemList.removeAt(index);
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    dueAmountCalculation();
    update();
  }

  // Total tax calculation
  void totalTaxCalculation() {
    if (_subTotal != null) {
      for (var data in _selectedTaxItemList) {
        if (_discountAmount != null) {
          data.totalTax = (((_subTotal! - _discountAmount!) / 100) * data.rate);
        } else {
          data.totalTax = ((_subTotal! / 100) * data.rate);
        }
      }
      update();
    }
  }

  // Grand total calculation
  void grandTotalCalculation() {
    if (_subTotal != null) {
      _grandTotal = 0.0;
      double totalTaxAmount = 0.0;
      for (var data in _selectedTaxItemList) {
        totalTaxAmount += data.totalTax;
      }
      if (_discountAmount != null) {
        _grandTotal = ((_subTotal! - _discountAmount!) + totalTaxAmount);
      } else {
        _grandTotal = (_subTotal! + totalTaxAmount);
      }
      update();
    }
  }

  // Due amount calculation
  void dueAmountCalculation() {
    if (_grandTotal == null) return;

    final inputText = receivedAmountController.text.trim();
    final manualReceived = double.tryParse(inputText) ?? 0.0;

    final totalReceived = _receivedAmountFromApi + manualReceived;

    _dueAmount = (_grandTotal! - totalReceived).clamp(0.0, double.infinity);

    update();
  }

  // Set selected invoice index
  void setSelectedInvoiceIndex(int index) {
    _selectedInvoiceIndex = index;
  }

  void clearInvoiceData() {
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBInvoiceIdList = [];
    _getDBTaxesIdList = [];
    chooseCustomerController.text = '';
    chooseProductController.text = '';
    refNumberController.text = '';
    discountAmountController.text = '';
    issueDateController.text = '';
    dueDateController.text = '';
    _selectedTemplate = null;
    selectedDiscount.value = '';
    _suggestedTaxesDWValue = null;
    _dueAmount = 0.0;
    _discount = 0.0;
    _discountAmount = 0.0;
    _subTotal = 0.0;
    receivedAmountController.text = '';
    _grandTotal = 0.0;
  }

  // Create invoice
  Future<void> createInvoice({required String submitType}) async {
    if (submitType == 'save') {
      _createInvoiceSaveLoading = true;
    } else if (submitType == 'send') {
      _createInvoiceSendLoading = true;
    }
    update();
    List myProduct = [];
    List myTaxes = [];
    for (var product in _selectedProductItemList) {
      myProduct.add({
        'name': product.name,
        'price': product.price,
        'product_id': product.productId,
        'quantity': product.quantity.text,
        'total_amount': product.totalPrice,
      });
    }
    for (var tax in _selectedTaxItemList) {
      myTaxes.add({'name': tax.name, 'rate': tax.rate, 'tax_id': tax.taxId});
    }
    final issueDate = DateConverter.apiDateFormat(issueDateController.text);

    final dueDate = DateConverter.apiDateFormat(dueDateController.text);
    final response = await invoiceRepo.createInvoice(
      map: {
        'customer_id': customerDropdownValue.toString(),
        'due_date': dueDate,
        'issue_date': issueDate,
        'reference_number': refNumberController.text,
        'products': myProduct,
        'invoice_template': _selectedTemplate,
        'discount_type': selectedDiscount.value.isEmpty
            ? 'none'
            : selectedDiscount.value,
        'discount_amount': discountAmountController.text,
        'due_amount': _dueAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxes,
        'received_amount': receivedAmountController.text,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
      },
    );
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      getInvoice();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _createInvoiceSaveLoading = false;
    _createInvoiceSendLoading = false;
    update();
  }

  // Get invoice details data
  Future<void> getInvoiceDetails() async {
    _getInvoiceDetailsLoading = true;
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBInvoiceIdList = [];
    _getDBTaxesIdList = [];
    update();

    final response = await invoiceRepo.getInvoiceDetails(
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      final data = response.body['result'];
      setCustomerDropdownValue(data['customer_id'].toString());
      setSelectedTemplate(data['invoice_template'] - 1);
      issueDateController.text = DateConverter.estimatedDate(
        DateTime.parse(data['issue_date']),
      );
      dueDateController.text = DateConverter.estimatedDate(
        DateTime.parse(data['due_date']),
      );
      refNumberController.text = data['reference_number'] ?? '';
      // receivedAmountController.text = data['received_amount'] != null
      //     ? data['received_amount'].toString()
      //     : '0.00';
      _receivedAmountFromApi = (data['received_amount'] is int)
          ? double.parse(data['received_amount'].toString())
          : data['received_amount'] ?? 0.0;
      data['discount_type'] == 'none'
          ? discountListDropdownList.isEmpty
          : setDiscountListDropDownValue(
              data['discount_type'] == 'fixed' ? "fixed" : "percentage",
            );
      _noteTxt = data['note'];
      if (data['invoice_details'].isNotEmpty) {
        for (var item in data['invoice_details']) {
          _getDBInvoiceIdList.add(item['id']);
          _selectedProductItemList.add(
            SelectedProductItemModel(
              id: item['id'],
              productId: item['product_id'],
              name: item['product_name'],
              price: (item['price'] is int)
                  ? double.parse(item['price'].toString())
                  : item['price'],
              quantity: TextEditingController(
                text: item['quantity'].toString(),
              ),
              totalPrice:
                  (double.parse(item['price'].toString()) *
                  double.parse(item['quantity'].toString())),
            ),
          );
        }
      } else {
        _selectedProductItemList = [];
      }
      subTotalCalculation();

      discountAmountController.text = data['discount_amount'] != null
          ? (data['discount_amount'].toString())
          : '0.00';

      _discount = (data['discount_amount'] is int)
          ? double.tryParse(data['discount_amount'].toString())
          : data['discount_amount'] ?? 0.0;

      print("discountAmountController.text : ${discountAmountController.text}");
      print("_discount : ${_discount}");
      discountAmountCalculation();
      if (data['taxes'].isNotEmpty) {
        for (var item in data['taxes']) {
          _getDBTaxesIdList.add(item['id']);
          _selectedTaxItemList.add(
            SelectedTaxItemModel(
              id: item['id'],
              taxId: (item['tax_id'] is String)
                  ? int.parse(item['tax_id'])
                  : item['tax_id'],
              name: item['name'],
              rate: (item['rate'] is int)
                  ? double.parse(item['rate'].toString())
                  : item['rate'],
              totalTax: _discountAmount != null
                  ? (((_subTotal! - _discountAmount!) / 100) * item['rate'])
                  : ((_subTotal! / 100) * item['rate']),
            ),
          );
        }
      } else {
        _selectedTaxItemList = [];
      }
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    _getInvoiceDetailsLoading = false;
    update();
  }

  // Create invoice
  Future<void> updateInvoice({required String submitType}) async {
    if (submitType == 'save') {
      _updateInvoiceSaveLoading = true;
    } else if (submitType == 'send') {
      _updateInvoiceSendLoading = true;
    }
    update();
    List myProduct = [];
    List myTaxes = [];
    List myRemoveInvoiceList = [];
    List myRemoveTaxesList = [];
    for (var id in _getDBInvoiceIdList) {
      bool isFound = false;
      for (var product in _selectedProductItemList) {
        if (id == product.id) {
          isFound = true;
          break;
        } else {
          isFound = false;
        }
      }
      if (isFound == false) {
        myRemoveInvoiceList.add(id);
      }
    }
    for (var id in _getDBTaxesIdList) {
      bool isFound = false;
      for (var tax in _selectedTaxItemList) {
        if (id == tax.id) {
          isFound = true;
          break;
        } else {
          isFound = false;
        }
      }
      if (isFound == false) {
        myRemoveTaxesList.add(id);
      }
    }
    for (var product in _selectedProductItemList) {
      myProduct.add({
        'name': product.name,
        'price': product.price,
        'id': product.id,
        'product_id': product.productId,
        'quantity': product.quantity.text,
        'total_amount': product.totalPrice,
      });
    }
    for (var tax in _selectedTaxItemList) {
      myTaxes.add({
        'name': tax.name,
        'rate': tax.rate,
        'tax_id': tax.taxId,
        'id': tax.id,
      });
    }
    final issueDate = DateConverter.apiDateFormat(issueDateController.text);
    final dueDate = DateConverter.apiDateFormat(dueDateController.text);
    final response = await invoiceRepo.updateInvoice(
      map: {
        'customer_id': _customerDropdownValue.toString(),
        'due_date': dueDate,
        'issue_date': issueDate,
        'reference_number': refNumberController.text,
        'products': myProduct,
        'invoice_template': _selectedTemplate,
        'discount_type': selectedDiscount.value.isEmpty
            ? 'none'
            : selectedDiscount.value,
        'discount_amount': discountAmountController.text,
        'due_amount': _dueAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxes,
        'received_amount': receivedAmountController.text,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
        'remove_product': myRemoveInvoiceList,
        'remove_tax': myRemoveTaxesList,
      },
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    _updateInvoiceSaveLoading = false;
    _updateInvoiceSendLoading = false;
    update();
  }

  // Resend invoice data
  Future<void> resendInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.resendInvoice(
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Clone invoice data
  Future<void> cloneInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.cloneInvoice(
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Delete invoice data
  Future<void> deleteInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.deleteInvoice(
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Download invoice data
  Future<void> downloadInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.downloadInvoice(
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200) {
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
      Get.back();
      File? file = await DownloadFile.downloadFile(
        // Corrected method name
        url: "${AppConstants.DOMAIN_URL}${response.body['result']}",
      );
      if (file != null) {
        showCustomSnackBar('download_complete_key'.tr, isError: false);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // View invoice data

  String? localFilePath;
  dynamic pdfPathList;
  bool isPdfLoading = false;

  Future<void> viewFile() async {
    try {
      isPdfLoading = true;
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_INVOICE_URI}${_invoiceList[_selectedInvoiceIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";
      final slug = prefs.getString(AppConstants.SLUG) ?? "";

      if (token.isEmpty) {
        // Handle missing token
        throw Exception("Token is missing");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'X-Domain': slug,
        },
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final pdfPath =
            '${dir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedInvoiceIndex = null;
        pdfPathList = pdfPath;
        update();
      } else {
        // Handle non-200 responses
        throw Exception('Error fetching PDF: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isPdfLoading = false;
      update();
    }
  }

  Future<void> shareFilePdf() async {
    final result = await Share.shareXFiles([
      XFile(pdfPathList),
    ], text: 'Here is a PDF file.');
    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing my PDF!');
    }
  }

  Future<void> downloadPDF() async {
    try {
      // isPdfLoading = true;
      Get.find<ExpensesController>().setDialogLoading(true);
      update();
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_INVOICE_URI}${_invoiceList[_selectedInvoiceIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";
      final slug = prefs.getString(AppConstants.SLUG) ?? "";
      if (token.isEmpty) {
        // Handle missing token
        throw Exception("Token is missing");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'X-Domain': slug,
        },
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final pdfPath =
            '${dir.path}/${_invoiceList[_selectedInvoiceIndex!].invoiceNumber}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedInvoiceIndex = null;

        final result = await OpenFilex.open(localFilePath!);

        if (result.type != ResultType.done) {
          showCustomSnackBar('Error opening PDF'.tr, isError: true);
        }

        Get.find<ExpensesController>().setDialogLoading(false);
        Get.back();
        update();
      } else {
        // Handle non-200 responses
        throw Exception('Error fetching PDF: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
    } finally {
      isPdfLoading = false;
      update();
    }
  }

  void refreshFilterForm() {
    _customerDropdownValue = null;
    _filterIssueStartDate = null;
    _filterIssueEndDate = null;
    _filterDueStartDate = null;
    _filterDueEndDate = null;
    _customerStatusId = null;
    _customerStatusDWValue = null;
    _selectedFilterCustomerItem = null;
    dueFilterController.text = '';
    issueFilterController.text = '';
    update();
  }

  bool isEmptyFilterForm() {
    if (_customerDropdownValue == null &&
        _filterIssueStartDate == null &&
        _filterIssueEndDate == null &&
        _filterDueStartDate == null &&
        _filterDueEndDate == null &&
        _customerStatusId == null &&
        _customerStatusDWValue == null &&
        _selectedFilterCustomerItem == null &&
        dueFilterController.text.isEmpty &&
        issueFilterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void setCustomerId(String? value) {
    _customerDropdownValue = value;
    update();
  }

  void setFilterIssueStartDate(String? date) {
    _filterIssueStartDate = date;
    update();
  }

  void setFilterIssueEndDate(String? date) {
    _filterIssueEndDate = date;
    if (_filterIssueStartDate != null && _filterIssueEndDate != null) {
      issueFilterController.text =
          "${_filterIssueStartDate}  To  ${_filterIssueEndDate}";
    }
    update();
  }

  void setFilterDueStartDate(String? date) {
    _filterDueStartDate = date;
    update();
  }

  void setFilterDueEndDate(String? date) {
    _filterDueEndDate = date;
    if (_filterDueStartDate != null && _filterDueEndDate != null) {
      dueFilterController.text =
          "${_filterDueStartDate}  To  ${_filterDueEndDate}";
    }
    update();
  }

  // Set customer status dw value
  void setCustomerStatusDWValue(String? value) {
    _customerStatusDWValue = value;
    _customerStatusId = value;

    update();
  }

  // Due Payment method
  Future<ResponseModel> duePayment({
    required DuePaymentBody duePaymentBody,
  }) async {
    _duePaymentLoading = true;
    update();
    Response response = await invoiceRepo.duePayment(
      duePaymentBody: duePaymentBody,
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _duePaymentLoading = false;
    update();
    return responseModel;
  }

  String formatCurrency(String? value) {
    String amount = value != null
        ? double.parse(value.replaceAll(RegExp(r'[^\d.]'), '')).toString()
        : "0.00";
    return amount;
  }

  void refreshData() {
    duePaymentDateController.text = '';
    selectedMethod.value = '';
    _paymentGatewayDWValue = null;
    update();
  }

  // customer list Show in dropdown
  List<CustomerListModel> _customerDropdownList = [];

  List<CustomerListModel> get customerDropdownList => _customerDropdownList;

  List<Map<String, String>> _customerDropdownStringList = [];

  List<Map<String, String>> get customerDropdownStringList =>
      _customerDropdownStringList;

  String? _customerDropdownValue;

  String? get customerDropdownValue => _customerDropdownValue;

  int? _selectedCustomerIndex;

  int? get selectedCustomerIndex => _selectedCustomerIndex;

  String? _selectedCustomerIdValue;

  String? get selectedCustomerIdValue => _selectedCustomerIdValue;

  void setCustomerDropdownValue(String? value) {
    _customerDropdownValue = value;
    update();
  }

  void setIssueDateValue(value) {
    final issueDate = DateConverter.estimatedDate(value);
    issueDateController.text = issueDate;

    update();
  }

  // Get customer list
  Future<void> getCustomerListDropdown() async {
    _suggestedAllItemListLoading = true;
    _customerDropdownList = [];
    _customerDropdownStringList = [];
    _customerDropdownValue = null;
    update();
    final response = await invoiceRepo.getCustomerListDropdown();
    if (response.statusCode == 200) {
      response.body['result'].forEach((item) {
        _customerDropdownList.add(CustomerListModel.fromJson(item));
        _customerDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  // Set selected customer index
  void setSelectedCustomerIndex(int index) {
    _selectedCustomerIndex = index;
  }

  // Product list Show in dropdown
  List<ProductListModel> _productDropdownList = [];

  List<ProductListModel> get productDropdownList => _productDropdownList;

  List<Map<String, String>> _productDropdownStringList = [];

  List<Map<String, String>> get productDropdownStringList =>
      _productDropdownStringList;

  String? _productDropdownValue;

  String? get productDropdownValue => _productDropdownValue;

  int? _selectedProductIndex;

  int? get selectedProductIndex => _selectedProductIndex;

  Future<void> setProductDropdownValue(String? value) async {
    _productDropdownValue = value;
    int index = await productIdToProductDropdownListIndexConvert(value!);
    var info = _productDropdownList[index];
    addSelectedProductItemList(
      productId: info.id ?? 0,
      name: info.name ?? '',
      price: (info.price is int)
          ? double.parse(info.price.toString())
          : info.price,
      quantity: '1',
      totalPrice: (info.price is int)
          ? double.parse(info.price.toString())
          : info.price,
    );
    update();
  }

  // Product name to productDropdownList index converter
  int productIdToProductDropdownListIndexConvert(String id) {
    int? index;
    for (int i = 0; i < _productDropdownList.length; i++) {
      var element = _productDropdownList[i];
      if (element.id.toString() == id) {
        index = i;
        return index;
      }
    }
    return index!;
  }

  // Get product list
  Future<void> getProductListDropdown() async {
    _suggestedAllItemListLoading = true;
    _productDropdownList = [];
    _productDropdownStringList = [];
    _productDropdownValue = null;
    update();
    final response = await invoiceRepo.getProductListDropdown();
    if (response.statusCode == 200) {
      response.body['result'].forEach((item) {
        _productDropdownList.add(ProductListModel.fromJson(item));
        _productDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }
}

class SelectedProductItemModel {
  int? id;
  int productId;
  String name;
  double price;
  TextEditingController quantity;
  double totalPrice;

  SelectedProductItemModel({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });
}

class SelectedTaxItemModel {
  int? id;
  int taxId;
  String name;
  double rate;
  double totalTax;

  SelectedTaxItemModel({
    this.id,
    required this.taxId,
    required this.name,
    required this.rate,
    required this.totalTax,
  });
}
