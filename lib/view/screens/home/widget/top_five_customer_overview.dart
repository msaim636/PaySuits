import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../controller/dashboard_controller.dart';
import '../../../../data/model/response/top_customer_chart_model.dart';
import '../../../../helper/dashboard_helper.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/loading_indicator.dart';

class TopFIveCustomerOverview extends StatelessWidget {
  const TopFIveCustomerOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'five_customer',
      builder: (dashboardController) {
        return dashboardController.isTopFiveCustomerLoading
            ? Container(
                height: 380,
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
                          'top_five_customer_transactions_key'.tr,
                          style: googleSansFlexRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(width: 10),
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

                            dwItems: dashboardController
                                .topFiveCustomerOverviewFilterType
                                .map(
                                  (e) => {
                                    'id': e['value'],
                                    'value': e['title']!.tr,
                                  },
                                )
                                .toList(),
                            dwValue: dashboardController
                                .topFiveCustomerOverviewFilterType
                                .firstWhere(
                                  (e) =>
                                      e['value'] ==
                                      dashboardController
                                          .selectedTopFiveCustomerOverviewFilterType,
                                )['title']!
                                .tr,
                            onChange: (value) {
                              dashboardController
                                  .setSelectedTopFiveCustomerOverviewFilterType(
                                    value!,
                                  );
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
                          labelIntersectAction:
                              AxisLabelIntersectAction.rotate45,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          interval: 1000,
                          numberFormat: NumberFormat.compact(),
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(width: 0),
                          majorGridLines: MajorGridLines(
                            width: 0.5,
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<TopCustomerChartModel, String>(
                            dataSource: getChartTopData(),
                            xValueMapper: (data, _) => data.name,
                            yValueMapper: (data, _) => data.amount,
                            pointColorMapper: (data, _) => data.color,
                            borderRadius: BorderRadius.circular(8),
                            width: 0.4,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: false,
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
