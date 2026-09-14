import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class NotificationRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  NotificationRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  // Get Payment Methods response
  Future<Response> getNotificationReadStatus() async {
    return await apiClient.getData(AppConstants.GET_NOTIFICATION_READ_STATUS);
  }

  // Read all notification response
  Future<Response> readAllNotification() async {
    return await apiClient.patchData(AppConstants.READ_ALL_NOTIFICATION, {});
  }

  // Get notification response
  Future<Response> getNotification({String? url}) async {
    return await apiClient.getData(url ?? AppConstants.GET_NOTIFICATION,
        isPaginate: url != null ? true : false);
  }

  // single notification as read
  Future<Response> markSingleNotificationAsRead(String id) async {
    return await apiClient.patchData(
      '${AppConstants.GET_NOTIFICATION_READ_STATUS}$id',
      {},
    );
  }
}
