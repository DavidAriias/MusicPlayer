import 'dart:ui';

import 'package:apple_music/src/models/audioplayer_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/widgets/buttom_sheet.dart';
import 'package:apple_music/src/widgets/expanded_buttom_sheet.dart';
import 'package:apple_music/src/widgets/menu_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ButtomSheet extends StatefulWidget {
  const ButtomSheet({super.key,
   required this.listenNowOnPress, 
   required this.libraryOnPress, 
   required this.searchOnPress});

  final Function listenNowOnPress;
  final Function libraryOnPress;
  final Function searchOnPress;

  @override
  State<ButtomSheet> createState() => _ButtomSheetState();
}

class _ButtomSheetState extends State<ButtomSheet>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _controller;

  double _currentHeight = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStatus = Provider.of<UserModel>(context);
    final size = MediaQuery.of(context).size;
    final audioPlayer = Provider.of<AudioPlayerModel>(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.bounceInOut.transform(_controller.value);
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              width: lerpDouble(size.width, 0, value),
              height: lerpDouble(140, 0, value),
              child: Column(
                children: [
                  (userStatus.isSignedIn != true)
                      ? const MusicNotPlaying()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = true;
                              _currentHeight = size.height;
                              _controller.forward();
                            });
                          },
                          child: const MusicDataPlaying()),
                  MenuApp(
                    items: [
                      MenuAppButton(
                          label: 'Listen Now',
                          icon: CupertinoIcons.play_circle_fill,
                          onPressed: () => setState(() {
                            widget.libraryOnPress.call();
                          })),
                      MenuAppButton(
                          label: 'Library',
                          icon: CupertinoIcons.music_albums_fill,
                          onPressed: () => setState(() {
                            widget.libraryOnPress.call();
                          })),
                      MenuAppButton(
                          label: 'Search',
                          icon: CupertinoIcons.search,
                          onPressed: () => setState(() {
                            widget.searchOnPress.call();
                          }))
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: lerpDouble(size.width / 2,0,value),
             
              height: lerpDouble(0, size.height, value),
              width: lerpDouble(0, size.width, value),
              child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      final newHeight = _currentHeight - details.delta.dy;
                      _controller.value = _currentHeight / size.height;
                      _currentHeight = newHeight.clamp(0, size.height);
                    });
                  },
                  onVerticalDragEnd: (details) {
                    if (_currentHeight < size.height / 2) {
                      _isExpanded = false;
                      _controller.reverse();
                    } else {
                      _isExpanded = true;
                      _controller.forward(from: _currentHeight / size.height);
                      _currentHeight = size.height;
                    }
                  },
                  child: const ExpandedSheet()),
            )
          ],
        );
      },
    );
  }
}
