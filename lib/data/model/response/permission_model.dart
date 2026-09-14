class MyPermissionModel {
  CompanyModel? company;
  PermissionModel? permission;

  MyPermissionModel({this.company, this.permission});

  MyPermissionModel.fromJson(Map<String, dynamic> json) {
    company = json['company'] != null
        ? CompanyModel.fromJson(json['company'])
        : null;

    final permissionsJson = json['permissions'];

    if (permissionsJson is Map<String, dynamic>) {
      permission = PermissionModel.fromJson(permissionsJson);
    } else {
      permission = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.toJson();
    }

    if (permission != null) {
      data['permissions'] = permission!.toJson();
    }
    return data;
  }
}

class CompanyModel {
  int? id;
  String? status;

  CompanyModel({this.id, this.status});
  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}

class PermissionModel {
  bool? manageGlobalAccess;
  bool? manageDashboard;
  bool? dashboardViewStatistics;
  bool? dashboardIncomeExpenseOverview;
  bool? dashboardPaymentOverview;
  bool? dashboardInvoiceOverview;
  bool? dashboardTopCustomerTransactions;
  bool? dashboardTicketsOverview;
  bool? viewCustomers;
  bool? createCustomers;
  bool? updateCustomers;
  bool? deleteCustomers;
  bool? updateCustomerStatus;
  bool? detailsViewCustomer;
  bool? viewInvoices;
  bool? createInvoices;
  bool? updateInvoices;
  bool? deleteInvoices;
  bool? duePaymentInvoice;
  bool? sendAttachmentInvoice;
  bool? cloneInvoice;
  bool? downloadInvoice;
  bool? viewEstimates;
  bool? createEstimates;
  bool? updateEstimates;
  bool? deleteEstimates;
  bool? resendMailEstimate;
  bool? downloadEstimate;
  bool? statusChangeEstimate;
  bool? invoiceConvertEstimate;
  bool? viewTransactions;
  bool? viewCategories;
  bool? createCategories;
  bool? updateCategories;
  bool? deleteCategories;
  bool? viewUnits;
  bool? createUnits;
  bool? updateUnits;
  bool? deleteUnits;
  bool? viewProducts;
  bool? createProducts;
  bool? updateProducts;
  bool? deleteProducts;
  bool? manageImportProduct;
  bool? viewExpenseCategories;
  bool? createExpenseCategories;
  bool? updateExpenseCategories;
  bool? deleteExpenseCategories;
  bool? viewExpenses;
  bool? createExpenses;
  bool? updateExpenses;
  bool? deleteExpenses;
  bool? manageImportExpense;
  bool? paymentReportView;
  bool? paymentYearlySummaryReport;
  bool? paymentCustomerSummaryReport;
  bool? incomeReportView;
  bool? incomeYearlyChartReport;
  bool? expenseReportView;
  bool? expenseYearlyChartReport;
  bool? expenseCategoryChartReport;
  bool? chartIncomeExpenseReport;
  bool? summaryIncomeExpenseReport;
  bool? viewTaxes;
  bool? createTaxes;
  bool? updateTaxes;
  bool? deleteTaxes;
  bool? viewNotes;
  bool? createNotes;
  bool? updateNotes;
  bool? deleteNotes;
  bool? viewPaymentMethods;
  bool? createPaymentMethods;
  bool? updatePaymentMethods;
  bool? deletePaymentMethods;
  bool? customizationsView;
  bool? invoiceSettingUpdate;
  bool? estimateSettingUpdate;
  bool? paymentSettingUpdate;
  bool? viewUsers;
  bool? createUsers;
  bool? updateUsers;
  bool? deleteUsers;
  bool? viewRoles;
  bool? createRoles;
  bool? updateRoles;
  bool? deleteRoles;
  bool? roleAttachUser;
  bool? roleDetachUser;
  bool? customerExport;
  bool? productExport;
  bool? expenseExport;
  bool? paymentExport;
  bool? viewTickets;
  bool? createTickets;
  bool? updateTickets;
  bool? deleteTickets;
  bool? viewTicketDetails;
  bool? createTicketComment;
  bool? createTicketRating;
  bool? changeTicketStatus;
  bool? viewSetting;
  bool? viewGeneralSetting;
  bool? updateSetting;
  bool? viewEmailSetting;
  bool? updateEmailSetting;

