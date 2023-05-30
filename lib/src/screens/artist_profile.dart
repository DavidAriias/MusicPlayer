import 'dart:typed_data';
import 'package:apple_music/src/widgets/list_albums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:apple_music/services/service_artist_profile.dart';
import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:apple_music/src/models/artist_profile_model.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/artist_profile_sections_expanded.dart';
import 'package:apple_music/src/screens/click_without_sign_in.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/buttom_sheet_mix.dart';
import 'package:apple_music/src/widgets/loading_widget.dart';
import 'package:apple_music/src/widgets/music_videos_container.dart';
import 'package:apple_music/src/widgets/top_song_container.dart';


class ArtistProfilePage extends StatelessWidget {
  const ArtistProfilePage(
      {super.key,
      required this.urlImage,
      required this.artistUri,
      required this.artistName,
      required this.genre});

  final String urlImage;
  final String artistUri;
  final String artistName;
  final String genre;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userStatus = Provider.of<UserModel>(context);
    final playlistModel = Provider.of<PlayListModel>(context);
   
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: (playlistModel.isCreatingAPlaylist)? null :
      ButtomSheet(
        libraryOnPress: (){
          Navigator.pop(context);
        },
        listenNowOnPress: (){
          Navigator.pop(context);
        },
        searchOnPress: (){
          Navigator.pop(context);
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: (playlistModel.isCreatingAPlaylist) ? size.width : 56,
            leading: (playlistModel.isCreatingAPlaylist)
                ? CupertinoButton(
                    padding: const EdgeInsets.only(left: 10),
                    onPressed: () { 
                      
                      Navigator.pop(context);
                    },
                    child: Row(children: const [
                      Icon(CupertinoIcons.back,
                          color: Color.fromRGBO(255, 51, 91, 1)),
                      Text('Playlist',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 51, 91, 1),
                              fontSize: 20))
                    ]),
                  )
                : null,
            centerTitle: true,
            expandedHeight: size.height / 2.5,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              final top = constraints.biggest.height;
              return FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: top >= size.height / 5 ? 1.0 : 0.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          artistName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 25),
                        ),
                        (playlistModel.isCreatingAPlaylist)
                            ? _nothingBox()
                            : CupertinoButton(
                                onPressed: () {
                                  if (userStatus.isSignedIn) {
                                  } else {
                                    showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            const SignInScreenAd());
                                  }
                                },
                                minSize: 25,
                                padding: const EdgeInsets.all(0),
                                borderRadius: BorderRadius.circular(100),
                                color: const Color.fromRGBO(255, 51, 91, 1),
                                child: const Icon(
                                    CupertinoIcons.play_arrow_solid,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    size: 15),
                              )
                      ]),
                ),
                centerTitle: true,
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                collapseMode: CollapseMode.pin,
                stretchModes: const [StretchMode.zoomBackground],
                background: Image.network(
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.2),
                    fit: BoxFit.cover,
                    Uri.encodeFull(urlImage)),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: dataArtist(artistUri, artistName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: LoadingWidget());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return _ContainPage(
                      artistUri: artistUri,
                      data: snapshot.requireData,
                      genre: genre,
                      artistName: artistName);
                } else {
                  return const Center(
                    child: Text('Theres not internet'),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ContainPage extends StatefulWidget {
  const _ContainPage(
      {required this.data, required this.genre, required this.artistName,required this.artistUri});

  final List<Uint8List> data;
  final String genre;
  final String artistName;
  final String artistUri;

  @override
  State<_ContainPage> createState() => _ContainPageState();
}

class _ContainPageState extends State<_ContainPage> {
  @override
  Widget build(BuildContext context) {
    final index = widget.data.length - 1;
    final sectionExpanded = Provider.of<ArtistProfileModel>(context);

    List<TopSongs> topSongs = topSongsFromJson(widget.data[index - 6]);

    List<Albums> albums = albumsFromJson(widget.data[index - 5]);

    List<MusicVideos> musicVideos = musicVideosFromJson(widget.data[index - 4]);

    List<Albums> singles = albumsFromJson(widget.data[index - 3]);

    List<Albums> appearsOn = albumsFromJson(widget.data[index - 2]);

    About aboutContain = aboutFromJson(widget.data[index - 1]);

    List<SimilarArtist> similarArtist =
        similarArtistFromJson(widget.data[index]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ButtomTitle(
            label: 'Top Songs',
            onTap: () {
              if (topSongs.length > 8) {
                sectionExpanded.topSongs = topSongs;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TopSongsExpanded(
                        artistUri: widget.artistUri,
                        artistName: widget.artistName,
                      ),
                    ));
              }
            },
            showChevron: (topSongs.length > 8) ? true : false,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 0),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                SizedBox(
                  height: 330,
                  width: 350,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 0),
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey),
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: topSongs.length ~/ 2,
                    itemBuilder: (context, index) {
                      return TopSongContainer(
                          artistUri: widget.artistUri,
                          albumUri: topSongs[index].albumUri,
                          artist: widget.artistName,
                          songID: topSongs[index].url,
                          urlImage: topSongs[index].image,
                          title: topSongs[index].name,
                          subtitle:
                              "${topSongs[index].album}~${topSongs[index].release}");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                (topSongs.length > 4)
                    ? SizedBox(
                        height: 330,
                        width: 380,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 0),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.grey),
                          itemCount: topSongs.length - 6,
                          itemBuilder: (context, index) {
                            return TopSongContainer(
                                artistUri: widget.artistUri,
                                albumUri: topSongs[index + 4].albumUri,
                                artist: widget.artistName,
                                songID: topSongs[index + 4].url,
                                urlImage: topSongs[index + 4].image,
                                title: topSongs[index + 4].name,
                                subtitle:
                                    "${topSongs[index + 4].album} ~ ${topSongs[index + 4].release}");
                          },
                        ),
                      )
                    : _nothingBox()
              ],
            ),
          ),
          (albums.isNotEmpty) ? _SectionAlbums(albums: albums, artistUri: widget.artistUri,) : _nothingBox(),
          (musicVideos.isNotEmpty)
              ? _SectionMusicVideos(musicVideos: musicVideos, artistUri: widget.artistUri,)
              : _nothingBox(),
          (singles.isNotEmpty)
              ? _SectionSingles(singles: singles, artistUri: widget.artistUri)
              : _nothingBox(),
          (appearsOn.isNotEmpty)
              ? _SectionAppearsOn(appearsOn: appearsOn, artistUri: widget.artistUri)
              : _nothingBox(),
          AboutCard(text: aboutContain.summary),
          DataContainer(
              isSinger: aboutContain.isSinger,
              origin: aboutContain.origin,
              birthday: aboutContain.date,
              genre: widget.genre),
          _ButtomTitle(
              showChevron: true,
              label: 'Similar Artists',
              onTap: () {
                sectionExpanded.similarArtist = similarArtist;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          const SimilarArtistSectionExpanded(),
                    ));
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (context, index) => SimilarArtistContain(
                  urlImageArtist: similarArtist[index].image,
                  artistName: similarArtist[index].name,
                  uri: similarArtist[index].uri,
                  genre: similarArtist[index].genre,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SectionAppearsOn extends StatelessWidget {
  const _SectionAppearsOn({
    required this.appearsOn,
    required this.artistUri
  });

  final List<Albums> appearsOn;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final sectionExpanded = Provider.of<ArtistProfileModel>(context);
    return Column(
      children: [
        _ButtomTitle(
            showChevron: (appearsOn.length > 6) ? true : false,
            label: 'Appears On',
            onTap: () {
              if (appearsOn.length > 6) {
                sectionExpanded.albums = appearsOn;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AlbumSectionExpanded(title: 'Appears On', artistUri: artistUri),
                    ));
              }
            }),
        ListAlbums(albums: appearsOn, artistUri: artistUri),
      ],
    );
  }
}

