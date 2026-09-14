// ignore_for_file: deprecated_member_use

import 'package:paysuite/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class SelectDateItemTextField extends StatefulWidget {
  const SelectDateItemTextField({
    super.key,
    required this.onTap,
    required this.svgImagePath,
    this.height,
    this.header,
    this.isRequired = true,
    required this.hintText,
    required this.controller,
    this.fillColor,
    this.hintColor,
    this.prefixIconColor,
    this.textAlign = TextAlign.start,
    this.hintColorEnable = false,
    this.textColor,
  });

  final String svgImagePath;
  final VoidCallback onTap;
  final double? height;
  final String? header;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final Color? fillColor;
  final TextAlign? textAlign;
  final Color? hintColor;
  final Color? prefixIconColor;
  final bool hintColorEnable;
  final Color? textColor;

  @override
  State<SelectDateItemTextField> createState() =>
      _SelectDateItemTextFieldState();
}

class _SelectDateItemTextFieldState extends State<SelectDateItemTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        if (widget.header != null)
          Row(
            children: [
              Text(
                widget.header!,
                style: googleSansFlexRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
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
            ],
          ),
        SizedBox(
          height: widget.header != null ? Dimensions.PADDING_SIZE_SMALL : 0,
        ),

        // Text Field Section
        GestureDetector(
          onTap: () {
            widget.onTap();
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: AbsorbPointer(
            child: CustomTextField(
              focusNode: _focusNode,
              readOnly: true,
              fontSize: Dimensions.FONT_SIZE_DEFAULT - 1,
              prefixIcon: widget.svgImagePath,
              prefixIconColor:
                  widget.prefixIconColor ?? Theme.of(context).disabledColor,
              hintText: widget.hintText,
              controller: widget.controller,
              fillColor: widget.fillColor ?? Theme.of(context).cardColor,
              textColor: widget.textColor,

              borderColor: _focusNode.hasFocus
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}
