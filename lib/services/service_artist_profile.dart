import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> getArtists(String artistName) async {

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/search/$artistName');

 
  try{
    final response = await http.get(url);
    return response;
    
  } catch (e){
    return Future.error(Exception(e));
  }
 
}

Future<List<Uint8List>> dataArtist(String uriArtist, String artistName) async {
  
  List<Uint8List> listResponse = [];

  final urlTopSongs = Uri.parse('https://applemusicservice.azurewebsites.net/artist/topSongs/$uriArtist');

  final responseTopSongs = await http.get(urlTopSongs);

  listResponse.add(responseTopSongs.bodyBytes);


  final urlDataAlbums = Uri.parse('https://applemusicservice.azurewebsites.net/artist/albumData/$uriArtist/album');

  final responseAlbums = await http.get(urlDataAlbums);

  listResponse.add(responseAlbums.bodyBytes);

  final urlDataVideos = Uri.parse('https://applemusicservice.azurewebsites.net/artist/musicVideos/$artistName');
  
  final responseVideos = await http.get(urlDataVideos);

  listResponse.add(responseVideos.bodyBytes);
  
  final urlDataSingles = Uri.parse('https://applemusicservice.azurewebsites.net/artist/albumData/$uriArtist/single');

  final responseSingles = await http.get(urlDataSingles);

  listResponse.add(responseSingles.bodyBytes);

  final urlDataAppearsOn = Uri.parse('https://applemusicservice.azurewebsites.net/artist/albumData/$uriArtist/appears_on');

  final responseAppearsOn = await http.get(urlDataAppearsOn);

  listResponse.add(responseAppearsOn.bodyBytes);

  final urlDataAbout = Uri.parse('https://applemusicservice.azurewebsites.net/artist/about/$artistName');

  final responseAbout = await http.get(urlDataAbout);

  listResponse.add(responseAbout.bodyBytes);

  final urlSimilar = Uri.parse('https://applemusicservice.azurewebsites.net/artist/similar/$uriArtist');

  final responseSimilar = await http.get(urlSimilar);

  listResponse.add(responseSimilar.bodyBytes);

  return listResponse;

}

Future<Uint8List> albumDataContain(String albumUri) async{

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/data/albums/$albumUri');

  final response = await http.get(url);

  return response.bodyBytes;
}
 


