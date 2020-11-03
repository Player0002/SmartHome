class Led {
  final int id;
  final int pwm;
  Led({this.id, this.pwm});

  factory Led.fromJson(Map<String, dynamic> map) => Led(
        id: map['id'],
        pwm: map['pwm'],
      );
}
