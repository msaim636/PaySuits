import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:paysuite/theme/light_theme.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class SwitchButton extends StatefulWidget {
  final String title;
  final bool? isButtonActive;
  final Function? onTap;

  const SwitchButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isButtonActive,
  });

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton>
    with SingleTickerProviderStateMixin {
  bool? _buttonActive;

  @override
  void initState() {
    super.initState();
    _buttonActive = widget.isButtonActive;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        // vertical: Dimensions.PADDING_SIZE_SMALL,
        horizontal: Dimensions.PADDING_SIZE_SMALL,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.right,
              style: googleSansFlexRegular.copyWith(
                color: Colors.white70,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// ------------------------------
          /// GLASS TOGGLE SWITCH
          /// ------------------------------
          GestureDetector(
            onTap: () {
              setState(() => _buttonActive = !_buttonActive!);
              widget.onTap!();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 50,
                  height: 25,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: _buttonActive!
                          ? [
                              Colors.white.withValues(alpha: 0.32),
                              Colors.white.withValues(alpha: 0.12),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.17),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  /// SWITCH "THUMB"
                  child: AnimatedAlign(
                    duration: Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    alignment: _buttonActive!
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _buttonActive!
                                ? LightAppColor.cardColor
                                : LightAppColor.disabledColor.withValues(
                                    alpha: 0.95,
                                  ),
                            _buttonActive!
                                ? LightAppColor.cardColor
                                : LightAppColor.disabledColor.withValues(
                                    alpha: 0.75,
                                  ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
