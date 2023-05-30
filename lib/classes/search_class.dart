import 'dart:convert';
import 'dart:typed_data';

List<SearchImage> searchImageFromJson(Uint8List body) => List<SearchImage>.from(json.decode(utf8.decode(body)).map((x) => SearchImage.fromJson(x)));

String searchImageToJson(List<SearchImage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchImage {
    SearchImage({
        required this.genre,
        required this.image,
    });

    String genre;
    String image;

    factory SearchImage.fromJson(Map<String, dynamic> json) => SearchImage(
        genre: json["genre"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "genre": genre,
        "image": image,
    };
}