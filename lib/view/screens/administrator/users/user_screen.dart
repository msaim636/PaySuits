// ignore_for_file: deprecated_member_use
import 'package:paysuite/view/screens/administrator/users/widget/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../controller/administrator_user_controller.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/loading_indicator.dart';
import '../../../base/nothing_to_show_here.dart';

class UserScreen extends StatefulWidget {
  final bool? isCustomerScreen;
  const UserScreen({super.key, this.isCustomerScreen});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
      if (!Get.find<AdministratorUserController>().userPaginateLoading &&
          Get.find<AdministratorUserController>().usersNextPageUrl != null) {
        await Get.find<AdministratorUserController>().getUsers(
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdministratorUserController>().getUsers();
    });
    return Scaffold(
      // App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isCustomerScreen ?? true,
        title: "users_management_key".tr,
        actions: [
          if (permissionData!.manageGlobalAccess!)
            // Add button section
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAddUsersRoute());
              },
              icon: SvgPicture.asset(
                Images.addUser,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),

          // Filter button section
          if (permissionData.viewUsers!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getUserFilterRoute());
              },
              icon: SvgPicture.asset(
                Images.filter,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      // Body Section
      body: GetBuilder<AdministratorUserController>(
        builder: (userController) {
          return userController.administratorListLoading
              ? const Center(child: LoadingIndicator())
              : userController.usersList.isEmpty
              ? const NothingToShowHere()
              : Column(
                  children: [
                    // User List Section
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: userController.usersList.length,
                        padding: const EdgeInsets.all(
                          Dimensions.PADDING_SIZE_SMALL,
                        ),
                        itemBuilder: (context, index) => UserItem(
                          userModel: userController.usersList[index],
                          index: index,
                        ),
                      ),
                    ),

                    // Load More Section
                    if (userController.userPaginateLoading)
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
