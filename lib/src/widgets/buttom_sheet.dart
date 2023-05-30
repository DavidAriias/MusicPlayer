import 'dart:ui';

import 'package:apple_music/src/models/audioplayer_model.dart';
import 'package:apple_music/src/widgets/album_not_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MusicNotPlaying extends StatelessWidget {
  const MusicNotPlaying({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY:  5.0),
          child: Container(
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    AlbumNotData(width: 50, height:50, iconSize: 25),
                     Text(
                      'Not Playing',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Row(
                    children: const [
                     Icon(CupertinoIcons.arrowtriangle_right_fill, color: Colors.grey),
                     SizedBox(width: 30),
                     Icon(CupertinoIcons.forward_fill, color: Colors.grey)
                    ],
                  ),
                ),
                
              ],
            )
          ),
          ),
      ),
    );
  }
}



class MusicDataPlaying extends StatefulWidget {

 
  const MusicDataPlaying({super.key});

  @override
  State<MusicDataPlaying> createState() => _MusicDataPlayingState();
}

class _MusicDataPlayingState extends State<MusicDataPlaying> {
 
  
  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerModel>(context);
    return SizedBox(
      height: 70,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY:  20.0),
          child: Container(
            color: Colors.black26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    (audioPlayer.isTouched)? Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10, left: 18),
                      child : ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(Uri.encodeFull(audioPlayer.image)),
                      )
                    ): const AlbumNotData(width: 50, height:50, iconSize: 0) ,
                
                    Text(
                      (audioPlayer.isTouched) ? audioPlayer.songName : 'Not Playing',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    children: [
                     IconButton(
                      onPressed: (){
                        setState(() {
                          audioPlayer.playing =! audioPlayer.playing;
                        });
                      }, 
                      icon: (audioPlayer.playing == false ) ? const Icon(CupertinoIcons.arrowtriangle_right_fill) : const Icon(CupertinoIcons.pause_solid)
                      ),
                
                      IconButton(
                        onPressed: (){
                          setState(() {
                            
                          });
                        }, 
                        icon: const Icon(CupertinoIcons.forward_fill)
                        )
                    ],
                  ),
                )                
              ],
            )
          ),
        ),
      ),
    );
  }
}