  PermissionModel({
    this.manageGlobalAccess,
    this.manageDashboard,
    this.dashboardViewStatistics,
    this.dashboardIncomeExpenseOverview,
    this.dashboardPaymentOverview,
    this.dashboardInvoiceOverview,
    this.dashboardTopCustomerTransactions,
    this.dashboardTicketsOverview,
    this.viewCustomers,
    this.createCustomers,
    this.updateCustomers,
    this.deleteCustomers,
    this.updateCustomerStatus,
    this.detailsViewCustomer,
    this.viewInvoices,
    this.createInvoices,
    this.updateInvoices,
    this.deleteInvoices,
    this.duePaymentInvoice,
    this.sendAttachmentInvoice,
    this.cloneInvoice,
    this.downloadInvoice,
    this.viewEstimates,
    this.createEstimates,
    this.updateEstimates,
    this.deleteEstimates,
    this.resendMailEstimate,
    this.downloadEstimate,
    this.statusChangeEstimate,
    this.invoiceConvertEstimate,
    this.viewTransactions,
    this.viewCategories,
    this.createCategories,
    this.updateCategories,
    this.deleteCategories,
    this.viewUnits,
    this.createUnits,
    this.updateUnits,
    this.deleteUnits,
    this.viewProducts,
    this.createProducts,
    this.updateProducts,
    this.deleteProducts,
    this.manageImportProduct,
    this.viewExpenseCategories,
    this.createExpenseCategories,
    this.updateExpenseCategories,
    this.deleteExpenseCategories,
    this.viewExpenses,
    this.createExpenses,
    this.updateExpenses,
    this.deleteExpenses,
    this.manageImportExpense,
    this.paymentReportView,
    this.paymentYearlySummaryReport,
    this.paymentCustomerSummaryReport,
    this.incomeReportView,
    this.incomeYearlyChartReport,
    this.expenseReportView,
    this.expenseYearlyChartReport,
    this.expenseCategoryChartReport,
    this.chartIncomeExpenseReport,
    this.summaryIncomeExpenseReport,
    this.viewTaxes,
    this.createTaxes,
    this.updateTaxes,
    this.deleteTaxes,
    this.viewNotes,
    this.createNotes,
    this.updateNotes,
    this.deleteNotes,
    this.viewPaymentMethods,
    this.createPaymentMethods,
    this.updatePaymentMethods,
    this.deletePaymentMethods,
    this.customizationsView,
    this.invoiceSettingUpdate,
    this.estimateSettingUpdate,
    this.paymentSettingUpdate,
    this.viewUsers,
    this.createUsers,
    this.updateUsers,
    this.deleteUsers,
    this.viewRoles,
    this.createRoles,
    this.updateRoles,
    this.deleteRoles,
    this.roleAttachUser,
    this.roleDetachUser,
    this.customerExport,
    this.productExport,
    this.expenseExport,
    this.paymentExport,
    this.viewTickets,
    this.createTickets,
    this.updateTickets,
    this.deleteTickets,
    this.viewTicketDetails,
    this.createTicketComment,
    this.createTicketRating,
    this.changeTicketStatus,
    this.viewSetting,
    this.viewGeneralSetting,
    this.updateSetting,
    this.viewEmailSetting,
    this.updateEmailSetting,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      manageGlobalAccess: json['manage_global_access'] ?? false,
      manageDashboard: json['manage_dashboard'] ?? false,
      dashboardViewStatistics: json['dashboard_view_statistics'] ?? false,
      dashboardIncomeExpenseOverview:
          json['dashboard_income_expense_overview'] ?? false,
      dashboardPaymentOverview: json['dashboard_payment_overview'] ?? false,
      dashboardInvoiceOverview: json['dashboard_invoice_overview'] ?? false,
      dashboardTopCustomerTransactions:
          json['dashboard_top_customer_transactions'] ?? false,
      dashboardTicketsOverview: json['dashboard_tickets_overview'] ?? false,
      viewCustomers: json['view_customers'] ?? false,
      createCustomers: json['create_customers'] ?? false,
      updateCustomers: json['update_customers'] ?? false,
      deleteCustomers: json['delete_customers'] ?? false,
      updateCustomerStatus: json['update_customer_status'] ?? false,
      detailsViewCustomer: json['details_view_customer'] ?? false,
      viewInvoices: json['view_invoices'] ?? false,
      createInvoices: json['create_invoices'] ?? false,
      updateInvoices: json['update_invoices'] ?? false,
      deleteInvoices: json['delete_invoices'] ?? false,
      duePaymentInvoice: json['due_payment_invoice'] ?? false,
      sendAttachmentInvoice: json['send_attachment_invoice'] ?? false,
      cloneInvoice: json['clone_invoice'] ?? false,
      downloadInvoice: json['download_invoice'] ?? false,
      viewEstimates: json['view_estimates'] ?? false,
      createEstimates: json['create_estimates'] ?? false,
      updateEstimates: json['update_estimates'] ?? false,
      deleteEstimates: json['delete_estimates'] ?? false,
      resendMailEstimate: json['resend_mail_estimate'] ?? false,
      downloadEstimate: json['download_estimate'] ?? false,
      statusChangeEstimate: json['status_change_estimate'] ?? false,
      invoiceConvertEstimate: json['invoice_convert_estimate'] ?? false,
      viewTransactions: json['view_transactions'] ?? false,
      viewCategories: json['view_categories'] ?? false,
      createCategories: json['create_categories'] ?? false,
      updateCategories: json['update_categories'] ?? false,
      deleteCategories: json['delete_categories'] ?? false,
      viewUnits: json['view_units'] ?? false,
      createUnits: json['create_units'] ?? false,
      updateUnits: json['update_units'] ?? false,
      deleteUnits: json['delete_units'] ?? false,
      viewProducts: json['view_products'] ?? false,
      createProducts: json['create_products'] ?? false,
      updateProducts: json['update_products'] ?? false,
      deleteProducts: json['delete_products'] ?? false,
      manageImportProduct: json['manage_import_product'] ?? false,
      viewExpenseCategories: json['view_expense_categories'] ?? false,
      createExpenseCategories: json['create_expense_categories'] ?? false,
      updateExpenseCategories: json['update_expense_categories'] ?? false,
      deleteExpenseCategories: json['delete_expense_categories'] ?? false,
      viewExpenses: json['view_expenses'] ?? false,
      createExpenses: json['create_expenses'] ?? false,
      updateExpenses: json['update_expenses'] ?? false,
      deleteExpenses: json['delete_expenses'] ?? false,
      manageImportExpense: json['manage_import_expense'] ?? false,
      paymentReportView: json['payment_report_view'] ?? false,
      paymentYearlySummaryReport:
          json['payment_yearly_summary_report'] ?? false,
      paymentCustomerSummaryReport:
          json['payment_customer_summary_report'] ?? false,
      incomeReportView: json['income_report_view'] ?? false,
      incomeYearlyChartReport: json['income_yearly_chart_report'] ?? false,
      expenseReportView: json['expense_report_view'] ?? false,
      expenseYearlyChartReport: json['expense_yearly_chart_report'] ?? false,
      expenseCategoryChartReport:
          json['expense_category_chart_report'] ?? false,
      chartIncomeExpenseReport: json['chart_income_expense_report'] ?? false,
      summaryIncomeExpenseReport:
          json['summary_income_expense_report'] ?? false,
      viewTaxes: json['view_taxes'] ?? false,
      createTaxes: json['create_taxes'] ?? false,
      updateTaxes: json['update_taxes'] ?? false,
      deleteTaxes: json['delete_taxes'] ?? false,
      viewNotes: json['view_notes'] ?? false,
      createNotes: json['create_notes'] ?? false,
      updateNotes: json['update_notes'] ?? false,
      deleteNotes: json['delete_notes'] ?? false,
      viewPaymentMethods: json['view_payment_methods'] ?? false,
      createPaymentMethods: json['create_payment_methods'] ?? false,
      updatePaymentMethods: json['update_payment_methods'] ?? false,
      deletePaymentMethods: json['delete_payment_methods'] ?? false,
      customizationsView: json['customizations_view'] ?? false,
      invoiceSettingUpdate: json['invoice_setting_update'] ?? false,
      estimateSettingUpdate: json['estimate_setting_update'] ?? false,
      paymentSettingUpdate: json['payment_setting_update'] ?? false,
      viewUsers: json['view_users'] ?? false,
      createUsers: json['create_users'] ?? false,
      updateUsers: json['update_users'] ?? false,
      deleteUsers: json['delete_users'] ?? false,
      viewRoles: json['view_roles'] ?? false,
      createRoles: json['create_roles'] ?? false,
      updateRoles: json['update_roles'] ?? false,
      deleteRoles: json['delete_roles'] ?? false,
      roleAttachUser: json['role_attach_user'] ?? false,
      roleDetachUser: json['role_detach_user'] ?? false,
      customerExport: json['customer_export'] ?? false,
      productExport: json['product_export'] ?? false,
      expenseExport: json['expense_export'] ?? false,
      paymentExport: json['payment_export'] ?? false,
      viewTickets: json['view_tickets'] ?? false,
      createTickets: json['create_tickets'] ?? false,
      updateTickets: json['update_tickets'] ?? false,
      deleteTickets: json['delete_tickets'] ?? false,
      viewTicketDetails: json['view_ticket_details'] ?? false,
      createTicketComment: json['create_ticket_comment'] ?? false,
      createTicketRating: json['create_ticket_rating'] ?? false,
      changeTicketStatus: json['change_ticket_status'] ?? false,
      viewSetting: json['view_setting'] ?? false,
      viewGeneralSetting: json['view_general_setting'] ?? false,
      updateSetting: json['update_setting'] ?? false,
      viewEmailSetting: json['view_email_setting'] ?? false,
      updateEmailSetting: json['update_email_setting'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manage_global_access': manageGlobalAccess,
      'manage_dashboard': manageDashboard,
      'dashboard_view_statistics': dashboardViewStatistics,
      'dashboard_income_expense_overview': dashboardIncomeExpenseOverview,
      'dashboard_payment_overview': dashboardPaymentOverview,
      'dashboard_invoice_overview': dashboardInvoiceOverview,
      'dashboard_top_customer_transactions': dashboardTopCustomerTransactions,
      'dashboard_tickets_overview': dashboardTicketsOverview,
      'view_customers': viewCustomers,
      'create_customers': createCustomers,
      'update_customers': updateCustomers,
      'delete_customers': deleteCustomers,
      'update_customer_status': updateCustomerStatus,
      'details_view_customer': detailsViewCustomer,
      'view_invoices': viewInvoices,
      'create_invoices': createInvoices,
      'update_invoices': updateInvoices,
      'delete_invoices': deleteInvoices,
      'due_payment_invoice': duePaymentInvoice,
      'send_attachment_invoice': sendAttachmentInvoice,
      'clone_invoice': cloneInvoice,
      'download_invoice': downloadInvoice,
      'view_estimates': viewEstimates,
      'create_estimates': createEstimates,
      'update_estimates': updateEstimates,
      'delete_estimates': deleteEstimates,
      'resend_mail_estimate': resendMailEstimate,
      'download_estimate': downloadEstimate,
      'status_change_estimate': statusChangeEstimate,
      'invoice_convert_estimate': invoiceConvertEstimate,
      'view_transactions': viewTransactions,
      'view_categories': viewCategories,
      'create_categories': createCategories,
      'update_categories': updateCategories,
      'delete_categories': deleteCategories,
      'view_units': viewUnits,
      'create_units': createUnits,
      'update_units': updateUnits,
      'delete_units': deleteUnits,
      'view_products': viewProducts,
      'create_products': createProducts,
      'update_products': updateProducts,
      'delete_products': deleteProducts,
      'manage_import_product': manageImportProduct,
      'view_expense_categories': viewExpenseCategories,
      'create_expense_categories': createExpenseCategories,
      'update_expense_categories': updateExpenseCategories,
      'delete_expense_categories': deleteExpenseCategories,
      'view_expenses': viewExpenses,
      'create_expenses': createExpenses,
      'update_expenses': updateExpenses,
      'delete_expenses': deleteExpenses,
      'manage_import_expense': manageImportExpense,
      'payment_report_view': paymentReportView,
      'payment_yearly_summary_report': paymentYearlySummaryReport,
      'payment_customer_summary_report': paymentCustomerSummaryReport,
      'income_report_view': incomeReportView,
      'income_yearly_chart_report': incomeYearlyChartReport,
      'expense_report_view': expenseReportView,
      'expense_yearly_chart_report': expenseYearlyChartReport,
      'expense_category_chart_report': expenseCategoryChartReport,
      'chart_income_expense_report': chartIncomeExpenseReport,
      'summary_income_expense_report': summaryIncomeExpenseReport,
      'view_taxes': viewTaxes,
      'create_taxes': createTaxes,
      'update_taxes': updateTaxes,
      'delete_taxes': deleteTaxes,
      'view_notes': viewNotes,
      'create_notes': createNotes,
      'update_notes': updateNotes,
      'delete_notes': deleteNotes,
      'view_payment_methods': viewPaymentMethods,
      'create_payment_methods': createPaymentMethods,
      'update_payment_methods': updatePaymentMethods,
      'delete_payment_methods': deletePaymentMethods,
      'customizations_view': customizationsView,
      'invoice_setting_update': invoiceSettingUpdate,
      'estimate_setting_update': estimateSettingUpdate,
      'payment_setting_update': paymentSettingUpdate,
      'view_users': viewUsers,
      'create_users': createUsers,
      'update_users': updateUsers,
      'delete_users': deleteUsers,
      'view_roles': viewRoles,
      'create_roles': createRoles,
      'update_roles': updateRoles,
      'delete_roles': deleteRoles,
      'role_attach_user': roleAttachUser,
      'role_detach_user': roleDetachUser,
      'customer_export': customerExport,
      'product_export': productExport,
      'expense_export': expenseExport,
      'payment_export': paymentExport,
      'view_tickets': viewTickets,
      'create_tickets': createTickets,
      'update_tickets': updateTickets,
      'delete_tickets': deleteTickets,
      'view_ticket_details': viewTicketDetails,
      'create_ticket_comment': createTicketComment,
      'create_ticket_rating': createTicketRating,
      'change_ticket_status': changeTicketStatus,
      'view_setting': viewSetting,
      'view_general_setting': viewGeneralSetting,
      'update_setting': updateSetting,
      'view_email_setting': viewEmailSetting,
      'update_email_setting': updateEmailSetting,
    };
  }
}
