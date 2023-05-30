
import 'package:apple_music/classes/playlist_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AudioPlayerModel with ChangeNotifier{

  bool _playing = false;
  
  
  bool get playing  => _playing;
  set playing (bool value){
    _playing = value;
    notifyListeners();
  }

  Duration _finalDuration = Duration.zero;

  Duration get finalDuration => _finalDuration;
  set finalDuration (Duration value){
    _finalDuration = value;
    notifyListeners();
  }

  Duration _currentDuration = Duration.zero;

  Duration get currentDuration => _currentDuration;
  set currentDuration (Duration value){
    _currentDuration = value;
    notifyListeners();
  }


  String _songID = "";

  String get songID => _songID;
  set songID (String value){
    _songID = value;
    notifyListeners();
  }

  bool _isTouched = false;

  bool get isTouched => _isTouched;
  set isTouched (bool value){
    _isTouched = value;
    notifyListeners();
  }

  int _volume = 0;
  int get volume => _volume;
  set volume (int value){
    _volume = value;
    notifyListeners();
  }

  bool _isVideo = false;
  bool get isVideo => _isVideo;
  set isVideo (bool value){
    _isVideo = value;
    notifyListeners();
  }

  String _songName = "";
  String get songName => _songName;
  set songName (String value){
    _songName = value;
    notifyListeners();
  }

  String _artistName = "";
  String get artistName => _artistName;
  set artistName (String value){
    _artistName = value;
    notifyListeners();
  }

  String _image = "";
  String get image => _image;
  set image (String value){
    _image  = value;
    notifyListeners();
  }

  String _albumName = "";
  String get albumName => _albumName;
  set albumName (String value){
    _albumName  = value;
    notifyListeners();
  }

   YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',

    );

  YoutubePlayerController get controller => _controller;
  set controller (YoutubePlayerController value){
    _controller = value;
    notifyListeners();
  }

  List<AudioTrack> _listeningTrack = [];

  List<AudioTrack> get listeningTrack => _listeningTrack;

  set listeningTrack(List<AudioTrack> value){
    _listeningTrack = value;
    notifyListeners();
  }

 int _currentSongPlaylist = 0;

 int get currentSongPlaylist => _currentSongPlaylist;

 set currentSongPlaylist(int value){
  _currentSongPlaylist = value;
  notifyListeners();
 }
  

}