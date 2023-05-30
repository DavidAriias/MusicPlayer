import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier{
  
  bool _dartTheme = false;

  ThemeData _currentTheme = ThemeData.light();


  bool get darkTheme => _dartTheme;
  
  set darkTheme (bool value){
    _dartTheme = value;

    if(value){
      _currentTheme =  ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }

    notifyListeners();
  }

  ThemeData get currentTheme => _currentTheme;

}