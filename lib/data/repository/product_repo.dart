import 'package:paysuite/data/model/body/add_product_body.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class ProductRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  ProductRepo({required this.apiClient, required this.sharedPreferences});

  // Get Products data
  Future<Response> getProducts({
    String? url,
    required bool fromFilter,
    String? category,
    String? unit,
  }) async {
    return await apiClient.getData(
      fromFilter
          ? url != null
                ? "$url&category=$category&unit=$unit"
                : "${AppConstants.GET_PRODUCTS_URI}?category=$category&unit=$unit"
          : url ?? AppConstants.GET_PRODUCTS_URI,
      isPaginate: url != null ? true : false,
    );
  }

  // Get Units response
  Future<Response> getUnits() async {
    return await apiClient.getData(AppConstants.GET_UNITS_URI);
  }

  // Add Product
  Future<Response> addProduct({required AddProductBody addProductBody}) async {
    return await apiClient.postData(
      AppConstants.ADD_PRODUCT_URI,
      addProductBody.toJson(),
    );
  }

  // Delete Product
  Future<Response> deleteProduct({required int id}) async {
    return await apiClient.deleteData("${AppConstants.DELETE_PRODUCT_URI}$id");
  }

  // Get Product Details data
  Future<Response> getProductDetails({required int id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_PRODUCT_DETAILS_URI}$id",
    );
  }

  // Update Product
  Future<Response> updateProduct({
    required AddProductBody addProductBody,
    required int productId,
  }) async {
    return await apiClient.patchData(
      "${AppConstants.UPDATE_PRODUCT_URI}$productId",
      addProductBody.toJson(),
    );
  }
}
