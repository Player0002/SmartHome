import 'package:flutter/material.dart';

class NeoPixel {
  final int id;
  final int r;
  final int g;
  final int b;
  NeoPixel({this.id, this.r, this.g, this.b});

  factory NeoPixel.fromJson(Map<String, dynamic> map) => NeoPixel(
        id: map['id'],
        r: map['r'],
        g: map['g'],
        b: map['b'],
      );
  factory NeoPixel.fromColor(int id, Color color) =>
      NeoPixel(id: id, r: color.red, g: color.green, b: color.blue);
  Color get color => Color.fromARGB(255, r, g, b);
}
