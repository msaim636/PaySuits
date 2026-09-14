// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/transaction_controller.dart';
import 'package:paysuite/util/images.dart';
import 'package:paysuite/view/screens/administrator/roles/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/administrator_role_controller.dart';
import '../../../../../controller/permission_controller.dart';
import '../../../../../data/model/response/roles_model.dart';
import '../../../../../util/dimensions.dart';
import '../../../../../util/styles.dart';
import '../../../../base/show_custom_popup_menu.dart';

class RolesItem extends StatelessWidget {
  final RolesModel roleModel;
  final int index;
  const RolesItem({super.key, required this.roleModel, required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          final permissionData =
              Get.find<PermissionController>().myPermissionModel!.permission;
          if (permissionData!.deleteRoles! || permissionData.updateRoles!) {
            if (roleModel.name == "Administrator" ||
                roleModel.name == "Manager") {
              print('null');
            } else {
              Get.find<AdministratorRolesController>().createRoleMoreList();
              Get.find<AdministratorRolesController>().setSelectedUsersIndex(
                index,
              );
              showPopupMenu(
                context,
                Get.find<AdministratorRolesController>().roleMoreList,
              );
            }
          }
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          tileColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          horizontalTitleGap: 8.0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3.4,
                  child: Text(
                    Get.find<TransactionController>().capitalizeFirstLetter(
                      roleModel.name ?? "",
                    ),
                    maxLines: 2,
                    style: googleSansFlexMedium.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      'Users : ${roleModel.userCount ?? 0}',
                      style: googleSansFlexMedium.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          trailing: SizedBox(
            height: 25,
            width: MediaQuery.of(context).size.width / 4.3,
            child: Align(
              alignment: Alignment.centerRight,
              child: AvatarStackScreen(
                height: 25,
                avatars: [
                  if (roleModel.userProfilePictures == null ||
                      roleModel.userProfilePictures!.isEmpty)
                    AssetImage(Images.placeholder),
                  if (roleModel.userProfilePictures != null &&
                      roleModel.userProfilePictures!.isNotEmpty)
                    for (
                      var n = 0;
                      n < roleModel.userProfilePictures!.length;
                      n++
                    )
                      NetworkImage(roleModel.userProfilePictures![n]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
