import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocket_quran/model/ayah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Position with ChangeNotifier {
  bool isConnected = false;

  PageController pageController;

  AudioPlayer audioPlayer = AudioPlayer();
  bool _audioIsPlay = false;
  String _url = 'https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/';

  AyahModel saved = AyahModel();

  int _position = 0;

  bool _isSaved = true;

  Color get colorSaved {
    return _isSaved ? Colors.amber[900] : Colors.grey[500];
  }

  Icon get iconSaved {
    return _isSaved ? Icon(Icons.star_rate) : Icon(Icons.star_rate);
  }

  Position() {
    setup();
  }

  void setup() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    saved.position = pref.getInt('IndexPosition') ?? 0;
    _position = saved.position;
    countProgressInJuz(_position);
    notifyListeners();
  }

  int get position => _position;
  set position(int value) {
    _position = value;
    print(_position);
    notifyListeners();
  }

  bool get isSaved => _isSaved;
  set isSaved(bool value) {
    _isSaved = value;
    notifyListeners();
  }

  void goToPage(int value) {
    print("gotopage");
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    print("success");
    notifyListeners();
  }

  void doAudio() {
    // _audioIsPlay = !_audioIsPlay;
    _audioIsPlay ? stopAudio() : playAudio();
    // notifyListeners();
  }

  playAudio() async {
    if (!isConnected) {
      return Fluttertoast.showToast(msg: 'Failed to connect');
    }
    _audioIsPlay = true;
    int result = await audioPlayer.play(_url + (_position + 1).toString());
    print('Trying to play audio');
    if (result != 1) {
      print('Failed to play audio');
      stopAudio();
      return Fluttertoast.showToast(msg: 'Failed to connect');
    }
    audioPlayer.onPlayerCompletion.listen((event) {
      print('ini callbacknya');
      stopAudio();
    });
    audioPlayer.onPlayerError.listen((msg) {
      print('Failed to play audio');
      stopAudio();
      return Fluttertoast.showToast(msg: 'Failed to connect');
    });
    notifyListeners();
  }

  stopAudio() async {
    _audioIsPlay = false;
    await audioPlayer.stop();
    notifyListeners();
  }

  Color get audioColor => _audioIsPlay ? Colors.amber[800] : Colors.amber;
  Icon get audioIcons =>
      _audioIsPlay ? Icon(Icons.stop) : Icon(Icons.play_arrow);

  countProgressInJuz(int number) async {
    for (var i = 1; i < 31; i++) {
      if (number < numberOfEveryJuz[i]) {
        double progress = (number - numberOfEveryJuz[i - 1]) /
            (numberOfEveryJuz[i] - numberOfEveryJuz[i - 1]);
        _currentProgress = progress;
        _currentJuz = i;
        print('current');
        print(_currentProgress);
        print(_currentJuz);

        notifyListeners();
        break;
      }
    }
  }

  double _currentProgress = 0.0;
  int _currentJuz = 0;

  double get currentProgress => _currentProgress;
  int get currentJuz => _currentJuz;

  List numberOfEveryJuz = [
    0,
    148,
    259,
    385,
    516,
    640,
    750,
    899,
    1041,
    1200,
    1327,
    1478,
    1648,
    1802,
    2029,
    2214,
    2483,
    2673,
    2875,
    3214,
    3385,
    3563,
    3732,
    4089,
    4264,
    4510,
    4705,
    5104,
    5241,
    5672,
    6236
  ];
}
