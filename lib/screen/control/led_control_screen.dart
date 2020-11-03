import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/title_builder.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class LedControlScreen extends StatelessWidget {
  final bool isOk;
  final String title;
  final Room room;
  LedControlScreen({this.isOk, this.room, this.title});

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
      body: Consumer<SocketProvider>(builder: (ctx, item, _) {
        final led = item.leds.firstWhere((element) => element.id == room.id);
        if (led == null) return CircularProgressIndicator();
        print(led.pwm);
        return SizedBox(
          width: double.infinity,
          child: Center(
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
              ]..add(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              SvgPicture.asset(
                                "assets/svgs/led_sun.svg",
                                width: 20,
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenWidth(10),
                                        vertical:
                                            getProportionateScreenHeight(10)),
                                    child: Container(
                                      child: FlutterSlider(
                                        axis: Axis.vertical,
                                        min: 0,
                                        max: 100,
                                        values: [led.pwm * 1.0],
                                        disabled: false,
                                        onDragging: (handlerIndex, lowerValue,
                                            upperValue) {
                                          if (lowerValue.toInt() != led.pwm)
                                            item.updateLed(
                                                led.id, lowerValue.toInt());
                                        },
                                        rtl: true,
                                        tooltip: FlutterSliderTooltip(
                                            disabled: true),
                                        handler: FlutterSliderHandler(
                                          decoration: BoxDecoration(),
                                          child: Container(),
                                        ),
                                        trackBar: FlutterSliderTrackBar(
                                          inactiveTrackBarHeight:
                                              getProportionateScreenWidth(70),
                                          activeTrackBarHeight:
                                              getProportionateScreenWidth(70),
                                          inactiveTrackBar: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          activeTrackBar: BoxDecoration(
                                            color: ColorTween(
                                                    begin: brightEndColor,
                                                    end: brightStartColor)
                                                .transform(led.pwm / 100),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/svgs/led_sun_off.svg",
                                width: 12,
                                height: 12,
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(30),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$title",
                              style: lightTitleFont,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(60),
                            ),
                            Text(
                              "${led.pwm.toInt()} %",
                              style: lightPercentFont,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(60),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
            ),
          ),
        );
      }),
    );
  }
}
