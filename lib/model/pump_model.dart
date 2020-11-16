import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/screen/control/pump_control_screen.dart';

import 'devices.dart';

class PumpModel extends Devices<String> {
  PumpModel(bool isOnline) {
    assetsLocation = "assets/svgs/pump.svg";
    currentState = isOnline ? "ON" : "OFF";
  }
  String get title => "펌프";
  String get subtitle => "전원";
  Color getColor() {
    return currentState == "ON" ? onlineTextColor : offlineTextColor;
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
      onPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => PumpControlScreen(
                      isOk: true,
                      room: room,
                      title: "펌프 $index",
                    )));
      },
      color: getColor(),
    );
  }
}
