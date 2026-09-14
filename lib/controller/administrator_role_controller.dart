import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/permission_controller.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/role_details_model.dart';
import '../data/model/response/role_permission_model.dart';
import '../data/model/response/roles_model.dart';
import '../data/repository/administrator_role_repo.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'expenses_controller.dart';

class AdministratorRolesController extends GetxController
    implements GetxService {
  final AdministratorRoleRepo administratorRoleRepo;

  AdministratorRolesController({required this.administratorRoleRepo});

  final createFormKey = GlobalKey<FormState>();

  bool _administratorListLoading = false;
  bool get administratorListLoading => _administratorListLoading;

  bool _rolePaginateLoading = false;
  bool get rolePaginateLoading => _rolePaginateLoading;

  String? _roleNextPageUrl;
  String? get roleNextPageUrl => _roleNextPageUrl;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  bool _isRolesFilter = false;
  bool get isRolesFilter => _isRolesFilter;

  List<RolesModel> _rolesList = [];
  List<RolesModel> get rolesList => _rolesList;

  RoleDetailModel? _roleDetailsModel;
  RoleDetailModel? get roleDetailsModel => _roleDetailsModel;

  List<RolePermission> _rolePermissionList = [];
  List<RolePermission> get rolePermissionList => _rolePermissionList;

  List<int> _selectedRolePermissions = [];
  List<int> get selectedRolePermissions => _selectedRolePermissions;

  final Map<String, int> _permissionNameToIdMap = {};
  Map<String, int> get permissionNameToIdMap => _permissionNameToIdMap;

  List<int> _selectedPermissionIds = [];
  List<int> get selectedPermissionIds => _selectedPermissionIds;

  final List<Map<String, String>> _rolePermissionStringList = [];
  List<Map<String, String>> get rolePermissionStringList =>
      _rolePermissionStringList;

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

  bool _getUserDetailsLoading = false;
  bool get getUserDetailsLoading => _getUserDetailsLoading;

  bool _createUserSaveLoading = false;
  bool get createUserSaveLoading => _createUserSaveLoading;

  bool _updateRolesSaveLoading = false;
  bool get updateRolesSaveLoading => _updateRolesSaveLoading;

  final nameFocusNode = FocusNode();
  final nameController = TextEditingController();

  int? _selectedUserIndex;
  int? get selectedUserIndex => _selectedUserIndex;

  // User More item list With  Status
  List<PopupModel> _roleMoreList = [];
  List<PopupModel> get roleMoreList => _roleMoreList;

  void createRoleMoreList() {
    _roleMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updateRoles!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getCreateRoleRoute('1'),
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteRoles!)
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
              Get.find<AdministratorRolesController>().deleteRoles();
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

  void refreshFilterForm() {
    // setUserRoleDWValue(null);
    _roleFilterDropdownValue = null;
    _userRoleDWValue = null;
    _statusId = null;
    _statusDWValue = null;
    _selectedFilterRoleItem = null;
    // update();
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
    nameController.text = '';
    _selectedPermissionIds = [];
    _selectedRolePermissions = [];
  }

  void setSelectedPermissionIds(List<int> value) {
    _selectedPermissionIds = value;
  }

  // all user list
  Future<ResponseModel> getRoles({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _rolePaginateLoading = true;
    } else {
      _rolesList = [];
      _roleNextPageUrl = null;
      _administratorListLoading = true;
      _isRolesFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }

    ResponseModel responseModel;
    if (fromFilter) {
      update();
      _userRoleDWValue = _roleFilterDropdownValue;
    }

    final response = await administratorRoleRepo.getRoles(
      url: _roleNextPageUrl,
      fromFilter: _isRolesFilter,
      roleId: _userRoleDWValue ?? "",
      status: _statusId ?? "",
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      _rolesList = [];
      response.body['result']['data'].forEach((item) {
        _rolesList.add(RolesModel.fromJson(item));
      });

      _roleNextPageUrl = response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(true, response.body['message']);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _rolePaginateLoading = false;
    } else {
      _administratorListLoading = false;
    }
    update();
    return responseModel;
  }

  // Create role
  Future<void> userRoleCreate() async {
    _createUserSaveLoading = true;
    update();
    final response = await administratorRoleRepo.userRoleCreate(
      map: {"name": nameController.text, "permissions": _selectedPermissionIds},
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      Get.back();
      Get.toNamed(RouteHelper.roleScreen);
      showCustomSnackBar(response.body['message'], isError: false);
      clearUsersData();
      getRoles();
    } else {
      ApiChecker.checkApi(response);
    }
    _createUserSaveLoading = false;
    update();
  }

  // update role
  Future<void> userRoleUpdate() async {
    _updateRolesSaveLoading = true;
    update();
    final response = await administratorRoleRepo.userRoleUpdate(
      map: {"name": nameController.text, "permissions": _selectedPermissionIds},
      id: _rolesList[_selectedUserIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      Get.back();
      Get.toNamed(RouteHelper.roleScreen);
      showCustomSnackBar(response.body['message'], isError: false);
      clearUsersData();
      getRoles();
    } else {
      ApiChecker.checkApi(response);
    }
    _updateRolesSaveLoading = false;
    update();
  }

  // Delete roles
  Future<void> deleteRoles() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await administratorRoleRepo.deleteRoles(
      id: _rolesList[_selectedUserIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getRoles();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Get role details data

  Future<void> getRoleDetails() async {
    _getUserDetailsLoading = true;
    _roleDetailsModel = null;
    _selectedRolePermissions = [];
    update();

    final response = await administratorRoleRepo.getRoleDetails(
      id: _rolesList[_selectedUserIndex!].id!,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      _roleDetailsModel = RoleDetailModel.fromJson(response.body['result']);

      // Populate the name controller with the role name
      nameController.text = _roleDetailsModel!.name ?? "";
      if (_roleDetailsModel!.permissions != null) {
        for (var data in _roleDetailsModel!.permissions!) {
          _selectedPermissionIds.add(data.id!.toInt());
          _selectedRolePermissions.add(data.id!);
        }
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }

    _getUserDetailsLoading = false;
    update();
  }

  // Get role Permission list

  Future<void> getRolePermissionList() async {
    _suggestedAllItemListLoading = true;
    _rolePermissionList = [];
    update();
    final response = await administratorRoleRepo.getRolePermission();
    if (response.statusCode == 200 && response.body['status'] == true) {
      final result = response.body['result'];
      result.forEach((key, permissions) {
        for (var item in permissions) {
          // Add the permission to the list
          _rolePermissionList.add(RolePermission.fromJson(item));
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }
}
