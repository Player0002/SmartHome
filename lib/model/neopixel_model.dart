import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/control_card.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/NeoPixel.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';

import 'devices.dart';

class NeoPixelModel extends Devices<Color> {
  NeoPixelModel(NeoPixel neoPixel) {
    assetsLocation = "assets/svgs/rgb.svg";
    currentState = Color.fromRGBO(neoPixel.r, neoPixel.g, neoPixel.b, 1);
    isTwo = true;
    secondState =
        neoPixel.r == 0 && neoPixel.g == 0 && neoPixel.b == 0 ? "OFF" : "ON";
  }
  String get title => "네오픽셀";
  String get subtitle => "색상";
  get secondState =>
      currentState.red == 0 && currentState.green == 0 && currentState.blue == 0
          ? "OFF"
          : "ON";

  Color getColor() {
    return currentState.red == 0 &&
            currentState.green == 0 &&
            currentState.blue == 0
        ? offlineTextColor
        : onlineTextColor;
  }

  Widget toCard(BuildContext context, Room room, int index) {
    print("OH ");
    return Consumer<SocketProvider>(
      builder: (ctx, item, _) => ControlCard<Color>(
        status: true,
        value: currentState,
        assetLocation: assetsLocation,
        hasPercent: true,
        index: index,
        subtitle: subtitle,
        title: title,
        onPress: () => showDialog<void>(
          context: context,
          builder: (_) => Material(
            color: Colors.grey.withOpacity(0.2),
            child: Center(
              child: OColorPicker(
                selectedColor: item.neoPixel.color,
                colors: primaryColorsPalette,
                onColorChange: (color) {
                  print(color);
                  item.updateNeoPixel(item.neoPixel.id, color);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
        color: getColor(),
      ),
    );
  }
}
