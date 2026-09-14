import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paysuite/controller/plan_controller.dart';
import 'package:paysuite/helper/date_converter.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/loading_indicator.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final PlanController planController = Get.find<PlanController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PlanController>().getMyPlan();
    });
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "my_plan_key".tr,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<PlanController>().getMyPlan();
        },
        child: GetBuilder<PlanController>(
          builder: (planController) {
            if (planController.isMyPlanLoading) {
              return const Center(child: LoadingIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  // ====================
                  // HERO SECTION - DAYS LEFT
                  // ====================
                  Container(
                    padding: const EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL,
                    ),
                    margin: const EdgeInsets.all(
                      Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.RADIUS_LARGE,
                      ),
                      color: Theme.of(context).primaryColor.withValues(
                        alpha: Get.isDarkMode ? 0.2 : 0.1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Days left visual
                        _DaysLeftVisual(
                          daysLeft: planController.daysLeft,
                          totalDays: planController.totalDays,
                          percentage: planController.percentage,
                        ),

                        const SizedBox(height: Dimensions.FREE_SIZE_SMALL),

                        // Quick stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatChip(
                              value: LocaleHelper.trNumber(
                                planController.totalDays,
                              ),
                              label: "total_days_key".tr,
                              icon: Icons.calendar_month_outlined,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.shade500,
                            ),
                            _StatChip(
                              value:
                                  "${LocaleHelper.trNumber(planController.daysLeft)} ${"days_key".tr}",
                              label: "remaining_key".tr,
                              icon: Icons.timer_outlined,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.shade500,
                            ),
                            _StatChip(
                              value:
                                  "${LocaleHelper.trNumber(planController.percentage.round())}%",
                              label: "active_key".tr,
                              icon: Icons.percent_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ====================
                  // PLAN DETAILS
                  // ====================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Current Plan Card
                        _GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "current_plan_key".tr,
                                    style: googleSansFlexBlack.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: planController.daysLeft == 0
                                          ? LightAppColor.lightRed.withValues(
                                              alpha: 0.1,
                                            )
                                          : planController.daysLeft > 7
                                          ? Get.isDarkMode
                                                ? LightAppColor.lightGreen
                                                      .withValues(alpha: 0.1)
                                                : Theme.of(context).primaryColor
                                                      .withValues(alpha: 0.1)
                                          : LightAppColor.lightOrange
                                                .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      planController.daysLeft == 0
                                          ? "expired_key".tr
                                          : planController.daysLeft > 7
                                          ? "active_key".tr
                                          : "expiring_soon_key".tr,
                                      style: googleSansFlexMedium.copyWith(
                                        fontSize: 11,
                                        color: planController.daysLeft == 0
                                            ? LightAppColor.lightRed
                                            : planController.daysLeft > 7
                                            ? Get.isDarkMode
                                                  ? LightAppColor.lightGreen
                                                  : Theme.of(
                                                      context,
                                                    ).primaryColor
                                            : LightAppColor.lightOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                planController.myPlan?.plan?.name
                                        ?.toLowerCase()
                                        .tr ??
                                    "",
                                style: googleSansFlexRegular.copyWith(),
                              ),
                              const SizedBox(height: 16),

                              // Date Range
                              Row(
                                children: [
                                  _DateChip(
                                    label: "start_key".tr,
                                    date: DateConverter.estimatedDate(
                                      planController.startDate,
                                    ),
                                    color: Get.isDarkMode
                                        ? LightAppColor.lightGreen
                                        : Theme.of(context).primaryColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  _DateChip(
                                    label: "end_key".tr,
                                    date: DateConverter.estimatedDate(
                                      planController.endDate,
                                    ),
                                    color: LightAppColor.lightRed,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ====================
                        // PURCHASE HISTORY
                        // ====================
                        _GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "purchase_history_key".tr,
                                style: googleSansFlexBlack.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Payment Details
                              _DetailRow(
                                title: "payment_method_key".tr,
                                value:
                                    planController
                                        .myPlan
                                        ?.billingHistory
                                        ?.paymentMethod
                                        ?.toLowerCase()
                                        .tr ??
                                    "no_method_key".tr,
                                icon: Icons.credit_card_outlined,
                              ),
                              const SizedBox(height: 12),
                              _DetailRow(
                                title: "paid_amount_key".tr,
                                value:
                                    planController
                                        .myPlan
                                        ?.billingHistory
                                        ?.formattedAmount ??
                                    "--".tr,
                                icon: Icons.payments_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ====================
                        // USAGE BREAKDOWN
                        // ====================
                        _GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "usage_breakdown_key".tr,
                                style: googleSansFlexBlack.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Visual breakdown
                              Row(
                                children: [
                                  Expanded(
                                    flex: planController.daysUsed,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: planController.daysLeft,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _UsageItem(
                                    label: "days_used_key".tr,
                                    value: LocaleHelper.trNumber(
                                      planController.daysUsed,
                                    ),
                                    color: Colors.grey.shade600,
                                    percentage:
                                        "${planController.totalDays > 0 ? (planController.daysUsed / planController.totalDays * 100).round() : 0}%",
                                  ),
                                  _UsageItem(
                                    label: "days_left_key".tr,
                                    value: LocaleHelper.trNumber(
                                      planController.daysLeft,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    percentage:
                                        "${planController.percentage.round()}%",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ====================
                        // ACTION BUTTONS
                        // ====================
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(RouteHelper.chooseSubscriptionPlan);
                          },
                          buttonText: "upgrade_plan_key".tr,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ====================
// CUSTOM WIDGETS (Keep the same)
// ====================

class _DaysLeftVisual extends StatelessWidget {
  final int daysLeft;
  final int totalDays;
  final double percentage;

  const _DaysLeftVisual({
    required this.daysLeft,
    required this.totalDays,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 12,
              ),
            ),
          ),

          // Progress ring
          SizedBox(
            width: 155,
            height: 155,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),

          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleHelper.trNumber(daysLeft),
                style: googleSansFlexBlack.copyWith(
                  color: Get.isDarkMode
                      ? LightAppColor.cardColor
                      : LightAppColor.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              Text(
                "days_left_key".tr,
                style: googleSansFlexMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: Colors.grey.shade600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? LightAppColor.lightGreen.withValues(alpha: 0.1)
                      : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    Dimensions.RADIUS_EXTRA_LARGE,
                  ),
                ),
                child: Text(
                  "${LocaleHelper.trNumber(percentage.round())}% ${"remaining_key".tr}",
                  style: googleSansFlexMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL - 2,
                    color: Get.isDarkMode
                        ? LightAppColor.lightGreen
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL - 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: LightAppColor.cardColor),
        ),
        const SizedBox(height: Dimensions.FREE_SIZE_SMALL),
        Text(
          value,
          style: googleSansFlexMedium.copyWith(
            color: Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.black87,
          ),
        ),
        Text(
          label,
          style: googleSansFlexRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String date;
  final Color color;

  const _DateChip({
    required this.label,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: Get.isDarkMode ? 0.2 : 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: googleSansFlexRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: googleSansFlexMedium.copyWith(
                color: Get.isDarkMode ? Colors.white60 : Colors.black87,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: googleSansFlexRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: Get.isDarkMode ? Colors.white60 : Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: googleSansFlexMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_DEFAULT,
            color: Get.isDarkMode ? Colors.white60 : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _UsageItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String percentage;

  const _UsageItem({
    required this.label,
    required this.value,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: googleSansFlexRegular.copyWith(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: googleSansFlexBlack.copyWith(fontSize: 20)),
        Text(
          percentage,
          style: googleSansFlexMedium.copyWith(
            fontSize: 12,
            color: Get.isDarkMode ? LightAppColor.lightGreen : color,
          ),
        ),
      ],
    );
  }
}

class LocaleHelper {
  /// Convert a number to a localized string based on the current locale
  static String trNumber(num number) {
    if (Get.locale?.languageCode == 'ar') {
      return number.toString().split('').map(_toArabicDigit).join();
    }
    return number.toString();
  }

  /// Convert a DateTime to a localized string
  /// Example: 'dd-MM-yyyy' or any custom format
  static String trDate(DateTime date, {String format = 'dd-MM-yyyy'}) {
    final formatted = DateFormat(format).format(date);

    if (Get.locale?.languageCode == 'ar') {
      return formatted.split('').map(_toArabicDigit).join();
    }
    return formatted;
  }

  /// Private helper to convert a single digit to Arabic
  static String _toArabicDigit(String char) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final int? digit = int.tryParse(char);
    if (digit != null && digit >= 0 && digit <= 9) {
      return arabicDigits[digit];
    }
    return char; // keep non-digit characters like / or -
  }

  /// Convert numbers inside a full string (like "Total: 123 items")
  static String trStringNumbers(String text) {
    if (Get.locale?.languageCode == 'ar') {
      return text.split('').map(_toArabicDigit).join();
    }
    return text;
  }
}
