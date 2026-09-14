// ignore_for_file: deprecated_member_use

import 'package:paysuite/data/model/body/update_profile_body.dart';
import 'package:paysuite/data/model/response/dashboard_info_model.dart';
import 'package:paysuite/data/repository/dashboard_repo.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/income_expense_model.dart';
import '../data/model/response/income_expenses_point.dart';
import '../data/model/response/income_overview_model.dart';
import '../data/model/response/payment_overview_model.dart';
import '../data/model/response/profile_details_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/top_five_customer_model.dart';
import '../data/model/response/top_ticket_chart_model.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../view/screens/home/home_screen.dart';

class DashboardController extends GetxController implements GetxService {
  final DashboardRepo dashboardRepo;
  DashboardController({required this.dashboardRepo});

  final GlobalKey<ScaffoldState> moreDrawerKey = GlobalKey<ScaffoldState>();
  int _bottomNavbarIndex = 0;
  int get bottomNavbarIndex => _bottomNavbarIndex;

  DashboardStatics? _dashboardInfoModel;
  DashboardStatics? get dashboardInfoModel => _dashboardInfoModel;

  IncomeStatics? _incomeStaticsModel;
  IncomeStatics? get incomeStaticsModel => _incomeStaticsModel;

  ProfileDetailsModel? _profileDetailsModel;
  ProfileDetailsModel? get profileDetailsModel => _profileDetailsModel;

  double _receivedAmountPercentage = 0;
  double get receivedAmountPercentage => _receivedAmountPercentage;

  double _dueAmountPercentage = 0;
  double get dueAmountPercentage => _dueAmountPercentage;

  // bool _isIncomeOverviewLoading = false;
  // bool get isIncomeOverviewLoading => _isIncomeOverviewLoading;

  bool _isProfileDetailsLoading = false;
  bool get isProfileDetailsLoading => _isProfileDetailsLoading;

  String? _dateOfBirth;
  String? get dateOfBirth => _dateOfBirth;

  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  final List<Map<String, String>> _genderList = [
    {'id': 'Male', 'value': 'Male'},
    {'id': 'Female', 'value': 'Female'},
  ];
  List<Map<String, String>> get genderList => _genderList;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  final String _countryCodeNumber = '+1';
  String get countryCodeNumber => _countryCodeNumber;

  bool _updateProfileLoading = false;
  bool get updateProfileLoading => _updateProfileLoading;

  Widget bodyItem = const HomeScreen();

  Country _country = CountryParser.parseCountryCode("US");
  Country get country => _country;

  void setBodyItem(Widget screen) {
    bodyItem = screen;
    update();
  }

  // Set country code
  void setCountryCode(String code) {
    _country = CountryParser.parseCountryCode(code);
  }

  // Set country code
  String removeCountryCode(String phoneNumber) {
    return phoneNumber.replaceAll("+${_country.phoneCode}", '');
  }

  // Filter data
  final List<Map<String, String>> _paymentOverviewFilterType = [
    {"title": "last_7_days_key", "value": "1"},
    {"title": "this_week_key", "value": "2"},
    {"title": "last_week_key", "value": "3"},
    {"title": "this_month_key", "value": "4"},
    {"title": "last_month_key", "value": "5"},
    {"title": "this_year_key", "value": "6"},
    {"title": "total_key", "value": "0"},
  ];

  //
  List<Map<String, String>> get paymentOverviewFilterType =>
      _paymentOverviewFilterType;

  String _selectedPaymentOverviewFilterType = "5";
  String get selectedPaymentOverviewFilterType =>
      _selectedPaymentOverviewFilterType;

  void refreshData() {
    _selectedPaymentOverviewFilterType = "5";
    print('this week= $_selectedPaymentOverviewFilterType');
    update();
  }

  void setSelectedPaymentOverviewFilterType(String id) {
    _selectedPaymentOverviewFilterType = id;
    getPaymentOverview(id, true);
    update(['income_payment']);
  }

  //  Set bottom nav bar selected button index
  void setBottomNavBarIndex(int index) {
    _bottomNavbarIndex = index;
    update();
  }

  bool _isInitialDashboardLoading = true;
  bool get isInitialDashboardLoading => _isInitialDashboardLoading;

  Future<void> loadInitialDashboardData() async {
    _isInitialDashboardLoading = true;
    update();

    await getProfileDetails();
    await getDashBoardData();

    await Future.wait([
      getIncomeExpensesOverviewData(
        incomeExpensesOverviewFilterType[5]['value']!,
      ),
      getTicketGraphData(ticketOverviewFilterType[5]['value']!),
      getPaymentOverview(paymentOverviewFilterType[5]['value']!, true),
      getTopFiveCustomerData(
        topFiveCustomerOverviewFilterType[5]['value']!,
        true,
      ),
    ]);

    _isInitialDashboardLoading = false;
    update();
  }

