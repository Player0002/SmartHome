import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/model/sockets/Room.dart';

import 'devices.dart';

class DhtModel extends Devices<int> {
  DhtModel(int humidity, int temp) {
    assetsLocation = assetLocation['dth'];
    currentState = humidity;
    isTwo = true;
    secondState = "$temp";
  }

  String get title => "온습도";
  String get subtitle => "현재";

  Color getColor() {
    return onlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    print("OH ");
    return ControlCard(
      status: true,
      value: currentState,
      value2: int.parse(secondState),
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
