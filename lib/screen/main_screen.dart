import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/add_location_card.dart';
import 'package:smarthome/components/location_card.dart';
import 'package:smarthome/components/title_builder.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/main_position_provider.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/screen/room_info_screen.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<SocketProvider>(
          builder: (ctx, provider, _) => SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      makeTitle(appTitle),
                      makeSubtitle(
                          "현재 연결된 방의 수는 ${provider.rooms.length}개 입니다."),
                      makeSubtitle("연결중 0개의 오류가 발생했습니다."),
                      SizedBox(height: getProportionateScreenHeight(10)),
                    ],
                  ),
                ),
                ChangeNotifierProvider<MainPositionProvider>(
                  create: (ctx) => MainPositionProvider(),
                  child: Consumer<MainPositionProvider>(
                    builder: (ctx, item, _) => Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    item.value = 1;
                                  },
                                  child: makeTitle(
                                    "외부",
                                    style: item.value == 2
                                        ? titleFont.copyWith(
                                            color: unselectedTextColor)
                                        : titleFont,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    item.value = 2;
                                  },
                                  child: makeTitle(
                                    "내부",
                                    style: item.value == 1
                                        ? titleFont.copyWith(
                                            color: unselectedTextColor)
                                        : titleFont,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: NotificationListener(
                              onNotification: (notification) {
                                if (notification
                                    is OverscrollIndicatorNotification) {
                                  notification.disallowGlow();
                                }
                                return;
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                  ]
                                    ..addAll(getSorted(provider.rooms
                                            .where((element) =>
                                                (element.inside ==
                                                    (item.value == 2)))
                                            .toList())
                                        .map<Widget>((e) => LocationCard(
                                            onPress: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          RoomInfoScreen(e)));
                                            },
                                            devices: e.toCards(provider),
                                            locationName: e.address))
                                        .toList())
                                    ..add(
                                      AddLocationCard(
                                        onPress: () {},
                                      ),
                                    ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Room> getSorted(List<Room> list) {
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }
}
