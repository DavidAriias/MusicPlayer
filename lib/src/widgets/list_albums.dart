import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:apple_music/src/widgets/album_container.dart';
import 'package:flutter/material.dart';

class ListAlbums extends StatelessWidget {
  const ListAlbums({super.key, 
    required this.albums, required this.artistUri,
  });

  final List<Albums> albums;
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
          itemCount: (albums.length > 6) ? 6 : albums.length,
          itemBuilder: (context, index) => AlbumContainer(
            artistUri: artistUri,
            albumUri: albums[index].uri,
            title: albums[index].name,
            urlImage: albums[index].image,
            year: albums[index].release,
          ),
        ),
      ),
    );
  }
}