  bool _isDashboardDataLoading = false;
  bool get isDashboardDataLoading => _isDashboardDataLoading;

  // Dash info get Data method
  Future<void> getDashBoardData() async {
    _isDashboardDataLoading = true;
    update();
    Response response = await dashboardRepo.getDashBoardData();
    if (response.statusCode == 200) {
      _dashboardInfoModel = DashboardStatics.fromJson(response.body['result']);
    } else {
      ApiChecker.checkApi(response);
    }
    _isDashboardDataLoading = false;
    update();
  }

  final List<Map<String, String>> _topFiveCustomerOverviewFilterType = [
    {"title": "last_7_days_key", "value": "1"},
    {"title": "this_week_key", "value": "2"},
    {"title": "last_week_key", "value": "3"},
    {"title": "this_month_key", "value": "4"},
    {"title": "last_month_key", "value": "5"},
    {"title": "this_year_key", "value": "6"},
    {"title": "total_key", "value": "0"},
  ];

  //
  List<Map<String, String>> get topFiveCustomerOverviewFilterType =>
      _topFiveCustomerOverviewFilterType;

  String _selectedTopFiveCustomerOverviewFilterType = "5";
  String get selectedTopFiveCustomerOverviewFilterType =>
      _selectedTopFiveCustomerOverviewFilterType;

  void refreshTopFiveCustomerData() {
    _selectedTopFiveCustomerOverviewFilterType = "5";
    print('this week= $_selectedTopFiveCustomerOverviewFilterType');
    update();
  }

  void setSelectedTopFiveCustomerOverviewFilterType(String id) {
    _selectedTopFiveCustomerOverviewFilterType = id;
    getTopFiveCustomerData(id, true);
    update(['five_customer']);
  }

  // Variable
  bool _isTopFiveCustomerLoading = false;
  bool get isTopFiveCustomerLoading => _isTopFiveCustomerLoading;

  TopCustomerResponse? _topFiveCustomerModel;
  TopCustomerResponse? get topFiveCustomerModel => _topFiveCustomerModel;

  // Dash info get Data method
  Future<void> getTopFiveCustomerData(String id, bool fromFilter) async {
    _isTopFiveCustomerLoading = true;
    update(['five_customer']);
    Response response = await dashboardRepo.getTopFiveCustomerData(id);
    if (response.statusCode == 200) {
      _topFiveCustomerModel = TopCustomerResponse.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }

    _isTopFiveCustomerLoading = false;
    update(['five_customer']);
  }

  // Income and Expenses Method

  final List<Map<String, String>> _incomeExpensesOverviewFilterType = [
    {"title": "last_7_days_key", "value": "1"},
    {"title": "this_week_key", "value": "2"},
    {"title": "last_week_key", "value": "3"},
    {"title": "this_month_key", "value": "4"},
    {"title": "last_month_key", "value": "5"},
    {"title": "this_year_key", "value": "6"},
    {"title": "total_key", "value": "0"},
  ];

  //
  List<Map<String, String>> get incomeExpensesOverviewFilterType =>
      _incomeExpensesOverviewFilterType;

  String _selectedIncomeExpensesOverviewFilterType = "5";
  String get selectedIncomeExpensesOverviewFilterType =>
      _selectedIncomeExpensesOverviewFilterType;

  void refreshIncomeExpensesData() {
    _selectedIncomeExpensesOverviewFilterType = "5";
    print('this week= $_selectedIncomeExpensesOverviewFilterType');
    update();
  }

  void setSelectedIncomeExpensesOverviewFilterType(String id) {
    _selectedIncomeExpensesOverviewFilterType = id;
    getIncomeExpensesOverviewData(id);
    update(['income_expense']);
  }

  // Variable
  IncomeExpenseChartModel? _incomeExpenseChartModel;
  IncomeExpenseChartModel? get incomeExpenseChartModel =>
      _incomeExpenseChartModel;

  bool _isIncomeExpenseOverviewLoading = false;
  bool get isIncomeExpenseOverviewLoading => _isIncomeExpenseOverviewLoading;

  String _normalizedKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  List<IncomeExpensePoint> chartData = [];

