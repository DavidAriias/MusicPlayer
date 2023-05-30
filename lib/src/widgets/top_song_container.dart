import 'package:apple_music/src/models/audioplayer_model.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/widgets/add_remove_song.dart';
import 'package:apple_music/src/screens/album_view_expanded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TopSongContainer extends StatefulWidget {
  const TopSongContainer(
      {super.key,
      required this.urlImage,
      required this.title,
      required this.subtitle,
      required this.songID,
      required this.artist,
      required this.albumUri,
      required this.artistUri
      });

  final String urlImage;
  final String title;
  final String subtitle;
  final String songID;
  final String artist;
  final String albumUri;
  final String artistUri;

  @override
  State<TopSongContainer> createState() => _TopSongContainerState();
}

class _TopSongContainerState extends State<TopSongContainer> {
  late YoutubePlayerController _controllerYoutube;

  @override
  void initState() {
    _controllerYoutube = YoutubePlayerController(
      initialVideoId: widget.songID,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideThumbnail: true,
        hideControls: true,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerModel>(context);
    final userStatus = Provider.of<UserModel>(context);
    final playlistModel = Provider.of<PlayListModel>(context);

    return SizedBox(
      width: 380,
      child: ListTile(
        onTap: () {
          if(userStatus.isSignedIn){
            audioPlayer.songID = widget.songID;
          audioPlayer.image = widget.urlImage;
          audioPlayer.albumName = widget.subtitle;
          audioPlayer.songName = widget.title;
          audioPlayer.isTouched = true;
          audioPlayer.isVideo = false;
          audioPlayer.artistName = widget.artist;
          audioPlayer.controller = _controllerYoutube;
          }
        },
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              placeholder: const AssetImage('assets/appleMusicError.jpg'), 
              image: NetworkImage(Uri.encodeFull(widget.urlImage)),
              width: 50,
              height: 50,
            )
        ),
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        trailing: (playlistModel.isCreatingAPlaylist)
            ? AddOrRemoveSong(
              artistUri: widget.artistUri,
              image: widget.urlImage,
              isVideo: false,
               artistName: widget.artist,
               songID: widget.songID,
               songName: widget.title,
            )
            : CupertinoContextMenu(
                actions: [
                  CupertinoContextMenuAction(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AlbumViewExpandend(
                                    artistUri: widget.artistUri,
                                    songName: widget.title,
                                    albumName: widget.subtitle,
                                    albumUri: widget.albumUri,
                                    urlImage: widget.urlImage,
                                  )));
                    },
                    trailingIcon: CupertinoIcons.music_note_list,
                    child: const Text('Show album'),
                  ),
                ],
                child: const Icon(CupertinoIcons.ellipsis,
                    color: CupertinoColors.systemGrey),
              ),
      ),
    );
  }
}


