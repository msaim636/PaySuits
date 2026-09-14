import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/dashboard_controller.dart';
import '../../helper/route_helper.dart';
import '../../view/base/custom_snackbar.dart';
import '../../view/screens/home/home_screen.dart';

class ApiChecker {
  static void checkApi(Response response) {
    // api response handler code
    if (response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } else if (response.statusCode == 403) {
      showCustomSnackBar(response.body['message'], isError: true);
      Get.find<DashboardController>().setBottomNavBarIndex(0);
      Get.find<DashboardController>().setBodyItem(const HomeScreen());
      Get.offAllNamed(RouteHelper.getNavbarRoute());
    } else if (response.statusCode == 500) {
      showCustomSnackBar(response.statusText!);
    } else {
      showCustomSnackBar(response.body['message'], isError: true);
    }
  }
}
