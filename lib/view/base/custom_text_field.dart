// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final double? fontSize;

  final Function? onSubmit;
  final bool? isEnabled;
  final bool readOnly;
  final int? maxLines;
  final String? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? header;
  final bool isRequired;
  final Color? fillColor;
  final Widget? headerRightElement;
  final double? width;
  final Color? borderColor;
  final Color? prefixIconColor;
  final Color? textColor;
  final Color? headerColor;
  final bool isOnlyNumber;
  final TextAlign? textAlign;
  final VoidCallback? onTap;
  final Color? suffixIconColor;
  final Color? cursorColor;

  const CustomTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.prefixIcon,
    this.isPassword = false,
    this.onChanged,
    this.header,
    this.isRequired = false,
    this.fillColor,
    this.headerRightElement,
    this.width,
    this.borderColor,
    this.prefixIconColor,
    this.textColor,
    this.headerColor,
    this.isOnlyNumber = false,
    this.textAlign,
    this.onTap,
    this.onFieldSubmitted,
    this.fontSize,
    this.suffixIconColor,
    this.cursorColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------- HEADER ----------
        if (widget.header != null)
          Row(
            children: [
              Text(
                widget.header!,
                style: googleSansFlexRegular.copyWith(
                  color:
                      widget.headerColor ??
                      Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                ),
              ),
              if (widget.isRequired)
                Text(
                  " *",
                  style: googleSansFlexRegular.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                  ),
                ),
              const Spacer(),
              widget.headerRightElement ?? const SizedBox(),
            ],
          ),

        SizedBox(height: widget.header != null ? 6 : 0),

        /// ---------- CLEAN MINIMAL GLASS FIELD ----------
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            cursorColor: widget.cursorColor,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTap: widget.onTap,
            textAlign: widget.textAlign ?? TextAlign.start,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.isEnabled,
            readOnly: widget.readOnly,
            obscureText: widget.isPassword! ? _obscureText : false,

            style: googleSansFlexRegular.copyWith(
              fontSize: widget.fontSize ?? Dimensions.FONT_SIZE_DEFAULT,
              color:
                  widget.textColor ??
                  Theme.of(context).textTheme.bodyLarge?.color,
            ),

            inputFormatters: widget.isOnlyNumber
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : widget.inputType == TextInputType.phone
                ? [FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
                : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 16,
              ),
              filled: true,
              fillColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: googleSansFlexRegular.copyWith(
                color:
                    widget.textColor ??
                    Theme.of(context).textTheme.bodyLarge?.color,
              ),

              /// ---------- ICON ----------
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SvgPicture.asset(
                        width: 24,
                        widget.prefixIcon!,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          widget.prefixIconColor ??
                              Theme.of(context).disabledColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : null,

              /// ---------- PASSWORD ----------
              suffixIcon: widget.isPassword!
                  ? IconButton(
                      splashRadius: 18,
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: widget.isPassword!
                            ? widget.suffixIconColor ??
                                  Theme.of(context).disabledColor
                            : null,
                      ),
                      onPressed: _toggle,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _toggle() => setState(() => _obscureText = !_obscureText);
}
