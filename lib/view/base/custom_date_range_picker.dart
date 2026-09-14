// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../helper/date_converter.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_text_field.dart';

class CustomDateRangePicker extends StatefulWidget {
  final Function(String) onStartTime;
  final Function(String) onEndTime;
  final bool isRequired;
  final String svgImagePath;
  final String? header;
  final String hintText;
  final TextEditingController controller;
  final Color? fillColor;
  final TextAlign? textAlign;
  final Color? titleColor;
  final Color? hintColor;
  final Color? prefixIconColor;
  final bool hintColorEnable;

  const CustomDateRangePicker({
    super.key,
    required this.onStartTime,
    required this.onEndTime,
    required this.svgImagePath,
    this.header,
    this.isRequired = true,
    required this.hintText,
    required this.controller,
    this.fillColor,
    this.titleColor,
    this.hintColor,
    this.prefixIconColor,
    this.textAlign = TextAlign.start,
    this.hintColorEnable = false,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
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
        SizedBox(height: widget.header != null ? 8.0 : 0),

        // Text Field Section
        GestureDetector(
          onTap: () async {
            DateTimeRange? _newDateRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2200),
            );

            if (_newDateRange != null) {
              // formatDate2
              // estimatedDate
              final startDate = DateConverter.estimatedDate(
                _newDateRange.start,
              );
              final endDate = DateConverter.estimatedDate(_newDateRange.end);
              widget.onStartTime(startDate);
              widget.onEndTime(endDate);
            }
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: AbsorbPointer(
            child: CustomTextField(
              focusNode: _focusNode,
              readOnly: true,
              prefixIcon: widget.svgImagePath,
              prefixIconColor: widget.prefixIconColor,
              hintText: widget.hintText,
              controller: widget.controller,
              fillColor: widget.fillColor ?? Theme.of(context).cardColor,
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
