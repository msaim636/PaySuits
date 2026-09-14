// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:paysuite/controller/ticket_controller.dart';
import 'package:paysuite/data/model/response/ticket_details_model.dart';
import 'package:paysuite/helper/date_converter.dart';
import 'package:paysuite/util/images.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:paysuite/view/base/loading_indicator.dart';

import '../../../theme/light_theme.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_appbar_action.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  bool _detailsExpanded = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTicket();
    });
  }

  void _loadTicket() async {
    final controller = Get.find<TicketController>();
    await controller.getTicketDetails(id: widget.ticketId);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void showRatingDialog({required int ticketId}) {
      final TicketController controller = Get.find<TicketController>();

      // Prefill rating from API
      RxInt rating = (controller.ticketDetailsModel?.rating ?? 0).obs;

      // Prevent double submit
      RxBool isSubmitting = false.obs;

      Get.dialog(
        AlertDialog(
          title: Text(
            "rate_ticket_key".tr,
            textAlign: TextAlign.center,
            style: googleSansFlexMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      splashRadius: 22,
                      onPressed: () {
                        rating.value = index + 1;
                      },
                      icon: Icon(
                        index < rating.value
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 32,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              // Loading indicator (no button modification)
            ],
          ),
          actions: [
            Obx(
              () => CustomButton(
                onPressed: () async {
                  if (rating.value == 0 || isSubmitting.value) return;

                  isSubmitting.value = true;

                  final result = await controller.rateTicket(
                    ticketId: ticketId,
                    rating: rating.value,
                  );

                  isSubmitting.value = false;

                  if (result.isSuccess) {
                    Get.back();

                    // refresh ticket details
                    controller.getTicketDetails(id: ticketId);

                    showCustomSnackBar(result.message, isError: false);
                  }
                },
                buttonTextWidget: isSubmitting.value
                    ? SizedBox(
                        height: 23,
                        width: 23,
                        child: LoadingIndicator(isWhiteColor: true),
                      )
                    : null,
                buttonText: "submit_key".tr,
              ),
            ),
          ],
        ),
        barrierDismissible: !isSubmitting.value,
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "ticket_details_key".tr,
        actions: [
          CustomAppBarActionButton(
            svgImagePath: Images.rating,
            onPressed: () => showRatingDialog(ticketId: widget.ticketId),
          ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),
      body: GetBuilder<TicketController>(
        builder: (ticketController) {
          if (ticketController.isTicketDetailsLoading) {
            return const Center(child: LoadingIndicator());
          }

          final comments = ticketController.ticketDetailsModel?.comments;

          // Scroll to bottom after rebuild
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              // ───────────── Minimal Collapsible Ticket Details ─────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_LARGE,
                  vertical: Dimensions.PADDING_SIZE_SMALL,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticketController
                                        .ticketDetailsModel
                                        ?.ticketNumber ??
                                    '--',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    ticketController
                                            .ticketDetailsModel
                                            ?.submittedBy
                                            ?.email ??
                                        '--',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: LightAppColor.lightGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _detailsExpanded = !_detailsExpanded;
                            });
                          },
                          icon: Icon(
                            _detailsExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _detailsExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: _ticketDetails(
                        theme,
                        ticketDetailsModel: ticketController.ticketDetailsModel,
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ───────────── Communication History ─────────────
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ticketController.getTicketDetails(
                      id: widget.ticketId,
                    );
                    _scrollToBottom();
                  },
                  child: (comments == null || comments.isEmpty)
                      ? Center(
                          child: Text(
                            "no_comments_key".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return _ChatBubble(
                              message: comment.comment ?? "--",
                              isUser: comment.userType == 'tenant',
                              time: comment.createdAt ?? '--',
                            );
                          },
                        ),
                ),
              ),

              // ───────────── Chat Input Field ─────────────
              ticketController.ticketDetailsModel?.status == 'solved'
                  ? const SizedBox.shrink()
                  : _chatInput(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _ticketDetails(
    ThemeData theme, {
    required TicketDetailsModel? ticketDetailsModel,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: theme.hintColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "claimed_by_key".tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                  Text(
                    ticketDetailsModel?.submittedBy?.fullName ?? '--',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: LightAppColor.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "submitted_at_key".tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                  Text(
                    DateConverter.formatStringDate(
                      ticketDetailsModel?.createdAt ?? '--',
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: LightAppColor.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "solved_at_key".tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                  Text(
                    DateConverter.formatStringDate(
                      ticketDetailsModel?.updatedAt ?? '--',
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: theme.colorScheme.error.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'write_reply_key'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Theme.of(context).primaryColor,
            child: GetBuilder<TicketController>(
              builder: (controller) {
                return controller.isAddTicketCommentsLoading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: LightAppColor.cardColor,
                        ),
                        onPressed: () async {
                          if (_messageController.text.trim().isEmpty) return;

                          await controller.addTicketComments(
                            ticketId: widget.ticketId,
                            comment: _messageController.text.trim(),
                          );

                          _messageController.clear();
                          _scrollToBottom();
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────── Chat Bubble ─────────────────

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    String decodeHtml(String html) {
      return html
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'");
    }

    double maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth, minWidth: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Html(
                  data: decodeHtml(message),
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      color: isUser
                          ? LightAppColor.cardColor
                          : LightAppColor.cardColor,
                      fontSize: FontSize(14),
                    ),
                    "p": Style(
                      margin: Margins.zero,
                      color: isUser
                          ? LightAppColor.cardColor
                          : LightAppColor.cardColor,
                    ),
                    "span": Style(
                      color: isUser
                          ? LightAppColor.cardColor
                          : LightAppColor.cardColor,
                    ),
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser
                        ? LightAppColor.cardColor.withValues(alpha: 0.7)
                        : LightAppColor.cardColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
