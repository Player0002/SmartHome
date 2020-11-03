import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/title_builder.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class RoomInfoScreen extends StatelessWidget {
  final Room room;
  RoomInfoScreen(this.room);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
      body: SizedBox(
        width: double.infinity,
        child: Consumer<SocketProvider>(
          builder: (ctx, itm, _) => Column(
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
                    makeSubtitle("현재 ${room.getCounts()}개의 기기와 연결되어 있습니다."),
                    SizedBox(height: getProportionateScreenHeight(10)),
                  ],
                ),
              ),
            ]..add(
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowGlow();
                      return;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: room.buildWidget(itm, context),
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
