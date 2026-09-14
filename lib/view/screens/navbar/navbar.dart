// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/screens/estimate/estimate_screen.dart';
import 'package:paysuite/view/screens/home/home_screen.dart';
import 'package:paysuite/view/screens/invoice/invoice_screen.dart';
import 'package:paysuite/view/screens/drawer/drawer_screen.dart';
import 'package:paysuite/view/screens/product/product_screen.dart';

import '../../../util/images.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  bool drawerOpened = false;

  final List<Widget> _pages = const [
    HomeScreen(),
    EstimateScreen(isBackButtonExist: false),
    InvoiceScreen(isBackButtonExist: false),
    ProductScreen(isBackButtonExist: false),
  ];

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      lowerBound: 0.0,
      upperBound: 0.10,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapNav(int index) {
    if (drawerOpened) return;
    _animController.forward().then((_) => _animController.reverse());
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _drawerKey,
      drawerEnableOpenDragGesture: false,
      extendBody: true,

      drawer: const MoreScreenDrawer(),
      onDrawerChanged: (opened) {
        setState(() {
          drawerOpened = opened;
        });
      },
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_currentIndex]),
          Positioned(bottom: 150, child: Container(height: 1500)),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            height: 50,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 10,
            child: _buildFloatingNavbar(drawerOpened: drawerOpened),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavbar({required bool drawerOpened}) {
    return SizedBox(
      height: 75,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Get.isDarkMode
                  ? Colors.grey.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.12),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Images.home, "home_key".tr, 0),
            _buildNavItem(Images.estimatesIcon, "estimates_key".tr, 1),
            _buildNavItem(Images.invoice, "invoices_key".tr, 2),
            _buildNavItem(Images.productIcon, "products_key".tr, 3),
            _buildDrawerButton(drawerOpened: drawerOpened),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final bool active = _currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onTapNav(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: active ? 24 : 20,
              color: active
                  ? Get.isDarkMode
                        ? LightAppColor.cardColor
                        : Theme.of(context).primaryColor
                  : Get.isDarkMode
                  ? LightAppColor.cardColor.withValues(alpha: 0.5)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            Text(
              label,
              style: googleSansFlexMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_SMALL,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active
                    ? Get.isDarkMode
                          ? LightAppColor.cardColor
                          : Theme.of(context).primaryColor
                    : Get.isDarkMode
                    ? LightAppColor.cardColor.withValues(alpha: 0.5)
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton({required bool drawerOpened}) {
    final bool active = drawerOpened;

    return GestureDetector(
      onTap: () => _drawerKey.currentState?.openDrawer(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Images.more,
              width: active ? 24 : 20,

              color: active
                  ? Get.isDarkMode
                        ? LightAppColor.cardColor
                        : Theme.of(context).primaryColor
                  : Get.isDarkMode
                  ? LightAppColor.cardColor.withValues(alpha: 0.5)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            Text(
              "more_key".tr,
              style: googleSansFlexMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_SMALL,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active
                    ? Get.isDarkMode
                          ? LightAppColor.cardColor
                          : Theme.of(context).primaryColor
                    : Get.isDarkMode
                    ? LightAppColor.cardColor.withValues(alpha: 0.5)
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
