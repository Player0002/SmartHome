// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/provider/fcm_provider.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/screen/connection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FcmProvider("token")),
        ChangeNotifierProvider.value(value: SocketProvider()),
      ],
      child: MaterialApp(
        home: ConnectionScreen(),
      ),
    ),
  );
}
