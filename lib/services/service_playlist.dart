import 'package:apple_music/classes/playlist_class.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> createPlaylist(UserPlaylist playlist) async {

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/playlists');
  
  final response = await http.post(
    url,
    headers:  {
      'Content-Type': 'application/json',
    },
    body: userPlaylistToJson(
      playlist
    )
  );
  
  return response;
}

Future <Response> modifyPlaylist(UserPlaylist playlist) async {

  final url = Uri.parse('https://applemusicservice.azurewebsites.net/playlists');


  final response = await http.put(
    url,
    headers:  {
      'Content-Type': 'application/json',
    },
    body: userPlaylistToJson(
      playlist
    )
  ); 

  return response;
}

Future <Response> deletePlaylist(String idPlaylist) async {
  
  final url = Uri.parse('https://applemusicservice.azurewebsites.net/playlists/$idPlaylist');

  final response = await http.delete(
    url,
    headers:  {
      'Content-Type': 'application/json',
    },
  );

  return response;
}