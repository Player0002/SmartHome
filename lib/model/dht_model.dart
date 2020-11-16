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
  String get subtitle => "습도";

  Color getColor() {
    return !(currentState == -127 && int.parse(secondState) == -127)
        ? onlineTextColor
        : offlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    return ControlCard(
      status: !(currentState == -127 && int.parse(secondState) == -127),
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
