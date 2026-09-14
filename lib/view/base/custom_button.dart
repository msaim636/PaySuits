// ignore_for_file: prefer_final_fields, unnecessary_import
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  final Color? bgColor;
  final Color? textColor;
  final double? radius;
  final Widget? buttonTextWidget;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.bgColor,
    this.radius,
    this.textColor,
    this.buttonTextWidget,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  bool _isDisabled = false;

  // press scale controller (shrink on press)
  late final AnimationController _pressController;

  // shimmer animation (loop)
  late final AnimationController _shimmerController;

  // ripple animation for tap (one-shot)
  late final AnimationController _rippleController;

  // small splash burst controller
  late final AnimationController _splashController;

  // tap position for ripple (local coords)
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _shimmerController.dispose();
    _rippleController.dispose();
    _splashController.dispose();
    super.dispose();
  }

  Future<void> _performPress(TapUpDetails details) async {
    if (_isDisabled) return;

    // capture tap pos relative to box
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    } else {
      _tapPosition = null;
    }

    // start ripple & splash
    _rippleController.forward(from: 0.0);
    _splashController.forward(from: 0.0);

    setState(() => _isDisabled = true);

    // call user's action
    widget.onPressed();

    // keep disabled for a short time to avoid accidental multi-tap
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _isDisabled = false);
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.reverse(); // shrink
  }

  void _onTapCancel() {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.forward(); // release
    _performPress(details);
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 10;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = Theme.of(context).primaryColor;
    final Color baseTextColor =
        widget.textColor ?? (isDark ? Colors.white : Colors.white);
    final Color neon = primary;
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MouseRegion(
        cursor: _isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: _isDisabled ? null : _onTapDown,
          onTapCancel: _isDisabled ? null : _onTapCancel,
          onTapUp: _isDisabled ? null : _onTapUp,
          child: AnimatedBuilder(
            animation: Listenable.merge([_pressController, _shimmerController]),
            builder: (context, child) {
              final double scale = _pressController.value;
              return Transform.scale(scale: scale, child: child);
            },
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // blur backdrop
                Container(
                  width: widget.width ?? double.infinity,
                  height: widget.height ?? 56,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(radius),
                    border: widget.transparent
                        ? Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // main content (text or custom widget)
                      widget.buttonTextWidget ??
                          Text(
                            widget.buttonText,
                            style: googleSansFlexMedium.copyWith(
                              color: baseTextColor,
                              fontSize:
                                  widget.fontSize ?? Dimensions.FONT_SIZE_LARGE,
                              letterSpacing: 0.15,
                            ),
                          ),

                      // neon glow ring (subtle) — uses primary color
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              boxShadow: [
                                BoxShadow(
                                  color: neon.withValues(alpha: 0.12),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // splash bursts (small particles)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _splashController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _SplashPainter(
                            progress: _splashController.value,
                            tapOffset:
                                _tapPosition ??
                                Offset(20, (widget.height ?? 56) / 2),
                            color: neon,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
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

/// Splash painter: small radial droplets outward
class _SplashPainter extends CustomPainter {
  final double progress; // 0..1
  final Offset tapOffset;
  final Color color;
  final bool isDark;

  _SplashPainter({
    required this.progress,
    required this.tapOffset,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.001) return;

    final int drops = 6;
    final double baseRadius = 6.0 + 12.0 * progress;
    final double spread = 36.0 * progress;
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < drops; i++) {
      final double angle = (i / drops) * 2 * 3.1415926 + progress * 1.2;
      final double dx = tapOffset.dx + (spread * cos(angle));
      final double dy = tapOffset.dy + (spread * sin(angle));
      final double r = baseRadius * (0.5 + 0.7 * (1 - progress));
      final double alpha = (1.0 - progress) * 0.9;
      paint.color = Colors.white.withAlpha((alpha * 0.14 * 255).toInt());

      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.tapOffset != tapOffset;
}
