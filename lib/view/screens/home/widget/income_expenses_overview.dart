import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controller/dashboard_controller.dart';
import '../../../../data/model/response/income_expenses_point.dart';
import '../../../../helper/dashboard_helper.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class IncomeExpensesOverview extends StatelessWidget {
  const IncomeExpensesOverview({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'income_expense',
      builder: (dashboardController) {
        return dashboardController.isIncomeExpenseOverviewLoading
            ? Container(
                height: 440,
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
                child: Center(child: LoadingIndicator()),
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
                          "income_expense_overview_key".tr,
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Wrap the dropdown in IntrinsicWidth to auto-size based on content
                        IntrinsicWidth(
                          child: CustomDropDown(
                            height: 30,
                            buttonRadius: 5,
                            isLeftIcon: true,
                            hintText: 'filter_key'.tr,
                            svgIcon: Images.filter,
                            backgroundColor: Theme.of(context).cardColor,
                            dwItems: dashboardController
                                .incomeExpensesOverviewFilterType
                                .map(
                                  (e) => {
                                    'id': e['value'],
                                    'value': e['title']!.tr,
                                  },
                                )
                                .toList(),

                            dwValue: dashboardController
                                .incomeExpensesOverviewFilterType
                                .firstWhere(
                                  (e) =>
                                      e['value'] ==
                                      dashboardController
                                          .selectedIncomeExpensesOverviewFilterType,
                                )['title']!
                                .tr,

                            onChange: (id) {
                              dashboardController
                                  .setSelectedIncomeExpensesOverviewFilterType(
                                    id!,
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),
                    SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,

                        /// X AXIS (Category like ticket chart)
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          labelStyle: googleSansFlexRegular.copyWith(
                            fontSize: 11,
                          ),
                          interval: 1,
                          labelRotation: -80,
                          labelIntersectAction: AxisLabelIntersectAction.hide,
                          axisLabelFormatter: (AxisLabelRenderDetails details) {
                            final text = details.text;

                            // Year only (2025)
                            if (text.length == 4) {
                              return ChartAxisLabel(text, details.textStyle);
                            }

                            // Full date (2025-12-13)
                            if (text.contains('-')) {
                              final date = DateTime.parse(text);
                              return ChartAxisLabel(
                                date.day.toString(), // 13
                                details.textStyle,
                              );
                            }

                            return ChartAxisLabel(text, details.textStyle);
                          },
                        ),

                        /// Y AXIS
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          numberFormat: NumberFormat.compact(),
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(width: 0),
                          majorGridLines: MajorGridLines(
                            width: 0.5,
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),

                        /// TOOLTIP
                        tooltipBehavior: TooltipBehavior(enable: true),

                        /// LEGEND
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          iconHeight: 15,
                          iconWidth: 15,
                        ),

                        series: <CartesianSeries>[
                          /// INCOME (Area)
                          SplineAreaSeries<IncomeExpensePoint, String>(
                            name:
                                '${"income_key".tr} ${formatAmount(totalIncome)}',
                            dataSource: dashboardController.chartData,
                            xValueMapper: (d, _) => d.context,
                            yValueMapper: (d, _) => d.income,
                            color: LightAppColor.emeraldGreen.withValues(
                              alpha: 0.15,
                            ),
                            borderColor: LightAppColor.emeraldGreen,
                            borderWidth: 2,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              width: 6,
                              height: 6,
                            ),
                          ),

                          /// EXPENSE (Line)
                          SplineSeries<IncomeExpensePoint, String>(
                            name:
                                '${"expense_key".tr} ${formatAmount(totalExpense)}',
                            dataSource: dashboardController.chartData,
                            xValueMapper: (d, _) => d.context,
                            yValueMapper: (d, _) => d.expense,
                            color: LightAppColor.lightRed,
                            width: 2,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              width: 6,
                              height: 6,
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
