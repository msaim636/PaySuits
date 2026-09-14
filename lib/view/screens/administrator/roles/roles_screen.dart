// ignore_for_file: deprecated_member_use

import 'package:paysuite/view/screens/administrator/roles/widget/roles_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../controller/administrator_role_controller.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/loading_indicator.dart';
import '../../../base/nothing_to_show_here.dart';

class RolesScreen extends StatefulWidget {
  final bool? isCustomerScreen;
  const RolesScreen({super.key, this.isCustomerScreen});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Scroll Listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<AdministratorRolesController>().rolePaginateLoading &&
          Get.find<AdministratorRolesController>().roleNextPageUrl != null) {
        await Get.find<AdministratorRolesController>().getRoles(
          isPaginate: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Permission Controller
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    Get.find<AdministratorRolesController>().getRoles();
    return Scaffold(
      // App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isCustomerScreen ?? true,
        title: "roles_key".tr,
        actions: [
          // Add button section
          if (permissionData!.createRoles!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getCreateRoleRoute('0'));
              },
              icon: SvgPicture.asset(
                Images.addRole,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
      // Body Section
      body: GetBuilder<AdministratorRolesController>(
        builder: (administratorController) {
          return administratorController.administratorListLoading
              ? const Center(child: LoadingIndicator())
              : administratorController.rolesList.isEmpty
              ? const NothingToShowHere()
              : Column(
                  children: [
                    // User List Section
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: administratorController.rolesList.length,
                        padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_SMALL,
                        ),
                        itemBuilder: (context, index) => RolesItem(
                          roleModel: administratorController.rolesList[index],
                          index: index,
                        ),
                      ),
                    ),

                    // Load More Section
                    if (administratorController.rolePaginateLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: Center(child: LoadingIndicator()),
                      ),
                  ],
                );
        },
      ),
    );
  }
}