  Future<void> getIncomeExpensesOverviewData(String id) async {
    _isIncomeExpenseOverviewLoading = true;
    update(['income_expense']);

    Response response = await dashboardRepo.getIncomeExpensesOverviewData(id);

    if (response.statusCode == 200) {
      _incomeExpenseChartModel = IncomeExpenseChartModel.fromJson(
        response.body['result'],
      );

      chartData.clear();

      final incomeList = _incomeExpenseChartModel?.income ?? [];
      final expenseList = _incomeExpenseChartModel?.expense ?? [];

      /// 🔑 Key = normalized date string
      final Map<String, IncomeExpensePoint> dataMap = {};

      // Income
      for (var item in incomeList) {
        final raw = (item.date ?? item.context ?? '').toString();
        if (raw.isEmpty) continue;

        final date = _parseDate(raw);
        final key = _normalizedKey(date);

        dataMap[key] = IncomeExpensePoint(
          date: date,
          income: item.income?.toDouble() ?? 0,
          expense: 0,
          context: item.context ?? raw,
        );
      }

      // Expense
      for (var item in expenseList) {
        final raw = (item.date ?? item.context ?? '').toString();
        if (raw.isEmpty) continue;

        final date = _parseDate(raw);
        final key = _normalizedKey(date);

        if (dataMap.containsKey(key)) {
          final old = dataMap[key]!;
          dataMap[key] = IncomeExpensePoint(
            date: old.date,
            income: old.income,
            expense: item.expense?.toDouble() ?? 0,
            context: old.context,
          );
        } else {
          dataMap[key] = IncomeExpensePoint(
            date: date,
            income: 0,
            expense: item.expense?.toDouble() ?? 0,
            context: item.context ?? raw,
          );
        }
      }

      chartData = dataMap.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      debugPrint('Chart data length: ${chartData.length}');
    } else {
      ApiChecker.checkApi(response);
    }

    _isIncomeExpenseOverviewLoading = false;
    update(['income_expense']);
  }

  DateTime _parseDate(String value) {
    // Year only (TOTAL)
    if (RegExp(r'^\d{4}$').hasMatch(value)) {
      return DateTime(int.parse(value), 1, 1);
    }

    // ISO / yyyy-MM-dd
    try {
      return DateTime.parse(value);
    } catch (_) {
      return DateTime.now();
    }
  }

  // Calculate Received and Due amount percentage
  void calculateAmountPercentage({
    required String receivedAmount,
    required String dueAmount,
  }) {
    double due, received, totalAmount;

    try {
      received = double.parse(receivedAmount);
      due = double.parse(dueAmount);
      totalAmount = received + due;

      _receivedAmountPercentage = (received / totalAmount) * 100;
      _dueAmountPercentage = (due / totalAmount) * 100;
      if (_receivedAmountPercentage.isNaN && _dueAmountPercentage.isNaN) {
        _receivedAmountPercentage = 50;
        _dueAmountPercentage = 50;
      } else {
        if (_receivedAmountPercentage.isNaN && !_dueAmountPercentage.isNaN) {
          _receivedAmountPercentage = 100 - _dueAmountPercentage;
        } else if (!_receivedAmountPercentage.isNaN &&
            _dueAmountPercentage.isNaN) {
          _dueAmountPercentage = 100 - _receivedAmountPercentage;
        }
      }
    } catch (e) {
      _receivedAmountPercentage = 50;
      _dueAmountPercentage = 50;
    }
  }

  final List<Map<String, String>> _ticketOverviewFilterType = [
    {"title": "last_7_days_key", "value": "1"},
    {"title": "this_week_key", "value": "2"},
    {"title": "last_week_key", "value": "3"},
    {"title": "this_month_key", "value": "4"},
    {"title": "last_month_key", "value": "5"},
    {"title": "this_year_key", "value": "6"},
    {"title": "total_key", "value": "0"},
  ];

  //
  List<Map<String, String>> get ticketOverviewFilterType =>
      _ticketOverviewFilterType;

  String _selectedTicketOverviewFilterType = "5";
  String get selectedTicketOverviewFilterType =>
      _selectedTicketOverviewFilterType;

  void refreshTicketData() {
    _selectedTicketOverviewFilterType = "5";
    print('this week= $_selectedTicketOverviewFilterType');
    update();
  }

  void setSelectedTicketOverviewFilterType(String id) {
    _selectedTicketOverviewFilterType = id;
    getTicketGraphData(id);
    update(['ticket_overview']);
  }

  List<TopTicketChartModel> chartSolvedData = [];
  List<TopTicketChartModel> chartCreatedData = [];

  bool _isTicketOverviewLoading = false;
  bool get isTicketOverviewLoading => _isTicketOverviewLoading;

  Future<void> getTicketGraphData(String id) async {
    _isTicketOverviewLoading = true;
    update(['ticket_overview']);

    try {
      Response response = await dashboardRepo.getTicketGraphData(id);

      if (response.statusCode == 200) {
        final solvedList = (response.body['result']['solved_tickets'] as List)
            .map((e) => TicketChartModel.fromJson(e))
            .toList();

        final createdList = (response.body['result']['created_tickets'] as List)
            .map((e) => TicketChartModel.fromJson(e))
            .toList();

        chartSolvedData = solvedList
            .map(
              (e) => TopTicketChartModel(
                context: e.context,
                amount: e.ticket,
                color: Theme.of(Get.context!).primaryColor,
              ),
            )
            .toList();

        chartCreatedData = createdList.map((createdData) {
          final solved = chartSolvedData.firstWhere(
            (s) => s.context == createdData.context,
            orElse: () => TopTicketChartModel(
              context: createdData.context,
              amount: 0,
              color: Colors.transparent,
            ),
          );

          return TopTicketChartModel(
            context: createdData.context,
            amount: (createdData.ticket - solved.amount)
                .clamp(0, double.infinity)
                .toInt(),
            color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.3),
          );
        }).toList();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('getTicketGraphData error: $e');
    } finally {
      _isTicketOverviewLoading = false;
      update(['ticket_overview']);
    }
  }

