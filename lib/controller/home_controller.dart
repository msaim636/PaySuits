// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/permission_controller.dart';

import '../helper/route_helper.dart';
import '../util/images.dart';

class HomeController extends GetxController implements GetxService {
  // Constructor
  HomeController();

  // Common Variable
  bool isExpenseExpanded = false;
  dynamic menuItemListIndex = -1;

  void toggleExpenseExpand() {
    isExpenseExpanded = !isExpenseExpanded;

    if (isExpenseExpanded) {
      menuItemListIndex = -1; // clear normal selection
    }

    update();
  }

  // ====================================
  // Side Menu List Section
  // ====================================

  List<MenuItemModel> menuItems = [
    MenuItemModel(
      title: "customer_key",
      icon: Images.customer,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getCustomerListRoute());
      },
    ),
    MenuItemModel(
      title: "trans_key",
      icon: Images.transaction,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getTransactionScreenRoute());
      },
    ),
    MenuItemModel(
      title: "ticket_key",
      icon: Images.ticketIcon,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getTicketRoute());
      },
    ),
    MenuItemModel(
      title: "plan_key",
      icon: Images.planIcon,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getPlanScreen());
      },
    ),
    MenuItemModel(
      title: "billing_key",
      icon: Images.billingIcon,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getBillingScreen());
      },
    ),
    MenuItemModel(
      title: "profile_key",
      icon: Images.userProfile,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getProfileRoute());
      },
    ),
    MenuItemModel(
      title: "change_language_key",
      icon: Images.changeLanguageIcon,
      onTap: () {
        Get.back();
        Get.toNamed(RouteHelper.getLanguageRoute());
      },
    ),
  ];

  // Select menu item
  void selectMenuItem(int index) {
    menuItemListIndex = index;
    isExpenseExpanded = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }
}

class MenuItemModel {
  final String title;
  final String icon;
  final bool isExpandable;
  final VoidCallback onTap;

  MenuItemModel({
    required this.title,
    required this.icon,
    this.isExpandable = false,
    required this.onTap,
  });
}
