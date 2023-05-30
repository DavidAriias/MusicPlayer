import 'package:apple_music/src/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/create_playlist.dart';
import 'package:apple_music/src/screens/playlist_screen_expanded.dart';


class LibrarySectionPlaylist extends StatelessWidget {
  const LibrarySectionPlaylist({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => const [
                  _AppBarCustom()
                ],
            body: const _ListViewPlaylist()));
  }
}

class _ListViewPlaylist extends StatelessWidget {
  const _ListViewPlaylist();


  @override
  Widget build(BuildContext context) {
    final userStatus = Provider.of<UserModel>(context);
    
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context);
    return SizedBox(
      height: size.height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => (index == 0)
              ? const _ListTitleCreatePlaylist()
              : _ListTitlePlaylistFromUser(userStatus: userStatus, appTheme: appTheme,index: index),
          itemCount: userStatus.playlists.length + 1),
    );
  }
}

class _ListTitlePlaylistFromUser extends StatelessWidget {
  const _ListTitlePlaylistFromUser({
    required this.userStatus,
    required this.appTheme, required this.index,
  });

  final UserModel userStatus;
  final ThemeChanger appTheme;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: () {
        
        userStatus.playlist.namePlaylist = userStatus.playlists[index - 1].namePlaylist;
        userStatus.playlist.description = userStatus.playlists[index - 1].description;
        userStatus.playlist.image = userStatus.playlists[index - 1].image;
        userStatus.playlist.audioTracks = userStatus.playlists[index - 1].audioTracks;
        userStatus.playlist.idUser = userStatus.playlists[index - 1].idUser;
        userStatus.playlist.id = userStatus.playlists[index - 1].id;
        Navigator.push(context, CupertinoPageRoute(builder: (context) => const PlaylistScreenExpandend()));
      },
      padding: const  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      leadingSize: 100,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/appleMusicError.jpg');
          },
          Uri.encodeFull(userStatus.playlists[index - 1].image)
        ),
      ),
        title: Text(
          userStatus.playlists[index - 1].namePlaylist,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20,color:(appTheme.darkTheme)? Colors.white: Colors.black),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward,
            color: CupertinoColors.systemGrey),
      );
  }
}

class _ListTitleCreatePlaylist extends StatelessWidget {
  const _ListTitleCreatePlaylist();

  @override
  Widget build(BuildContext context) {
    final playlist = Provider.of<PlayListModel>(context);
    return CupertinoListTile(
      padding: const  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      leadingSize: 100,
        onTap: () {
          playlist.playlist.audioTracks = [];
          playlist.imageCover = "";
          Navigator.push(context, CupertinoPageRoute(builder: (context) => const CreatePlaylistScreen(),));
        },
        leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                  colors: [ Color.fromARGB(255, 207, 195, 243),Color(0xfff3e7ea)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            height: 100,
            width: 100,
            child:  Icon(CupertinoIcons.add,
                color: Colors.purple.shade200,size: 50)),
          title: const Text('New Playlist', style: TextStyle(color: Color.fromRGBO(255, 51, 91, 1),fontWeight: FontWeight.w500,fontSize: 20)),
      );
  }
}

class _AppBarCustom extends StatelessWidget {
  const _AppBarCustom();



  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return CupertinoSliverNavigationBar(
      backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
      leading: CupertinoButton(
        padding: EdgeInsetsDirectional.zero,
        onPressed: () => Navigator.pop(context),
        child: Row(children: const [
          Icon(CupertinoIcons.back,
              color: Color.fromRGBO(255, 51, 91, 1)),
          Text('Library',
              style: TextStyle(
                  color: Color.fromRGBO(255, 51, 91, 1)))
        ]),
      ),
      largeTitle: Text('Playlists', style: TextStyle(color:(appTheme.darkTheme)? Colors.white: Colors.black),),
    );
  }
}
