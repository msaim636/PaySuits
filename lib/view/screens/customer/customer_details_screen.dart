// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/view/screens/customer/widget/customer_estimate_item.dart';
import 'package:paysuite/view/screens/customer/widget/customer_transaction_item.dart';

import '../../../controller/customer_controller.dart';
import '../../../controller/transaction_controller.dart';
import '../../../data/model/response/customer_details_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_image.dart';
import '../../base/loading_indicator.dart';
import 'widget/customer_invoice_item.dart';
import 'widget/customer_payment_summary.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CustomerController>().getCustomerInvoiceDetails();
      Get.find<CustomerController>().getCustomerEstimateDetails();
      Get.find<CustomerController>().getCustomerTransactionDetails();
      Get.find<CustomerController>().getCustomerDetails();
    });
    return GetBuilder<CustomerController>(
      builder: (customerController) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: CustomAppBar(
              title: "customer_details_key".tr,
              isBackButtonExist: true,
            ),
            body:
                customerController.isCustomerDetailsLoading ||
                    customerController.isCustomerInvoiceLoading ||
                    customerController.isCustomerEstimateLoading ||
                    customerController.isCustomerTransactionLoading ||
                    customerController.customerDetailsModel == null
                ? const Center(child: LoadingIndicator())
                : SafeArea(
                    child: NestedScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: 350,
                            pinned: true,
                            floating: true,
                            backgroundColor: Theme.of(context).cardColor,
                            flexibleSpace: FlexibleSpaceBar(
                              background: _buildProfileArea(
                                context,
                                customerController.customerDetailsModel!,
                                customerController,
                              ),
                            ),
                            bottom: TabBar(
                              tabs: [
                                Tab(text: 'Estimates'),
                                Tab(text: 'Invoice'),
                                Tab(text: 'Transaction'),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: [
                          //Estimates List View
                          customerController.isCustomerInvoiceLoading
                              ? const Center(child: LoadingIndicator())
                              : EstimateListView(
                                  customerController: customerController,
                                ),
                          //Invoice List View
                          customerController.isCustomerInvoiceLoading
                              ? const Center(child: LoadingIndicator())
                              : InvoiceListView(
                                  customerController: customerController,
                                ),
                          // Transaction List View
                          customerController.isCustomerInvoiceLoading
                              ? const Center(child: LoadingIndicator())
                              : TransactionListView(
                                  customerController: customerController,
                                ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildProfileArea(
    BuildContext context,
    CustomerDetailsModel customerDetailsModel,
    CustomerController customerController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Customer profile info section
              Container(
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                  vertical: Dimensions.PADDING_SIZE_SMALL - 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).cardColor,
                      Theme.of(context).cardColor.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Customer Image section
                    customerController
                                .customerDetailsModel!
                                .customer!
                                .profilePicture !=
                            null
                        ? ClipOval(
                            child: CustomImage(
                              image: customerController
                                  .customerDetailsModel!
                                  .customer!
                                  .profilePicture!,
                              height: 70,
                              width: 70,
                            ),
                          )
                        : Container(
                            height: 70,
                            width: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              Get.find<TransactionController>()
                                  .getFirstTwoCapitalLetters(
                                    customerController
                                        .customerDetailsModel!
                                        .customer!
                                        .fullName
                                        .toString(),
                                  ),
                              style: googleSansFlexBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_OVER_LARGE - 4,
                                color: Theme.of(context).indicatorColor,
                              ),
                            ),
                          ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL - 2),
                    Text(
                      customerController
                              .customerDetailsModel!
                              .customer!
                              .fullName ??
                          "name_not_added_key".tr,
                      style: googleSansFlexMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),
                    Text(
                      customerController
                              .customerDetailsModel!
                              .customer!
                              .email ??
                          "",
                      style: googleSansFlexRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Customer Payment summary section
              Positioned(
                bottom: -130,
                child: CustomerPaymentSummary(
                  customerDetailsModel:
                      customerController.customerDetailsModel!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// InvoiceListView Widget
class InvoiceListView extends StatefulWidget {
  const InvoiceListView({super.key, required this.customerController});

  final CustomerController customerController;

  @override
  State<InvoiceListView> createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<InvoiceListView> {
  @override
  Widget build(BuildContext context) {
    final list = widget.customerController.customerInvoiceList;

    if (list!.data!.isEmpty) {
      return Center(
        child: Text(
          "No Invoice Found",
          style: googleSansFlexMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Check if we've scrolled to the bottom and not already loading
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !widget.customerController.isInvoicePaginateLoading &&
            widget.customerController.customerInvoiceNextPageUrl != null) {
          // Trigger pagination
          widget.customerController.getCustomerInvoiceDetails(isPaginate: true);
          return true;
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        itemCount:
            list.data!.length +
            (widget.customerController.isInvoicePaginateLoading ? 1 : 0),
        separatorBuilder: (context, _) =>
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        itemBuilder: (context, index) {
          if (index >= list.data!.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Center(child: LoadingIndicator()),
            );
          }
          return CustomerInvoiceItem(
            customerInvoiceDetailsModel: list.data![index],
          );
        },
      ),
    );
  }
}

// TransactionListView Widget
class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key, required this.customerController});

  final CustomerController customerController;

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  @override
  Widget build(BuildContext context) {
    final list = widget.customerController.customerTransactionList;

    if (list!.data!.isEmpty) {
      return Center(
        child: Text(
          "No Transaction Found",
          style: googleSansFlexMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Check if we've scrolled to the bottom and not already loading
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !widget.customerController.isInvoicePaginateLoading &&
            widget.customerController.isInvoicePaginateLoading != null) {
          // Trigger pagination
          widget.customerController.getCustomerInvoiceDetails(isPaginate: true);
          return true;
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        itemCount:
            list.data!.length +
            (widget.customerController.isInvoicePaginateLoading ? 1 : 0),
        separatorBuilder: (context, _) =>
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        itemBuilder: (context, index) {
          if (index >= list.data!.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Center(child: LoadingIndicator()),
            );
          }
          return CustomerTransactionItem(data: list.data![index]);
        },
      ),
    );
  }
}

// EstimateListView Widget
class EstimateListView extends StatefulWidget {
  const EstimateListView({super.key, required this.customerController});

  final CustomerController customerController;

  @override
  State<EstimateListView> createState() => _EstimateListViewState();
}

class _EstimateListViewState extends State<EstimateListView> {
  @override
  Widget build(BuildContext context) {
    final list = widget.customerController.customerEstimateList;

    if (list!.data!.isEmpty) {
      return Center(
        child: Text(
          "No Estimate Found",
          style: googleSansFlexMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // Check if we've scrolled to the bottom and not already loading
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !widget.customerController.isInvoicePaginateLoading &&
            widget.customerController.customerInvoiceNextPageUrl != null) {
          widget.customerController.getCustomerInvoiceDetails(isPaginate: true);
          return true;
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        itemCount:
            list.data!.length +
            (widget.customerController.isInvoicePaginateLoading ? 1 : 0),
        separatorBuilder: (context, _) =>
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        itemBuilder: (context, index) {
          if (index >= list.data!.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Center(child: LoadingIndicator()),
            );
          }
          return CustomerEstimateItem(
            estimateModel: list.data![index],
            index: index,
          );
        },
      ),
    );
  }
}
