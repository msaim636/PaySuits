import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../data/model/response/language_model.dart';
import '../util/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  LocalizationController(
      {required this.sharedPreferences, required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!,
      AppConstants.languages[0].countryCode);
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  List<LanguageModel> get languages => _languages;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// Load the current language or detect device language if first install
  Future<void> loadCurrentLanguage() async {
    String? savedLanguageCode =
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    String? savedCountryCode =
        sharedPreferences.getString(AppConstants.COUNTRY_CODE);

    if (savedLanguageCode == null || savedCountryCode == null) {
      // If no language is saved, detect the device language
      Locale deviceLocale = Get.deviceLocale ?? Locale('en', 'US');
      _locale = deviceLocale;
      await saveLanguage(_locale);
    } else {
      _locale = Locale(savedLanguageCode, savedCountryCode);
    }

    // Find the selected index in the language list
    _selectedIndex = AppConstants.languages
        .indexWhere((lang) => lang.languageCode == _locale.languageCode);
    _selectedIndex = _selectedIndex == -1
        ? 0
        : _selectedIndex; // Default to first language if not found

    _languages = List.from(AppConstants.languages);
    update();
  }

  /// Set new language when user selects one
  void setLanguage(Locale locale, int index) {
    Get.updateLocale(locale);
    _locale = locale;
    _selectedIndex = index;
    saveLanguage(_locale);
    update();
  }

  /// Save the selected language to local storage
  Future<void> saveLanguage(Locale locale) async {
    await sharedPreferences.setString(
        AppConstants.LANGUAGE_CODE, locale.languageCode);
    await sharedPreferences.setString(
        AppConstants.COUNTRY_CODE, locale.countryCode!);
  }

  /// Set selected language index (for UI updates)
  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }
}
