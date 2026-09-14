import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class PermissionRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  PermissionRepo({required this.apiClient, required this.sharedPreferences});

  // Get Permission data
  Future<Response> getPermission() async {
    return await apiClient.getData(AppConstants.GET_PERMISSION_URI);
  }
}
