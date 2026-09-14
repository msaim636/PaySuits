// ignore_for_file: deprecated_member_use

import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../util/dimensions.dart';

class NoteDialog extends StatelessWidget {
  const NoteDialog({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      insetPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title start
              Text(
                "note_key".tr,
                style: googleSansFlexMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: Dimensions.FREE_SIZE_DEFAULT),

              // Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).disabledColor.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(
                    Dimensions.RADIUS_DEFAULT - 2,
                  ),
                ),
                child: Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: Dimensions.FREE_SIZE_EXTRA_LARGE),

              // Close Button
              CustomButton(
                radius: Dimensions.RADIUS_DEFAULT - 2,
                onPressed: () {
                  Get.back();
                },
                buttonText: "close_key".tr,
                textColor: Theme.of(context).indicatorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
