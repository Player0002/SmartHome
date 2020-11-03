import 'package:flutter/material.dart';
import 'package:smarthome/constants/constants.dart';
import 'package:smarthome/model/sockets/Dth.dart';
import 'package:smarthome/model/sockets/Led.dart';
import 'package:smarthome/model/sockets/NeoPixel.dart';
import 'package:smarthome/model/sockets/Room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum Status { connection, connected, error }

class SocketProvider extends ChangeNotifier {
  IO.Socket _socket;
  IO.Socket get socket => _socket;

  Status status = Status.connection;
  Map<String, bool> device = {
    'room': false,
    'led': false,
    'dth': false,
    'dust': false,
    'waterStatus': false,
    'neoPixel': false,
  };

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;
  List<Led> _leds = [];
  List<Led> get leds => _leds;
  List<Dth> _dths = [];
  List<Dth> get dths => _dths;
  int _dust = 0;
  int get dust => _dust;
  bool _waterStatus = false;
  bool get waterStatus => _waterStatus;
  NeoPixel _neoPixel;
  NeoPixel get neoPixel => _neoPixel;

  bool get allComplete =>
      device.values.where((element) => element == true).length == device.length;

  void updateLed(int id, int newPwm) {
    int idx = _leds.indexOf(_leds.firstWhere((element) => element.id == id));
    _leds[idx] = Led(id: id, pwm: newPwm);
    notifyListeners();
    socket.emit("led", ({'room': id, 'pwm': newPwm}));
  }

  void updatePump(int id, bool newStatus) {
    _waterStatus = newStatus;
    print("UPDATE $id");
    notifyListeners();
    socket.emit('water_state', {'status': newStatus});
  }

  SocketProvider() {
    print("HERE");
    if (_socket != null) return;
    _socket = IO.io(serverIp, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.on('connect', (data) {
      print("Connected to server!");
      status = Status.connected;
      notifyListeners();

      socket.emit('change', 'android'); // Notify android connected
    });
    socket.on('add_sensor', (data) {
      final roomInfo = data['room'];
      final sensorInfo = data['updated'];
      //print(data);
      print("Current room");
      print(_rooms);
      int idx = _rooms.indexOf(
          _rooms.firstWhere((element) => element.id == roomInfo['id']));
      _rooms[idx] = Room.fromJson(roomInfo);
      if (sensorInfo['sensor'] == 'dust') {
        _dust = sensorInfo['initvalue'];
      }
      if (sensorInfo['sensor'] == 'neopixel') {
        _neoPixel = NeoPixel(
          id: sensorInfo['id'],
          r: sensorInfo['initvalue'],
          g: sensorInfo['initvalue'],
          b: sensorInfo['initvalue'],
        );
      }
      if (sensorInfo['sensor'] == 'pump') {
        _waterStatus = sensorInfo['initvalue'];
      }
      if (sensorInfo['sensor'] == 'servo') {
        //pass
      }
      if (sensorInfo['sensor'] == 'dth') {
        _dths.add(Dth(
            id: sensorInfo['id'],
            temp: sensorInfo['initvalue'] * 1.0,
            humi: 1.0 * sensorInfo['initvalue']));
      }
      if (sensorInfo['sensor'] == 'camera') {
        //pass
      }
      if (sensorInfo['sensor'] == 'led') {
        _leds.add(Led(id: sensorInfo['id'], pwm: sensorInfo['initvalue']));
        print("LED IS ADDED");
      }
      notifyListeners();
      // _rooms.forEach((element) {
      //   print("ELEMENT : ${element.id} / ROOMID : ${roomInfo['id']}");
      //   if (element.id == roomInfo['id']) {
      //     print("FIND");
      //     element =
      //
      //   }
      // });
      print("END FOREACH");
      rooms.forEach((element) {
        print("ID : ${element.id} , ${element.address}, ${element.led}");
      });
    });
    socket.on(
      'init',
      (data) {
        final obj = data;
        if (obj['room'] != null) {
          device['room'] = true;
          _rooms.clear();
          (obj['room'] as List<dynamic>).forEach((element) {
            _rooms.add(Room.fromJson(element));
          });
          notifyListeners();
        }
        if (obj['led'] != null) {
          device['led'] = true;
          _leds.clear();
          (obj['led'] as List<dynamic>).forEach((element) {
            _leds.add(Led.fromJson(element));
          });
          notifyListeners();
        }
        if (obj['dth'] != null) {
          device['dth'] = true;
          _dths.clear();
          (obj['dth'] as List<dynamic>).forEach((element) {
            _dths.add(Dth.fromJson(element));
          });
          notifyListeners();
        }
        if (obj['dust'] != null) {
          device['dust'] = true;
          _dust = obj['dust'];
          notifyListeners();
        }
        if (obj['waterStatus'] != null) {
          device['waterStatus'] = true;
          _waterStatus = obj['waterStatus'];
          notifyListeners();
        }
        if (obj['neoPixel'] != null) {
          device['neoPixel'] = true;
          _neoPixel = NeoPixel.fromJson(obj['neoPixel']);
          notifyListeners();
        }
        print("Receive Init data :");
        print(obj);
        print("\n");
      },
    );
    socket.connect();
  }
}
