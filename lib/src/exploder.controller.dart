import 'package:flutter/material.dart';

class ExploderController extends ChangeNotifier {
  bool _trigger = false;
  bool _reset = false;
  bool _autoReset = false;
  Duration _autoResetDelay = const Duration(milliseconds: 500);

  bool get trigger => _trigger;
  bool get reset => _reset;
  bool get autoReset => _autoReset;
  Duration get autoResetDelay => _autoResetDelay;

  void setAutoReset(bool value, {Duration? delay}) {
    _autoReset = value;
    if (delay != null) {
      _autoResetDelay = delay;
    }
    notifyListeners();
  }

  void dissolve() {
    _trigger = true;
    notifyListeners();
  }

  void animationComplete() {
    if (_autoReset) {
      Future.delayed(_autoResetDelay, () {
        resetDissolver();
      });
    }
  }

  void resetDissolver() {
    _trigger = false;
    _reset = true;
    notifyListeners();

    Future.microtask(() {
      _reset = false;
      notifyListeners();
    });
  }

  void clearTrigger() {
    if (_trigger) {
      _trigger = false;
      notifyListeners();
    }
  }
}
