import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class SettingsRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SettingsRepo({required this.apiClient, required this.sharedPreferences});

  // Get Company Details
  Future<Response> getCompanySettings() async {
    return await apiClient.getData(AppConstants.COMPANY_DETAILS_URI);
  }
}
