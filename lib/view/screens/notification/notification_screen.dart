// ignore_for_file: deprecated_member_use

import 'package:paysuite/controller/notification_controller.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/response/notification_model.dart';
import '../../../helper/date_converter.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final controller = Get.find<NotificationController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotification();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !controller.notificationPaginateLoading &&
          controller.notificationNextPageUrl != null) {
        controller.getNotification(isPaginate: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'notifications_key'.tr,
            isBackButtonExist: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => controller.getNotification(),
                  child: controller.notificationListLoading
                      ? const Center(child: LoadingIndicator())
                      : controller.notificationList.isEmpty
                      ? const NothingToShowHere()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          itemCount:
                              controller.notificationList.length +
                              (controller.notificationPaginateLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < controller.notificationList.length) {
                              final item = controller.notificationList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: NotificationItem(item: item),
                              );
                            }
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: LoadingIndicator()),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel item;
  NotificationItem({super.key, required this.item});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    bool isUnread = item.readAt == null;

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        _showNotificationDetails(context, item);
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE),
          border: Border.all(
            color: isUnread
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: isUnread
                    ? theme.colorScheme.primary
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: isUnread
                  ? const Icon(
                      Icons.notification_important_outlined,
                      color: Colors.white,
                      size: 12,
                    )
                  : const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 12,
                    ),
            ),
            const SizedBox(width: Dimensions.FREE_SIZE_LARGE),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.data?.title ?? "",
                    style: googleSansFlexBold.copyWith(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: Dimensions.FREE_SIZE_SMALL),

                  // Message
                  Text(
                    item.data?.message ?? "",
                    style: googleSansFlexMedium.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.FREE_SIZE_SMALL),

                  // Timestamp
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: theme.textTheme.bodySmall!.color?.withOpacity(
                          0.6,
                        ),
                      ),
                      const SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                      Text(
                        DateConverter.convertDateAndTime(
                          item.createdAt ?? "not_set_key".tr,
                          isYearShow: true,
                        ),
                        style: googleSansFlexRegular.copyWith(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationModel item) {
    final theme = Theme.of(context);
    bool wasUnread = item.readAt == null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.RADIUS_DEFAULT),
        ),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.RADIUS_LARGE),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE),
            ),
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        decoration: BoxDecoration(
                          color: theme.disabledColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_SMALL,
                          ),
                        ),
                      ),
                    ),

                    // Title
                    Text(
                      item.data?.title ?? "",
                      style: googleSansFlexBold.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

                    // Message
                    Text(
                      item.data?.message ?? "",
                      style: googleSansFlexMedium.copyWith(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

                    // Timestamp
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: theme.textTheme.bodySmall!.color?.withOpacity(
                            0.6,
                          ),
                        ),
                        const SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                        Text(
                          DateConverter.convertDateAndTime(
                            item.createdAt ?? "not_set_key".tr,
                            isYearShow: true,
                          ),
                          style: googleSansFlexRegular.copyWith(),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.FREE_SIZE_EXTRA_LARGE),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (wasUnread && item.id != null) {
        controller.markSingleNotificationAsRead(id: item.id!);
      }
    });
  }
}