class _SectionSingles extends StatelessWidget {
  const _SectionSingles({
    required this.singles,
    required this.artistUri
  });

  final List<Albums> singles;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final sectionExpanded = Provider.of<ArtistProfileModel>(context);
    return Column(
      children: [
        _ButtomTitle(
            showChevron: (singles.length > 6) ? true : false,
            label: 'Singles & EPs',
            onTap: () {
              if (singles.length > 6) {
                sectionExpanded.albums = singles;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AlbumSectionExpanded(title: 'Singles & EPs', artistUri: artistUri),
                    ));
              }
            }),
        ListAlbums(albums: singles, artistUri:artistUri),
      ],
    );
  }
}

class _SectionMusicVideos extends StatelessWidget {
  const _SectionMusicVideos({
    required this.musicVideos,
    required this.artistUri
  });

  final List<MusicVideos> musicVideos;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final sectionExpanded = Provider.of<ArtistProfileModel>(context);
    return Column(
      children: [
        _ButtomTitle(
            showChevron: (musicVideos.length > 8) ? true : false,
            label: 'Music Videos',
            onTap: () {
              if (musicVideos.length > 8) {
                sectionExpanded.musicVideos = musicVideos;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MusicVideosSectionExpanded(artistUri: artistUri),
                    ));
              }
            }),
        _ListMusicVideos(musicVideos: musicVideos, artistUri: artistUri),
      ],
    );
  }
}

