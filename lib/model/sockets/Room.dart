import 'package:flutter/material.dart';
import 'package:smarthome/components/add_location_card.dart';
import 'package:smarthome/constants/fonts.dart';
import 'package:smarthome/model/camera_model.dart';
import 'package:smarthome/model/devices.dart';
import 'package:smarthome/model/dust_model.dart';
import 'package:smarthome/model/pump_model.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/utils/sizeconfig.dart';

import '../gate_model.dart';
import '../led_model.dart';

class Room {
  final int id;
  final String address;
  final bool inside;
  final int dust;
  final int neopixel;
  final int pump;
  final int servo;
  final int dth;
  final int camera;
  final int led;

  Room(
      {this.id,
      this.address,
      this.inside,
      this.dust,
      this.neopixel,
      this.pump,
      this.servo,
      this.dth,
      this.camera,
      this.led});
  factory Room.fromJson(Map<String, dynamic> map) => Room(
        id: map['id'],
        address: map['name'],
        inside: map['inside'],
        dust: map['dust'],
        neopixel: map['neopixel'],
        pump: map['pump'],
        servo: map['servo'],
        dth: map['dth'],
        camera: map['camera'],
        led: map['led'],
      );
  //64 to 1
  List<Devices> toCards(SocketProvider provider) {
    List<Devices> devices = [];
    if (dust > 0)
      for (int i = 0; i < dust; i++) devices.add(DustModel(provider.dust));
    //if (neopixel > 0) for(int i = 0; i < neopixel; i ++)devices.add(NeoPixel());
    if (pump > 0)
      for (int i = 0; i < pump; i++)
        devices.add(PumpModel(provider.waterStatus));
    if (servo > 0)
      for (int i = 0; i < servo; i++) devices.add(GateModel(false));
    //if(dth > 0) for(int i = 0; i < dth; i ++)devices.add(DTHModel());
    if (camera > 0)
      for (int i = 0; i < camera; i++) devices.add(CameraModel("link", false));
    if (led > 0)
      for (int i = 0; i < led; i++)
        devices.add(
            LedModel(provider.leds.firstWhere((element) => element.id == id)));
    return devices;
  }

  List<Widget> buildWidget(SocketProvider provider, BuildContext context) {
    List<Widget> widget = [];
    List<Devices> currentCard = toCards(provider);
    if (camera > 0) {
      final cards =
          currentCard.where((element) => element is CameraModel).toList();
      widget.add(_makeWidget(cards, "카메라", context, provider));
    }
    if (led > 0) {
      final cards =
          currentCard.where((element) => element is LedModel).toList();
      widget.add(_makeWidget(cards, "조명", context, provider));
    }
    if (pump > 0) {
      final cards =
          currentCard.where((element) => element is PumpModel).toList();
      widget.add(_makeWidget(cards, "펌프", context, provider));
    }
    if (servo > 0) {
      final cards =
          currentCard.where((element) => element is GateModel).toList();
      widget.add(_makeWidget(cards, "게이트", context, provider));
    }
    if (dth > 0) {
      /*final cards =
          currentCard.where((element) => element is DthModel).toList();
      widget.add(_makeWidget(cards, "온습도", context, provider));*/
    }
    if (neopixel > 0) {
      /* final cards =
          currentCard.where((element) => element is NeoPixelModel).toList();
      widget.add(_makeWidget(cards, "네오픽셀", context, provider));*/
    }
    if (dust > 0) {
      final cards =
          currentCard.where((element) => element is DustModel).toList();
      widget.add(_makeWidget(cards, "미세먼지", context, provider));
    }
    return widget;
  }

  Widget _makeWidget(List<Devices> cards, String title, BuildContext context,
      SocketProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: Text(title, style: editTitleFont),
        ),
      ]
        ..addAll(
          List.generate(
            cards.length,
            (index) => cards[index].toCard(context, this, index + 1),
          ),
        )
        ..add(
          AddLocationCard(
            onPress: () {},
            assetsName: title,
          ),
        ),
    );
  }

  getCounts() {
    int cnt = 0;
    if (dust > 0) cnt++;
    if (neopixel > 0) cnt++;
    if (pump > 0) cnt++;
    if (servo > 0) cnt++;
    if (dth > 0) cnt++;
    if (camera > 0) cnt++;
    if (led > 0) cnt++;
    return cnt;
  }
}
