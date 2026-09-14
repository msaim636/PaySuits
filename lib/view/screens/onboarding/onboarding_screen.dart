import 'package:paysuite/controller/onboarding_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/images.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/screens/onboarding/widgets/body_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<Widget> _pages = [
    BodyWidget(
      title: 'welcome_paysuite_key',
      description: 'welcome_paysuite_description',
      image: Images.onboarding1,
    ),

    BodyWidget(
      title: 'invoice_management_key',
      description: 'track_and_manage_all_your_invoices_instantly_key',
      image: Images.onboarding2,
    ),
    BodyWidget(
      title: 'estimates_key',
      description: 'create_and_send_professional_Estimates_key',
      image: Images.onboarding3,
    ),
    BodyWidget(
      title: 'product_list_key',
      description: 'manage_your_product_details_efficiently_key',
      image: Images.onboarding4,
    ),
    BodyWidget(
      title: 'plan_management_key',
      description: 'plan_management_description',
      image: Images.onboarding5,
    ),
    BodyWidget(
      title: 'ticket_support_key',
      description: 'ticket_support_description',
      image: Images.onboarding6,
    ),
    BodyWidget(
      title: 'billing_title_key',
      description: 'billing_description',
      image: Images.onboarding7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        mainWidget: SafeArea(
          child: GetBuilder<OnboardingController>(
            builder: (onboardingController) {
              return Column(
                children: [
                  // Skip button (Top Right)
                  Align(
                    alignment: Alignment.topRight,
                    child: Obx(
                      () =>
                          onboardingController.currentIndex.value ==
                              _pages.length - 1
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () => onboardingController.skip(),
                              child: Text(
                                "skip_key".tr,
                                style: googleSansFlexMedium.copyWith(
                                  color: LightAppColor.cardColor.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ),
                  ),

                  // PageView
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      controller: onboardingController.pageController,
                      onPageChanged: onboardingController.setCurrentIndex,
                      itemCount: _pages.length,
                      itemBuilder: (_, index) => _pages[index],
                    ),
                  ),

                  // Indicator
                  _buildIndicator(context, onboardingController),

                  const SizedBox(height: 30),

                  // Next / Done Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                    ),
                    child: Obx(
                      () => CustomButton(
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        buttonText:
                            onboardingController.currentIndex.value ==
                                _pages.length - 1
                            ? "done_key".tr
                            : "next_key".tr,
                        onPressed: () async {
                          if (onboardingController.currentIndex.value ==
                              _pages.length - 1) {
                            await onboardingController
                                .markOnboardingAsComplete();
                            Get.offAllNamed(RouteHelper.getLoginRoute());
                          } else {
                            onboardingController.nextPage();
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    OnboardingController controller,
  ) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: controller.currentIndex.value == index ? 28 : 8,
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index
                  ? LightAppColor.cardColor
                  : LightAppColor.cardColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
