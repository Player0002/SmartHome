import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/components/success_view.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/screen/main_screen.dart';
import 'package:smarthome/utils/sizeconfig.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex;
  AnimationController controller;
  Animation<Offset> _translationAnim;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    currentIndex = 0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _translationAnim =
        Tween(begin: Offset(0, 0), end: Offset(500, 0)).animate(controller)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemProvider = Provider.of<SocketProvider>(context);
    var item = itemProvider.device.keys
        .where((element) => itemProvider.device[element] == false)
        .toList();
    print(item);
    SizeConfig().init(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.forward().whenComplete(() {
        setState(() {
          print("Called! $currentIndex");
          controller.reset();
          /*var item = itemProvider.device.keys
                .where((element) => itemProvider.device[element] == false)
                .toList();
            itemProvider.device[item[0]] = true;*/
          //currentIndex += 1;
        });
      });
    });

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(20)),
              child: Stack(
                  children: List.generate(
                      itemProvider.device.length,
                      (index) => Positioned(
                            top: getProportionateScreenHeight(30) * index,
                            left: 10,
                            child: Container(
                              height: getProportionateScreenHeight(30),
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: SvgPicture.asset(assetLocation[
                                        itemProvider.device.keys
                                            .toList()[index]]),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Text(
                                    itemProvider.device.values.toList()[index]
                                        ? "연결됨"
                                        : "연결중",
                                    style: subtitleFont.copyWith(
                                      color: itemProvider.device.values
                                              .toList()[index]
                                          ? onlineTextColor
                                          : offlineTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ..addAll(
                      [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: item.length > 0
                                ? List.generate(
                                    item.length,
                                    (i) {
                                      int index = item.length - 1 - i;
                                      final currentItem = item.toList()[index];
                                      return Transform.translate(
                                        offset: _getTranslationFromIndex(index),
                                        child: FractionalTranslation(
                                          translation:
                                              _getPositionFromIndex(index),
                                          child: Transform.scale(
                                            scale: _getScaleFromIndex(index),
                                            child: LoadingCard(
                                              name: currentItem,
                                              assetsLink:
                                                  assetLocation[currentItem],
                                              status: itemProvider
                                                      .device[currentItem]
                                                  ? "연결됨"
                                                  : "연결중",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : [
                                    SuccessView(
                                      callback: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    MainScreen()));
                                      },
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    )),
            ),
          ),
        ),
      ),
    );
  }

  _getTranslationFromIndex(int index) {
    if (index == currentIndex)
      return _translationAnim.value;
    else
      return Offset(0, 0);
  }

  _getScaleFromIndex(int index) {
    int diff = index - currentIndex;
    if (index == currentIndex)
      return 1.0;
    else if (index == currentIndex + 1)
      return (1 - (0.025 * diff.abs()));
    else
      return (1 - (0.025 * diff.abs()));
  }

  _getPositionFromIndex(int index) {
    int diff = index - currentIndex;
    if (index == currentIndex + 1)
      return Offset(0.0, 0.05);
    else if (diff > 0 && diff <= 3)
      return Offset(0.0, 0.05 * diff);
    else
      return Offset(0, 0);
  }
}

class LoadingCard extends StatelessWidget {
  final String name;
  final String status;
  final String assetsLink;
  LoadingCard(
      {@required this.name, @required this.status, @required this.assetsLink});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(150),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(40),
          vertical: getProportionateScreenHeight(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x20000000),
                offset: Offset(0, 2),
                blurRadius: 9,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(30)),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.asset(assetsLink),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: cardTitleFont,
                        ),
                        Text(
                          status,
                          style: cardSubtitleFont,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
