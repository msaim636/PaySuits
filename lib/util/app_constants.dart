// ignore_for_file: constant_identifier_names

import '../data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {
  // Flutter SDk Version 3.38.3
  static const String APP_NAME = 'PaySuite';
  static const String APP_VERSION = "1.0.0";

  // Shared Key
  static const String THEME = 'theme';

  // BASE URL LINK
  static const String BASE_URL = 'https://paysuite.theme29.com/api';
  static const String VERSION = '/v1/mobile';
  static const String ADMIN = '/admin';
  static const String DOMAIN_URL = 'https://paysuite.theme29.com';

  // API END POINT
  // Auth
  static const String LOGIN_URI = '/auth/login';
  static const String SOCIAL_LOGIN_URI = '/auth/social';
  static const String GENERATE_OTP_URI = '/auth/forgot-password';
  static const String OTP_VERIFICATION_URI = '/auth/verify-otp';
  static const String CHANGE_PASSWORD_URI = '/auth/confirm-password';
  static const String GET_PERMISSION_URI = '$VERSION/my-permissions';
  static const String REGISTER_URI = '/auth/register';
  static const String CHANGE_PASSWORD = '$VERSION/change-password';

  // Dashboard
  static const String GET_DASHBOARD_INFO_URI = '$VERSION/statistics';
  static const String GET_PAYMENT_OVERVIEW_URI = '$VERSION/payment-overview';
  static const String GET_TOP_FIVE_CUSTOMER_URI =
      '$VERSION/top-customer-transactions/';
  static const String GET_INCOME_EXPENSES_OVERVIEW_URI =
      '$VERSION/income-expense-overview/';
  static const String GET_INCOME_OVERVIEW_URI = '$VERSION/payment-overview/';
  static const String GET_TICKET_OVERVIEW_URI = '$VERSION/ticket-overview/';

  // Transaction
  static const String GET_TRANSACTION_URI = '$VERSION/transactions';

  // Notes
  static const String GET_NOTES_URI = '/notes';
  static const String ADD_NOTES_URI = '/notes';
  static const String EDIT_NOTES_URI = '/notes/';
  static const String DELETE_NOTES_URI = '/notes/';

  // Tax
  static const String GET_TAX_URI = '/taxes';
  static const String ADD_TAX_URI = '/taxes';
  static const String EDIT_TAX_URI = '/taxes/';
  static const String DELETE_TAX_URI = '/taxes/';

  // Payment
  static const String GET_PAYMENT_METHODS_URI =
      '/admin/landlord/support/payment-methods';
  static const String ADD_PAYMENT_METHODS_URI = '/payment-methods';
  static const String EDIT_PAYMENT_METHODS_URI = '/payment-methods/';
  static const String DELETE_PAYMENT_METHODS_URI = '/payment-methods/';
  static const String GET_PAYMENT_METHODS_DETAILS_URI = '/payment-methods/';
  static const String UPDATE_PAYMENT_METHODS_URI = '/payment-methods/';

  // Customer
  static const String GET_CUSTOMER_URI = '$VERSION/customers';
  static const String ADD_CUSTOMER_URI = '$VERSION/customers';
  static const String GET_CUSTOMER_DETAILS_URI = '$VERSION/customer-details/';
  static const String GET_CUSTOMER_INVOICE_DETAILS_URI =
      '$VERSION/customer/invoice-details/';
  static const String GET_CUSTOMER_ESTIMATE_DETAILS_URI =
      '$VERSION/customer/estimate-details/';
  static const String GET_CUSTOMER_TRANSACTION_DETAILS_URI =
      '$VERSION/customer/transaction-details/';
  static const String DELETE_CUSTOMER_URI = '$VERSION/customers/';
  static const String CUSTOMER_RESEND_PORTAL_ACCESS_URI =
      '$VERSION/customer-resend-portal-access/';
  static const String CUSTOMER_UPDATE_STATUS_URI =
      '/tenant/customer/change-status/';
  static const String GET_CUSTOMER_UPDATE_DETAILS_URI = '$VERSION/customers/';
  static const String CUSTOMER_UPDATE_URI = '$VERSION/customers/';

  // Expenses
  static const String GET_EXPENSES_URI = '$VERSION/expenses';
  static const String ADD_EXPENSES_URI = '$VERSION/expenses';
  static const String DELETE_EXPENSES_URI = '$VERSION/expenses/';
  static const String GET_EXPENSES_CATEGORY_URI = '$VERSION/categories';
  static const String ADD_EXPENSES_CATEGORY_URI = '$VERSION/categories';
  static const String EDIT_EXPENSES_CATEGORY_URI = '$VERSION/categories/';
  static const String DELETE_EXPENSES_CATEGORY_URI = '$VERSION/categories/';
  static const String GET_EXPENSES_DETAILS_URI = '$VERSION/expenses/';
  static const String UPDATE_EXPENSES_URI = '$VERSION/expenses/';

  // Ticket
  static const String GET_TICKET_URI = '$VERSION/tickets';
  static const String GET_TICKET_DETAILS_URI = '$VERSION/ticket-details';
  static const String ADD_TICKET_COMMENTS_URI = '$VERSION/ticket-comment';
  static const String RATING_TICKET_URI = '$VERSION/ticket-rating/';
  static const String TICKET_STATUS_UPDATE_URI =
      '/tenant/tickets/change-status/';

  // Plan
  static const String GET_MY_PLAN_URI = '$VERSION/my-plan';

  // Billing
  static const String GET_BILLING_URI = '$VERSION/billings';

  // Select
  static const String GET_CATEGORIES_URI = '$VERSION/selected/categories';
  static const String GET_UNITS_URI = '$VERSION/selected/units';
  static const String GET_PAYMENT_METHODS_DROPDOWN_URI =
      '$VERSION/selected/payment-methods';
  static const String GET_NOTE_TYPE_URI = '$VERSION/selected/note-types';
  // static const String GET_PAYMENT_METHODS_DROPDOWN_LIST_URI = '/selected/payment-method-lists';
  static const String GET_PAYMENT_METHODS_DROPDOWN_LIST_URI =
      '$VERSION/selected/payment-methods';
  static const String GET_PAYMENT_GATEWAY_DROPDOWN_LIST_URI =
      '$VERSION/selected/customer-payment-method';
  static const String GET_DEPARTMENT_URI = '$VERSION/selected/departments';
  static const String GET_PRIORITY_URI = '$VERSION/selected/priorities';
  static const String GET_SUBSCRIPTION_MY_PLAN_URI =
      '$VERSION/selected/my-plans';

  // Estimate
  static const String GET_ESTIMATE_URI = '$VERSION/estimates';
  static const String CREATE_ESTIMATE_URI = '$VERSION/estimates';
  static const String GET_ESTIMATE_DETAILS_URI = '$VERSION/estimates/';
  static const String UPDATE_ESTIMATE_URI = '$VERSION/estimates/';
  static const String ESTIMATE_SEND_ATTACHMENT_URI =
      '$VERSION/estimate-resend-mail/';
  static const String ESTIMATE_STATUS_UPDATE_URI =
      '$VERSION/estimate-status-change/';
  static const String ESTIMATE_INVOICE_CONVERT_URI =
      '$VERSION/estimate-invoice-convert/';
  static const String DELETE_ESTIMATE_URI = '$VERSION/estimates/';
  static const String DOWNLOAD_ESTIMATE_URI = '$VERSION/estimate-download/';
  static const String VIEW_ESTIMATE_URI = '$VERSION/estimate-download/';

  // Invoice
  static const String GET_INVOICE_URI = '$VERSION/invoices';
  static const String GET_SUGGEST_CUSTOMER_URI = '$VERSION/selected/customers';
  static const String GET_SUGGEST_DISCOUNT_TYPE_URI =
      '$VERSION/selected/discount-types';
  static const String GET_SUGGEST_PRODUCT_URI = '$VERSION/selected/products';
  static const String GET_SUGGEST_TAXES_URI = '$VERSION/selected/taxes';
  static const String GET_SUGGEST_NOTES_URI = '$VERSION/selected/notes';
  static const String CREATE_INVOICE_URI = '$VERSION/invoices';
  static const String GET_INVOICE_DETAILS_URI = '$VERSION/invoices/';
  static const String UPDATE_INVOICE_URI = '$VERSION/invoices/';
  static const String RESEND_INVOICE_URI = '$VERSION/invoice-send-attachment/';
  static const String CLONE_INVOICE_URI = '$VERSION/invoice-clone/';
  static const String DELETE_INVOICE_URI = '$VERSION/invoices/';
  static const String DOWNLOAD_INVOICE_URI = '$VERSION/invoice-download/';
  static const String VIEW_INVOICE_URI = '$VERSION/invoice-download/';
  static const String DUE_PAYMENT_URI = '$VERSION/invoice-due-payment/';
  static const String CUSTOMER_INVOICE_DUE_PAYMENT_URI =
      '$VERSION/invoice-customer-due-payment/';

  // Product
  static const String GET_PRODUCTS_URI = '$VERSION/products';
  static const String ADD_PRODUCT_URI = '$VERSION/products';
  static const String DELETE_PRODUCT_URI = '$VERSION/products/';
  static const String GET_PRODUCT_DETAILS_URI = '$VERSION/products/';
  static const String UPDATE_PRODUCT_URI = '$VERSION/products/';

  // Profile
  static const String GET_PROFILE_URI = '$VERSION/my-profile';
  static const String DELETE_PROFILE_URI = '/tenant/account-delete-request';
  static const String UPDATE_PROFILE_URI = '$VERSION/my-profile';

  // Notification
  static const String GET_NOTIFICATION_READ_STATUS = '/app/read-notifications/';
  static const String GET_NOTIFICATION = '/app/mobile/notifications';
  static const String READ_ALL_NOTIFICATION = '$VERSION/read-all-notifications';

  // Report
  static const String GET_INCOME_REPORT_URI = '$VERSION/income-report';
  static const String GET_EXPENSES_REPORT_URI = '$VERSION/expense-report';

  //administrator
  static const String GET_USER_URI = '$VERSION/users';
  static const String ROLE_URI = '$VERSION/selected/roles';
  static const String USER_INVITE_CREATE_URI = '$VERSION/user-invite';
  static const String GET_ROLE_URI = '$VERSION/roles';
  static const String GET_ROLE_PERMISSION_URI = '$VERSION/permissions';

  // company settings
  static const String COMPANY_DETAILS_URI = '/tenant/settings';
  static const String UPDATE_COMPANY_SETTINGS = '/tenant/settings';

  // All settings  urls
  static const String SETTINGS_DETAILS_URI = '$VERSION/customizations';
  static const String UPDATE_INVOICE_SETTINGS_URI = '$VERSION/invoice-setting';
  static const String UPDATE_ESTIMATE_SETTINGS_URI =
      '$VERSION/estimate-setting';
  static const String UPDATE_PAYMENT_SETTINGS_URI = '$VERSION/payment-setting';

  // Buy Plan
  static const String BUY_PLAN_URI = '/tenant/plan-buy';
  static const String RENEW_PLAN_URI = '/tenant/pay-now/';

  // Email Setting
  static const String EMAIL_SETTINGS_URI = '$VERSION/email-settings';
  static const String UPDATE_EMAIL_SETTINGS = '$VERSION/email-settings';

  // Email Template
  static const String EMAIL_TEMPLATE_DW_URI =
      '$VERSION/selected/email-template-type';
  static const String EMAIL_TEMPLATE_DETAILS_URI =
      '$VERSION/selected/email-templates/';
  static const String UPDATE_EMAIL_TEMPLATE = '$VERSION/email-templates/';

  // Tutorial
  static const String TUTORIAL_URI = '$VERSION/tutorials';

  // Shared Key
  static const String USER_PASSWORD = 'user_password';
  static const String USER_EMAIL = 'user_email';
  static const String USER_ADDRESS = 'user_address';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String TOKEN = 'access_token';
  static const String SLUG = 'tenant_slug';
  static const String IS_LANGUAGE_SELECTED = 'is_language_selected';
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';
  static const String KEEP_ME_LOGGED_IN = 'keep_me_logged_in';
  static const String PERMISSION = 'permission_status';
  static const String APP_LOGO = 'app_logo';

  /// Notification FirebaseOptions Key
  static const String apiKey = 'AIzaSyBXxbZyFot2gmexyqKMVF2XDhitQ5vUTmE';
  static const String appId = '1:1035488155178:android:5f5e099ed24c7f1fd6d553';
  static const String iosBundleId = 'app.invoicemaker.io';
  static const String messagingSenderId = '1035488155178';
  static const String projectId = 'invoice-maker-b5674';
  static const String storageBucket = 'invoice-maker-b5674.firebasestorage.app';

  // All Language model list section
  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: Images.englishIcon,
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),

    LanguageModel(
      imageUrl: Images.arabicIcon,
      languageName: 'Arabic',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}
