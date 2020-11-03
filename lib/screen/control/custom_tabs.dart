import 'package:flutter/material.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/utils/sizeconfig.dart';

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
