import 'package:flutter/material.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/utils/sizeconfig.dart';

Widget makeTitle(String title, {TextStyle style}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
    child: Text(
      title,
      style: style ?? titleFont,
    ),
  );
}

Widget makeSubtitle(String subtitle) {
  return Padding(
    padding: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
    child: Text(
      subtitle,
      style: subtitleFont,
    ),
  );
}
