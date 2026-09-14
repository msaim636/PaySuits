import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class ExpensesRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  ExpensesRepo({required this.apiClient, required this.sharedPreferences});

  // Get expenses response
  Future<Response> getExpenses(
      {String? url,
      required bool fromFilter,
      String? categoryId,
      String? startDate,
      String? endDate}) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&date[]=$startDate&date[]=$endDate"
                : "${AppConstants.GET_EXPENSES_URI}?date[]=$startDate&date[]=$endDate"
            : url ?? AppConstants.GET_EXPENSES_URI,
        isPaginate: url != null ? true : false);
  }

  // Get categories response
  Future<Response> getCategories(bool fromProduct) async {
    return await apiClient.getData(
        "${AppConstants.GET_CATEGORIES_URI}?type=${fromProduct ? "category" : "expense"}");
  }

  // Add expenses response
  Future<Response> addExpenses(
      {required dynamic map, required List<MultipartBody> files}) async {
    return await apiClient.postMultipartData(
      AppConstants.ADD_EXPENSES_URI,
      map,
      files,
    );
  }

  // Delete expenses response
  Future<Response> deleteExpenses({required int id}) async {
    return await apiClient.deleteData(
      "${AppConstants.DELETE_EXPENSES_URI}$id",
    );
  }

  // Get expenses category response
  Future<Response> getExpensesCategory({String? url, String? searchKey}) async {
    return await apiClient.getData(
        url != null
            ? "$url&per_page=20&search=${searchKey ?? ''}"
            : "${AppConstants.GET_EXPENSES_CATEGORY_URI}?page=1&per_page=20&search=${searchKey ?? ''}",
        isPaginate: url != null ? true : false);
  }

  // Add expenses category response
  Future<Response> addExpensesCategory({required String catName}) async {
    return await apiClient
        .postData(AppConstants.ADD_EXPENSES_CATEGORY_URI, {'name': catName});
  }

  // Edit expenses category response
  Future<Response> editExpensesCategory(
      {required int id, required String name}) async {
    return await apiClient.putData(
      "${AppConstants.EDIT_EXPENSES_CATEGORY_URI}$id",
      {'name': name},
    );
  }

  // Delete expenses category response
  Future<Response> deleteExpensesCategory({required int id}) async {
    return await apiClient
        .deleteData("${AppConstants.DELETE_EXPENSES_CATEGORY_URI}$id");
  }

  // Get expenses details response
  Future<Response> getExpensesDetails({required int id}) async {
    return await apiClient
        .getData("${AppConstants.GET_EXPENSES_DETAILS_URI}$id");
  }

  // Update expenses response
  Future<Response> updateExpenses(
      {required int id,
      required Map<String, String> map,
      required List<MultipartBody> files}) async {
    return await apiClient.postMultipartData(
        "${AppConstants.UPDATE_EXPENSES_URI}$id?_method=PATCH", map, files);
  }
}
