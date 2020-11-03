import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

import 'base_control_screen.dart';

class PumpControlScreen extends StatelessWidget {
  final bool isOk;
  final String title;
  final Room room;
  PumpControlScreen({this.isOk, this.room, this.title});
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
              SvgPicture.asset(
                assetLocation['waterStatus'],
                width: minWH * 0.5,
              ),
              Consumer<SocketProvider>(
                builder: (ctx, itm, _) => CustomTabs(
                  onPress: (i) {
                    itm.updatePump(room.id, i == 0);
                  },
                  initialIndex: itm.waterStatus ? 0 : 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  final ValueChanged<int> onPress;
  final int initialIndex;
  final String first;
  final String seconds;
  const CustomTabs({
    Key key,
    @required this.initialIndex,
    @required this.onPress,
    this.first,
    this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: Container(
        width: SizeConfig.screenWidth * 0.7,
        height: getProportionateScreenHeight(90),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: tabColor,
        ),
        child: DefaultTabController(
          initialIndex: initialIndex,
          length: 2,
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
            ),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: tabColor,
            ),
            labelStyle: tabButtonFont,
            labelColor: defaultTextColor,
            unselectedLabelColor: unselectedTextColor,
            onTap: onPress,
            tabs: [
              Tab(
                text: first ?? "ON",
              ),
              Tab(
                text: seconds ?? "OFF",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
