import 'package:flutter/material.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/devices.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class LocationCard extends StatelessWidget {
  LocationCard({
    Key key,
    @required this.onPress,
    @required this.locationName,
    @required this.devices,
  }) : super(key: key);
  final Function onPress;
  final String locationName;
  final List<Devices> devices;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: getProportionateScreenHeight(285),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x10000000),
                offset: Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(20)),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    locationName,
                    style: cardTitleFont,
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(5),
                  ),
                  Text(
                    "현재 ${devices.length}개의 기기와 연결되어있습니다.",
                    style: cardSubtitleFont,
                  )
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: devices
                    .map(
                      (e) => Column(
                        children: [
                          //e.getIcon(getProportionateScreenWidth(80),
                          //    getProportionateScreenWidth(80)),
                          Container(
                            child: e.getIcon(
                              getProportionateScreenWidth(80),
                              getProportionateScreenWidth(80),
                            ),
                          ),
                          e.isTwo
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10),
                                      ),
                                      child: Text(
                                        "${e.currentState}",
                                        style: cardInfoFont,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: getProportionateScreenHeight(5),
                                      ),
                                      child: Text(
                                        "${e.secondState}",
                                        style: cardInfoFont.copyWith(
                                          color: e.getColor(),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(5),
                                  ),
                                  child: Text(
                                    "${e.currentState}",
                                    style: cardInfoFont.copyWith(
                                      color: e.getColor(),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                    .toList(),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
