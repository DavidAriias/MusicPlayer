import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/widgets/add_remove_song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoContainer extends StatelessWidget {
  const VideoContainer(
      {super.key,
      required this.videoID,
      required this.urlImage,
      required this.title,
      required this.year,
      required this.artistUri});

  final String urlImage;
  final String title;
  final String year;
  final String videoID;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    final playlistModel = Provider.of<PlayListModel>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      Image.network(errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/appleMusicError.jpg');
                  }, Uri.encodeFull(urlImage), width: 290)),
              (playlistModel.isCreatingAPlaylist)
                  ? Center(
                      child: AddOrRemoveSong(
                      artistUri: artistUri,
                      image: urlImage,
                      artistName: "",
                      isVideo: true,
                      songID: videoID,
                      songName: title,
                    ))
                  : _nothingBox(),
            ]),
            Text(title,
                style: TextStyle(fontSize: (title.length >= 60) ? 10 : 15),
                textAlign: TextAlign.left),
            Text(year,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
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
