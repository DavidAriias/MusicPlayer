import 'dart:math';
import 'dart:typed_data';

import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:apple_music/services/service_listen_now.dart';
import 'package:apple_music/src/models/artist_profile_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/artist_profile_sections_expanded.dart';
import 'package:apple_music/src/screens/login.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/list_albums.dart';
import 'package:apple_music/src/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/animation_pages.dart';

class ListenNowView extends StatelessWidget {
  const ListenNowView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userStatus = Provider.of<UserModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: 30),
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CupertinoSliverNavigationBar(
                  backgroundColor:
                      appTheme.currentTheme.scaffoldBackgroundColor,
                  padding: EdgeInsetsDirectional.zero,
                  largeTitle: Text('Listen now',
                      style: TextStyle(
                          color: (appTheme.darkTheme)
                              ? Colors.white
                              : Colors.black)),
                  trailing: CupertinoButton(
                    padding: const EdgeInsets.only(right: 16),
                    onPressed: () {
                      Navigator.push(context, routeAnimation(const Login()));
                    },
                    child: const Icon(CupertinoIcons.person_crop_circle,
                        color: Color.fromRGBO(255, 51, 91, 1), size: 45),
                  ),
                ),
              ],
          body: (!userStatus.isSignedIn)
              ? _UserNotLogin(size: size)
              : (userStatus.playlists.isEmpty)
                  ? _nothingBox()
                  : const _UserLogin()),
    );
  }
}

class _UserLogin extends StatelessWidget {
  const _UserLogin();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final indexPlaylists = Random().nextInt(user.playlists.length);
    final index =
        Random().nextInt(user.playlists[indexPlaylists].audioTracks.length);

    final recommendData =
        user.playlists[indexPlaylists].audioTracks[index].artistUri;
    final artistName =
        user.playlists[indexPlaylists].audioTracks[index].artistName;

    return FutureBuilder(
      future: recommendDataService(recommendData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else {
          return _ContainPage(
              preData: snapshot.requireData,
              artistUri: recommendData,
              artistName: artistName);
        }
      },
    );
  }
}

class _ContainPage extends StatelessWidget {
  const _ContainPage(
      {required this.preData,
      required this.artistUri,
      required this.artistName});

  final List<Uint8List> preData;
  final String artistUri;
  final String artistName;

  @override
  Widget build(BuildContext context) {
    final albums = albumsFromJson(preData[0]);
    final otherArtists = albumsFromJson(preData[1]);

    final sectionExpanded = Provider.of<ArtistProfileModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          _ButtomTitle(
              showChevron: (albums.length > 6) ? true : false,
              label: 'More By $artistName',
              onTap: () {
                if (albums.length > 6) {
                  sectionExpanded.albums = albums;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AlbumSectionExpanded(
                              title: 'More By $artistName',
                              artistUri: artistUri)));
                }
              }),
          ListAlbums(
            albums: albums,
            artistUri: artistUri,
          ),
          _ButtomTitle(
              showChevron: (albums.length > 6) ? true : false,
              label: 'Because you listen $artistName',
              onTap: () {
                if (albums.length > 6) {
                  sectionExpanded.albums = otherArtists;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AlbumSectionExpanded(
                              title: otherArtists.first.name, artistUri: "")));
                }
              }),
          ListAlbums(
            albums: otherArtists,
            artistUri: "",
          ),
        ],
      ),
    );
  }
}

class _ButtomTitle extends StatelessWidget {
  const _ButtomTitle({
    required this.showChevron,
    required this.label,
    required this.onTap,
  });

  final bool showChevron;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: (appTheme.darkTheme) ? Colors.white : Colors.black),
            ),
            (showChevron == false)
                ? _nothingBox()
                : const Icon(CupertinoIcons.chevron_forward,
                    color: Colors.grey, fill: 1),
          ],
        ),
      ),
    );
  }
}

SizedBox _nothingBox() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}

class _UserNotLogin extends StatelessWidget {
  const _UserNotLogin({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _Advertisment(
          size: size,
          gradient: const [Color.fromRGBO(255, 51, 91, 1), Colors.redAccent],
          color: Colors.white,
          textUp: '100 million songs to play or download. All ad-free',
          textDown: 'Enter now',
          urlImage:
              'https://logosmarcas.net/wp-content/uploads/2020/11/Apple-Music-Logo.png',
        ),
        _Advertisment(
            size: size,
            gradient: const [Colors.black, Colors.black87],
            textUp: 'Play anything with Siri',
            textDown: 'Try It Now',
            urlImage:
                'https://www.apple.com/v/homepod/k/images/overview/siri__czoibyic3byq_large_2x.png')
      ],
    );
  }
}

class _Advertisment extends StatelessWidget {
  const _Advertisment({
    required this.size,
    required this.gradient,
    required this.textUp,
    required this.textDown,
    required this.urlImage,
    this.color,
  });

  final Size size;
  final List<Color> gradient;
  final String textUp;
  final String textDown;
  final String urlImage;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 30,
          child: Container(
            width: size.width,
            height: size.height / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(textUp,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 30)),
                  Image.network(
                    errorBuilder: (context, error, stackTrace) {
                      return _nothingBox();
                    },
                      width: size.width / 1.5,
                      color: color,
                      Uri.encodeFull(urlImage)),
                  Text(textDown,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
