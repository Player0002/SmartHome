import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:smarthome/constants/colors.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:smarthome/utils/sizeconfig.dart';

import 'devices.dart';

class CameraModel extends Devices<String> {
  CameraModel(String link, bool status) {
    assetsLocation = "assets/svgs/cam.svg";
    currentState = status ? "ONLINE" : "OFFLINE";
    secondState = link;
  }
  String get title => "카메라";
  String get subtitle => "";

  Color getColor() {
    return currentState == "ONLINE" ? onlineTextColor : offlineTextColor;
  }

  VlcPlayerController controller;

  Widget toCard(BuildContext context, Room room, int index) {
    controller = VlcPlayerController(
      onInit: () {
        controller.play();
      },
    );
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: SizedBox(
            width: double.infinity,
            child: cams.containsKey(room.id)
                ? Container(
                    child: VlcPlayer(
                      aspectRatio: 16 / 9,
                      url: cams[room.id],
                      controller: controller,
                      placeholder: Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
                : Image.network(
                    '${serverIp.substring(0, serverIp.length - 5)}3000/image?url=sample_images_05.png',
                    loadingBuilder: (ctx, _, __) {
                      if (__ == null) return _;
                      return Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                              "${__.cumulativeBytesLoaded / 1024} / ${__.expectedTotalBytes / 1024} MB")
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
