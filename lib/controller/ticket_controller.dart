// ignore_for_file: prefer_final_fields, strict_top_level_inference

import 'package:file_picker/file_picker.dart' as filepicker;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paysuite/data/repository/ticket_repo.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';

import '../data/api/api_checker.dart';
import '../data/api/api_client.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/ticket_details_model.dart';
import '../data/model/response/ticket_model.dart';
import '../data/model/response/ticket_update_model.dart' hide Images;
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import 'expenses_controller.dart';
import 'permission_controller.dart';

class TicketController extends GetxController implements GetxService {
  final TicketRepo ticketRepo;

  TicketController({required this.ticketRepo});

  // Common Variable
  bool _suggestedAllItemListLoading = false;
  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  bool _ticketPaginateLoading = false;
  bool get ticketPaginateLoading => _ticketPaginateLoading;

  String? _ticketNextPageUrl;
  String? get ticketNextPageUrl => _ticketNextPageUrl;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  static int _ticketSelectedId = -1;
  static int get ticketSelectedId => _ticketSelectedId;

  // Text Editing Controller
  final subjectController = TextEditingController();
  final HtmlEditorController descriptionController = HtmlEditorController();

  final subjectFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  // Filter

  // Variable

  String? _ticketStatusDWValue;

  String? get ticketStatusDWValue => _ticketStatusDWValue;

  final List<Map<String, String>> _ticketStatusList = [
    {'id': 'open', 'value': 'open_key'},
    {'id': 'pending', 'value': 'pending_key'},
    {'id': 'solved', 'value': 'solved_key'},
    {'id': 'closed', 'value': 'closed_key'},
  ];

  List<Map<String, String>> get ticketStatusList => _ticketStatusList
      .map(
        (e) => {
          'id': e['id']!,
          'value': e['value']!.tr, // Translate here
        },
      )
      .toList();

  String? _ticketStatusId;

  String? get ticketStatusId => _ticketStatusId;

  // Ticket More item list
  List<PopupModel> _ticketMoreList = [];
  List<PopupModel> get ticketMoreList => _ticketMoreList;

