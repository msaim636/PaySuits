// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductAmountCustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final Function? onSubmit;
  final bool? isEnabled;
  final bool readOnly;
  final int? maxLines;
  final String? prefixIcon;
  final ValueChanged<String>? onChanged;
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
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  const ProductAmountCustomTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
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
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
  });

  @override
  _ProductAmountCustomTextFieldState createState() =>
      _ProductAmountCustomTextFieldState();
}

class _ProductAmountCustomTextFieldState
    extends State<ProductAmountCustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        widget.header != null
            ? Row(
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
              )
            : const SizedBox(),
        SizedBox(
          height: widget.header != null ? Dimensions.PADDING_SIZE_SMALL : 0,
        ),

        // Text Field Section
        SizedBox(
          width: widget.width,
          child: TextFormField(
            onTap: widget.onTap,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            textAlign: widget.textAlign ?? TextAlign.start,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: googleSansFlexRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color:
                  widget.textColor ??
                  Theme.of(context).textTheme.bodyMedium!.color,
            ),
            textInputAction: widget.inputAction,
            keyboardType: widget.inputType,
            cursorColor: Theme.of(context).primaryColor,
            enabled: widget.isEnabled,
            autofocus: false,
            readOnly: widget.readOnly,
            obscureText: widget.isPassword! ? _obscureText : false,
            inputFormatters: widget.inputType == TextInputType.phone
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
                  ]
                : widget.isOnlyNumber
                ? <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(
                      4,
                    ), // Limits to 4 characters
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ]
                : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_DEFAULT,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                borderSide: BorderSide(
                  color: widget.borderColor ?? Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: .7),
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: .7),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor.withValues(alpha: .3),
                  width: 1,
                ),
              ),
              isDense: true,
              hintText: widget.hintText,
              fillColor: widget.fillColor ?? Theme.of(context).cardColor,
              hintStyle: googleSansFlexRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: Theme.of(context).disabledColor,
                overflow: TextOverflow.ellipsis,
              ),
              filled: true,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: SvgPicture.asset(
                        widget.prefixIcon!,
                        color:
                            widget.prefixIconColor ??
                            Theme.of(context).primaryColor,
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPassword!
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(
                          context,
                        ).disabledColor.withValues(alpha: 0.3),
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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
