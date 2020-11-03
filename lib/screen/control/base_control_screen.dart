import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/title_builder.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class BaseControlScreen extends StatelessWidget {
  final bool isOk;
  final String title;
  final Room room;
  final Widget child;
  BaseControlScreen({this.isOk, this.room, this.title, this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: defaultTextColor,
          ),
        ),
      ),
      body: Consumer<SocketProvider>(
        builder: (ctx, item, _) {
          final led = item.leds.firstWhere((element) => element.id == room.id);
          if (led == null) return CircularProgressIndicator();
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      makeTitle(room.address),
                      makeSubtitle("현재 상태는 양호합니다"),
                      SizedBox(height: getProportionateScreenHeight(10)),
                    ],
                  ),
                ),
              ]..add(child),
            ),
          );
        },
      ),
    );
  }
}