  void createTicketMoreList(TicketModel? ticketModel) {
    _ticketMoreList = [
      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .viewTickets!)
        PopupModel(
          image: Images.viewDetails,
          title: 'details_key',
          route: RouteHelper.getTicketDetailsRoute(id: _ticketSelectedId),
          isRoute: true,
        ),
      if (Get.find<PermissionController>()
              .myPermissionModel!
              .permission!
              .updateTickets! &&
          ticketModel?.status != "solved" &&
          ticketModel?.status != "open")
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getAddTicketRoute('2'),
          isRoute: true,
        ),
      if (Get.find<PermissionController>()
              .myPermissionModel!
              .permission!
              .updateInvoices! &&
          ticketModel?.status == "pending")
        PopupModel(
          image: Images.solved,
          title: 'solved_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.approveEstimate,
            description: 'this_content_will_be_solved_key',
            title: "you_want_to_solved_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              ticketStatusChanged(ticketId: ticketModel!.id!);
            },
          ),
        ),

      if (Get.find<PermissionController>()
          .myPermissionModel!
          .permission!
          .deleteTickets!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteIcon,
            description: 'this_content_will_be_deleted_key',
            title: "you_want_to_delete_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              deleteTicketData();
            },
          ),
        ),
    ];
  }

  // ===================================
  // Get Ticket Update Details Section
  // ===================================

  // variable

  TicketUpdateModel? _updateTicketModel;
  TicketUpdateModel? get updateTicketModel => _updateTicketModel;

  bool _isUpdateTicketDetailsLoading = false;
  bool get isUpdateTicketDetailsLoading => _isUpdateTicketDetailsLoading;

  // range leave (start–end)
  Rx<DateTime> selectedStartDate = DateTime.now().obs;
  Rx<DateTime> selectedEndDate = DateTime.now().obs;

  Future<void> getTicketUpdateDetails({int? id}) async {
    _isUpdateTicketDetailsLoading = true;
    _updateTicketModel = null;
    update();

    final response = await ticketRepo.getTicketUpdateDetails(
      id: _ticketSelectedId,
    );

    if (response.statusCode == 200) {
      _updateTicketModel = TicketUpdateModel.fromJson(response.body['result']);
      subjectController.text = _updateTicketModel?.subject ?? '';
      // Leave type dropdown
      if (_updateTicketModel?.departmentId != null) {
        _departmentDropdownValue = _updateTicketModel!.departmentId.toString();
      }
      if (_updateTicketModel?.priorityId != null) {
        _priorityDropdownValue = _updateTicketModel!.priorityId.toString();
      }

      // Attachments
      final imageList = _updateTicketModel?.images ?? [];
      for (var img in imageList) {
        if (img.url == null || img.id == null) continue;

        String fileName = img.url!.split('/').last;
        if (fileName.contains('_')) fileName = fileName.split('_').last;
        if (fileName.contains('-')) fileName = fileName.split('-').last;

        String extension = fileName.split('.').last;

        _myFiles.add(
          MyFile(
            id: img.id!,
            file: XFile(img.url!),
            type: extension,
            name: fileName,
          ),
        );
        _getDBAttachmentIdList.add(img.id!);
      }
    } else {
      ApiChecker.checkApi(response);
    }

    _isUpdateTicketDetailsLoading = false;
    update();
  }

  // ===================================
  // Get Ticket Data Section
  // ===================================

  // Variable
  List<TicketModel> _ticketList = [];
  List<TicketModel> get ticketList => _ticketList;

  bool _ticketListLoading = false;
  bool get ticketListLoading => _ticketListLoading;

  bool _isTicketFilter = false;
  bool get isTicketFilter => _isTicketFilter;

  // Get ticket data
  Future<ResponseModel> getTicket({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _ticketPaginateLoading = true;
    } else {
      _ticketList = [];
      _ticketNextPageUrl = null;
      _ticketListLoading = true;
      _isTicketFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;

    final response = await ticketRepo.getTicket(
      url: ticketNextPageUrl,
      fromFilter: _isTicketFilter,
      status: _ticketStatusId ?? "",
    );
    if (response.statusCode == 200) {
      response.body['result']['data'].forEach((item) {
        _ticketList.add(TicketModel.fromJson(item));
      });
      _ticketNextPageUrl = response.body['result']['links']['next'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _ticketPaginateLoading = false;
    } else {
      _ticketListLoading = false;
    }
    update();
    return responseModel;
  }

  // ===================================
  // Add Ticket Section
  // ===================================

  // Variable
  bool _addTicketLoading = false;
  bool get addTicketLoading => _addTicketLoading;

  // Add Product method
  // Add Ticket method
  Future<ResponseModel> addTicket() async {
    _addTicketLoading = true;
    update();

    List<MultipartBody> filesList = [];
    for (int i = 0; i < _myFiles.length; i++) {
      filesList.add(MultipartBody('attachments[$i]', _myFiles[i].file));
    }
    final htmlDescription = await descriptionController.getText();
    debugPrint("Event Description HTML: $htmlDescription");

    final Map<String, String> requestData = {
      if (_priorityDropdownValue != null && _priorityDropdownValue!.isNotEmpty)
        'priority_id': _priorityDropdownValue!,

      if (_departmentDropdownValue != null &&
          _departmentDropdownValue!.isNotEmpty)
        'department_id': _departmentDropdownValue!,

      'subject': subjectController.text.trim(),
      'description': htmlDescription,
    };

    Response response = await ticketRepo.addTicket(
      map: requestData,
      files: filesList,
    );

    ResponseModel responseModel;

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);

      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getTicket();
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }

    _addTicketLoading = false;
    update();
    return responseModel;
  }

  // ============================
  // Update Ticket data Section
  // ============================

  // Variable
  bool _isUpdateTicketLoading = false;
  bool get isUpdateTicketLoading => _isUpdateTicketLoading;

  Future<void> updateTicketData() async {
    _isUpdateTicketLoading = true;
    update();
    List<MultipartBody> filesList = [];

    // Prepare the files list
    for (int i = 0; i < _myFiles.length; i++) {
      if (!_myFiles[i].file.path.startsWith('http')) {
        filesList.add(MultipartBody('attachments[$i]', _myFiles[i].file));
      }
    }

    final Map<String, String> payload = {
      if (_priorityDropdownValue != null && _priorityDropdownValue!.isNotEmpty)
        'priority_id': _priorityDropdownValue!,

      if (_departmentDropdownValue != null &&
          _departmentDropdownValue!.isNotEmpty)
        'department_id': _departmentDropdownValue!,

      'subject': subjectController.text.trim(),
    };

    // Add attachment ids properly
    for (int i = 0; i < _attachmentsMarkedForRemoval.length; i++) {
      payload['deletable_attachment_ids[$i]'] = _attachmentsMarkedForRemoval[i]
          .toString();
    }
    // Make the API call
    final response = await ticketRepo.updateTicket(
      map: payload,
      files: filesList,
      id: _ticketSelectedId,
    );

    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      refreshTicketForm();
      _attachmentsMarkedForRemoval.clear();
      getTicket();
    } else {
      ApiChecker.checkApi(response);
    }

    _isUpdateTicketLoading = false;
    update();
  }

  // ============================
  // Delete Ticket Data Section
  // ============================

  // Delete Ticket Method
  Future<void> deleteTicketData() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await ticketRepo.deleteTicket(id: _ticketSelectedId);

    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getTicket();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  } // Delete Ticket Method

  Future<void> ticketStatusChanged({required int ticketId}) async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await ticketRepo.ticketStatusChanged(ticketId: ticketId);

    if (response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getTicket();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // ===================================
  // Get Ticket Details
  // ===================================

  // Variable
  TicketDetailsModel? _ticketDetailsModel;
  TicketDetailsModel? get ticketDetailsModel => _ticketDetailsModel;

  bool _isTicketDetailsLoading = false;
  bool get isTicketDetailsLoading => _isTicketDetailsLoading;

  Future<void> getTicketDetails({
    required int id,
    bool reloadOff = false,
  }) async {
    _isTicketDetailsLoading = reloadOff ? false : true;
    update();

    final response = await ticketRepo.getTicketDetails(id: id);
    if (response.statusCode == 200) {
      _ticketDetailsModel = null;
      _ticketDetailsModel = TicketDetailsModel.fromJson(
        response.body['result'],
      );
    } else {
      ApiChecker.checkApi(response);
    }
    _isTicketDetailsLoading = false;
    update();
  }

  // ============================
  // Get Department List Section
  // ============================

  // variable
  List<Department> _departmentDropdownList = [];
  List<Department> get departmentDropdownList => _departmentDropdownList;

  List<Map<String, String>> _departmentDropdownStringList = [];

  List<Map<String, String>> get departmentDropdownStringList =>
      _departmentDropdownStringList
          .map((e) => {'id': e['id']!, 'value': e['value']!.toLowerCase().tr})
          .toList();

  String? _departmentDropdownValue;
  String? get departmentDropdownValue => _departmentDropdownValue;

  // Get Designation DropDown list
  Future<void> getDesignationListDropdown() async {
    _suggestedAllItemListLoading = true;
    _departmentDropdownList = [];
    _departmentDropdownStringList = [];
    _departmentDropdownValue = null;
    update();
    final response = await ticketRepo.getDepartmentListDropdown();
    if (response.statusCode == 200) {
      response.body['result'].forEach((item) {
        _departmentDropdownList.add(Department.fromJson(item));
        _departmentDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'] ?? '',
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  // set dropdown Value
  setDepartmentDropDownValue(String? value) {
    _departmentDropdownValue = value;
    update();
  }

  // ============================
  // Priority Dropdown
  // ============================

  // Backend list
  List<Department> _priorityDropdownList = [];
  List<Department> get priorityDropdownList => _priorityDropdownList;

  // Dropdown with translation
  List<Map<String, String>> _priorityDropdownStringList = [];
  List<Map<String, String>> get priorityDropdownStringList =>
      _priorityDropdownStringList
          .map((e) => {'id': e['id']!, 'value': e['value']!.toLowerCase().tr})
          .toList();

  // Selected value
  String? _priorityDropdownValue;
  String? get priorityDropdownValue => _priorityDropdownValue;

  // Fetch priority list from backend
  Future<void> getPriorityListDropdown() async {
    _suggestedAllItemListLoading = true;
    _priorityDropdownList = [];
    _priorityDropdownStringList = [];
    _priorityDropdownValue = null;
    update();

    final response = await ticketRepo.getPriorityListDropdown();
    if (response.statusCode == 200) {
      for (var item in response.body['result']) {
        _priorityDropdownList.add(Department.fromJson(item));

        // Store backend id + key for translation
        _priorityDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'] ?? '',
        });
      }
    } else {
      ApiChecker.checkApi(response);
    }

    _suggestedAllItemListLoading = false;
    update();
  }

  // Set selected value
  setPriorityDropDownValue(String? value) {
    _priorityDropdownValue = value;
    update();
  }

  // ===================================
  // Attachments Section
  // ===================================

  // Variable
  List<MyFile> _myFiles = [];
  List<MyFile> get myFiles => _myFiles;

  List<int> _getDBAttachmentIdList = [];

  final List<int> _attachmentsMarkedForRemoval = [];

  // Picked file function
  pickedFile() async {
    double allItemSize = 0;
    filepicker.FilePickerResult? result = await filepicker.FilePicker.platform
        .pickFiles(
          allowMultiple: true,
          type: filepicker.FileType.custom,
          allowedExtensions: [
            'jpeg',
            'jpg',
            'gif',
            'png',
            'pdf',
            'zip',
            'doc',
            'xls',
          ],
        );
    if (result != null) {
      for (var item in result.files) {
        allItemSize += item.size / 1024;
      }
      if (allItemSize <= 2048) {
        for (var data in result.files) {
          String? fileName;
          List<String> parts = data.path!.split('/');
          fileName = parts.last;
          if (fileName.contains('_')) {
            List<String> parts = fileName.split('_');
            fileName = parts.last;
          }
          if (fileName.contains('-')) {
            List<String> parts = fileName.split('-');
            fileName = parts.last;
          }
          _myFiles.add(
            MyFile(
              file: XFile(data.path!),
              type: data.extension ?? '',
              name: fileName,
            ),
          );
        }
      } else {
        showCustomSnackBar('Max_file_size_is_2_MB_key'.tr);
      }
    }
    update();
  }

  // Picked camera function
  pickedCamera() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedFile != null) {
      String? fileName;
      List<String> parts = pickedFile.path.split('/');
      fileName = parts.last;
      if (fileName.contains('_')) {
        List<String> parts = fileName.split('_');
        fileName = parts.last;
      }
      if (fileName.contains('-')) {
        List<String> parts = fileName.split('-');
        fileName = parts.last;
      }
      _myFiles.add(
        MyFile(file: XFile(pickedFile.path), type: '', name: fileName),
      );
    }

    update();
  }

  void removePickedFileByIndex(int index) {
    if (index >= 0 && index < _myFiles.length) {
      final removedFile = _myFiles[index];

      if (removedFile.id != null) {
        _attachmentsMarkedForRemoval.add(removedFile.id!);
      }

      _myFiles.removeAt(index);

      update();
      debugPrint('removePickedFileByIndex: $index');
    }
  }

  // set empty picked files
  setEmptyPickedFiles() {
    _myFiles = [];
  }

  // Filter Method

  // Variable

  void refreshFilterForm() {
    _ticketStatusId = null;
    _ticketStatusDWValue = null;
    update();
  }

  bool isEmptyFilterForm() {
    if (_ticketStatusId == null && _ticketStatusDWValue == null) {
      return true;
    } else {
      return false;
    }
  }

  // Set ticket status dw value
  void setTicketStatusDWValue(String? value) {
    _ticketStatusDWValue = value;
    _ticketStatusId = value;
    update();
  }

  void refreshTicketForm() async {
    subjectController.clear();
    await safeClearEditor();
    _priorityDropdownValue = null;
    _departmentDropdownValue = null;
    _myFiles = [];
  }

  // Set Ticket on tap id
  void setTicketSelectedId({required int id}) {
    _ticketSelectedId = id;
    update();
  }

  // Editor
  int editorInstanceId = 0;
  bool isEditorReady = false;
  String? pendingHtml;
  void markEditorReady({int? instanceId}) {
    isEditorReady = true;
    if (instanceId != null) editorInstanceId = instanceId;
  }

  void markEditorNotReady() {
    isEditorReady = false;
    // bump id so pending async ops abort
    editorInstanceId++;
  }

  /// Safe wrapper to set text only if editor is valid
  Future<void> safeSetEditorText(
    String html, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final int localId = editorInstanceId;
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      // if instance invalidated, abort
      if (localId != editorInstanceId) return;

      if (!isEditorReady) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      try {
        if (localId != editorInstanceId) return;

        // Add a small delay before calling setText for iOS stability
        await Future.delayed(const Duration(milliseconds: 50));
        descriptionController.setText(html);
        return;
      } catch (e) {
        final message = e.toString().toLowerCase();
        if (message.contains('disposed') || message.contains('webview')) {
          markEditorNotReady();
          return;
        }
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    if (kDebugMode) {
      print("⚠️ safeSetEditorText: couldn't set text within $timeout");
    }
  }

  /// Safe wrapper to clear text
  Future<void> safeClearEditor({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final int localId = editorInstanceId;
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      if (localId != editorInstanceId) return;

      if (!isEditorReady) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      try {
        if (localId != editorInstanceId) return;

        await Future.delayed(const Duration(milliseconds: 50));
        descriptionController.clear();
        return;
      } catch (e) {
        final message = e.toString().toLowerCase();
        if (message.contains('disposed') || message.contains('webview')) {
          markEditorNotReady();
          return;
        }
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    if (kDebugMode) {
      print("⚠️ safeClearEditor: couldn't clear editor within $timeout");
    }
  }

  // ===================================
  // Ticket Comments
  // ===================================

  // Variable
  bool _isAddTicketCommentsLoading = false;
  bool get isAddTicketCommentsLoading => _isAddTicketCommentsLoading;

  Future<ResponseModel> addTicketComments({
    required int ticketId,
    required String comment,
  }) async {
    _isAddTicketCommentsLoading = true;
    update();
    Response response = await ticketRepo.addTicketComment(
      map: {'ticket_id': ticketId, 'comment': comment},
    );

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
      getTicketDetails(id: _ticketSelectedId, reloadOff: true);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isAddTicketCommentsLoading = false;
    update();
    return responseModel;
  }

  @override
  void onClose() {
    // prevent pending async ops from running on disposed editor
    markEditorNotReady();
    super.onClose();
  }

  @override
  void dispose() {
    // double guard to invalidate the editor globally
    Get.find<TicketController>().markEditorNotReady();
    super.dispose();
  }

  // Ticket Rating
  // Variable
  bool _isTicketRatingLoading = false;
  bool get isTicketRatingLoading => _isTicketRatingLoading;

  Future<ResponseModel> rateTicket({
    required int ticketId,
    required int rating,
  }) async {
    _isTicketRatingLoading = true;
    update();
    Response response = await ticketRepo.rateTicket(
      ticketId: ticketId,
      map: {'rating': rating},
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isTicketRatingLoading = false;
    update();
    return responseModel;
  }
}
