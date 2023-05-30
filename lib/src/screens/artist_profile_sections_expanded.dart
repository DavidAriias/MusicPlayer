import 'package:apple_music/src/models/artist_profile_model.dart';
import 'package:apple_music/src/screens/artist_profile.dart';
import 'package:apple_music/src/widgets/album_container.dart';
import 'package:apple_music/src/widgets/music_videos_container.dart';
import 'package:apple_music/src/widgets/top_song_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/themes.dart';

class TopSongsExpanded extends StatelessWidget {
  const TopSongsExpanded({super.key, required this.artistName, required this.artistUri});

  final String artistName;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final list = Provider.of<ArtistProfileModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
          leading: CupertinoButton(
              padding: EdgeInsetsDirectional.zero,
              child: const Icon(CupertinoIcons.back,
                  color: Color.fromRGBO(255, 51, 91, 1)),
              onPressed: () => Navigator.pop(context)),
          middle: const Text('Top songs'),
        ),
      body: CustomScrollView(
        
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(color: CupertinoColors.systemGrey),
                padding: const EdgeInsets.only(top: 0),
                physics: const BouncingScrollPhysics(),
                itemCount: list.topSongs.length,
                itemBuilder: (context, index) {
                  return TopSongContainer(
                    artistUri: artistUri,
                    albumUri: list.topSongs[index].albumUri,
                    artist: artistName,
                    songID: list.topSongs[index].url,
                    urlImage: list.topSongs[index].image,
                    title: list.topSongs[index].name,
                    subtitle:
                        "${list.topSongs[index].album}~${list.topSongs[index].release}",
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlbumSectionExpanded extends StatelessWidget {
  const AlbumSectionExpanded({super.key, required this.title, required this.artistUri});

  final String title;
  final String artistUri;
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ArtistProfileModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
          leading: CupertinoButton(
              padding: EdgeInsetsDirectional.zero,
              child: const Icon(CupertinoIcons.back,
                  color: Color.fromRGBO(255, 51, 91, 1)),
              onPressed: () => Navigator.pop(context)),
          middle: Text(title, style: TextStyle(color: (appTheme.darkTheme)? Colors.white: Colors.black),),
        ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
         
          _GridAlbums(list: list, artistUri:artistUri)
        ],
      ),
    );
  }
}

class _GridAlbums extends StatelessWidget {
  const _GridAlbums({
    required this.list,
    required this.artistUri
  });

  final ArtistProfileModel list;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: list.albums.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 240,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: AlbumContainer(
          artistUri: artistUri,
            albumUri: list.albums[index].uri,
            urlImage: list.albums[index].image,
            title: list.albums[index].name,
            year: list.albums[index].release),
      ),
    );
  }
}

class MusicVideosSectionExpanded extends StatelessWidget {
  const MusicVideosSectionExpanded({super.key, required this.artistUri});

  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
          leading: CupertinoButton(
              padding: EdgeInsetsDirectional.zero,
              child: const Icon(CupertinoIcons.back,
                  color: Color.fromRGBO(255, 51, 91, 1)),
              onPressed: () => Navigator.pop(context)),
          middle: const Text('Music Videos'),
        ),
        body: CustomScrollView(
      slivers: [
         _GridMusicVideos(artistUri: artistUri)
      ],
    ));
  }
}

class _GridMusicVideos extends StatelessWidget {
  const _GridMusicVideos({required this.artistUri});

  final String artistUri;
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ArtistProfileModel>(context);
    return SliverGrid.builder(
      itemCount: list.musicVideos.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 240,
      ),
      itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: VideoContainer(
            artistUri: artistUri,
            videoID: list.musicVideos[index].url,
            title: list.musicVideos[index].title,
            urlImage: list.musicVideos[index].thumbnailUrl,
            year: list.musicVideos[index].year,
          )),
    );
  }
}

class SongsAlbumSectionExpanded extends StatelessWidget {
  const SongsAlbumSectionExpanded({super.key, required this.albumName, required this.artistUri});

  final String albumName;
  final String artistUri;
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
          leading: CupertinoButton(
              padding: EdgeInsetsDirectional.zero,
              child: const Icon(CupertinoIcons.back,
                  color: Color.fromRGBO(255, 51, 91, 1)),
              onPressed: () => Navigator.pop(context)),
          middle: Text(albumName),
        ),
        body:  CustomScrollView(
          slivers: [_GridMusicVideos(artistUri: artistUri)],
        ));
  }
}

class SimilarArtistSectionExpanded extends StatelessWidget {
  const SimilarArtistSectionExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ArtistProfileModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
            padding: EdgeInsetsDirectional.zero,
            child: const Icon(CupertinoIcons.back,
                color: Color.fromRGBO(255, 51, 91, 1)),
            onPressed: () => Navigator.pop(context)),
        middle: const Text('Similar Artists'),
      ),
      body: SizedBox(
        height: size.height,
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              const Divider(color: CupertinoColors.systemGrey),
          padding: const EdgeInsets.only(top: 0),
          physics: const BouncingScrollPhysics(),
          itemCount: list.similarArtist.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ArtistProfilePage(
                            artistName: list.similarArtist[index].name,
                            artistUri: list.similarArtist[index].uri,
                            urlImage: list.similarArtist[index].image,
                            genre: list.similarArtist[index].genre,
                          ))),
              style: ListTileStyle.list,
              contentPadding: EdgeInsetsDirectional.zero,
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(list.similarArtist[index].image),
              ),
              title: Text(list.similarArtist[index].name),
              trailing: CupertinoButton(
                onPressed: () {},
                child: const Icon(
                  CupertinoIcons.chevron_right,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
