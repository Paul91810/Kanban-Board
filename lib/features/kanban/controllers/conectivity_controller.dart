import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool isOnline = true;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
  }
}
