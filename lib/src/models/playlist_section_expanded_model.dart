import 'package:flutter/material.dart';

class PlaylistSectionExpandendModel with ChangeNotifier{

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  set isEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

}