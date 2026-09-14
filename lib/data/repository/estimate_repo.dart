import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class EstimateRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  EstimateRepo({required this.apiClient, required this.sharedPreferences});

  // Get estimate response
  Future<Response> getEstimate(
      {String? url,
      required bool fromFilter,
      String? status,
      String? customerId,
      String? startDate,
      String? endDate}) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&${"status=$status"}${"&customer=$customerId"}${"&date[]=$startDate&date[]=$endDate"}"
                : "${AppConstants.GET_ESTIMATE_URI}?${"status=$status"}${"&customer=$customerId"}${"&date[]=$startDate&date[]=$endDate"}"
            : url ?? AppConstants.GET_ESTIMATE_URI,
        isPaginate: url != null ? true : false);
  }

  // Get suggested customer response
  Future<Response> getSuggestedCustomer(
      {int? pageNumber, String? searchKey, int? selectedId}) async {
    var url =
        "${AppConstants.GET_SUGGEST_CUSTOMER_URI}?page=${pageNumber ?? ''}${"&search=${searchKey ?? ''}"}${"&selected=${selectedId ?? ''}"}";
    return await apiClient.getData(url);
  }

  Future<Response> getSuggestedDiscountType() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_DISCOUNT_TYPE_URI);
  }

  // Get suggested taxes response
  Future<Response> getSuggestedTaxes() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_TAXES_URI);
  }

  // Create estimate response
  Future<Response> createEstimate({required dynamic map}) async {
    return await apiClient.postData(AppConstants.CREATE_ESTIMATE_URI, map);
  }

  // Get estimate details response
  Future<Response> getEstimateDetails({required int id}) async {
    return await apiClient
        .getData("${AppConstants.GET_ESTIMATE_DETAILS_URI}$id");
  }

  // Update estimate response
  Future<Response> updateEstimate(
      {required dynamic map, required int id}) async {
    return await apiClient.patchData(
        "${AppConstants.UPDATE_ESTIMATE_URI}$id", map);
  }

  // Estimate send attachment response
  Future<Response> estimateSendAttachment({required int id}) async {
    return await apiClient
        .getData("${AppConstants.ESTIMATE_SEND_ATTACHMENT_URI}$id");
  }

  // Estimate status update response
  Future<Response> estimateStatusUpdate(
      {required int id, required dynamic map}) async {
    return await apiClient.patchData(
        "${AppConstants.ESTIMATE_STATUS_UPDATE_URI}$id", map);
  }

  // Estimate invoice convert response
  Future<Response> estimateInvoiceConvert({required int id}) async {
    return await apiClient
        .getData("${AppConstants.ESTIMATE_INVOICE_CONVERT_URI}$id");
  }

  // Delete estimate response
  Future<Response> deleteEstimate({required int id}) async {
    return await apiClient.deleteData("${AppConstants.DELETE_ESTIMATE_URI}$id");
  }

  // Download estimate response
  Future<Response> downloadEstimate({required int id}) async {
    return await apiClient.getData(
        "${AppConstants.DOWNLOAD_ESTIMATE_URI}$id?isMobileDownload=true");
  }

  // Get Customer response
  Future<Response> getCustomerListDropdown() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_CUSTOMER_URI);
  }

  // Get Product response
  Future<Response> getProductListDropdown() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_PRODUCT_URI);
  }
}
