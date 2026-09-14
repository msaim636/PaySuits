import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/permission_controller.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/user_role_model.dart';
import '../data/model/response/users_model.dart';
import '../data/repository/administrator_user_repo.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'expenses_controller.dart';

class AdministratorUserController extends GetxController
    implements GetxService {
  final AdministratorUserRepo administratorUserRepo;

  AdministratorUserController({required this.administratorUserRepo});

  final createFormKey = GlobalKey<FormState>();

  bool _administratorListLoading = false;
  bool get administratorListLoading => _administratorListLoading;

  bool _userPaginateLoading = false;
  bool get userPaginateLoading => _userPaginateLoading;

  String? _usersNextPageUrl;
  String? get usersNextPageUrl => _usersNextPageUrl;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  bool _isUsersFilter = false;
  bool get isUsersFilter => _isUsersFilter;

  List<UsersModel> _usersList = [];
  List<UsersModel> get usersList => _usersList;

  List<UserRolesModel> _roleDropdownList = [];
  List<UserRolesModel> get roleDropdownList => _roleDropdownList;

  List<Map<String, String>> _roleDropdownStringList = [];
  List<Map<String, String>> get roleDropdownStringList =>
      _roleDropdownStringList;

  String? _userRoleDWValue;
  String? get userRoleDWValue => _userRoleDWValue;

  String? _roleFilterDropdownValue;
  String? get roleFilterDropdownValue => _roleFilterDropdownValue;

  String? _statusDWValue;
  String? get statusDWValue => _statusDWValue;

  final List<Map<String, String>> _statusList = [
    {'id': '1', 'value': 'Active'},
    {'id': '2', 'value': 'Inactive'},
    {'id': '3', 'value': 'Invited'},
  ];
  List<Map<String, String>> get statusList => _statusList;

  String? _statusId;
  String? get statusId => _statusId;

  Map<String, dynamic>? _selectedFilterRoleItem;
  Map<String, dynamic>? get selectedFilterRoleItem => _selectedFilterRoleItem;

  bool _suggestedAllItemListLoading = false;
  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  final bool _getUserDetailsLoading = false;
  bool get getUserDetailsLoading => _getUserDetailsLoading;

  bool _createUserSaveLoading = false;
  bool get createUserSaveLoading => _createUserSaveLoading;

  final bool _updateUserSaveLoading = false;
  bool get updateUserSaveLoading => _updateUserSaveLoading;

  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();

  static int _userSelectedId = -1;
  static int get userSelectedId => _userSelectedId;

  static String _userSelectedStatus = "status_active";
  static String get userSelectedStatus => _userSelectedStatus;

  int? _selectedUserIndex;
  int? get selectedUserIndex => _selectedUserIndex;

  // User More item list With Out Status
  List<PopupModel> _uerMoreListWithOutStatus = [];
  List<PopupModel> get uerMoreListWithOutStatus => _uerMoreListWithOutStatus;

  void createUserMoreListWitOutStatus() {
    _uerMoreListWithOutStatus = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteUsers!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteIcon,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: 'delete_key'.tr,
            rightBtnOnTap: () {
              Get.find<AdministratorUserController>().deleteUsers();
            },
          ),
        ),
    ];
  }

  // User More item list With  Status
  List<PopupModel> _uerMoreListWithStatus = [];
  List<PopupModel> get uerMoreListWithStatus => _uerMoreListWithStatus;

  void createUserMoreListWitStatus({String? status}) {
    print("object_userSelectedStatus $_userSelectedStatus");
    _uerMoreListWithStatus = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updateUsers!)
        PopupModel(
          image: Images.inactiveUser,
          title: status == "status_active" ? 'active_key' : "inactive_key",
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            description:
                'are_you_sure_you_want_to_change_customer_status_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<AdministratorUserController>().usersUpdateStatus();
            },
          ),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteUsers!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteAlert,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: 'delete_key'.tr,
            rightBtnOnTap: () {
              Get.find<AdministratorUserController>().deleteUsers();
            },
          ),
        ),
    ];
  }

  // Set selected estimate index
  void setSelectedUsersIndex(int? index) {
    _selectedUserIndex = index;
  }

  void setSelectedFilterCustomerItem(Map<String, dynamic> map) {
    _selectedFilterRoleItem = map;
    update();
  }

  // Set expenses category dw value
  void setUserRoleDWValue(String? value) {
    _userRoleDWValue = value;
    update();
  }

  // Set Role filter dw value
  void setRoleFilterDropdownValue(String? value) {
    _roleFilterDropdownValue = value;
    update();
  }

  // Set user status dw value
  void setStatusDWValue(String? value) {
    _statusDWValue = value;
    _statusId = value;
    update();
  }

  // all user list
  Future<ResponseModel> getUsers({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _userPaginateLoading = true;
    } else {
      _usersList = [];
      _usersNextPageUrl = null;
      _administratorListLoading = true;
      _isUsersFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      update();
      _userRoleDWValue = _roleFilterDropdownValue;
    }
    final response = await administratorUserRepo.getUsers(
      url: _usersNextPageUrl,
      fromFilter: _isUsersFilter,
      roleId: _userRoleDWValue ?? "",
      status: _statusId ?? "",
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _usersList.add(UsersModel.fromJson(item));
      });
      _usersNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(true, response.body['message']);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _userPaginateLoading = false;
    } else {
      _administratorListLoading = false;
    }
    update();
    return responseModel;
  }

  // Create estimate
  Future<void> createUserInvite() async {
    _createUserSaveLoading = true;
    update();
    final response = await administratorUserRepo.userInviteCreate(
      map: {'email': emailController.text, 'role': userRoleDWValue.toString()},
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      Get.back();
      Get.toNamed(RouteHelper.userScreen);
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _createUserSaveLoading = false;
    update();
  }

  // Users Update Status

  Future<void> usersUpdateStatus() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    Response response = await administratorUserRepo.userInviteUpdate(
      map: {'status_name': _userSelectedStatus},
      id: _userSelectedId,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.isSnackbarOpen ? Get.back() : null;
      Get.back();

      getUsers();

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Delete user
  Future<void> deleteUsers() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await administratorUserRepo.deleteUsers(
      id: _usersList[_selectedUserIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getUsers();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Set User on tap id
  void setUserSelectedId({required int id, required String status}) {
    _userSelectedId = id;
    _userSelectedStatus = status;
    update();
    if (Get.find<PermissionController>()
        .myPermissionModel!
        .permission!
        .updateCustomers!) {
      for (int i = 0; i < _uerMoreListWithOutStatus.length; i++) {
        if (_uerMoreListWithOutStatus[i].image == Images.inactiveUser) {
          _uerMoreListWithOutStatus[i] = PopupModel(
            image: Images.inactiveUser,
            title: _userSelectedStatus == "status_active"
                ? "active_key"
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
                usersUpdateStatus();
              },
            ),
          );
        }
      }
    }
    update();
  }

  // Get role list
  Future<void> getRoleListDropdown() async {
    _suggestedAllItemListLoading = true;
    _roleDropdownList = [];
    _roleDropdownStringList = [];
    update();
    final response = await administratorUserRepo.getRoleListDropdown();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _roleDropdownList.add(UserRolesModel.fromJson(item));
        _roleDropdownStringList.add({
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

  void refreshFilterForm() {
    // setUserRoleDWValue(null);
    _roleFilterDropdownValue = null;
    _userRoleDWValue = null;
    _statusId = null;
    _statusDWValue = null;
    _selectedFilterRoleItem = null;
    update();
  }

  bool isEmptyFilterForm() {
    if (_roleFilterDropdownValue == null &&
        _userRoleDWValue == null &&
        _statusId == null &&
        _statusDWValue == null &&
        _selectedFilterRoleItem == null) {
      return true;
    } else {
      return false;
    }
  }

  // clear dats
  void clearUsersData() {
    emailController.text = '';
    _roleDropdownList = [];
    _userRoleDWValue = null;
  }
}
