import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final IconData? icon;
  final Function()? onTap;
  const CustomIconButton({
    super.key,
    required this.iconPath,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: icon != null
          ? Icon(icon, color: Theme.of(context).primaryColor)
          : SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
    );
  }
}
