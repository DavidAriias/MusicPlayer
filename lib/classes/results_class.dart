import 'dart:convert';
import 'dart:typed_data';

List<ArtistResult> artistResultFromJson(Uint8List body) => List<ArtistResult>.from(json.decode(utf8.decode(body)).map((x) => ArtistResult.fromJson(x)));

String artistResultToJson(List<ArtistResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArtistResult {
    ArtistResult({
        required this.name,
        required this.images,
        required this.type,
        required this.uri,
        required this.genre,
    });

    String name;
    List<Images> images;
    String type;
    String uri;
    List<String> genre;

    factory ArtistResult.fromJson(Map<String, dynamic> json) => ArtistResult(
        name: json["name"],
        images: List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
        type: json["type"],
        uri: json["uri"],
        genre: List<String>.from(json["genre"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "type": type,
        "uri": uri,
        "genre": List<dynamic>.from(genre.map((x) => x)),
    };
}

class Images {
    Images({
        required this.height,
        required this.url,
        required this.width,
    });

    int height;
    String url;
    int width;

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        height: json["height"],
        url: json["url"],
        width: json["width"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "url": url,
        "width": width,
    };
}