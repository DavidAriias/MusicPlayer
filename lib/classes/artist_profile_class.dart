import 'dart:convert';
import 'dart:typed_data';


List<TopSongs> topSongsFromJson(Uint8List body) => List<TopSongs>.from(json.decode(utf8.decode(body)).map((x) => TopSongs.fromJson(x)));

String topSongsToJson(List<TopSongs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSongs {
    TopSongs({
        required this.name,
        required this.image,
        required this.album,
        required this.release,
        required this.url,
        required this.albumUri
    });

    String name;
    String image;
    String album;
    String release;
    String url;
    String albumUri;

    factory TopSongs.fromJson(Map<String, dynamic> json) => TopSongs(
        name: json["name"],
        image: json["image"],
        album: json["album"],
        release: json["release"],
        url: json["url"],
        albumUri: json["albumUri"]
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "album": album,
        "release": release,
        "url":url,
        "albumUri": albumUri
    };
}

List<Albums> albumsFromJson(Uint8List body) => List<Albums>.from(json.decode(utf8.decode(body)).map((x) => Albums.fromJson(x)));

String albumsToJson(List<Albums> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Albums {
    Albums({
        required this.name,
        required this.uri,
        required this.image,
        required this.release,
    });

    String name;
    String uri;
    String image;
    String release;

    factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        name: json["name"],
        uri: json["uri"],
        image: json["image"],
        release: json["release"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "uri": uri,
        "image": image,
        "release": release,
    };
}

List<MusicVideos> musicVideosFromJson(Uint8List body) => List<MusicVideos>.from(json.decode(utf8.decode(body)).map((x) => MusicVideos.fromJson(x)));

String musicVideosToJson(List<MusicVideos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MusicVideos {
    MusicVideos({
        required this.url,
        required this.title,
        required this.year,
        required this.thumbnailUrl,
    });

    String url;
    String title;
    String year;
    String thumbnailUrl;

    factory MusicVideos.fromJson(Map<String, dynamic> json) => MusicVideos(
        url: json["url"],
        title: json["title"],
        year: json["year"],
        thumbnailUrl: json["thumbnail_url"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "year": year,
        "thumbnail_url": thumbnailUrl,
    };
}

About aboutFromJson(Uint8List body) => About.fromJson(json.decode(utf8.decode(body)));

String aboutToJson(About data) => json.encode(data.toJson());

class About {
    About({
        required this.summary,
        required this.origin,
        required this.date,
        required this.isSinger,
    });

    String summary;
    String origin;
    String date;
    bool isSinger;

    factory About.fromJson(Map<String, dynamic> json) => About(
        summary: json["summary"],
        origin: json["origin"],
        date: json["date"],
        isSinger: json["isSinger"],
    );

    Map<String, dynamic> toJson() => {
        "summary": summary,
        "origin": origin,
        "date": date,
        "isSinger": isSinger,
    };
}

List<SimilarArtist> similarArtistFromJson(Uint8List body) => List<SimilarArtist>.from(json.decode(utf8.decode(body)).map((x) => SimilarArtist.fromJson(x)));

String similarArtistToJson(List<SimilarArtist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SimilarArtist {
    SimilarArtist({
        required this.name,
        required this.uri,
        required this.image,
        required this.genre,
    });

    String name;
    String uri;
    String image;
    String genre;

    factory SimilarArtist.fromJson(Map<String, dynamic> json) => SimilarArtist(
        name: json["name"],
        uri: json["uri"],
        image: json["image"],
        genre: json["genre"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "uri": uri,
        "image": image,
        "genre": genre,
    };
}

AlbumTracks albumTracksFromJson(Uint8List body) => AlbumTracks.fromJson(json.decode(utf8.decode(body)));

String albumTracksToJson(AlbumTracks data) => json.encode(data.toJson());

class AlbumTracks {
    String artist;
    List<Track> data;

    AlbumTracks({
        required this.artist,
        required this.data,
    });

    factory AlbumTracks.fromJson(Map<String, dynamic> json) => AlbumTracks(
        artist: json["artist"],
        data: List<Track>.from(json["data"].map((x) => Track.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "artist": artist,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Track {
    int trackNumber;
    String url;
    String name;

    Track({
        required this.trackNumber,
        required this.url,
        required this.name,
    });

    factory Track.fromJson(Map<String, dynamic> json) => Track(
        trackNumber: json["trackNumber"],
        url: json["url"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "trackNumber": trackNumber,
        "url": url,
        "name": name,
    };
}

