class Dth {
  final int id;
  final double temp;
  final double humi;
  Dth({this.id, this.temp, this.humi});

  factory Dth.fromJson(Map<String, dynamic> map) => Dth(
        id: map['id'],
        temp: 1.0 * (map['temp'] ?? -127.0),
        humi: 1.0 * (map['humi'] ?? -127.0),
      );
}
