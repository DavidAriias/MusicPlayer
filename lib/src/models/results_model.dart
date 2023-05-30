import 'package:flutter/material.dart';
import '../../classes/results_class.dart';

class ResultsModel with ChangeNotifier{

  List<ArtistResult> _listArtist = [];

  List<ArtistResult> get listArtist => _listArtist;

  set listArtist(List<ArtistResult> list){
    _listArtist = list;
    notifyListeners();
  }

  String _placeholder = 'Artists,Songs,Lyrics, and More';

  String get placeholder => _placeholder;

  set placeholder (String value){
    _placeholder = value;
    notifyListeners();
  }

  bool _changeSlider = false;

  bool get changeSlider => _changeSlider;

  set changeSlider (bool value){
    _changeSlider = value;
    notifyListeners();
  }

  bool _getInfoLibrarySection = false;

  bool get infoLibrarySection => _getInfoLibrarySection;

  set infoLibrarySection (bool value){
    _getInfoLibrarySection = value;
    notifyListeners();
  }

  List<int> indexsPlaylist = [];

}