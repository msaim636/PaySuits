import 'package:flutter/material.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class TitleItem extends StatelessWidget {
  const TitleItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
        vertical: Dimensions.PADDING_SIZE_SMALL - 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Text(
        title,
        style: googleSansFlexMedium.copyWith(
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    );
  }
}
