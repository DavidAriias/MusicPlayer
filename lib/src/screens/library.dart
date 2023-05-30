import 'package:apple_music/src/models/library_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/library_section.dart';
import 'package:apple_music/src/screens/library_section_playlist.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final list = <_Options>[
  _Options(
    pageTitle: 'Create your playlist',
    pageSubTitle:
        'Choose your favourite songs and music videos in a just one place.',
    textButton: 'Started a playlist',
    iconStart: CupertinoIcons.music_note_list,
    title: 'Playlists',
    activate: true,
    playlist: true,
  ),
  _Options(
      pageTitle: 'Save your favourite artists',
      pageSubTitle:
          'Saved all songs and music videos of your favourite artists in a just place.',
      textButton: 'Find a artist',
      iconStart: CupertinoIcons.music_mic,
      title: 'Artist',
      activate: true,
      playlist: false),
  _Options(
      pageTitle: 'Save your favorite albums',
      pageSubTitle: 'Save all your favourite albums in a just place.',
      textButton: 'Find a album',
      iconStart: CupertinoIcons.square_stack,
      title: 'Albums',
      activate: true,
      playlist: false),
  _Options(
      pageTitle: 'Save your favourite songs',
      pageSubTitle: 'Saved all your favorite songs in a just place.',
      textButton: 'Find a song',
      iconStart: CupertinoIcons.music_note,
      title: 'Songs',
      activate: true,
      playlist: false)
];

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 30), child: _LibraryBody());
  }
}

class _LibraryBody extends StatefulWidget {
  const _LibraryBody();

  @override
  State<_LibraryBody> createState() => _LibraryBodyState();
}

class _LibraryBodyState extends State<_LibraryBody> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LibraryModel>(context);
    final appTheme = Provider.of<ThemeChanger>(context);

    return NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CupertinoSliverNavigationBar(
                backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
                largeTitle: Text('Library',
                    style: TextStyle(
                        color: (appTheme.darkTheme)
                            ? Colors.white
                            : Colors.black)),
                padding: EdgeInsetsDirectional.zero,
                trailing: CupertinoButton(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      (state.isEditBottonClicked == false) ? 'Edit' : 'Done',
                      style: TextStyle(
                          color: const Color.fromRGBO(255, 51, 91, 1),
                          fontSize: 21,
                          fontWeight: (state.isEditBottonClicked == false)
                              ? FontWeight.normal
                              : FontWeight.w600),
                    ),
                    onPressed: () => setState(() {
                          state.isEditBottonClicked =
                              !state.isEditBottonClicked;
                        })),
              )
            ],
        body: _Body());
  }
}

class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LibraryModel>(context);
    final userStatus = Provider.of<UserModel>(context);
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      (state.isEditBottonClicked == true)
          ? const _EditList()
          : _doneList(userStatus),
    ]);
  }

  SliverList _doneList(UserModel userStatus) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: 1,
            (context, index) {
      if (list[index].activate == true) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => (userStatus.playlists.isEmpty)
                            ? LibrarySection(
                                playlist: list[index].playlist,
                                title: list[index].pageTitle,
                                subtitle: list[index].pageSubTitle,
                                textButton: list[index].textButton,
                              )
                            : const LibrarySectionPlaylist()));
              },
              child: _ListTileEdit(
                iconStart: list[index].iconStart,
                title: list[index].title,
                iconEnd: CupertinoIcons.chevron_forward,
              ),
            ),
            const Divider(color: CupertinoColors.systemGrey)
          ],
        );
      } else {
        return _nothingBox();
      }
    }));
  }

  SizedBox _nothingBox() {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }
}

class SongAdded extends StatelessWidget {
  const SongAdded(
      {super.key, required this.artistName,
      required this.songName,
      required this.urlImage});

  final String artistName;
  final String songName;
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              urlImage,
            ),
          ),
          Text(
            artistName,
            style: const TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.left,
          ),
          Text(songName,
              style: const TextStyle(
                  fontSize: 15, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}

class _Options {
  final IconData iconStart;
  final String title;
  bool? activate;
  final String pageTitle;
  final String pageSubTitle;
  final String textButton;
  final bool playlist;

  _Options(
      {required this.pageTitle,
      required this.pageSubTitle,
      required this.textButton,
      required this.iconStart,
      required this.title,
      required this.activate,
      required this.playlist});
}

class _EditList extends StatefulWidget {
  const _EditList();

  @override
  State<_EditList> createState() => _OptionListState();
}

class _OptionListState extends State<_EditList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: ReorderableListView.builder(
          physics: const BouncingScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final item = list.removeAt(oldIndex);
            list.insert(newIndex, item);
          },
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Column(
              key: ValueKey(index),
              children: [
                Row(
                  children: [
                    Checkbox(
                      shape: const CircleBorder(
                        side: BorderSide(
                            style: BorderStyle.solid,
                            width: 0.5,
                            strokeAlign: Checkbox.width),
                        eccentricity: 1,
                      ),
                      activeColor: const Color.fromRGBO(255, 51, 91, 1),
                      value: list[index].activate,
                      onChanged: (value) {
                        setState(() {
                          list[index].activate = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: size.width / 1.18,
                      child: _ListTileEdit(
                        iconStart: list[index].iconStart,
                        title: list[index].title,
                        iconEnd: CupertinoIcons.bars,
                      ),
                    )
                  ],
                ),
                const Divider(color: CupertinoColors.systemGrey2)
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ListTileEdit extends StatelessWidget {
  const _ListTileEdit(
      {required this.iconStart, required this.title, required this.iconEnd});

  final IconData iconStart;
  final String title;
  final IconData iconEnd;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconStart, color: const Color.fromRGBO(255, 51, 91, 1)),
      minLeadingWidth: 5,
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
      trailing: Icon(iconEnd, color: CupertinoColors.systemGrey),
    );
  }
}
