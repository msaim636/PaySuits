import 'package:paysuite/data/model/body/due_payment_body.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class InvoiceRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  InvoiceRepo({required this.apiClient, required this.sharedPreferences});

  // Get invoice response
  Future<Response> getInvoice({
    String? url,
    required bool fromFilter,
    String? status,
    String? customerId,
    String? issueStartDate,
    String? issueEndDate,
    String? dueStartDate,
    String? dueEndDate,
  }) async {
    return await apiClient.getData(
      fromFilter
          ? url != null
                ? "$url&${"status=$status"}${"&customer=$customerId"}${"&issue_date[]=$issueStartDate&issue_date[]=$issueEndDate"}${"&due_date[]=$dueStartDate&due_date[]=$dueEndDate"}"
                : "${AppConstants.GET_INVOICE_URI}?${"status=$status"}${"&customer=$customerId"}${"&issue_date[]=$issueStartDate&issue_date[]=$issueEndDate"}${"&due_date[]=$dueStartDate&due_date[]=$dueEndDate"}"
          : url ?? AppConstants.GET_INVOICE_URI,
      isPaginate: url != null ? true : false,
    );
  }

  // Get suggested discount type response
  Future<Response> getSuggestedDiscountType() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_DISCOUNT_TYPE_URI);
  }

  // Get suggested taxes response
  Future<Response> getSuggestedTaxes() async {
    return await apiClient.getData(AppConstants.GET_SUGGEST_TAXES_URI);
  }

  // Create invoice response
  Future<Response> createInvoice({required dynamic map}) async {
    return await apiClient.postData(AppConstants.CREATE_INVOICE_URI, map);
  }

  // Get invoice details response
  Future<Response> getInvoiceDetails({required int id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_INVOICE_DETAILS_URI}$id",
    );
  }

  // Update invoice response
  Future<Response> updateInvoice({
    required dynamic map,
    required int id,
  }) async {
    return await apiClient.patchData(
      "${AppConstants.UPDATE_INVOICE_URI}$id",
      map,
    );
  }

  // Resend invoice response
  Future<Response> resendInvoice({required int id}) async {
    return await apiClient.postData(
      "${AppConstants.RESEND_INVOICE_URI}$id",
      '',
    );
  }

  // Clone invoice response
  Future<Response> cloneInvoice({required int id}) async {
    return await apiClient.postData("${AppConstants.CLONE_INVOICE_URI}$id", '');
  }

  // Delete invoice response
  Future<Response> deleteInvoice({required int id}) async {
    return await apiClient.deleteData("${AppConstants.DELETE_INVOICE_URI}$id");
  }

  // Download invoice response
  Future<Response> downloadInvoice({required int id}) async {
    return await apiClient.getData(
      "${AppConstants.DOWNLOAD_INVOICE_URI}$id?isMobileDownload=true",
    );
  }

  // Due Amount response
  Future<Response> duePayment({
    required DuePaymentBody duePaymentBody,
    required int id,
  }) async {
    return await apiClient.postData(
      "${AppConstants.DUE_PAYMENT_URI}$id",
      duePaymentBody.toJson(),
    );
  }

  Future<Response> customerDuePayment({
    required DuePaymentBody duePaymentBody,
    required int id,
  }) async {
    return await apiClient.postData(
      "${AppConstants.CUSTOMER_INVOICE_DUE_PAYMENT_URI}$id",
      duePaymentBody.toJson(),
    );
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
