import 'dart:ui';

class TicketChartModel {
  final String context;
  final int ticket;

  TicketChartModel({required this.context, required this.ticket});

  factory TicketChartModel.fromJson(Map<String, dynamic> json) {
    return TicketChartModel(
      context: json['context'] ?? '',
      ticket: (json['ticket'] as num?)?.toInt() ?? 0,
    );
  }
}

class TopTicketChartModel {
  final String context;
  final int amount;
  final Color color;

  TopTicketChartModel({
    required this.context,
    required this.amount,
    required this.color,
  });
}
