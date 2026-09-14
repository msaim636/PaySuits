// Top Customer Response Model
class TopCustomerResponse {
  final String message;
  final TopCustomerResult? result;

  TopCustomerResponse({required this.message, this.result});

  factory TopCustomerResponse.fromJson(Map<String, dynamic> json) {
    return TopCustomerResponse(
      message: json['message'] ?? '',
      result: json['result'] != null
          ? TopCustomerResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'result': result?.toJson()};
  }
}

// Top Customer Result Model

class TopCustomerResult {
  final List<String> labels;
  final List<double> data;

  TopCustomerResult({required this.labels, required this.data});

  factory TopCustomerResult.fromJson(Map<String, dynamic> json) {
    final rawLabels = json['labels'];
    final rawData = json['data'];

    return TopCustomerResult(
      labels: rawLabels is List
          ? rawLabels.where((e) => e != null).map((e) => e.toString()).toList()
          : <String>[],
      data: rawData is List
          ? rawData.map((e) => e is num ? e.toDouble() : 0.0).toList()
          : <double>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {'labels': labels, 'data': data};
  }
}

// ========================
// General Chart Model (Optional)
// ========================

class ChartModel {
  List<String>? labels;
  List<double>? data;

  ChartModel({this.labels, this.data});

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      labels: json['labels'] is List
          ? (json['labels'] as List)
                .where((e) => e != null)
                .map((e) => e.toString())
                .toList()
          : [],
      data: json['data'] is List
          ? (json['data'] as List)
                .map((e) => e is num ? e.toDouble() : 0.0)
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'labels': labels, 'data': data};
  }
}
