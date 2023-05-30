import 'package:apple_music/classes/playlist_class.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier{

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  set isSignedIn(bool value) {
    _isSignedIn = value;
    notifyListeners();
  }

  String _email = "";

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String _password = "";

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool _errorSign = false;

  bool get errorSign => _errorSign;
  set errorSign(bool value){
    _errorSign = value;
    notifyListeners();
  }

  List<UserPlaylist> _playlists = [];

  List<UserPlaylist> get playlists => _playlists;
  set playlists(List<UserPlaylist> value){
    _playlists = value;
    notifyListeners();
  }

  UserPlaylist _playlist = UserPlaylist(namePlaylist: "", description: "", image: "", audioTracks: List.empty());

  UserPlaylist get playlist => _playlist;
  set playlist(UserPlaylist value){
    _playlist = value;
    notifyListeners();
  }

}