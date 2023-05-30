import 'package:apple_music/classes/playlist_class.dart';
import 'package:flutter/material.dart';

class PlayListModel with ChangeNotifier{

  bool _isCreatingAPlaylist = false;

  bool get isCreatingAPlaylist => _isCreatingAPlaylist;

  set isCreatingAPlaylist(bool value) {
    _isCreatingAPlaylist = value;
    notifyListeners();
  }

  String _imageCover = "";
  String get imageCover => _imageCover;
  set imageCover(String value){
    _imageCover = value;
    notifyListeners();
  }


  
  UserPlaylist _playlist = UserPlaylist(  
   namePlaylist: "", description: "", audioTracks: [], image: "");

  UserPlaylist get playlist => _playlist;
  set playlist(UserPlaylist value){
    _playlist = value;
    notifyListeners();
  }

  List<AudioTrack> _saveTracks = [];

  List<AudioTrack> get saveTracks => _saveTracks;
  set saveTracks(List<AudioTrack> value) {
    _saveTracks = value;
    notifyListeners();
  }

}