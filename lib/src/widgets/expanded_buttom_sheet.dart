import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:apple_music/src/widgets/album_not_data.dart';


import '../models/audioplayer_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExpandedSheet extends StatefulWidget {
  const ExpandedSheet({
    super.key,
  });

  @override
  State<ExpandedSheet> createState() => _ExpandedSheetState();
}

class _ExpandedSheetState extends State<ExpandedSheet>
    with TickerProviderStateMixin {
  late Animation<double> _scaleSliderMusic;
  late Animation<double> _scaleImage;
  late Animation<double> _scaleSliderVolume;
  late AnimationController _controller;
  late AnimationController _controllerSliderMusic;
  late AnimationController _controllerSliderVolume;

  bool isExpandedSliderMusic = false;
  bool isExpandedSliderVolume = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controllerSliderMusic = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controllerSliderVolume = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleImage = Tween(begin: 1.00, end: 0.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _scaleSliderMusic = Tween(begin: 0.9, end: 1.00).animate(CurvedAnimation(
        parent: _controllerSliderMusic, curve: Curves.bounceIn));
    _scaleSliderVolume = Tween(begin: 0.9, end: 1.00).animate(CurvedAnimation(
        parent: _controllerSliderVolume, curve: Curves.bounceIn));
    
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerSliderMusic.dispose();
    _controllerSliderVolume.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioPlayer = Provider.of<AudioPlayerModel>(context);

    (audioPlayer.playing == true)
        ? _controller.forward()
        : _controller.reverse();

    if (audioPlayer.isTouched) {
      audioPlayer.controller.play();
      
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _backgroundPlayer(audioPlayer),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 30),
                  width: 40,
                  height: 5,
                  color: Colors.white38,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: Colors.transparent,
                elevation: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return (!audioPlayer.isTouched)
                          ? AlbumNotData(
                              iconSize: 150,
                              width: lerpDouble(
                                  280, size.height / 2, _scaleImage.value),
                              height: lerpDouble(
                                  280, size.width / 2, _scaleImage.value))
                          : (audioPlayer.isVideo)
                              ? _VideoView(
                                  scaleImage: _scaleImage,
                                  size: size,
                                  controllerYoutube: audioPlayer.controller)
                              : _SongView(
                                  size: size,
                                  scaleImage: _scaleImage,
                                  controller: audioPlayer.controller);
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 40, right: 40, top: size.height * 0.1),
            child: Column(
              //Columna para todosd los componentes del reproductor
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    //Row para el titulo de la cancion, artista y boton de opcion de la parte derecha
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        //Columna para el nombre de la cancion y el artista
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (audioPlayer.songName.isNotEmpty)
                                ? audioPlayer.songName
                                : 'Not Playing',
                            style: TextStyle(
                                color: (audioPlayer.isVideo)
                                    ? const Color.fromRGBO(255, 51, 91, 1)
                                    : Colors.white,
                                fontSize: 22,
                                wordSpacing: 5,
                                fontWeight: FontWeight.w500),
                          ),
                          PopupMenuButton(
                              color: const Color.fromARGB(255, 36, 33, 33),
                              position: PopupMenuPosition.over,
                              itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                        child: _ModelOptionsArtist(
                                            title: 'Go to album',
                                            subtitle: audioPlayer.albumName,
                                            icon: CupertinoIcons.square_stack)),
                                    PopupMenuItem(
                                        child: _ModelOptionsArtist(
                                            title: 'Go to Artist',
                                            subtitle: audioPlayer.artistName,
                                            icon: CupertinoIcons.music_mic))
                                  ],
                              child: Text(
                                audioPlayer.artistName,
                                style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 22,
                                    wordSpacing: 5,
                                    fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                      (audioPlayer.songName.isNotEmpty)
                          ? const _ButtonOptions()
                          : const SizedBox(height: 0, width: 0)
                    ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.25),
            child: GestureDetector(
              onTapDown: (details) {
                setState(() {
                  isExpandedSliderMusic = true;
                  _controllerSliderMusic.forward();
                });
              },
              onTapCancel: () {
                setState(() {
                  isExpandedSliderMusic = false;
                  _controllerSliderMusic.reverse();
                });
              },
              child: AnimatedBuilder(
                  animation: _controllerSliderMusic,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleSliderMusic.value,
                      child: child,
                    );
                  },
                  child: _SliderMusic(
                      controller: audioPlayer.controller,
                      isExpandedSliderMusic: isExpandedSliderMusic)),
            ),
          ),
          _sliderVolumeZoom(size, audioPlayer.controller),
          Positioned(
            bottom: size.height / 4.5,
            left: size.width * 1 / 4,
            right: size.width * 1 / 4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.backward_fill,
                            color: Colors.white, size: 40)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          audioPlayer.playing = !audioPlayer.playing;
                        });
                        if (audioPlayer.playing) {
                          audioPlayer.controller.play();
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                      },
                      icon: (audioPlayer.playing == true)
                          ? const Icon(CupertinoIcons.pause_solid,
                              color: Colors.white, size: 40)
                          : const Icon(CupertinoIcons.play_fill,
                              color: Colors.white, size: 40),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.forward_fill,
                            color: Colors.white, size: 40))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _backgroundPlayer(AudioPlayerModel audioPlayer) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: (audioPlayer.isTouched)
          ? _imageBackground(audioPlayer)
          : const BoxDecoration(color: Colors.grey),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 35, sigmaY: 40),
          child: Container(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  BoxDecoration _imageBackground(AudioPlayerModel audioPlayer) {
    return BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(Uri.encodeFull(audioPlayer.image))));
  }

  Padding _sliderVolumeZoom(
      Size size, YoutubePlayerController youtubeController) {
    return Padding(
      padding: EdgeInsets.only(top: size.height / 1.5),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            isExpandedSliderVolume = true;
            _controllerSliderVolume.forward();
          });
        },
        onTapCancel: () {
          setState(() {
            isExpandedSliderVolume = false;
            _controllerSliderVolume.reverse();
          });
        },
        child: AnimatedBuilder(
            animation: _controllerSliderVolume,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleSliderVolume.value,
                child: child,
              );
            },
            child: _SliderVolume(
                isExpandedSliderVolume: isExpandedSliderVolume,
                controller: youtubeController)),
      ),
    );
  }
}

