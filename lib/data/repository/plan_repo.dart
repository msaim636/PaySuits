import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class PlanRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  PlanRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getMyPlan() async {
    return await apiClient.getData(AppConstants.GET_MY_PLAN_URI);
  }

  Future<Response> getSubscriptionMyPlan() async {
    return await apiClient.getData(AppConstants.GET_SUBSCRIPTION_MY_PLAN_URI);
  }
}
