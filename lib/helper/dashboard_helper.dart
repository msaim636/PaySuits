// Colors for pie chart

// ignore_for_file: dead_code, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';
import '../data/model/response/top_customer_chart_model.dart';
import '../theme/light_theme.dart';

List<Color> gradientColors = [
  LightAppColor.lightRed,
  LightAppColor.lightOrange,
];

double parseCurrency(String? value) {
  if (value == null) return 0.0;

  return double.tryParse(
        value.replaceAll('\$', '').replaceAll(',', '').trim(),
      ) ??
      0.0;
}

double get totalIncome {
  final data = Get.find<DashboardController>().chartData;

  final Map<String, double> unique = {};
  for (var point in data) {
    if (point.context == null) continue;
    unique[point.context] = point.income;
  }

  return unique.values.fold(0.0, (a, b) => a + b);
}

double get totalExpense {
  final data = Get.find<DashboardController>().chartData;

  final Map<String, double> unique = {};
  for (var point in data) {
    if (point.context == null) continue;
    unique[point.context] = point.expense;
  }

  return unique.values.fold(0.0, (a, b) => a + b);
}


int get totalSolvedTickets {
  int sum = 0;
  for (var t in Get.find<DashboardController>().chartSolvedData) {
    sum += t.amount;
  }
  return sum;
}

int get totalCreatedTickets {
  int sum = 0;
  for (var t in Get.find<DashboardController>().chartCreatedData) {
    sum += t.amount;
  }
  return sum;
}

final List<TopCustomerChartModel> chartTicketData = [
  TopCustomerChartModel(name: 'Fri', amount: 50, color: Colors.grey.shade300),
  TopCustomerChartModel(name: 'Sat', amount: 9, color: Colors.grey.shade300),
  TopCustomerChartModel(name: 'Sun', amount: 9, color: Colors.grey.shade300),
  TopCustomerChartModel(name: 'Mon', amount: 40, color: Colors.green),
  TopCustomerChartModel(name: 'Tue', amount: 1, color: Colors.green),
  TopCustomerChartModel(name: 'Wed', amount: 10, color: Colors.green),
  TopCustomerChartModel(name: 'Thu', amount: 0, color: Colors.grey.shade300),
];

final List<TopCustomerChartModel> chartDataCreated = [
  TopCustomerChartModel(name: 'Fri', amount: 50, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Sat', amount: 10, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Sun', amount: 9, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Mon', amount: 45, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Tue', amount: 3, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Wed', amount: 15, color: Colors.grey.shade200),
  TopCustomerChartModel(name: 'Thu', amount: 5, color: Colors.grey.shade200),
];

List<TopCustomerChartModel> getChartTopData() {
  // Get the top five customer model from the DashboardController
  final model = Get.find<DashboardController>().topFiveCustomerModel;

  // Return empty list if the model is null
  if (model == null) return [];

  // Return empty list if the result is null or empty
  if (model.result == null || model.result!.data.isEmpty) return [];

  // Take the first chart data
  final chart = model.result!;

  // Return empty list if labels or data are null

  // Return empty list if the number of labels and data do not match
  if (chart.labels.length != chart.data.length) return [];

  // Generate the list of TopCustomerChartModel with dynamic colors
  return List.generate(chart.labels.length, (index) {
    // Assign different colors for each bar
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
    ];
    return TopCustomerChartModel(
      name: chart.labels[index],
      amount: chart.data[index],
      color: colors[index % colors.length], // cycle through colors
    );
  });
}

String formatAmount(double value) {
  if (value >= 1e9) {
    return '\$ ${(value / 1e9).toStringAsFixed(1)}B';
  } else if (value >= 1e6) {
    return '\$ ${(value / 1e6).toStringAsFixed(1)}M';
  } else if (value >= 1e3) {
    return '\$ ${(value / 1e3).toStringAsFixed(1)}K';
  } else {
    return '\$ ${value.toStringAsFixed(0)}';
  }
}

int touchedIndex = -1;
