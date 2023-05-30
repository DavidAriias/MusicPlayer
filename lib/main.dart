import 'package:apple_music/src/models/artist_profile_model.dart';
import 'package:apple_music/src/models/audioplayer_model.dart';
import 'package:apple_music/src/models/library_model.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/playlist_section_expanded_model.dart';
import 'package:apple_music/src/models/results_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
        ChangeNotifierProvider(create: (_) => ResultsModel()),
        ChangeNotifierProvider(create : (_) => ArtistProfileModel()),
        ChangeNotifierProvider(create: (_) => LibraryModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => PlayListModel()),
        ChangeNotifierProvider(create: (_) => PlaylistSectionExpandendModel()),
      ],
      child: const MainApp())
  );
}

class MainApp extends StatelessWidget {
   const MainApp({super.key});

  
  @override
  Widget build(BuildContext context) {
  final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const Tabs(),      
    );
  }
}
