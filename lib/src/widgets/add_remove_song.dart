import 'package:apple_music/classes/playlist_class.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddOrRemoveSong extends StatefulWidget {
  const AddOrRemoveSong(
      {super.key,
      this.artistName,
      required this.songID,
      required this.songName,
      required this.isVideo,
      required this.image,
      required this.artistUri
      });

  final String? artistName;
  final String songID;
  final String songName;
  final bool isVideo;
  final String image;
  final String artistUri;

  @override
  State<AddOrRemoveSong> createState() => _AddOrRemoveSongState();
}

class _AddOrRemoveSongState extends State<AddOrRemoveSong> {
  bool isAddToPlaylist = false;

  @override
  Widget build(BuildContext context) {
    final playlistModel = Provider.of<PlayListModel>(context);
    return CupertinoButton(
        child: Icon(
            (!isAddToPlaylist)
                ? CupertinoIcons.add_circled
                : CupertinoIcons.check_mark,
            color: const Color.fromRGBO(255, 51, 91, 1)),
        onPressed: () {
          setState(() {
            isAddToPlaylist = !isAddToPlaylist;
          });

          if (isAddToPlaylist) {
              playlistModel.playlist.audioTracks.add(AudioTrack(
              artistUri: widget.artistUri,
              isVideo: widget.isVideo,
              image: widget.image,
              artistName: widget.artistName.toString(),
              songId: widget.songID,
              title: widget.songName,
            ));
           
          }
        });
  }
}
