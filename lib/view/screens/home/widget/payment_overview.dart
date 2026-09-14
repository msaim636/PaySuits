import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controller/dashboard_controller.dart';
import '../../../../helper/dashboard_helper.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class PaymentOverview extends StatelessWidget {
  const PaymentOverview({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'income_payment',
      builder: (dashboardController) {
        return dashboardController.isPaymentOverviewLoading ||
                dashboardController.paymentOverviewList == null
            ? Container(
                height: 420,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).disabledColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: const Center(child: LoadingIndicator()),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).disabledColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Payment Overview Header and amount section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "payment_overview_key".tr,
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IntrinsicWidth(
                          child: CustomDropDown(
                            height: 30,
                            buttonRadius: 5,
                            isLeftIcon: true,
                            hintText: 'filter_key'.tr,

                            svgIcon: Images.filter,
                            iconColor: Get.isDarkMode
                                ? LightAppColor.cardColor
                                : Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).cardColor,
                            borderColor: Theme.of(
                              context,
                            ).disabledColor.withValues(alpha: 0.2),
                            multiSelect: false,
                            dwItems: dashboardController
                                .paymentOverviewFilterType
                                .map(
                                  (e) => {
                                    'id': e['value'],
                                    'value': e['title']!.tr,
                                  },
                                )
                                .toList(),
                            dwValue: dashboardController
                                .paymentOverviewFilterType
                                .firstWhere(
                                  (e) =>
                                      e['value'] ==
                                      dashboardController
                                          .selectedPaymentOverviewFilterType,
                                )['title']!
                                .tr,

                            onChange: (value) {
                              dashboardController
                                  .setSelectedPaymentOverviewFilterType(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
                    // Payment Overview chart section
                    SizedBox(
                      height: 340,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x : point.y',
                          builder:
                              (
                                dynamic data,
                                dynamic point,
                                dynamic series,
                                int pointIndex,
                                int seriesIndex,
                              ) {
                                double value = point.y;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${point.x} : ${formatAmount(value)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                        ),
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'total_key'.tr.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        letterSpacing: 1.2,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formatAmount(
                                    parseCurrency(
                                          dashboardController
                                              .paymentOverviewList!
                                              .receivedAmount
                                              .toString(),
                                        ) +
                                        parseCurrency(
                                          dashboardController
                                              .paymentOverviewList!
                                              .dueAmount
                                              .toString(),
                                        ),
                                  ),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          iconHeight: 12,
                          iconWidth: 12,
                          itemPadding: 8,
                          textStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        series: <DoughnutSeries<_PaymentData, String>>[
                          DoughnutSeries<_PaymentData, String>(
                            dataSource: [
                              _PaymentData(
                                'Paid'.tr,
                                parseCurrency(
                                  dashboardController
                                      .paymentOverviewList
                                      ?.receivedAmount
                                      .toString(),
                                ),
                                Theme.of(context).primaryColor,
                              ),
                              _PaymentData(
                                'Due'.tr,
                                parseCurrency(
                                  dashboardController
                                      .paymentOverviewList
                                      ?.dueAmount
                                      .toString(),
                                ),
                                LightAppColor.lightOrange,
                              ),
                            ],
                            xValueMapper: (data, _) => data.label,
                            yValueMapper: (data, _) => data.amount,

                            dataLabelMapper: (data, _) =>
                                data.amount.toString(),
                            pointColorMapper: (data, _) => data.color,
                            radius: '85%',
                            innerRadius: '55%',
                            animationDuration: 900,
                            dataLabelSettings: DataLabelSettings(
                              textStyle: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).cardColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class _PaymentData {
  final String label;
  final double amount;
  final Color color;

  _PaymentData(this.label, this.amount, this.color);
}
