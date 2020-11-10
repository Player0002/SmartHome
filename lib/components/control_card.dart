import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class ControlCard<T> extends StatelessWidget {
  ControlCard(
      {Key key,
      @required this.onPress,
      @required this.assetLocation,
      @required this.title,
      @required this.index,
      @required this.subtitle,
      @required this.value,
      this.value2,
      @required this.hasPercent,
      @required this.status,
      @required this.color})
      : super(key: key);
  final Function onPress;
  final String assetLocation;
  final String title;
  final String subtitle;
  final T value;
  final T value2;
  final bool hasPercent;
  final int index;
  final bool status;
  final Color color;
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
          height: getProportionateScreenHeight(120),
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
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: SvgPicture.asset(assetLocation),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$title $index",
                          style: editCardTitleFont,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(TextSpan(
                                  text: title == "온습도" ? "온도 : " : "상태 : ",
                                  style: editCardSubtitleFont,
                                  children: [
                                    TextSpan(
                                      text: title == "온습도"
                                          ? "$value2 ℃"
                                          : status
                                              ? "연결됨"
                                              : "연결실패",
                                      style: editCardSubtitleFont.copyWith(
                                          color: title == "온습도"
                                              ? onlineTextColor
                                              : status
                                                  ? onlineTextColor
                                                  : offlineTextColor),
                                    )
                                  ])),
                              SizedBox(
                                width: getProportionateScreenWidth(20),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: "$subtitle : ",
                                  style: editCardSubtitleFont,
                                  children: [
                                    TextSpan(
                                      text: value is Color
                                          ? "■"
                                          : title == "온습도"
                                              ? "$value %"
                                              : "$value ${hasPercent ? "%" : ""}",
                                      style: value is Color
                                          ? editCardTitleFont.copyWith(
                                              color: value as Color)
                                          : editCardSubtitleFont.copyWith(
                                              color: color,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
