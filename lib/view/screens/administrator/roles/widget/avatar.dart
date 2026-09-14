// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../../../../util/dimensions.dart';
import '../../../../../util/styles.dart';

class AvatarStackScreen extends StatelessWidget {
  final double height;
  final List<ImageProvider> avatars;
  const AvatarStackScreen({required this.height, required this.avatars});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          (avatars.length > 4 ? 4 : avatars.length) * (height * 0.6) + height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(
            avatars.length > 4 ? 4 : avatars.length,
            (index) => Positioned(
              left: index * (height * 0.6),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
                child: CircleAvatar(
                  radius: height / 2,
                  backgroundImage: avatars[index],
                ),
              ),
            ),
          ),
          if (avatars.length > 4)
            Positioned(
              left: 4.3 * (height * 0.6),
              child: CircleAvatar(
                radius: height / 2,
                backgroundColor: Color(
                  0xFFFFAB00,
                ), // Change this color as needed
                child: Text(
                  '+${avatars.length - 4}',
                  style: googleSansFlexBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
