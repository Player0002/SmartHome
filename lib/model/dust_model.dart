import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Room.dart';

import 'devices.dart';

class DustModel extends Devices<int> {
  DustModel(int dust) {
    assetsLocation = "assets/svgs/dust.svg";
    currentState = dust;
    isTwo = true;
    secondState = "좋음";
  }

  String get title => "미세먼지";
  String get subtitle => "현재";

  String get secondState => currentState <= 30
      ? "좋음"
      : currentState <= 80
          ? "보통"
          : "나쁨";

  Color getColor() {
    return currentState <= 30 ? onlineTextColor : offlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    return ControlCard(
      status: true,
      value: currentState,
      assetLocation: assetsLocation,
      hasPercent: false,
      index: index,
      subtitle: subtitle,
      title: title,
      onPress: () {},
      color: getColor(),
    );
  }
}
