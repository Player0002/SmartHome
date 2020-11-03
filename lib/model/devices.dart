import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/model/sockets/Room.dart';

abstract class Devices<T> {
  String assetsLocation;
  T currentState;
  bool isTwo = false;
  String secondState;
  SvgPicture getIcon(double width, double height) => SvgPicture.asset(
        assetsLocation,
        width: width,
        height: height,
      );
  String get title;
  String get subtitle;
  Color getColor();
  Widget toCard(BuildContext context, Room room, int index);
}
