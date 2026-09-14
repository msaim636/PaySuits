import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class BillingRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  BillingRepo({required this.apiClient, required this.sharedPreferences});

  // Get Billing response
  Future<Response> getBilling({
    String? url,
    required bool fromFilter,
    String? search,
  }) async {
    return await apiClient.getData(
      fromFilter
          ? url != null
          ? "$url&${"search=$search"}"
          : "${AppConstants.GET_BILLING_URI}?${"search=$search"}"
          : url ?? AppConstants.GET_BILLING_URI,
      isPaginate: url != null ? true : false,
    );
  }
}
