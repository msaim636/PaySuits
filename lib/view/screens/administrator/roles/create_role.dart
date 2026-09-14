// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/administrator_role_controller.dart';
import '../../../../data/model/response/role_permission_model.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../../../base/loading_indicator.dart';

class CreateRoles extends StatefulWidget {
  final String isUpdate;
  const CreateRoles({super.key, required this.isUpdate});

  @override
  State<CreateRoles> createState() => _CreateRolesState();
}

class _CreateRolesState extends State<CreateRoles> {
  bool selectAllPermissions = false;
  Map<String, Map<String, bool>> permissions = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<AdministratorRolesController>().clearUsersData();
      await Get.find<AdministratorRolesController>().getRolePermissionList();

      if (widget.isUpdate == '1') {
        await Get.find<AdministratorRolesController>().getRoleDetails();
        _initializePermissionsWithSelected(
          Get.find<AdministratorRolesController>().rolePermissionList,
          Get.find<AdministratorRolesController>().selectedRolePermissions,
        );
      } else {
        _initializePermissions(
          Get.find<AdministratorRolesController>().rolePermissionList,
        );
      }
    });
  }

  void _initializePermissions(List<RolePermission> rolePermissionList) {
    setState(() {
      for (var permission in rolePermissionList) {
        if (!permissions.containsKey(permission.groupName)) {
          permissions[permission.groupName] = {};
        }
        permissions[permission.groupName]![permission.translatedName] = false;

        Get.find<AdministratorRolesController>()
                .permissionNameToIdMap[permission.translatedName] =
            permission.id;
      }
    });
  }

  void _initializePermissionsWithSelected(
    List<RolePermission> rolePermissionList,
    List<int> selectedPermissionIds,
  ) {
    setState(() {
      permissions.clear(); // Clear any previous data

      for (var permission in rolePermissionList) {
        if (!permissions.containsKey(permission.groupName)) {
          permissions[permission.groupName] = {};
        }

        // Check if the permission ID exists in the selectedPermissionIds list
        bool isSelected = selectedPermissionIds.contains(permission.id);
        permissions[permission.groupName]![permission.translatedName] =
            isSelected;

        // Store the permission ID mapping
        Get.find<AdministratorRolesController>()
                .permissionNameToIdMap[permission.translatedName] =
            permission.id;
      }

      // Update the "Select All" checkbox state
      _updateSelectAllPermissions();
    });

    // Debugging: print the state of permissions
    permissions.forEach((groupName, groupPermissions) {
      print('Group: $groupName');
      groupPermissions.forEach((permissionName, isSelected) {
        print(' - Permission: $permissionName, Selected: $isSelected');
      });
    });
  }

  void _toggleGroupSelection(String groupName, bool isSelected) {
    setState(() {
      permissions[groupName]!.updateAll((key, value) => isSelected);
      _updateSelectAllPermissions();
      _printSelectedIds();
    });
  }

  void _togglePermissionSelection(
    String groupName,
    String permissionName,
    bool isSelected,
  ) {
    setState(() {
      permissions[groupName]![permissionName] = isSelected;
      _updateSelectAllPermissions();
      _printSelectedIds();
    });

    // Debugging: print the state of the updated permission
    print(
      'Toggled permission: $permissionName in group: $groupName, Selected: $isSelected',
    );
  }

  void _updateSelectAllPermissions() {
    bool allSelected = permissions.values.every(
      (group) => group.values.every((val) => val),
    );
    setState(() {
      selectAllPermissions = allSelected;
    });
  }

  void _toggleSelectAllPermissions(bool isSelected) {
    setState(() {
      selectAllPermissions = isSelected;
      permissions.forEach((groupName, groupPermissions) {
        groupPermissions.updateAll((key, val) => isSelected);
      });
      _printSelectedIds();
    });

    // Debugging: print the state after toggling select all
    print('Select All Permissions: $selectAllPermissions');
    permissions.forEach((groupName, groupPermissions) {
      print('Group: $groupName');
      groupPermissions.forEach((permissionName, isSelected) {
        print(' - Permission: $permissionName, Selected: $isSelected');
      });
    });
  }

  void _printSelectedIds() {
    List<int> selectedIds = [];
    permissions.forEach((groupName, groupPermissions) {
      groupPermissions.forEach((permissionName, isSelected) {
        if (isSelected) {
          var id = Get.find<AdministratorRolesController>()
              .permissionNameToIdMap[permissionName];
          if (id != null) {
            selectedIds.add(id.toInt());
          }
        }
      });
    });

    // Update the controller with the selected IDs
    Get.find<AdministratorRolesController>().setSelectedPermissionIds(
      selectedIds,
    );
    if (kDebugMode) {
      print('Selected IDs: $selectedIds');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: widget.isUpdate == '1' ? "edit_key".tr : "add_roles".tr,
      ),
      body: GetBuilder<AdministratorRolesController>(
        builder: (administratorRoleController) {
          if (administratorRoleController.suggestedAllItemListLoading ||
              administratorRoleController.getUserDetailsLoading) {
            return const Center(child: LoadingIndicator());
          } else {
            return Form(
              key: administratorRoleController.createFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Role name field
                    CustomTextField(
                      controller: administratorRoleController.nameController,
                      focusNode: administratorRoleController.nameFocusNode,
                      inputAction: TextInputAction.done,
                      headerColor: Theme.of(context).disabledColor,
                      header: 'role_name'.tr,
                      isRequired: true,
                      hintText: 'write_role_name_here'.tr,
                      fillColor: Theme.of(context).cardColor,
                      borderColor: Theme.of(
                        context,
                      ).disabledColor.withValues(alpha: .3),
                    ),
                    const SizedBox(height: 10),

                    // select all permission
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoCheckbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: selectAllPermissions,
                          onChanged: (value) {
                            _toggleSelectAllPermissions(value!);
                          },
                        ),
                        Text(
                          "select_all_permission".tr,
                          style: googleSansFlexRegular.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: permissions.keys.length,
                        itemBuilder: (BuildContext context, int index) {
                          String groupName = permissions.keys.elementAt(index);
                          Map<String, bool> groupPermissions =
                              permissions[groupName]!;
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).disabledColor.withValues(alpha: .3),
                                ),
                              ),
                              child: ExpansionTile(
                                iconColor: Theme.of(context).disabledColor,
                                collapsedIconColor: Theme.of(
                                  context,
                                ).disabledColor,
                                shape: const Border(
                                  top: BorderSide(color: Colors.transparent),
                                ),
                                childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                expandedAlignment: Alignment.centerLeft,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                title: Row(
                                  children: [
                                    CupertinoCheckbox(
                                      activeColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      value: groupPermissions.values.every(
                                        (val) => val,
                                      ),
                                      onChanged: (bool? value) {
                                        _toggleGroupSelection(
                                          groupName,
                                          value!,
                                        );
                                      },
                                    ),
                                    Text(
                                      groupName,
                                      style: googleSansFlexMedium.copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      ),
                                    ),
                                  ],
                                ),
                                children: groupPermissions.keys.map((
                                  String key,
                                ) {
                                  return CupertinoListTile(
                                    leading: CupertinoCheckbox(
                                      activeColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      value: groupPermissions[key],
                                      onChanged: (bool? value) {
                                        _togglePermissionSelection(
                                          groupName,
                                          key,
                                          value!,
                                        );
                                      },
                                    ),
                                    title: Text(
                                      key,
                                      style: googleSansFlexRegular.copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            transparent: true,
                            onPressed: () {
                              Get.back();
                            },
                            buttonText: "cancel_key".tr,
                            textColor: Get.isDarkMode
                                ? Theme.of(context).indicatorColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                          child: CustomButton(
                            radius: Dimensions.RADIUS_DEFAULT - 2,
                            onPressed:
                                administratorRoleController
                                        .createUserSaveLoading ||
                                    administratorRoleController
                                        .updateRolesSaveLoading
                                ? () {}
                                : () async {
                                    if (administratorRoleController
                                        .nameController
                                        .text
                                        .isEmpty) {
                                      showCustomSnackBar(
                                        'name_not_added_key'.tr,
                                        isError: true,
                                      );
                                      return;
                                    }
                                    widget.isUpdate == '1'
                                        ? administratorRoleController
                                              .userRoleUpdate()
                                        : administratorRoleController
                                              .userRoleCreate();
                                  },
                            buttonTextWidget:
                                administratorRoleController
                                        .createUserSaveLoading ||
                                    administratorRoleController
                                        .updateRolesSaveLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: LoadingIndicator(
                                        isWhiteColor: true,
                                      ),
                                    ),
                                  )
                                : null,
                            buttonText: widget.isUpdate == '1'
                                ? "update_key".tr
                                : "save_key".tr,
                            textColor: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
