import 'package:get/get.dart';
import '../data/model/response/company_details_model.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/settings_repo.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsRepo settingsRepo;

  SettingsController({required this.settingsRepo});

  // Loading state
  bool _isCompanyDetailsLoading = false;
  bool get isCompanyDetailsLoading => _isCompanyDetailsLoading;

  // Company details model
  CompanySettingsModel? _companyDetailsModel;
  CompanySettingsModel? get companyDetailsModel => _companyDetailsModel;

  // Fetch company details from API and load logo bytes
  Future<ResponseModel> getCompanySettings() async {
    _isCompanyDetailsLoading = true;
    update();

    final response = await settingsRepo.getCompanySettings();

    if (response.statusCode == 200) {
      _companyDetailsModel = CompanySettingsModel.fromJson(response.body);

      _isCompanyDetailsLoading = false;
      update();
      return ResponseModel(true, 'Settings loaded successfully');
    }

    _isCompanyDetailsLoading = false;
    update();
    return ResponseModel(false, response.body['message']);
  }
}
