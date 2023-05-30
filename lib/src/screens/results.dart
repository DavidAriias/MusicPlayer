import 'package:apple_music/src/models/results_model.dart';
import 'package:apple_music/src/screens/artist_profile.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:apple_music/classes/results_class.dart';
import 'package:apple_music/services/service_artist_profile.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';




class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final placeholder = Provider.of<ResultsModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);
    final input = Provider.of<ResultsModel>(context);
    final user = Provider.of<UserModel>(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: _appBarCustom(size, placeholder, user, input, context, appTheme),
        body: const _ListFounded()
      ),
    );
  }

  AppBar _appBarCustom(Size size, ResultsModel placeholder, UserModel user, ResultsModel input, BuildContext context, ThemeChanger appTheme) {
    return AppBar(
        leadingWidth: size.width,
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width / 1.3,
                      child: CupertinoSearchTextField(
                        style: TextStyle(color: (appTheme.darkTheme)? Colors.white:Colors.black),
                        onChanged: (value) {
                          if(value.isEmpty){
                            placeholder.indexsPlaylist = [];
                            input.listArtist = [];
                          }
                          if (placeholder.changeSlider) {
                           
                           for(int i = 0; i <  user.playlists.length; i++){
                            for(int j = 0; j < user.playlists[i].audioTracks.length; j++){
                              final artistName = user.playlists[i].audioTracks[j].artistName.toLowerCase();
                              if(artistName.contains(value.toLowerCase())){
                                
                                placeholder.indexsPlaylist.add(i);
                                placeholder.infoLibrarySection = true;
                                break;
                                                             
                            } 
                            }
                            if(placeholder.infoLibrarySection){
                              break;
                            }
                           }
                          } else {
                            
                            Future<Response> future = getArtists(value);
                            future.then((res) {
                              if (res.statusCode == 200) {
                                input.listArtist =
                                    artistResultFromJson(res.bodyBytes);
                              }
                            });
                          }
                        },
                        placeholder: placeholder.placeholder,
                        autofocus: true,
                      ),
                    ),
                    const _CancelButton()
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _slidingSegmentedControlResults(size, appTheme, placeholder),
            ],
          ),
        ),
        toolbarHeight: 120,
        backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
      );
  }

  Padding _slidingSegmentedControlResults(Size size, ThemeChanger appTheme, ResultsModel placeholder) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: size.width,
                child: CupertinoSlidingSegmentedControl(
                  children: {
                    0: Text(
                      'Apple music',
                      style: TextStyle(
                          fontSize: 18,
                          color: (appTheme.darkTheme)
                              ? Colors.white
                              : Colors.black),
                    ),
                    1: Text(
                      'Your library',
                      style: TextStyle(
                          fontSize: 18,
                          color: (appTheme.darkTheme)
                              ? Colors.white
                              : Colors.black),
                    )
                  },
                  groupValue: _sliding,
                  onValueChanged: (int? newValue) {
                    setState(() {
                      _sliding = newValue;
                      placeholder.changeSlider = !placeholder.changeSlider;

                      if (placeholder.changeSlider == true) {
                        placeholder.placeholder = 'Your library';
                      } else {
                        placeholder.placeholder =
                            'Artists,Songs,Lyrics, and More';
                        placeholder.infoLibrarySection = false;
                        placeholder.indexsPlaylist = [];
                      }
                    });
                  },
                ),
              ),
            );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    final placeholder = Provider.of<ResultsModel>(context);
  
    return TextButton(
        onPressed: (){
         
          placeholder.placeholder =
              'Artists,Songs, Lyrics and More';
          placeholder.infoLibrarySection = false;
          placeholder.changeSlider = false;
          placeholder.indexsPlaylist = [];
          Navigator.pop(context);
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(
              color: Color.fromRGBO(255, 51, 91, 1),
              fontSize: 18),
        ));
  }
}

class _NotFoundLibrary extends StatelessWidget {
  const _NotFoundLibrary();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'No Results',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Try a new search',
            style: TextStyle(color: Colors.grey, fontSize: 15))
      ],
    ));
  }
}

class _ListFounded extends StatelessWidget {
  const _ListFounded();

  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<ResultsModel>(context);
   
    return GestureDetector(
      onVerticalDragDown: (details) => (artist.listArtist.isNotEmpty)
          ? FocusManager.instance.primaryFocus!.unfocus()
          : null,
      child: (artist.changeSlider)?
      (artist.infoLibrarySection)?
      const _ListPlaylist():const _NotFoundLibrary()
      :_ListArtist(artist: artist),
    );
  }
}

class _ListPlaylist extends StatelessWidget {
  const _ListPlaylist();

  @override
  Widget build(BuildContext context) {
    final userPlaylist = Provider.of<UserModel>(context);
    final indexsPlaylist = Provider.of<ResultsModel>(context).indexsPlaylist;
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(color: CupertinoColors.systemGrey),
      itemBuilder: (context, index) => ListTile(
        leading:  ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(Uri.encodeFull(
            userPlaylist.playlists[indexsPlaylist[index]].image
          )),
        ),
        title: Text(userPlaylist.playlists[indexsPlaylist[index]].namePlaylist),
        trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey),
      ),
      itemCount: indexsPlaylist.length);
  }
}

class _ListArtist extends StatelessWidget {
  const _ListArtist({
    required this.artist,
  });

  final ResultsModel artist;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(color: CupertinoColors.systemGrey),
      itemCount: artist.listArtist.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final url = artist.listArtist[index].images[2].url;
        return ListTile(
          title: Text(
            artist.listArtist[index].name,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(artist.listArtist[index].type,
              style: const TextStyle(fontSize: 20)),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(Uri.encodeFull(url)),
            
            maxRadius: 30,
          ),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ArtistProfilePage(
                          artistName: artist.listArtist[index].name,
                          artistUri: artist.listArtist[index].uri,
                          genre: artist.listArtist[index].genre.first,
                          urlImage: artist.listArtist[index].images[0].url,
                        )));
          },
          trailing:
              const Icon(CupertinoIcons.chevron_forward, color: Colors.grey),
        );
      },
    );
  }
}
