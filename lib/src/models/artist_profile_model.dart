
import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:flutter/material.dart';

class ArtistProfileModel extends ChangeNotifier{

  List<TopSongs> _topSongs = [];

  List<TopSongs> get topSongs => _topSongs;

  set topSongs (List<TopSongs> value){
    _topSongs = value;
    notifyListeners();
  }

  List<Albums> _albums = [];

  List<Albums> get albums => _albums;

  set albums (List<Albums> value){
    _albums = value;
    notifyListeners();
  }

  List<MusicVideos> _musicVideos = [];

  List<MusicVideos> get musicVideos => _musicVideos;

  set musicVideos (List<MusicVideos> value){
    _musicVideos = value;
    notifyListeners();
  }

  List<SimilarArtist> _similarArtist = [];

  List<SimilarArtist> get similarArtist => _similarArtist;

  set similarArtist (List<SimilarArtist> value){
    _similarArtist = value;
    notifyListeners();
  }


}