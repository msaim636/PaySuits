import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controller/dashboard_controller.dart';
import '../../../../data/model/response/top_ticket_chart_model.dart';
import '../../../../helper/dashboard_helper.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class TicketOverview extends StatelessWidget {
  const TicketOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'ticket_overview',
      builder: (dashboardController) {
        return dashboardController.isTicketOverviewLoading
            ? Container(
                height: 360,
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).disabledColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ticket_overview_key'.tr,
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
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
                                : Get.isDarkMode
                                ? LightAppColor.cardColor
                                : Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).cardColor,
                            borderColor: Theme.of(
                              context,
                            ).disabledColor.withValues(alpha: 0.2),

                            dwItems: dashboardController
                                .ticketOverviewFilterType
                                .map(
                                  (e) => {
                                    'id': e['value'],
                                    'value': e['title']!.tr,
                                  },
                                )
                                .toList(),
                            dwValue: dashboardController
                                .ticketOverviewFilterType
                                .firstWhere(
                                  (e) =>
                                      e['value'] ==
                                      dashboardController
                                          .selectedTicketOverviewFilterType,
                                )['title']!
                                .tr,

                            onChange: (value) {
                              dashboardController
                                  .setSelectedTicketOverviewFilterType(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

                    // CHART
                    SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          labelStyle: const TextStyle(fontSize: 11),
                          interval: 1,
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
                                date.day.toString(),
                                details.textStyle,
                              );
                            }

                            return ChartAxisLabel(text, details.textStyle);
                          },

                          labelIntersectAction: AxisLabelIntersectAction.hide,
                          labelRotation: -80,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          interval: 5,
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(width: 0),
                          majorGridLines: MajorGridLines(
                            width: 0.5,
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          iconHeight: 15,
                          iconWidth: 15,
                        ),
                        series: <CartesianSeries>[
                          // Solved tickets
                          StackedColumnSeries<TopTicketChartModel, String>(
                            name: '${"solved_key".tr} $totalSolvedTickets',
                            dataSource: dashboardController.chartSolvedData,
                            xValueMapper: (data, _) => data.context,
                            yValueMapper: (data, _) => data.amount,
                            color: Theme.of(Get.context!).primaryColor,
                          ),

                          // Remaining tickets (Created - Solved)
                          StackedColumnSeries<TopTicketChartModel, String>(
                            name: '${"created_key".tr} $totalCreatedTickets',
                            dataSource: dashboardController.chartCreatedData,
                            xValueMapper: (data, _) => data.context,
                            yValueMapper: (data, _) => data.amount,
                            color: Theme.of(
                              Get.context!,
                            ).primaryColor.withValues(alpha: 0.3),
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