  PaymentOverviewModel? _paymentOverviewList;
  PaymentOverviewModel? get paymentOverviewList => _paymentOverviewList;

  bool _isPaymentOverviewLoading = false;
  bool get isPaymentOverviewLoading => _isPaymentOverviewLoading;

  // Get income overview data
  Future<void> getPaymentOverview(String id, bool fromFilter) async {
    _isPaymentOverviewLoading = true;
    update(['income_payment']);

    final response = await dashboardRepo.getIncomeOverviewData(id);

    if (response.statusCode == 200) {
      _paymentOverviewList = PaymentOverviewModel.fromJson(
        response.body['result']['payment_overview'],
      );

      calculateAmountPercentage(
        receivedAmount: _paymentOverviewList!.receivedAmount.toString(),
        dueAmount: _paymentOverviewList!.dueAmount.toString(),
      );
    } else {
      ApiChecker.checkApi(response);
    }

    _isPaymentOverviewLoading = false;
    update(['income_payment']);
  }

  // Get Profile Data
  Future<ResponseModel> getProfileDetails() async {
    _isProfileDetailsLoading = true;
    _profileDetailsModel = null;
    update();
    ResponseModel responseModel;
    Response response = await dashboardRepo.getProfileDetails();
    if (response.statusCode == 200) {
      _profileDetailsModel = ProfileDetailsModel.fromJson(
        response.body['result'],
      );
      print("result ${response.body['result']}");
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isProfileDetailsLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteProfiles() async {
    ResponseModel responseModel;
    Response response = await dashboardRepo.deleteProfile();
    if (response.statusCode == 200) {
      print("statusCode ${response.statusCode} ${response.body['status']}");
      responseModel = ResponseModel(true, response.body['message']);
      showCustomSnackBar(response.body['message'], isError: false);
      update();
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    update();
    return responseModel;
  }

  // Set Selected Gender name
  void setGender(String? value, bool notify) {
    _selectedGender = value;
    if (notify) {
      update();
    }
  }

  // Set pick image
  void pickImage(bool isRemove) async {
    if (isRemove) {
      _pickedImage = null;
      update();
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final fileSize = await pickedFile.length();

      if (fileSize > 2 * 1024 * 1024) {
        showCustomSnackBar("image_max_size_key".tr, isError: true);
        return;
      }

      _pickedImage = pickedFile;
      update(); // UI will show the picked image instantly
    }
  }

  // Update Profile
  Future<ResponseModel> updateProfile(
    UpdateProfileBody updateProfileBody,
  ) async {
    _updateProfileLoading = true;
    update();
    ResponseModel responseModel;
    Response response = await dashboardRepo.updateProfile(
      updateProfileBody: updateProfileBody,
      image: _pickedImage,
    );
    if (_pickedImage != null) {
      print('Uploading profile picture: ${_pickedImage!.path}');
    }

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
      _pickedImage = null;
      getProfileDetails();
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    _updateProfileLoading = false;
    update();
    return responseModel;
  }

  // change password
  Future<ResponseModel> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _updateProfileLoading = true;
    update();
    ResponseModel responseModel;
    Response response = await dashboardRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (response.statusCode == 200) {
      Get.back();
      responseModel = ResponseModel(true, response.body['message']);
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    _updateProfileLoading = false;
    update();
    return responseModel;
  }

  // Set country
  void setCountry(Country country) {
    _country = country;
    update();
  }

  // Email De..@gemail.com formatter
  String formatEmail(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex <= 2) {
      return email; // Not enough characters to shorten
    }
    return '${email.substring(0, 2)}..${email.substring(atIndex)}';
  }

  // ======================
  // More List List Section
  // ======================

  // Variable
  List<PopupModel> _profileMoreList = [];
  List<PopupModel> get profileMoreList => _profileMoreList;

  // Create More List
  void createProfileMoreList(BuildContext context) {
    _profileMoreList = [
      PopupModel(
        image: Images.edit,
        title: 'edit_key'.tr,
        route: RouteHelper.profileEditScreen,
      ),
    ];
    update();
    debugPrint(
      'userMoreList initialized with ${_profileMoreList.length} items.',
    );
  }
}
