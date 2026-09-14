// ignore_for_file: prefer_if_null_operators, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/data/model/body/add_product_body.dart';
import 'package:paysuite/data/model/response/product_details_model.dart';
import 'package:paysuite/data/model/response/unit_model.dart';
import 'package:paysuite/data/repository/product_repo.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:get/get.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/product_model.dart';
import '../data/model/response/response_model.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'expenses_controller.dart';

class ProductController extends GetxController implements GetxService {
  ProductRepo productRepo;
  ProductController({required this.productRepo});

  bool _isPaginateLoading = false;
  bool get isPaginateLoading => _isPaginateLoading;

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  bool _isProductsLoading = false;
  bool get isProductsLoading => _isProductsLoading;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  String? _productsNextPageUrl;
  String? get productsNextPageUrl => _productsNextPageUrl;

  List<UnitModel> _unitList = [];
  List<UnitModel> get unitList => _unitList;

  List<Map<String, String>> _unitStringList = [];
  List<Map<String, String>> get unitStringList =>
      _unitStringList
          .map((e) => {'id': e['id']!, 'value': e['value']!.toLowerCase().tr})
          .toList();

  String? _unitsDWValue;
  String? get unitsDWValue => _unitsDWValue;

  String? _unitsFilterDWValue;
  String? get unitsFilterDWValue => _unitsFilterDWValue;

  String? _unitsDWBackUpValue;
  String? get unitsDWBackUpValue => _unitsDWBackUpValue;

  bool _unitLoading = false;
  bool get unitLoading => _unitLoading;

  bool _addProductLoading = false;
  bool get addProductLoading => _addProductLoading;

  bool _isProductUpdateLoading = false;
  bool get isProductUpdateLoading => _isProductUpdateLoading;

  static int _productSelectedId = -1;
  static int get productSelectedId => _productSelectedId;

  ProductDetailsModel? _productDetailsModel;
  ProductDetailsModel? get productDetailsModel => _productDetailsModel;

  bool _isProductDetailsLoading = false;
  bool get isProductDetailsLoading => _isProductDetailsLoading;

  int? _categoryListSelectedIndex;
  int? get categoryListSelectedIndex => _categoryListSelectedIndex;

  String? _categoriesDWValue;
  String? get categoriesDWValue => _categoriesDWValue;

  String? _categoriesDWBackUpValue;
  String? get categoriesDWBackUpValue => _categoriesDWBackUpValue;

  bool _isTransactionFilter = false;
  bool get isTransactionFilter => _isTransactionFilter;

  bool _suggestedAllItemListLoading = false;
  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  // Text Editing Controller
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();

