// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/provider/fcm_provider.dart';
import 'package:smarthome/provider/socket_provider.dart';
import 'package:smarthome/screen/connection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FcmProvider("token")),
        ChangeNotifierProvider.value(value: SocketProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ConnectionScreen(),
      ),
    ),
  );
}
