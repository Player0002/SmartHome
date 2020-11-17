import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/title_builder.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class LedControlScreenRefactor extends StatelessWidget {
  final bool isOk;
  final String title;
  final Room room;
  LedControlScreenRefactor({this.isOk, this.room, this.title});
  final _titleKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<SocketProvider>(builder: (ctx, item, _) {
      final led = item.leds[room.id - 1];
      final size = SizeConfig.screenWidth * 0.4;
      if (led == null) return CircularProgressIndicator();
      return Scaffold(
        backgroundColor: ColorTween(begin: Colors.white, end: lightFull)
            .transform(led.pwm / 100),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          getProportionateScreenWidth(20),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        key: _titleKey,
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            makeTitle(room.address),
                            makeSubtitle("현재 상태는 양호합니다"),
                            SizedBox(height: getProportionateScreenHeight(10)),
                          ],
                        ),
                      ),
                    ]..add(
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset:
                                      Offset((led.pwm * 1.15) + -(size / 2), 0),
                                  child: Hero(
                                    tag: "images조명1",
                                    child: SvgPicture.asset(
                                      'assets/svgs/led.svg',
                                      width: size + size / 2 * (led.pwm / 100),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(50),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
              ),
              Positioned(
                bottom: getProportionateScreenHeight(70),
                left: getProportionateScreenWidth(25),
                child: Row(
                  children: [
                    _buildStatus(
                      "전원",
                      Row(
                        children: [
                          _buildPowerView(led.pwm != 0),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          Text(
                            "${led.pwm == 0 ? "OFF" : "ON"}",
                            style: editCardSubtitleFont.copyWith(
                              color: led.pwm != 0
                                  ? onlineTextColor
                                  : offlineTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(60),
                    ),
                    _buildStatus(
                      "밝기",
                      Row(
                        children: [
                          Text(
                            "${led.pwm}%",
                            style: editCardSubtitleFont.copyWith(
                              color:
                                  /*led.pwm != 0
                                  ? onlineTextColor
                                  : offlineTextColor*/
                                  ColorTween(
                                          begin: offlineTextColor,
                                          end: onlineTextColor)
                                      .transform(led.pwm / 100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                width: getProportionateScreenWidth(70),
                height: SizeConfig.screenHeight,
                child: Container(
                  color: ColorTween(
                          begin: Colors.grey.withOpacity(0.1), end: sliderFull)
                      .transform(led.pwm / 100),
                  child: FlutterSlider(
                    axis: Axis.vertical,
                    min: 0,
                    max: 100,
                    values: [led.pwm * 1.0],
                    disabled: false,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      if (lowerValue.toInt() != led.pwm)
                        item.updateLed(
                          led.id,
                          lowerValue.toInt(),
                        );
                    },
                    rtl: true,
                    tooltip: FlutterSliderTooltip(
                      disabled: true,
                    ),
                    handler: FlutterSliderHandler(
                      disabled: true,
                      decoration: BoxDecoration(),
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    handlerHeight: 0,
                    touchSize: 5,
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBarHeight: getProportionateScreenWidth(35),
                      activeTrackBarHeight: getProportionateScreenWidth(35),
                      activeTrackBar: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      inactiveTrackBar: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPowerView(bool isOn) {
    return Container(
      width: getProportionateScreenWidth(20),
      height: getProportionateScreenWidth(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: statusBackColor,
      ),
      child: Center(
        child: Container(
          width: getProportionateScreenWidth(14),
          height: getProportionateScreenWidth(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: isOn ? onlineTextColor : offlineTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: cardTitleFont.copyWith(fontSize: 22),
        ),
        child
      ],
    );
  }
}
