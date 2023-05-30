import 'package:apple_music/classes/playlist_class.dart';
import 'package:apple_music/services/service_playlist.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/playlist_section_expanded_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/routes/animation_pages.dart';
import 'package:apple_music/src/screens/results.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/album_not_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';

class CreatePlaylistScreen extends StatelessWidget {
  const CreatePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editPlaylist = Provider.of<PlaylistSectionExpandendModel>(context);
    final playlistModel = Provider.of<PlayListModel>(context);
    final size = MediaQuery.of(context).size;
    final userStatus = Provider.of<UserModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: (editPlaylist.isEdit)
          ? null
          : CupertinoNavigationBar(
              backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
              leading: CupertinoButton(
                padding: EdgeInsetsDirectional.zero,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel',
                    style: TextStyle(color: Color.fromRGBO(255, 51, 91, 1))),
              ),
              middle: Text(
                'New Playlist',
                style: TextStyle(
                    color: (appTheme.darkTheme) ? Colors.white : Colors.black),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsetsDirectional.zero,
                onPressed: () {
                  if (playlistModel.playlist.namePlaylist.isEmpty ||
                      playlistModel.imageCover.isEmpty) {
                    _showAlertMissingField(context);
                  } else {
                    playlistModel.playlist.image = playlistModel.imageCover;
                    final response = createPlaylist(playlistModel.playlist);
                    response.then((res) {
                      if (res.statusCode != 200) {
                        _showAlertErrorToSavePlaylist(context, res);
                      } else {
                        playlistModel.isCreatingAPlaylist = false;
                        playlistModel.playlist.description = "";
                        playlistModel.playlist.namePlaylist = "";
                        userStatus.playlists =
                            userPlaylistsFromJson(res.bodyBytes);

                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: const Text('Done',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(255, 51, 91, 1))),
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  (playlistModel.imageCover.isEmpty)
                      ? const Center(
                          child: AlbumNotData(
                              height: 180, width: 180, iconSize: 100))
                      : _ImageCover(urlImage: playlistModel.imageCover),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: CupertinoButton(
                        child: const Icon(CupertinoIcons.camera_circle_fill,
                            color: CupertinoColors.systemGrey, size: 50),
                        onPressed: () {
                          if (playlistModel.playlist.audioTracks.isEmpty) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      title: const Text('Image'),
                                      content: const Text(
                                          "Choose a song for selecting a image for your playlist's cover"),
                                      actions: [
                                        CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () =>
                                                Navigator.pop(context))
                                      ],
                                    ));
                          } else {
                            imagePlaylistSelect(context, size, playlistModel);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CupertinoTextField(
                    style: TextStyle(
                        color:
                            (appTheme.darkTheme) ? Colors.white : Colors.black),
                    onChanged: (value) {
                      playlistModel.playlist.namePlaylist = value;
                    },
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    placeholder: (editPlaylist.isEdit)
                        ? playlistModel.playlist.namePlaylist
                        : 'Playlist Name',
                    placeholderStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemGrey,
                        fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CupertinoFormSection.insetGrouped(
                  backgroundColor: Colors.transparent,
                  children: [
                    CupertinoTextField(
                        style: TextStyle(
                            color: (appTheme.darkTheme)
                                ? Colors.white
                                : Colors.black),
                        onChanged: (value) {
                          playlistModel.playlist.description = value;
                        },
                        maxLength: 30,
                        placeholder: 'Description',
                        placeholderStyle:
                            const TextStyle(color: CupertinoColors.systemGrey)),
                    CupertinoButton(
                        child: Row(
                          children: const [
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(CupertinoIcons.add_circled_solid,
                                    color: CupertinoColors.systemGreen)),
                            Text('Add Music',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 51, 91, 1)))
                          ],
                        ),
                        onPressed: () {
                          playlistModel.isCreatingAPlaylist = true;
                          Navigator.push(
                              context, routeAnimation(const ResultsScreen()));
                        })
                  ]),
              SizedBox(
                height: size.height,
                child: ReorderableListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      key: ValueKey(index),
                      children: [
                        Row(
                          children: [
                            CupertinoButton(
                                padding: const EdgeInsets.only(left: 10),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: const Text('Delete'),
                                      content: Text('Are you sure of delete '
                                          "${playlistModel.playlist.audioTracks[index].title}?"),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: const Text('Confirm'),
                                          onPressed: () {
                                            playlistModel.playlist.audioTracks
                                                .removeAt(index);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                            child: const Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.pop(context))
                                      ],
                                    ),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.minus_circle_fill,
                                  color: Color.fromRGBO(255, 51, 91, 1),
                                )),
                            SizedBox(
                              width: size.width / 1.18,
                              child: CupertinoListTile(
                                title: Text(
                                    playlistModel
                                        .playlist.audioTracks[index].title,
                                    style: TextStyle(
                                        color: (appTheme.darkTheme)
                                            ? Colors.white
                                            : Colors.black)),
                                subtitle: Text(playlistModel
                                    .playlist.audioTracks[index].artistName),
                                trailing: const Icon(CupertinoIcons.bars,
                                    color: CupertinoColors.systemGrey),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(playlistModel
                                      .playlist.audioTracks[index].image),
                                ),
                                leadingSize: 50,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: CupertinoColors.systemGrey2)
                      ],
                    );
                  },
                  itemCount: playlistModel.playlist.audioTracks.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final item = playlistModel.playlist.audioTracks.removeAt(oldIndex);
                    playlistModel.playlist.audioTracks.insert(newIndex, item);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showAlertErrorToSavePlaylist(
      BuildContext context, Response res) {
    return showCupertinoDialog(
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
  }

  Future<dynamic> _showAlertMissingField(BuildContext context) {
    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: const Text('Playlist Field'),
                content:
                    const Text('Missing some field for doing your playlist.'),
                actions: [
                  CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context))
                ]));
  }

  Future<dynamic> imagePlaylistSelect(
      BuildContext context, Size size, PlayListModel playlistModel) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoPopupSurface(
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  if (details.globalPosition.dy > size.height / 4) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: size.width,
                  height: size.height / 4,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 15),
                          width: 50,
                          height: 5,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      SizedBox(
                          height: 150,
                          child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  playlistModel.playlist.audioTracks.length,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      playlistModel.imageCover = playlistModel
                                          .playlist.audioTracks[index].image;
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(playlistModel
                                            .playlist.audioTracks[index].image),
                                      ),
                                    ),
                                  )))
                    ],
                  ),
                ),
              ),
            ));
  }
}

class _ImageCover extends StatelessWidget {
  const _ImageCover({
    required this.urlImage,
  });

  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:
              Image.network(Uri.encodeFull(urlImage), width: 180, height: 180),
        ),
      ),
    );
  }
}
