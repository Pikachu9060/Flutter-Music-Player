import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class Music extends ChangeNotifier {
  //all files
  List<FileSystemEntity> filesList;

  //all songs from _files variable
  List<FileSystemEntity> songsList;

  set songs(List<FileSystemEntity> list) => songsList = list;

  // ignore: non_constant_identifier_names
  Future<List<FileSystemEntity>> get Songs async {
    if (await Permission.storage.request() != null) {
      try {
        filesList = [];
        songsList = [];
        Directory dir = Directory('/storage/emulated/0/');

        filesList = dir.listSync(recursive: true, followLinks: false);

        //get only .mp3 file from _files variable
        for (FileSystemEntity entity in filesList) {
          if (entity.path.endsWith('.mp3')) {
            songsList.add(entity);
          }
        }
        // _songs.sort((a, b) => a.toString().);
      } catch (e) {
        songsList = [];
      }
    }

    // notifyListeners();
    songs = songsList;
    return Future.value(songsList);
    // return _songs;
  }

  //String variable for path
  @required
  String _path;

  Duration _songLength = new Duration(seconds: 0);

  // ignore: unnecessary_getters_setters
  Duration get songLength => _songLength;

  // ignore: unnecessary_getters_setters
  set songLength(Duration songLength) {
    _songLength = songLength;
    // notifyListeners();
  }

  Duration _songCurrentLength = new Duration(seconds: 0);

  // ignore: unnecessary_getters_setters
  Duration get songCurrentLength => _songCurrentLength;

  // ignore: unnecessary_getters_setters
  set songCurrentLength(Duration songCurrentLength) {
    _songCurrentLength = songCurrentLength;
    // notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  String get path => _path;

  // ignore: unnecessary_getters_setters
  set path(String path) {
    _path = path;
    notifyListeners();
  }

  int _songIndex;

  // ignore: unnecessary_getters_setters
  int get songIndex => _songIndex;

  // ignore: unnecessary_getters_setters
  set songIndex(int songIndex) {
    _songIndex = songIndex;
    notifyListeners();
  }

  bool _isPlaying = true;

  // ignore: unnecessary_getters_setters
  bool get isPlaying => _isPlaying;

  // ignore: unnecessary_getters_setters
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    // notifyListeners();
  }

  bool _isShuffle = false;

  bool get isShuffle => _isShuffle;

  set isShuffle(bool isShuffle) {
    _isShuffle = isShuffle;
    notifyListeners();
  }

  AudioPlayerState _state;

  AudioPlayerState get state => _state;

  set state(AudioPlayerState state) {
    _state = state;
    notifyListeners();
  }
}
