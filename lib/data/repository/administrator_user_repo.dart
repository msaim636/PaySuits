import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class AdministratorUserRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  AdministratorUserRepo(
      {required this.apiClient, required this.sharedPreferences});

  // Get user response
  Future<Response> getUsers({
    String? url,
    required bool fromFilter,
    String? roleId,
    String? status,
  }) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&role=$roleId&status=$status"
                : "${AppConstants.GET_USER_URI}?role=$roleId&status=$status"
            : url ?? AppConstants.GET_USER_URI,
        isPaginate: url != null ? true : false);
  }

  // User invite create response
  Future<Response> userInviteCreate({required dynamic map}) async {
    return await apiClient.postData(AppConstants.USER_INVITE_CREATE_URI, map);
  }

  // User invite Update  response
  Future<Response> userInviteUpdate(
      {required dynamic map, required int id}) async {
    return await apiClient.patchData("${AppConstants.GET_USER_URI}/$id", map);
  }

// Get role response
  Future<Response> getRoleListDropdown() async {
    return await apiClient.getData(AppConstants.ROLE_URI);
  }

  // Delete Customer
  Future<Response> deleteUsers({required int id}) async {
    return await apiClient.deleteData("${AppConstants.GET_USER_URI}/$id");
  }

  // Get DashBoard Info method
  Future<Response> getTutorialData() async {
    return await apiClient.getData(
      AppConstants.TUTORIAL_URI,
    );
  }
}
