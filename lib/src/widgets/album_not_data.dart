import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumNotData extends StatelessWidget {
  const AlbumNotData({super.key, this.height,this.width, required this.iconSize});

  final double? height;
  final double? width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:  Colors.grey.withOpacity(0.25)
      ),
      margin: const EdgeInsets.only(right: 10, left: 18),
      child:  Icon(CupertinoIcons.music_note_2, color: CupertinoColors.systemGrey3, size: iconSize,),
    );
  }
}