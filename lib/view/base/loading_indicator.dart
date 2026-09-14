// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';

class LoadingIndicator extends StatefulWidget {
  final bool? isWhiteColor;

  const LoadingIndicator({super.key, this.isWhiteColor});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color _loaderColor(BuildContext context) {
    return widget.isWhiteColor == true
        ? LightAppColor.cardColor
        : Get.isDarkMode
        ? LightAppColor.disabledColor
        : Theme.of(context).primaryColor;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _loaderColor(context);

    return SizedBox(
      width: 32,
      height: 16,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final progress = (_controller.value + (i * 0.2)) % 1;
              final scale = 0.5 + 0.5 * (1 - (progress - 0.5).abs() * 2);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.rectangle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