class _ButtonOptions extends StatelessWidget {
  const _ButtonOptions();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        color: Colors.white12,
        child: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
                child: _ModelOptionsButtom(
              title: 'Add to library',
              icon: CupertinoIcons.add,
            )),
            const PopupMenuItem(
                child: _ModelOptionsButtom(
              title: 'Add to playlist',
              icon: CupertinoIcons.text_badge_plus,
            )),
            const PopupMenuItem(
                child: _ModelOptionsButtom(
              title: 'Show Album',
              icon: CupertinoIcons.music_note_list,
            )),
          ],
          position: PopupMenuPosition.over,
          icon: const Icon(CupertinoIcons.ellipsis,
              color: Colors.white, size: 20),
          color: const Color.fromARGB(255, 36, 33, 33),
        ),
      ),
    );
  }
}

class _VideoView extends StatelessWidget {
  const _VideoView({
    required Animation<double> scaleImage,
    required this.size,
    required YoutubePlayerController controllerYoutube,
  })  : _scaleImage = scaleImage,
        _controllerYoutube = controllerYoutube;

  final Animation<double> _scaleImage;
  final Size size;
  final YoutubePlayerController _controllerYoutube;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: lerpDouble(280, 250, _scaleImage.value),
      width: lerpDouble(size.width, size.width / 1.2, _scaleImage.value),
      child: YoutubePlayer(controller: _controllerYoutube),
    );
  }
}

class _SongView extends StatelessWidget {
  const _SongView({
    required this.controller,
    required this.size,
    required Animation<double> scaleImage,
  }) : _scaleImage = scaleImage;

  final Size size;
  final Animation<double> _scaleImage;
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerModel>(context);
    return Column(
      children: [
        Image.network(Uri.encodeFull(audioPlayer.image),
            width: lerpDouble(280, size.width / 2, _scaleImage.value),
            height: lerpDouble(280, size.height / 2, _scaleImage.value)),
        SizedBox(
            height: 0,
            width: 0,
            child: YoutubePlayer(
                thumbnail: const SizedBox(height: 0, width: 0),
                onEnded: (data) {
                  int currentSong = audioPlayer.currentSongPlaylist + 1;
                  audioPlayer.currentSongPlaylist = currentSong;
                 controller.load(audioPlayer.listeningTrack[currentSong].songId);
                },
                controller: controller)),
      ],
    );
  }
}

class _SliderVolume extends StatelessWidget {
  const _SliderVolume(
      {required this.isExpandedSliderVolume, required this.controller});

  final bool isExpandedSliderVolume;
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(CupertinoIcons.volume_mute,
            color: (isExpandedSliderVolume == false)
                ? Colors.white60
                : Colors.white),
        SliderTheme(
            data: const SliderThemeData(trackHeight: 10),
            child: Expanded(
              child: Slider.adaptive(
                min: 0.0,
                max: 100,
                value: audioPlayer.volume.toDouble(),
                onChanged: (value) {
                  controller.setVolume(value.toInt());
                },
                inactiveColor: Colors.white12,
                activeColor: (isExpandedSliderVolume == false)
                    ? Colors.white60
                    : Colors.white,
                thumbColor: (isExpandedSliderVolume == false)
                    ? Colors.white60
                    : Colors.white,
              ),
            )),
        Icon(CupertinoIcons.volume_up,
            color: (isExpandedSliderVolume == false)
                ? Colors.white60
                : Colors.white)
      ],
    );
  }
}

class _SliderMusic extends StatelessWidget {
  const _SliderMusic(
      {required this.isExpandedSliderMusic, required this.controller});

  final bool isExpandedSliderMusic;
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
            data: const SliderThemeData(
              trackHeight: 10,
            ),
            child: Slider.adaptive(
              min: 0.0,
              max: controller.metadata.duration.inSeconds.toDouble() + 1,
              value: controller.value.position.inSeconds.toDouble(),
              onChanged: (value) {},
              inactiveColor: Colors.white12,
              activeColor: (isExpandedSliderMusic == false)
                  ? Colors.white60
                  : Colors.white,
              thumbColor: (isExpandedSliderMusic == false)
                  ? Colors.white60
                  : Colors.white,
            )),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.value.position.inMinutes} : ${controller.value.position.inSeconds % 60}",
                style: TextStyle(
                  color: (isExpandedSliderMusic == false)
                      ? Colors.white38
                      : Colors.white,
                ),
              ),
              Text(
                "- ${controller.value.metaData.duration.inMinutes - controller.value.position.inMinutes} : ${controller.metadata.duration.inSeconds % 60 - controller.value.position.inSeconds % 60}",
                style: TextStyle(
                  color: (isExpandedSliderMusic == false)
                      ? Colors.white38
                      : Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ModelOptionsArtist extends StatelessWidget {
  const _ModelOptionsArtist({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white38),
            )
          ],
        ),
        Icon(icon, color: Colors.white),
      ],
    );
  }
}

class _ModelOptionsButtom extends StatelessWidget {
  const _ModelOptionsButtom({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        Icon(icon, color: Colors.white),
      ],
    );
  }
}
