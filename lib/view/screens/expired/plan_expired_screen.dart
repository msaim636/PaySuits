import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_button.dart';

class PlanExpiredScreen extends StatelessWidget {
  const PlanExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.RADIUS_EXTRA_LARGE + 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),

              const SizedBox(height: Dimensions.FREE_SIZE_EXTRA_LARGE),

              Text(
                'Your Plan is Expired',
                style: googleSansFlexRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

              const Text(
                'Please renew your subscription to continue using the app.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: Dimensions.FREE_SIZE_EXTRA_LARGE + 10),

              CustomButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getPlanScreen());
                },
                buttonText: 'View Plans',
              ),

              const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

              CustomButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getBillingScreen());
                },
                buttonText: 'Billing History',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
