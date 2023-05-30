import 'package:apple_music/src/screens/album_view_expanded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumContainer extends StatelessWidget {
  const AlbumContainer({
    super.key,
    required this.urlImage,
    required this.title,
    required this.year,
    required this.albumUri,
    required this.artistUri
  });

  final String urlImage;
  final String title;
  final String year;
  final String albumUri;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => 
        AlbumViewExpandend(
          artistUri: artistUri,
          songName: "",
          urlImage: urlImage,
          albumName: title,
          albumUri: albumUri,
        )));
      },
      child: SizedBox(
        height: 300,
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
              placeholder: const AssetImage('assets/appleMusicError.jpg'), 
              image: NetworkImage(Uri.encodeFull(urlImage)),
              width: 160,
              height: 160,
            )
            ),
            Text(
              title,
              style:  TextStyle(
                fontSize : (title.length >= 60) ? 10 : 15 ,
              ),
              textAlign: TextAlign.left,
            ),
            Text(year,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}