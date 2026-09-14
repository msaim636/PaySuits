// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../controller/administrator_user_controller.dart';
import '../../../../../controller/permission_controller.dart';
import '../../../../../controller/transaction_controller.dart';
import '../../../../../data/model/response/users_model.dart';
import '../../../../../theme/light_theme.dart';
import '../../../../../util/dimensions.dart';
import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
import '../../../../base/show_custom_popup_menu.dart';

class UserItem extends StatelessWidget {
  final UsersModel userModel;
  final int index;
  const UserItem({super.key, required this.userModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: userModel.isSubscriber == true
          ? () {}
          : () {
              final permissionData = Get.find<PermissionController>()
                  .myPermissionModel!
                  .permission;

              if (permissionData!.updateUsers! || permissionData.deleteUsers!) {
                if (userModel.isAdmin == false) {
                  Get.find<AdministratorUserController>()
                      .createUserMoreListWitOutStatus();
                  Get.find<AdministratorUserController>()
                      .createUserMoreListWitStatus(
                        status: userModel.status?.translatedName == "Active"
                            ? "status_inactive"
                            : "status_active",
                      );
                  Get.find<AdministratorUserController>().setSelectedUsersIndex(
                    index,
                  );
                  Get.find<AdministratorUserController>().setUserSelectedId(
                    id: userModel.id!,
                    status: userModel.status?.translatedName == "Active"
                        ? "status_inactive"
                        : "status_active",
                  );
                  showPopupMenu(
                    context,
                    userModel.status?.translatedName == "Invited"
                        ? Get.find<AdministratorUserController>()
                              .uerMoreListWithOutStatus
                        : Get.find<AdministratorUserController>()
                              .uerMoreListWithStatus,
                  );
                }
              }
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).cardColor,
        ),
        margin: EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          bottom: Dimensions.PADDING_SIZE_SMALL,
        ),
        padding: EdgeInsets.symmetric(vertical: 17.0),
        child: Row(
          children: [
            userModel.profilePictures != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 10.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userModel.profilePictures!),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 10.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        Get.find<TransactionController>()
                            .getFirstTwoCapitalLetters(
                              userModel.fullName.toString(),
                            ),
                        style: googleSansFlexBold.copyWith(
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Get.find<TransactionController>().capitalizeFirstLetter(
                    userModel.fullName ?? "",
                  ),
                  style: googleSansFlexMedium.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  ),
                ),
                Text(
                  userModel.email ?? "",
                  style: googleSansFlexRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_SMALL,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    SvgPicture.asset(
                      Images.taj,
                      // height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      userModel.roleName ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: userModel.status?.translatedName == "Active"
                    ? LightAppColor.lightGreen
                    : userModel.status?.translatedName == "Inactive"
                    ? Color(0xFFE85B5B)
                    : LightAppColor.lightRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              height: 20,
              width: 69,
              child: Center(
                child: Text(
                  userModel.status?.translatedName ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
