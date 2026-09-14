import 'package:paysuite/data/model/body/add_payment_method_body.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class PaymentMethodsRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  PaymentMethodsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  // Get Payment Methods response
  Future<Response> getPaymentMethods({String? url}) async {
    return await apiClient.getData(
      url ?? AppConstants.GET_PAYMENT_METHODS_URI,
      isPaginate: url != null ? true : false,
    );
  }

  // Get Payment Methods response
  Future<Response> getPaymentMethodsDropdown() async {
    return await apiClient.getData(
      AppConstants.GET_PAYMENT_METHODS_DROPDOWN_URI,
    );
  }

  // Get Payment Methods response
  Future<Response> getPaymentMethodsDropdownList() async {
    return await apiClient.getData(
      AppConstants.GET_PAYMENT_METHODS_DROPDOWN_LIST_URI,
    );
  }

  // Get Payment Methods response
  Future<Response> getPaymentGatewayDropdownList() async {
    return await apiClient.getData(
      AppConstants.GET_PAYMENT_GATEWAY_DROPDOWN_LIST_URI,
    );
  }

  // Edit Payment Methods response
  Future<Response> editPaymentMethods({
    required int id,
    required String editNoteName,
    required String editNoteType,
    required String editNote,
  }) async {
    return await apiClient.putData("${AppConstants.EDIT_NOTES_URI}$id", {
      'name': editNoteName,
      'type': editNoteType,
      'note': editNote,
    });
  }

  // Delete Payment Methods response
  Future<Response> deletePaymentMethods({required int id}) async {
    return await apiClient.deleteData(
      "${AppConstants.DELETE_PAYMENT_METHODS_URI}$id",
    );
  }

  // Add Payment method
  Future<Response> addPaymentMethod({
    required AddPaymentMethodBody addPaymentMethodBody,
  }) async {
    return await apiClient.postData(
      AppConstants.ADD_PAYMENT_METHODS_URI,
      addPaymentMethodBody.toJson(),
    );
  }

  // Get Payment Methods details response
  Future<Response> getPaymentMethodDetails({required int id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_PAYMENT_METHODS_DETAILS_URI}$id",
    );
  }

  // Update Payment method
  Future<Response> updatePaymentMethod({
    required AddPaymentMethodBody addPaymentMethodBody,
    required int id,
  }) async {
    return await apiClient.patchData(
      "${AppConstants.UPDATE_PAYMENT_METHODS_URI}$id",
      addPaymentMethodBody.toJson(),
    );
  }

  Future<Response> buyPlan({required Map<String, dynamic> map}) {
    return apiClient.postData("${AppConstants.BUY_PLAN_URI}", map);
  }

  Future<Response> renewPlan({
    required Map<String, dynamic> map,
    required int billingId,
  }) {
    return apiClient.postData("${AppConstants.RENEW_PLAN_URI}$billingId", map);
  }
}
