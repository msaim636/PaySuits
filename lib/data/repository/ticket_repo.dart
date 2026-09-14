import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class TicketRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  TicketRepo({required this.apiClient, required this.sharedPreferences});

  // Get estimate response
  Future<Response> getTicket({
    String? url,
    required bool fromFilter,
    String? status,
  }) async {
    return await apiClient.getData(
      fromFilter
          ? url != null
                ? "$url&${"status=$status"}"
                : "${AppConstants.GET_TICKET_URI}?${"status=$status"}"
          : url ?? AppConstants.GET_TICKET_URI,
      isPaginate: url != null ? true : false,
    );
  }

  // Get Leaves details response
  Future<Response> getTicketUpdateDetails({int? id}) async {
    return await apiClient.getData("${AppConstants.GET_TICKET_URI}/$id");
  }

  // add ticket
  Future<Response> addTicket({
    required dynamic map,
    required List<MultipartBody> files,
  }) async {
    return await apiClient.postMultipartData(
      AppConstants.GET_TICKET_URI,
      map,
      files,
    );
  }

  // Update Ticket response
  Future<Response> updateTicket({
    required int id,
    required Map<String, String> map,
    required List<MultipartBody> files,
  }) async {
    return await apiClient.postMultipartData(
      "${AppConstants.GET_TICKET_URI}/$id?_method=PATCH",
      map,
      files,
    );
  }

  // get ticket details
  Future<Response> getTicketDetails({required int id}) async {
    return await apiClient.getData(
      "${AppConstants.GET_TICKET_DETAILS_URI}/$id",
    );
  }

  // add ticket comment
  Future<Response> addTicketComment({required Map<String, dynamic> map}) async {
    return await apiClient.postData(
      "${AppConstants.ADD_TICKET_COMMENTS_URI}",
      map,
    );
  }

  // Rating Ticket
  Future<Response> rateTicket({
    required int ticketId,
    required Map<String, dynamic> map,
  }) async {
    return await apiClient.postData(
      "${AppConstants.RATING_TICKET_URI}$ticketId",
      map,
    );
  }

  // Delete Ticket
  Future<Response> deleteTicket({required int id}) async {
    return await apiClient.deleteData("${AppConstants.GET_TICKET_URI}/$id");
  } // Delete Ticket

  Future<Response> ticketStatusChanged({required int ticketId}) async {
    return await apiClient.postData(
      "${AppConstants.TICKET_STATUS_UPDATE_URI}$ticketId",
      {"status": "solved"},
    );
  }

  // Get Department Dropdown List Method
  Future<Response> getDepartmentListDropdown() async {
    return await apiClient.getData(AppConstants.GET_DEPARTMENT_URI);
  } // Get Department Dropdown List Method

  Future<Response> getPriorityListDropdown() async {
    return await apiClient.getData(AppConstants.GET_PRIORITY_URI);
  }
}
