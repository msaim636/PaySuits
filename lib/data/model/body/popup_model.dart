import 'package:flutter/material.dart';

class PopupModel {
  final String image;
  final String title;
  final String route;
  final Widget? widget;
  final bool isRoute;
  final Function()? onTap;

  PopupModel(
      {required this.image,
      required this.title,
      required this.route,
      this.widget,
        this.onTap,
      this.isRoute = true});
}
