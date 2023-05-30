import 'package:flutter/cupertino.dart';

class LibraryModel with ChangeNotifier{

  bool _isEditBottonClicked = false;

  bool get isEditBottonClicked => _isEditBottonClicked;

  set isEditBottonClicked(bool value) {
    _isEditBottonClicked = value;
    notifyListeners();
  }
}