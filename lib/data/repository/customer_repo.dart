import 'package:paysuite/data/model/body/add_customer_body.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class CustomerRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  CustomerRepo({required this.apiClient, required this.sharedPreferences});

  // Get Customer data
  Future<Response> getCustomerData({
    String? url,
    required bool fromFilter,
    String? status,
  }) async {
    return await apiClient.getData(
      fromFilter
          ? url != null
                ? "$url&status=$status"
                : "${AppConstants.GET_CUSTOMER_URI}?status=$status"
          : url ?? AppConstants.GET_CUSTOMER_URI,
      isPaginate: url != null ? true : false,
    );
  }

  // Add Customer
  Future<Response> addCustomer({
    required AddCustomerBody addCustomerBody,
  }) async {
    return await apiClient.postData(
      AppConstants.ADD_CUSTOMER_URI,
      addCustomerBody.toJson(),
    );
  }

  // Get Customer details
  Future<Response> getCustomerDetails({String? id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_CUSTOMER_DETAILS_URI}$id",
    );
  }

  // Get Customer invoice details data
  Future<Response> getCustomerInvoiceDetails({
    String? url,
    required String id,
  }) async {
    return await apiClient.getData(
      url ?? "${AppConstants.GET_CUSTOMER_INVOICE_DETAILS_URI}$id",
      isPaginate: url != null ? true : false,
    );
  }

  // Delete Customer
  Future<Response> deleteCustomer({required int id}) async {
    return await apiClient.deleteData("${AppConstants.DELETE_CUSTOMER_URI}$id");
  }

  // Inactive Customer
  Future<Response> inactiveCustomer({required int id, dynamic map}) async {
    return await apiClient.patchData(
      "${AppConstants.CUSTOMER_UPDATE_STATUS_URI}$id",
      map,
    );
  }

  // Customer Resend Portal Access
  Future<Response> customerResendPortalAccess({String? id}) async {
    return await apiClient.getData(
      "${AppConstants.CUSTOMER_RESEND_PORTAL_ACCESS_URI}$id",
    );
  }

  // Customer Update Status
  Future<Response> customerUpdateStatus({
    required String id,
    required String status,
  }) async {
    return await apiClient.patchData(
      "${AppConstants.CUSTOMER_UPDATE_STATUS_URI}$id",
      {"status_name": status},
    );
  }

  // Get Customer update details
  Future<Response> getCustomerUpdateDetails({String? id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_CUSTOMER_UPDATE_DETAILS_URI}$id",
    );
  }

  // Customer update method
  Future<Response> customerUpdate({
    required String id,
    required AddCustomerBody addCustomerBody,
  }) async {
    return await apiClient.patchData(
      "${AppConstants.CUSTOMER_UPDATE_URI}$id",
      addCustomerBody.toJson(),
    );
  }

  // Get Customer Estimate details data
  Future<Response> getCustomerEstimateDetails({
    String? url,
    required String id,
  }) async {
    return await apiClient.getData(
      url ?? "${AppConstants.GET_CUSTOMER_ESTIMATE_DETAILS_URI}$id",
      isPaginate: url != null ? true : false,
    );
  }

  // Get Customer Transaction details data
  Future<Response> getCustomerTransactionDetails({
    String? url,
    required String id,
  }) async {
    return await apiClient.getData(
      url ?? "${AppConstants.GET_CUSTOMER_TRANSACTION_DETAILS_URI}$id",
      isPaginate: url != null ? true : false,
    );
  }
}
