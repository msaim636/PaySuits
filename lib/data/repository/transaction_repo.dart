import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class TransactionRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  TransactionRepo({required this.apiClient, required this.sharedPreferences});

  // Get transaction response
  Future<Response> getTransaction(
      {String? url,
      required bool fromFilter,
      String? customerId,
      String? paymentMethodId,
      String? startDate,
      String? endDate}) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&${"payment_method=$paymentMethodId"}${"&customer=$customerId"}${"&date[]=$startDate&date[]=$endDate"}"
                : "${AppConstants.GET_TRANSACTION_URI}?${"payment_method=$paymentMethodId"}${"&customer=$customerId"}${"&date[]=$startDate&date[]=$endDate"}"
            : url ?? AppConstants.GET_TRANSACTION_URI,
        isPaginate: url != null ? true : false);
  }
}
