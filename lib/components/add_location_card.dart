import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class AddLocationCard extends StatelessWidget {
  AddLocationCard({Key key, @required this.onPress, this.assetsName})
      : super(key: key);
  final Function onPress;
  final String assetsName;
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
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset("assets/svgs/plus.svg"),
                  Text(
                    "새로운 ${assetsName ?? "지역"} 추가하기",
                    style: cardInfoFont,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
