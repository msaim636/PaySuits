
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class AdministratorRoleRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  AdministratorRoleRepo(

      {required this.apiClient, required this.sharedPreferences});

  // Get role response
  Future<Response> getRoles(
      {String? url,
        required bool fromFilter,
        String? roleId,
        String? status,
      }) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
            ? "$url&role=$roleId&status=$status"
            : "${AppConstants.GET_ROLE_URI}?role=$roleId&status=$status"
            : url ?? AppConstants.GET_ROLE_URI,
        isPaginate: url != null ? true : false);
  }

  // Delete Roles
  Future<Response> deleteRoles({required int id}) async {
    return await apiClient.deleteData("${AppConstants.GET_ROLE_URI}/$id");
  }

  // Get Role Permission data
  Future<Response> getRolePermission() async {
    return await apiClient.getData(AppConstants.GET_ROLE_PERMISSION_URI);
  }

  // User invite create response
  Future<Response> userRoleCreate({required dynamic map}) async {
    return await apiClient.postData(AppConstants.GET_ROLE_URI, map);
  }

  Future<Response> userRoleUpdate({required dynamic map,required int id}) async {
    return await apiClient.patchData("${AppConstants.GET_ROLE_URI}/$id", map);
  }

  // Get expenses details response
  Future<Response> getRoleDetails({required int id}) async {
    return await apiClient
        .getData("${AppConstants.GET_ROLE_URI}/$id");
  }
}