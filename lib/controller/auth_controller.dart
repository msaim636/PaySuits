// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:paysuite/controller/dashboard_controller.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/data/model/response/permission_model.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/app_constants.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../data/model/response/response_model.dart';
import '../data/repository/auth_repo.dart';
import 'expenses_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isGenerateOtpLoading = false;
  bool get isGenerateOtpLoading => _isGenerateOtpLoading;

  bool _isOtpVerificationLoading = false;
  bool get isOtpVerificationLoading => _isOtpVerificationLoading;

  bool _isResetPasswordLoading = false;
  bool get isResetPasswordLoading => _isResetPasswordLoading;

  bool _isActiveRememberMe = true;
  bool get isActiveRememberMe => _isActiveRememberMe;

  final bool _isSocialAuthActiveRememberMe = true;
  bool get isSocialAuthActiveRememberMe => _isSocialAuthActiveRememberMe;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  // login Method
  Future<ResponseModel> login({
    required String email,
    required String password,
    dynamic deviceToken,
  }) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    _isLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }

    Response response = await authRepo.login(
      email: email,
      password: password,
      deviceToken: deviceToken,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("device_token $deviceToken");
      print('object ${response.body}');
      print(
        'tenant slug=> ${response.body['result']['user']['tenant']['slug']}',
      );
      authRepo.saveTenantToken(
        response.body['result']['access_token'],
        response.body['result']['user']['tenant']['slug'],
      );
      authRepo.sharedPreferences.setString(
        AppConstants.SLUG,
        "${response.body['result']['user']['tenant']['slug']}",
      );
      Get.find<PermissionController>().getPermission();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Google Auth Variable
  bool _isGoogleAuthLoading = false;
  bool get isGoogleAuthLoading => _isGoogleAuthLoading;

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  // Google Auth Function
  Future googleLogin() async {
    try {
      // // Ensure the previous user is signed out first
      // await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      debugPrint("googleUser $googleUser");

      if (googleUser == null) return;

      _user = googleUser;
      var userName = _user!.displayName;

      List<String> nameParts = userName!.split(" ");
      String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
      String lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(" ")
          : "";

      print("firstName $firstName");
      print("lastName $lastName");

      if (_user != null) {
        customSocialAuth(
          providerId: _user!.id,
          firstName: firstName,
          lastName: lastName,
          email: _user!.email,
          authType: "google",
        ).then((status) async {
          if (status.isSuccess) {
            if (isSocialAuthActiveRememberMe) {
              saveKeepMeLoggedIn(
                isSocialAuthActiveRememberMe: isSocialAuthActiveRememberMe,
              );
            } else {
              clearUserNumberAndPassword();
              saveKeepMeLoggedIn(
                isSocialAuthActiveRememberMe: isSocialAuthActiveRememberMe,
              );
            }
            showCustomSnackBar(status.message, isError: false);
            Get.find<DashboardController>().getProfileDetails();

            Get.offNamed(RouteHelper.getNavbarRoute());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      } else {
        showCustomSnackBar("not_get_any_user_info_key".tr, isError: true);
        debugPrint(
          "Didn't get any user info after google sign in. visit google sign in service file",
        );
      }
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      showCustomSnackBar('something_wrong_key'.tr, isError: true);
    }
  }

  //Logout from google ====>

  //Logout from google
  Future<void> logOutFromGoogleLogin() async {
    try {
      Get.find<ExpensesController>().setDialogLoading(true);
      await googleSignIn.signOut();
    } catch (e) {
      print("Google logout error: $e");
    } finally {
      Get.find<ExpensesController>().setDialogLoading(false);
    }
  }

  // Apple Auth Variable
  // Apple Auth Variable
  bool _isAppleAuthLoading = false;
  bool get isAppleAuthLoading => _isAppleAuthLoading;

  // Apple Auth Function
  Future appleLogin() async {
    debugPrint("Trying to sign in using Apple ID");

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId:
            '1035488155178-6hppeh0v9ri648073vgvf8flr6iuph9r.apps.googleusercontent.com',
        redirectUri: Uri.parse("https://pub.dev/packages/sign_in_with_apple"),
      ),
    );

    debugPrint("Apple Credential: $credential");

    // Handle email & name storageEi week ta aktu kosto beshiu
    String? email = credential.email ?? await getStoredEmail();
    String? givenName = credential.givenName ?? await getStoredName();

    List<String> nameParts = givenName != null ? givenName.split(" ") : [];

    String firstName = nameParts.isNotEmpty ? nameParts[0] : "";
    String lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    debugPrint("Apple All data email: $email, name: $givenName");

    if (credential.userIdentifier != null) {
      debugPrint("Apple All data email: $email, name: $givenName");
      // Save email & name for future logins
      if (credential.email != null && credential.givenName != null) {
        await saveUserDetails(credential.email!, credential.givenName!);
      }

      customSocialAuth(
        providerId: credential.userIdentifier ?? '',
        firstName: firstName,
        lastName: lastName,
        email: email ?? '',
        authType: "apple",
        // ignore: unnecessary_null_comparison
        isSecondTime: givenName == null && email == null ? true : false,
      ).then((status) async {
        if (status.isSuccess) {
          if (isSocialAuthActiveRememberMe) {
            saveKeepMeLoggedIn(
              isSocialAuthActiveRememberMe: isSocialAuthActiveRememberMe,
            );
          } else {
            clearUserNumberAndPassword();
            saveKeepMeLoggedIn(
              isSocialAuthActiveRememberMe: isSocialAuthActiveRememberMe,
            );
          }
          showCustomSnackBar(status.message, isError: false);
          Get.find<DashboardController>().getProfileDetails();

          Get.offNamed(RouteHelper.getNavbarRoute());
        } else {
          showCustomSnackBar(status.message);
        }
      });
    } else {
      showCustomSnackBar("Something went wrong", isError: true);
      update();
      return false;
    }
  }

  // Save email & name locally
  Future<void> saveUserDetails(String email, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apple_email', email);
    await prefs.setString('apple_name', name);
  }

  // Retrieve email & name if Apple doesn't provide them
  Future<String?> getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('apple_email');
  }

  Future<String?> getStoredName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('apple_name');
  }
  // Custom Social Auth Function

  Future<ResponseModel> customSocialAuth({
    required String providerId,
    required String firstName,
    required String lastName,
    required String email,
    required String authType,
    bool? isSecondTime,
  }) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken');
    print("device_token $deviceToken");
    print("providerId $providerId");
    print("name $firstName");
    print("email $email");
    print("authType $authType");
    print("isSecondTime $isSecondTime");
    authType == "google"
        ? _isGoogleAuthLoading = true
        : _isAppleAuthLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }

    Response response = await authRepo.socialLogin(
      providerId: providerId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      deviceToken: deviceToken ?? "No Device Token",
      authType: authType,
      isSecondTime: isSecondTime ?? false,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("device_token $deviceToken");
      print('object ${response.body}');
      print(
        'tenant slug=> ${response.body['result']['user']['tenant']['slug']}',
      );
      storage.setBool(
        "isSafetyAndBackup",
        response.body['result']['user']['is_safety_and_backup'],
      );

      authRepo.saveTenantToken(
        response.body['result']['access_token'],
        response.body['result']['user']['tenant']['slug'],
      );
      authRepo.sharedPreferences.setString(
        AppConstants.SLUG,
        "${response.body['result']['user']['tenant']['slug']}",
      );
      Get.find<PermissionController>().myPermissionModel!.permission =
          PermissionModel.fromJson(response.body['result']['permissions']);
      Get.find<PermissionController>().setPermissionInfo();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    authType == "google"
        ? _isGoogleAuthLoading = false
        : _isAppleAuthLoading = false;
    update();
    return responseModel;
  }

  // Save email and Password in shared pref
  void saveUserNumberAndPassword({
    required String email,
    required String password,
  }) {
    authRepo.saveUserEmailAndPassword(email, password);
  }

  // Save keep me logged in value
  void saveKeepMeLoggedIn({bool? isSocialAuthActiveRememberMe}) {
    authRepo.saveKeepMeLoggedIn(
      isSocialAuthActiveRememberMe ?? isActiveRememberMe,
    );
  }

  // Clear  credentials from shared pref
  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  // Keep me logged in button toggle
  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  // Get user email from shared pref
  String getUserEmail() {
    return authRepo.getUserEmail();
  }

  // Get user Password from shared pref
  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  // Clear all Shared pref data
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  // Check user is logged in
  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  // Check user keep me logged in
  bool isKeepMeLoggedIn() {
    return authRepo.isKeepMeLoggedIn();
  }

  // Update verification code
  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  // generate OTP
  Future<ResponseModel> forgetPassword({required String email}) async {
    _isGenerateOtpLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }
    Response response = await authRepo.forgetPassword(email: email);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      showCustomSnackBar(response.body['message']);
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isGenerateOtpLoading = false;
    update();
    return responseModel;
  }

  // generate OTP

  Future<ResponseModel> generateOtp({required String email}) async {
    _isGenerateOtpLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }
    Response response = await authRepo.generateOtp(email: email);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isGenerateOtpLoading = false;
    update();
    return responseModel;
  }

  // OTP Verification
  Future<ResponseModel> otpVerification({required String email}) async {
    _isOtpVerificationLoading = true;
    update();
    Response response = await authRepo.optVerification(
      email: email,
      otp: _verificationCode,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isOtpVerificationLoading = false;
    update();
    return responseModel;
  }

  // Reset Password
  Future<ResponseModel> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isResetPasswordLoading = true;
    update();
    Response response = await authRepo.resetPassword(
      email: email,
      otp: _verificationCode,
      password: password,
      confirmPassword: confirmPassword,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isResetPasswordLoading = false;
    update();
    return responseModel;
  }

  // Register
  bool _isRegisterLoading = false;
  bool get isRegisterLoading => _isRegisterLoading;
  Future<ResponseModel> register({
    required String company_name,
    required String first_name,
    required String last_name,
    required String email,
  }) async {
    _isRegisterLoading = true;
    update();
    Response response = await authRepo.register(
      company_name: company_name,
      first_name: first_name,
      last_name: last_name,
      email: email,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isRegisterLoading = false;
    update();
    return responseModel;
  }
}
