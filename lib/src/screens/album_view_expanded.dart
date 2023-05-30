import 'dart:typed_data';

import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:apple_music/services/service_artist_profile.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/widgets/add_remove_song.dart';
import 'package:apple_music/src/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumViewExpandend extends StatelessWidget {
  const AlbumViewExpandend(
    {super.key,required this.songName, required this.albumName, required this.urlImage, required this.albumUri, required this.artistUri});

  final String albumName;
  final String urlImage;
  final String albumUri;
  final String songName;
  final String artistUri;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Color.fromRGBO(255, 51, 91, 1))),
        middle: Text(albumName),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
          
            child: FutureBuilder(
              future: albumDataContain(albumUri),
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const LoadingWidget();
              } else {
                return _ContainPage(
                  artistUri: artistUri,
                  urlImage: urlImage, 
                  albumName: albumName,
                  preData: snapshot.requireData, 
                  songName: songName);
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
  const _ContainPage({
    required this.urlImage,
    required this.albumName, required this.preData,
    required this.songName, required this.artistUri
  });

  final String urlImage;
  final String albumName;
  final Uint8List preData;
  final String songName;
  final String artistUri;

  @override
  State<_ContainPage> createState() => _ContainPageState();
}

class _ContainPageState extends State<_ContainPage> {
  bool isAddToPlaylist = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = albumTracksFromJson(widget.preData);
    final playlistModel = Provider.of<PlayListModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
              placeholder: const AssetImage('assets/appleMusicError.jpg'), 
              image: NetworkImage(Uri.encodeFull(widget.urlImage)),
              width: 250,
              height: 250,
            ),
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.albumName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          const SizedBox(height: 5),
          Text(data.artist, style: const TextStyle(color:  Color.fromRGBO(255, 51, 91,1), fontSize: 18)),
          const SizedBox(height: 10),
          (playlistModel.isCreatingAPlaylist)? _nothingBox():CupertinoButton(
            borderRadius: BorderRadius.circular(10),
            color: CupertinoColors.systemGrey5,
            child: SizedBox(
              width: size.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.play_arrow_solid, color:  Color.fromRGBO(255, 51, 91,1)),
                  Text('Play', style: TextStyle(color:  Color.fromRGBO(255, 51, 91,1),fontWeight: FontWeight.w600,fontSize: 15))
                ],
              ),
            ), 
            onPressed: (){}
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: size.height,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
               separatorBuilder: (context, index) => const Divider(color: CupertinoColors.systemGrey), 
               itemCount: data.data.length,
               itemBuilder: (context, index) => CupertinoListTile(
                backgroundColor: (widget.songName.compareTo(data.data[index].name) == 0)?const Color.fromRGBO(255, 51, 91, 1).withOpacity(0.2): null,
                leading: Text(data.data[index].trackNumber.toString() , style:  TextStyle(color: (widget.songName.compareTo(data.data[index].name) == 0)?const Color.fromRGBO(255, 51, 91, 1): CupertinoColors.systemGrey2)),
                title: Text(data.data[index].name  ,style: TextStyle(color: (widget.songName.compareTo(data.data[index].name) == 0)?const Color.fromRGBO(255, 51, 91, 1): null),),
                trailing: (playlistModel.isCreatingAPlaylist)? 
                AddOrRemoveSong(
                  artistUri: widget.artistUri,
                  image: widget.urlImage,
                  songName: data.data[index].name,
                  artistName: data.artist,
                  isVideo: false,
                  songID: data.data[index].url,
                ) : null
               ),
            ),
          )
    
        ]),
    );
  }
}

SizedBox _nothingBox(){
  return const SizedBox(
    height: 0,
    width:0
  );
}