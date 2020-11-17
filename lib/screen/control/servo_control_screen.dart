import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

import 'base_control_screen.dart';
import 'custom_tabs.dart';

class ServoControlScreen extends StatelessWidget {
  final bool isOk;
  final String title;
  final Room room;
  ServoControlScreen({this.isOk, this.room, this.title});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double minWH = SizeConfig.screenWidth > SizeConfig.screenHeight
        ? SizeConfig.screenHeight
        : SizeConfig.screenWidth;
    return BaseControlScreen(
      isOk: isOk,
      title: title,
      room: room,
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: "images게이트1",
                child: SvgPicture.asset(
                  assetLocation['servo'],
                  width: minWH * 0.5,
                ),
              ),
              Consumer<SocketProvider>(
                builder: (ctx, itm, _) => CustomTabs(
                  first: "OPEN",
                  seconds: "CLOSE",
                  onPress: (i) {
                    itm.updateServo(room.id, i == 0);
                  },
                  initialIndex: itm.servo ? 0 : 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
