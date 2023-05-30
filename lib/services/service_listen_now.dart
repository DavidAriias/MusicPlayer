import 'dart:typed_data';
import 'package:apple_music/classes/artist_profile_class.dart';
import 'package:http/http.dart' as http;

Future<List<Uint8List>> recommendDataService(String uriArtist)async {

  List<Uint8List> listResponse = [];

  final urlDataAlbums = Uri.parse('https://applemusicservice.azurewebsites.net/artist/albumData/$uriArtist/album');

  final responseAlbums = await http.get(urlDataAlbums);

  listResponse.add(responseAlbums.bodyBytes);

  final urlSuggestArtist = Uri.parse('https://applemusicservice.azurewebsites.net/artist/similar/$uriArtist');

  final responseSuggestArtist = await http.get(urlSuggestArtist);

  final data = similarArtistFromJson(responseSuggestArtist.bodyBytes);

  final newUri = data.first.uri;

  final urlOtherAlbums = Uri.parse('https://applemusicservice.azurewebsites.net/artist/albumData/$newUri/album');

  final responseOtherAlbums = await http.get(urlOtherAlbums);
   
  
  listResponse.add(responseOtherAlbums.bodyBytes);
  return listResponse;
}

