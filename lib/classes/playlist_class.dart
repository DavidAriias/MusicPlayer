import 'dart:convert';
import 'package:flutter/foundation.dart';

List<UserPlaylist> userPlaylistsFromJson(Uint8List body) => List<UserPlaylist>.from(json.decode(utf8.decode(body)).map((x) => UserPlaylist.fromJson(x)));

UserPlaylist userPlaylistFromJson(Uint8List body) => UserPlaylist.fromJson(json.decode(utf8.decode(body)));
String userPlaylistToJson(UserPlaylist data) => json.encode(data.toJson());

class UserPlaylist {
    String? id;
    String? idUser;
    String namePlaylist;
    String description;
    String? emailUser;
    String image;
    List<AudioTrack> audioTracks;

    UserPlaylist({
        this.id,
        this.idUser,
        required this.namePlaylist,
        required this.description,
        this.emailUser,
        required this.image,
        required this.audioTracks,
    });

    factory UserPlaylist.fromJson(Map<String, dynamic> json) => UserPlaylist(
        id: json["id"],
        idUser: json["idUser"],
        namePlaylist: json["namePlaylist"],
        description: json["description"],
        emailUser: json["emailUser"],
        image: json["image"],
        audioTracks: List<AudioTrack>.from(json["audioTracks"].map((x) => AudioTrack.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idUser": idUser,
        "namePlaylist": namePlaylist,
        "description": description,
        "emailUser": emailUser,
        "image":image,
        "audioTracks": List<dynamic>.from(audioTracks.map((x) => x.toJson())),
    };
}

class AudioTrack {
    String songId;
    String title;
    String artistName;
    bool isVideo;
    String image;
    String artistUri;

    AudioTrack({
        required this.songId,
        required this.title,
        required this.artistName,
        required this.isVideo,
        required this.image,
        required this.artistUri
    });

    factory AudioTrack.fromJson(Map<String, dynamic> json) => AudioTrack(
        songId: json["songID"],
        title: json["title"],
        artistName: json["artistName"],
        isVideo: json["isVideo"],
        image: json["image"],
        artistUri: json["artistUri"]
    );

    Map<String, dynamic> toJson() => {
        "songID": songId,
        "title": title,
        "artistName": artistName,
        "isVideo": isVideo,
        "image": image,
        "artistUri":artistUri
    };
}
