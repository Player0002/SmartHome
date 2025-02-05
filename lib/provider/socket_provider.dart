import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
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
    //'waterStatus': false,
    'neoPixel': false,
    'servo': false,
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

  bool _servo = false;
  bool get servo => _servo;

  NeoPixel _neoPixel;
  NeoPixel get neoPixel => _neoPixel;

  bool get allComplete =>
      device.values.where((element) => element == true).length == device.length;

  int errorCnt = 0;

  Timer _ledDebouncer;

  void updateLed(int id, int newPwm) {
    int idx = _leds.indexOf(_leds.firstWhere((element) => element.id == id));
    _leds[idx] = Led(id: id, pwm: newPwm);
    notifyListeners();
    if (_ledDebouncer?.isActive ?? false) _ledDebouncer.cancel();
    _ledDebouncer = Timer(
      Duration(milliseconds: 500),
      () {
        socket.emit("led", ({'room': id, 'pwm': newPwm}));
      },
    );
  }

  void updatePump(int id, bool newStatus) {
    _waterStatus = newStatus;
    notifyListeners();
    socket.emit('water_state', {'status': newStatus});
  }

  void updateServo(int id, bool newStatus) {
    _servo = newStatus;
    notifyListeners();
    socket.emit('servo', {'status': newStatus});
  }

  void updateNeoPixel(int id, Color color) {
    _neoPixel = NeoPixel.fromColor(id, color);
    notifyListeners();
    socket.emit('neopixel', {
      'r': color.red,
      'g': color.green,
      'b': color.blue,
      'status': !(color.red == 0 && color.green == 0 && color.blue == 0)
    });
  }

  SocketProvider() {
    if (_socket != null) return;
    _socket = IO.io(serverIp, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.on('dht', (data) {
      int idx =
          dths.indexOf(dths.where((element) => element.id == data['id']).first);
      if (idx == -1) return;
      if (data['humi'] == null) data['humi'] = -127.0;
      if (data['temp'] == null) data['temp'] = -127.0;
      if (data['humi'] == -127.0 || data['temp'] == -127.0)
        errorCnt = 1;
      else
        errorCnt = 0;
      _dths[idx] = Dth(
          id: data['id'], humi: data['humi'] * 1.0, temp: data['temp'] * 1.0);
      notifyListeners();
    });
    socket.on('dust', (data) {
      _dust = (data['dust']).toInt();
      notifyListeners();
    });
    socket.on('user_exit', (data) {
      SweetAlert.dialog(
        type: AlertType.ERROR,
        title: "Error",
        content: "Server disconnected",
        showCancel: false,
        confirmButtonText: "확인",
      ).then(
        (value) {
          SystemNavigator.pop();
          exit(0);
        },
      ).timeout(Duration(seconds: 2), onTimeout: () {
        SystemNavigator.pop();
        exit(0);
      });
    });
    socket.on('connect', (data) {
      status = Status.connected;
      notifyListeners();

      socket.emit('change', 'android'); // Notify android connected
    });
    socket.on('add_sensor', (data) {
      final roomInfo = data['room'];
      final sensorInfo = data['updated'];
      int idx = _rooms.indexOf(
          _rooms.firstWhere((element) => element.id == roomInfo['id']));
      _rooms[idx] = Room.fromJson(roomInfo);
      if (sensorInfo['sensor'] == 'dust') {
        _dust = sensorInfo['initvalue'];
      }
      if (sensorInfo['sensor'] == 'neopixel') {
        _neoPixel = NeoPixel(
          id: sensorInfo['id'],
          r: sensorInfo['initvalue']['r'],
          g: sensorInfo['initvalue']['g'],
          b: sensorInfo['initvalue']['b'],
        );
      }
      if (sensorInfo['sensor'] == 'pump') {
        _waterStatus = sensorInfo['initvalue'];
      }
      if (sensorInfo['sensor'] == 'servo') {
        _servo = sensorInfo['initvalue'];
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
      }
      notifyListeners();
      // _rooms.forEach((element) {
      //   if (element.id == roomInfo['id']) {
      //     element =
      //
      //   }
      // });
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
            if (element['humi'] == -127.0 || element['temp'] == -127.0)
              errorCnt = 1;
            else
              errorCnt = 0;
            _dths.add(Dth.fromJson(element));
          });
          notifyListeners();
        }
        if (obj['dust'] != null) {
          device['dust'] = true;
          _dust = obj['dust'];
          notifyListeners();
        }
        /*if (obj['waterStatus'] != null) {
          device['waterStatus'] = true;
          _waterStatus = obj['waterStatus'];
          notifyListeners();
        }*/
        if (obj['neoPixel'] != null) {
          device['neoPixel'] = true;
          _neoPixel = NeoPixel.fromJson(obj['neoPixel']);
          notifyListeners();
        }
        if (obj['servo'] != null) {
          device['servo'] = true;
          _servo = obj['servo']['status'];
          notifyListeners();
        }
      },
    );
    socket.connect();
  }
}
