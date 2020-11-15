import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Led.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/screen/control/led_control_screen_refactor.dart';

import 'devices.dart';

class LedModel extends Devices<int> {
  LedModel(Led led) {
    assetsLocation = "assets/svgs/led.svg";
    currentState = led.pwm;
    isTwo = true;
    secondState = led.pwm == 0 ? "OFF" : "ON";
  }
  String get title => "조명";
  String get subtitle => "밝기";
  get secondState => currentState == 0 ? "OFF" : "ON";

  Color getColor() {
    return currentState != 0 ? onlineTextColor : offlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    print("OH sad");
    return ControlCard(
      status: true,
      value: currentState,
      assetLocation: assetsLocation,
      hasPercent: true,
      index: index,
      subtitle: subtitle,
      title: title,
      onPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => LedControlScreenRefactor(
              isOk: true,
              room: room,
              title: "조명 $index",
            ),
          ),
        );
      },
      color: currentState == 0 ? offlineTextColor : brightTextColor,
    );
  }
}
