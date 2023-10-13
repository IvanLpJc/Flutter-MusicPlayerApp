import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _isPlaying = false;

  late AnimationController controller;

  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _current = const Duration(milliseconds: 0);

  String get songTotalDuration => printDuration(_songDuration);
  String get currentSecond => printDuration(_current);

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  Duration get songDuration => _songDuration;

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  Duration get current => _current;

  set current(Duration value) {
    _current = value;
    notifyListeners();
  }

  double get percentage => _songDuration.inSeconds > 0
      ? _current.inSeconds / _songDuration.inSeconds
      : 0;

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";

      return "0$n";
    }

    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitsMinutes:$twoDigitsSeconds";
  }
}