  // Focus Node
  final productNameFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final codeFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  // Product More item list
  List<PopupModel> _productMoreList = [];
  List<PopupModel> get productMoreList => _productMoreList;
  createProductMoreList() {
    _productMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .updateProducts!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getAddProductRoute("1"),
          isRoute: true,
        ),
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteProducts!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteIcon,
            description: 'this_content_will_be_deleted_key',
            title: "you_want_to_delete_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<ProductController>().deleteProduct();
            },
          ),
        ),
    ];
  }

  // Get All Products
  Future<ResponseModel> getProducts({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _isPaginateLoading = true;
    } else {
      _productList = [];
      _productsNextPageUrl = null;
      _isProductsLoading = true;
      _isTransactionFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    _suggestedAllItemListLoading = true;
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _categoriesDWBackUpValue = _categoriesDWValue != null
          ? _categoriesDWValue
          : "";
      _unitsDWBackUpValue = _unitsFilterDWValue != null
          ? _unitsFilterDWValue
          : "";
    }
    final response = await productRepo.getProducts(
      url: _productsNextPageUrl,
      fromFilter: _isTransactionFilter,
      category: _categoriesDWBackUpValue ?? "",
      unit: _unitsDWBackUpValue ?? "",
    );
    if (response.statusCode == 200) {
      response.body['result']['data'].forEach((item) {
        _productList.add(ProductModel.fromJson(item));
      });
      _productsNextPageUrl = response.body['result']['links']['next'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(true, response.body['message']);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _isPaginateLoading = false;
    } else {
      _isProductsLoading = false;
    }

    _suggestedAllItemListLoading = false;
    update();
    return responseModel;
  }

  // Get units data
  Future<void> getUnits({bool isUpdate = false, int? unitId}) async {
    _unitLoading = true;
    _unitList = [];
    _unitStringList = [];
    _unitsDWValue = null;
    update();
    final response = await productRepo.getUnits();
    if (response.statusCode == 200) {
      response.body['result'].forEach((item) {
        _unitList.add(UnitModel.fromJson(item));
        //  _unitStringList.add(item['name']);
        _unitStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
      if (isUpdate && unitId != null) {
        _unitsDWValue = unitId.toString();
        //  unitIdToNameConvert(unitId);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _unitLoading = false;
    update();
  }

  // Set unit dw value
  setUnitDWValue(String? value) {
    _unitsDWValue = value;
    update();
  }

  // Set unit filter dw value
  setFilterUnitDWValue(String? value) {
    _unitsFilterDWValue = value;
    update();
  }

  // Add Product
  Future<ResponseModel> addProduct({
    required AddProductBody addProductBody,
  }) async {
    _addProductLoading = true;

    update();
    Response response = await productRepo.addProduct(
      addProductBody: addProductBody,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _addProductLoading = false;
    update();
    return responseModel;
  }

  Future<void> deleteProduct() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.deleteProduct(id: _productSelectedId);
    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getProducts();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Set product on tap id
  void setProductSelectedId({required int id}) {
    _productSelectedId = id;
    update();
  }

  // get Product Details
  Future<void> getProductDetails() async {
    _isProductDetailsLoading = true;
    _productDetailsModel = null;
    update();

    try {
      final response = await productRepo.getProductDetails(
        id: _productSelectedId,
      );
      if (response.statusCode == 200) {
        _productDetailsModel = ProductDetailsModel.fromJson(
          response.body["result"],
        );

        productNameController.text = _productDetailsModel!.name ?? "";
        priceController.text = _productDetailsModel!.price?.toString() ?? "";
        codeController.text = _productDetailsModel!.code?.toString() ?? "";
        descriptionController.text = _productDetailsModel!.description ?? "";
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("Error fetching product details: $e");
    }
    _isProductDetailsLoading = false;
    update();
  }

  // Update Product
  Future<ResponseModel> updateProduct({
    required AddProductBody addProductBody,
  }) async {
    _isProductUpdateLoading = true;
    update();
    Response response = await productRepo.updateProduct(
      addProductBody: addProductBody,
      productId: _productSelectedId,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getProducts();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isProductUpdateLoading = false;
    update();
    return responseModel;
  }

  //  Set category list selected index
  setCategoryListSelectedIndex(int index) {
    _categoryListSelectedIndex = index;
    update();
  }

  void refreshFilterForm() {
    _categoriesDWValue = null;
    _unitsFilterDWValue = null;
    _unitsDWValue = null;
    update();
  }

  bool isEmptyFilterForm() {
    if (_categoriesDWValue == null &&
        _unitsDWValue == null &&
        _unitsFilterDWValue == null) {
      return true;
    } else {
      return false;
    }
  }

  // Set category dw value
  setCategoriesDWValue(String? value) {
    _categoriesDWValue = value;
    update();
  }

  void setProductDetailsLoading(bool value) {
    _isProductDetailsLoading = value;
    update(); // UI refresh
  }

  // refresh Product Form
  void refreshProductForm() {
    productNameController.text = "";
    priceController.text = "";
    codeController.text = "";
    _unitsDWValue = null;
    descriptionController.text = "";
  }
}
