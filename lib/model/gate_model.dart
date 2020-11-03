import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Room.dart';

import 'devices.dart';

class GateModel extends Devices<String> {
  GateModel(bool isOpen) {
    assetsLocation = "assets/svgs/gate.svg";
    currentState = isOpen ? "OPEN" : "CLOSE";
    isTwo = false;
  }

  String get title => "게이트";
  String get subtitle => "문";

  Color getColor() {
    return currentState == "OPEN" ? onlineTextColor : offlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    print("OH ");
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