class _SectionAlbums extends StatelessWidget {
  const _SectionAlbums({
    required this.albums, required this.artistUri,
  });

  final List<Albums> albums;
  final String artistUri;
  @override
  Widget build(BuildContext context) {
    final sectionExpanded = Provider.of<ArtistProfileModel>(context);
    return Column(
      children: [
        _ButtomTitle(
            showChevron: (albums.length > 6) ? true : false,
            label: 'Albums',
            onTap: () {
              if (albums.length > 6) {
                sectionExpanded.albums = albums;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AlbumSectionExpanded(title: 'Albums',artistUri: artistUri)
                    ));
              }
            }),
        ListAlbums(albums: albums, artistUri: artistUri),
      ],
    );
  }
}

class SimilarArtistContain extends StatelessWidget {
  const SimilarArtistContain(
      {super.key,
      required this.urlImageArtist,
      required this.artistName,
      required this.uri,
      required this.genre});

  final String urlImageArtist;
  final String artistName;
  final String uri;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ArtistProfilePage(
                            artistName: artistName,
                            artistUri: uri,
                            urlImage: urlImageArtist,
                            genre: genre,
                          )));
            },
            child: CircleAvatar(
              
              backgroundImage: NetworkImage(Uri.encodeFull(urlImageArtist)),
              radius: 60,
              backgroundColor: Colors.transparent,
            ),
          ),
          Text(artistName, style: const TextStyle(fontSize: 18))
        ],
      ),
    );
  }
}

class _ListMusicVideos extends StatelessWidget {
  const _ListMusicVideos({
    required this.musicVideos, required this.artistUri,
  });

  final List<MusicVideos> musicVideos;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: (musicVideos.length > 6) ? 6 : musicVideos.length,
          itemBuilder: (context, index) => VideoContainer(
              artistUri: artistUri,
              videoID: musicVideos[index].url,
              urlImage: musicVideos[index].thumbnailUrl,
              title: musicVideos[index].title,
              year: musicVideos[index].year),
        ),
      ),
    );
  }
}



class DataContainer extends StatelessWidget {
  const DataContainer(
      {super.key,
      required this.isSinger,
      required this.origin,
      required this.birthday,
      required this.genre});

  final bool isSinger;
  final String origin;
  final String birthday;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isSinger == true)
              ? const Text('HOMETOWN',
                  style: TextStyle(fontSize: 18, color: Colors.grey))
              : const Text('ORIGIN',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(origin, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          (isSinger == true)
              ? const Text('BORN',
                  style: TextStyle(fontSize: 18, color: Colors.grey))
              : const Text('FORMED',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(birthday, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          const Text('GENRE',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(genre, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class AboutCard extends StatelessWidget {
  const AboutCard({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 5),
            Text(text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
          ],
        ),
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
    final playlistModel = Provider.of<PlayListModel>(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisAlignment: (playlistModel.isCreatingAPlaylist)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
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
                : (playlistModel.isCreatingAPlaylist)
                    ? const Text(
                        'See All',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 51, 91, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )
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
