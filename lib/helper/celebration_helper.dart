import 'package:confetti/confetti.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCelebrationPopup(
  BuildContext context,
  tittle,
  subTittle,
  buttonTittle,
) {
  final confettiController = ConfettiController(
    duration: const Duration(seconds: 10),
  );
  confettiController.play();

  Get.dialog(
    Stack(
      alignment: Alignment.center,
      children: [
        // Party-style Confetti effect with streamers
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            emissionFrequency: 0.50,
            numberOfParticles: 30,
            gravity: 0.5,
            maxBlastForce: 15,
            minBlastForce: 8,
            colors: const [
              LightAppColor.dodgerBlue,
              LightAppColor.pink,
              LightAppColor.lightYellow,
              LightAppColor.lightOrange,
              LightAppColor.purple,
            ],
            createParticlePath: (size) {
              return _createStreamerPath(size); // Custom path for streamers
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AlertDialog(
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            title: Text(
              "$tittle".tr,
              style: googleSansFlexBold.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$subTittle".tr,
                  style: googleSansFlexBold.copyWith(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.back();
                },
                child: Text(
                  "continue_key".tr,
                  style: googleSansFlexBold.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

Path _createStreamerPath(Size size) {
  final path = Path();
  path.moveTo(0, 0);
  path.quadraticBezierTo(10, 20, 20, 10);
  path.quadraticBezierTo(30, -20, 40, 0);
  return path;
}
