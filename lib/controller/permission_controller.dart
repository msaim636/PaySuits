// ignore_for_file: strict_top_level_inference

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/permission_model.dart';
import '../data/repository/permission_repo.dart';
import '../helper/route_helper.dart';
import '../util/app_constants.dart';

class PermissionController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final PermissionRepo permissionRepo;

  PermissionController({
    required this.sharedPreferences,
    required this.permissionRepo,
  });

  RxBool isExpired = false.obs;

  // PermissionModel
  MyPermissionModel? myPermissionModel;

  // Loading
  bool _permissionLoading = false;
  bool get permissionLoading => _permissionLoading;

  // Create count
  int _createCount = 0;
  int get createCount => _createCount;

  // App logo
  String? _appLogo;
  String? get appLogo => _appLogo;

  // Get units data
  Future<void> getPermission() async {
    _permissionLoading = true;
    update();
    final response = await permissionRepo.getPermission();
    if (response.statusCode == 200) {
      try {
        final result = response.body['result'];
        myPermissionModel = MyPermissionModel.fromJson(result);

        await setPermissionInfo();
      } catch (e) {
        print("Error parsing permission response: $e");
      }
      Get.find<PermissionController>().setPermissionInfo();
    } else {
      ApiChecker.checkApi(response);
    }
    _permissionLoading = false;
    update();
  }

  /// Set permission info safely
  Future<void> setPermissionInfo() async {
    if (myPermissionModel != null) {
      await sharedPreferences.setString(
        AppConstants.PERMISSION,
        json.encode(myPermissionModel!.toJson()),
      );
    }
    await getPermissionInfo();
    update();
  }

  /// Get permission info safely
  Future<void> getPermissionInfo() async {
    try {
      // _appLogo = sharedPreferences.getString(AppConstants.APP_LOGO);

      final dataString = sharedPreferences.getString(AppConstants.PERMISSION);
      if (dataString == null || dataString.isEmpty) {
        myPermissionModel = null;
        _createCount = 0;
        update();
        return;
      }

      final data = json.decode(dataString);
      myPermissionModel = MyPermissionModel.fromJson(data);

      int count = 0;
      final permission = myPermissionModel?.permission;

      if (permission?.createCustomers == true) count++;
      if (permission?.createProducts == true) count++;
      if (permission?.createExpenses == true) count++;
      if (permission?.createEstimates == true) count++;
      if (permission?.createInvoices == true) count++;

      _createCount = count;
    } catch (e) {
      print("Error reading permission info: $e");
      myPermissionModel = null;
      _createCount = 0;
    }

    update();
  }

  void updateStatus(String status) {
    if (status == 'expired') {
      isExpired.value = true;
      _redirectToExpired();
    }
  }

  void _redirectToExpired() {
    if (Get.currentRoute != RouteHelper.getPlanExpiredRoute()) {
      Get.offAllNamed(RouteHelper.getPlanExpiredRoute());
    }
  }
}
