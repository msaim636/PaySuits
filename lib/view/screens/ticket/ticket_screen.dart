import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/ticket_controller.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';

import '../../../controller/permission_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_appbar_action.dart';
import 'widget/ticket_item.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TicketController>().getTicket();
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Scroll Listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<TicketController>().ticketPaginateLoading &&
          Get.find<TicketController>().ticketNextPageUrl != null) {
        await Get.find<TicketController>().getTicket(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData =
        Get.find<PermissionController>().myPermissionModel!.permission;
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "ticket_key".tr,
        actions: [
          // Add button section
          if (permissionData!.manageGlobalAccess!)
            CustomAppBarActionButton(
              onPressed: () => Get.toNamed(RouteHelper.getAddTicketRoute('1')),
              svgImagePath: Images.addIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
          if (permissionData.manageGlobalAccess!)
            CustomAppBarActionButton(
              onPressed: () => Get.toNamed(RouteHelper.getTicketFilterRoute()),
              svgImagePath: Images.filterIcon,
            ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<TicketController>().getTicket();
        },
        child: GetBuilder<TicketController>(
          builder: (ticketController) {
            return ticketController.ticketListLoading
                ? const Center(child: LoadingIndicator())
                : ticketController.ticketList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: ticketController.ticketList.length,
                          padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          itemBuilder: (context, index) => TicketItem(
                            ticketModel: ticketController.ticketList[index],
                            index: index,
                          ),
                        ),
                      ),

                      // Pagination loading indicator
                      if (ticketController.ticketPaginateLoading)
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
      ),
    );
  }
}
