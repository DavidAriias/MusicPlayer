import 'package:apple_music/classes/playlist_class.dart';
import 'package:apple_music/services/service_playlist.dart';
import 'package:apple_music/src/models/audioplayer_model.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/playlist_section_expanded_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/create_playlist.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/buttom_sheet_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/src/response.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistScreenExpandend extends StatefulWidget {
  const PlaylistScreenExpandend({super.key});

  @override
  State<PlaylistScreenExpandend> createState() =>
      _PlaylistScreenExpandendState();
}

class _PlaylistScreenExpandendState extends State<PlaylistScreenExpandend> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PlaylistSectionExpandendModel>(context);
    final size = MediaQuery.of(context).size;
    final playlistModel = Provider.of<PlayListModel>(context);
    final user = Provider.of<UserModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: (model.isEdit)
          ? null
          : ButtomSheet(
              libraryOnPress: () {
                Navigator.pop(context);
              },
              listenNowOnPress: () {
                Navigator.pop(context);
              },
              searchOnPress: () {
                Navigator.pop(context);
              },
            ),
      appBar: CupertinoNavigationBar(
        backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
        leading: CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          onPressed: () {
            if (model.isEdit) {
              model.isEdit = !model.isEdit;
              //updatePlaylist(playlistModel, context, user);
            }
            Navigator.pop(context);
          },
          child: Row(children: const [
            Icon(CupertinoIcons.back, color: Color.fromRGBO(255, 51, 91, 1)),
            Text('Playlists',
                style: TextStyle(color: Color.fromRGBO(255, 51, 91, 1)))
          ]),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          child: Text(
            (model.isEdit == false) ? 'Edit' : 'Done',
            style: TextStyle(
                color: const Color.fromRGBO(255, 51, 91, 1),
                fontSize: 21,
                fontWeight: (model.isEdit == false)
                    ? FontWeight.normal
                    : FontWeight.w600),
          ),
          onPressed: () {
            setState(() {
              model.isEdit = !model.isEdit;
            });

            if (model.isEdit) {
              playlistModel.playlist.description = user.playlist.description;
              playlistModel.playlist.namePlaylist = user.playlist.namePlaylist;
              playlistModel.imageCover = user.playlist.image;
              playlistModel.playlist.audioTracks = user.playlist.audioTracks;
            } else {
              updatePlaylist(playlistModel, context, user);
              playlistModel.playlist.audioTracks = [];
            }
          },
        ),
      ),
      body: (model.isEdit)
          ? const CreatePlaylistScreen()
          : _ShowPlaylist(size: size),
    );
  }
}

void updatePlaylist(
    PlayListModel playlist, BuildContext context, UserModel user) {
  playlist.playlist.image = playlist.imageCover;
  playlist.playlist.id = user.playlist.id;
  playlist.playlist.idUser = user.playlist.idUser;

  final response = modifyPlaylist(playlist.playlist);
  response.then((res) {
    if (res.statusCode != 200) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text('Error'),
                content: Text(res.body),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    } else {
      user.playlists = userPlaylistsFromJson(res.bodyBytes);
    }
  });
}

class _ShowPlaylist extends StatelessWidget {
  const _ShowPlaylist({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final audioPlayer = Provider.of<AudioPlayerModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(Uri.encodeFull(user.playlist.image),
                          width: 100, height: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        user.playlist.namePlaylist,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    )
                  ],
                ),
                (user.playlist.description.isNotEmpty)
                    ? const Divider(color: CupertinoColors.systemGrey)
                    : _nothingBox(),
                (user.playlist.description.isNotEmpty)
                    ? Text(user.playlist.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 15))
                    : _nothingBox(),
                const Divider(color: CupertinoColors.systemGrey),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ButtonStartPlaylist(
                          size: size,
                          icon: CupertinoIcons.play_arrow_solid,
                          titleButton: 'Play',
                          onPressed: () {
                            audioPlayer.controller = YoutubePlayerController(
                                initialVideoId:
                                    user.playlist.audioTracks.first.songId);

                            audioPlayer.image =
                                user.playlist.audioTracks.first.image;
                            audioPlayer.artistName =
                                user.playlist.audioTracks.first.artistName;

                            audioPlayer.isVideo =
                                user.playlist.audioTracks.first.isVideo;
                            audioPlayer.songName =
                                user.playlist.audioTracks.first.title;

                            audioPlayer.isTouched = true;
                          }),
                      _ButtonStartPlaylist(
                        size: size,
                        icon: CupertinoIcons.trash,
                        titleButton: 'Delete',
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                        'Are you sure want to delete this playlist?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        child: const Text('Confirm'),
                                        onPressed: () {
                                          final res = deletePlaylist(
                                              user.playlist.id.toString());
                                          
                                          res.then((response) {
                                           
                                            if (response.statusCode == 200) {
                                              user.playlists = userPlaylistsFromJson(response.bodyBytes); 
                                                                                   
                              
                                            } else {
                                              _showDialogError(
                                                  context, response);
                                            }
                                          });
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ));
                        },
                      ),
                    ]),
                const Divider(color: CupertinoColors.systemGrey),
                SizedBox(
                  height: size.height,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const Divider(color: CupertinoColors.systemGrey),
                      itemBuilder: (context, index) => CupertinoListTile(
                            padding: const EdgeInsetsDirectional.all(0),
                            leadingSize: 50,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(Uri.encodeFull(
                                  user.playlist.audioTracks[index].image)),
                            ),
                            title: Text(
                              user.playlist.audioTracks[index].title,
                              style: TextStyle(
                                  color: (appTheme.darkTheme)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            subtitle: Text(
                                user.playlist.audioTracks[index].artistName),
                          ),
                      itemCount: user.playlist.audioTracks.length),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> _showDialogError(BuildContext context, Response response) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(response.body),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

class _ButtonStartPlaylist extends StatelessWidget {
  const _ButtonStartPlaylist({
    required this.size,
    required this.titleButton,
    required this.icon,
    required this.onPressed,
  });

  final Size size;
  final String titleButton;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        borderRadius: BorderRadius.circular(10),
        color: CupertinoColors.systemGrey5,
        child: SizedBox(
          width: size.width / 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color.fromRGBO(255, 51, 91, 1)),
              Text(titleButton,
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 51, 91, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: 12))
            ],
          ),
        ),
        onPressed: () {
          onPressed.call();
        });
  }
}

SizedBox _nothingBox() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}
