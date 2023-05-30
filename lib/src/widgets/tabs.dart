import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/screens/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/library.dart';
import '../screens/listen_now.dart';
import 'buttom_sheet.dart';
import 'expanded_buttom_sheet.dart';
import 'menu_app.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  late Animation<double> _scaleButtomSheet;
  late AnimationController _controller;

  double _currentHeight = 0.0;
  late Size _size;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleButtomSheet = Tween(begin: 0.0, end: 1.00).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  bool _isExpanded = false;

  final screens = const [ListenNowView(), LibraryView(), SearchView()];
  @override
  Widget build(BuildContext context) {
    final userStatus = Provider.of<UserModel>(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        screens[_selectedIndex],
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                alignment: Alignment.bottomLeft,
                scaleY: _scaleButtomSheet.value,
                child: GestureDetector(
                    onVerticalDragUpdate: 
                         (details) {
                            setState(() {
                              final newHeight =
                                  _currentHeight - details.delta.dy;
                              _controller.value = _currentHeight / _size.height;
                              _currentHeight = newHeight.clamp(0, _size.height);
                            });
                          }
                       ,
                    onVerticalDragEnd: (details) {
                            if (_currentHeight < _size.height / 2) {
                              _isExpanded = false;
                              _controller.reverse();
                            } else {
                              _isExpanded = true;
                              _controller.forward(
                                  from: _currentHeight / _size.height);
                              _currentHeight = _size.height;
                            }
                          },
                    child: const ExpandedSheet(
                      
                )),
              );
            })
      ]),
      resizeToAvoidBottomInset: false,
      bottomSheet: 
      (userStatus.isSignedIn == false) ? const MusicNotPlaying() :
      (_isExpanded == false)
          ? _bottomNavigationBar()
          : _expandButtomSheet(),
      
      bottomNavigationBar: (_isExpanded == false) ? MenuApp(
        items: [
          MenuAppButton(label:'Listen Now' ,icon: CupertinoIcons.play_circle_fill, onPressed: () => setState((){_selectedIndex = 0;})),
          MenuAppButton(label: 'Library', icon: CupertinoIcons.music_albums_fill, onPressed: () => setState((){_selectedIndex = 1;})),
          MenuAppButton(label: 'Search', icon: CupertinoIcons.search, onPressed: () => setState((){_selectedIndex = 2;}))
        ],
      ): _expandButtomSheet(),
    );
  }

  SizedBox _expandButtomSheet() {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }

GestureDetector _bottomNavigationBar() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = true;
            _currentHeight = _size.height;
            _controller.forward();
          });
        },
        child: const MusicDataPlaying(
           
           ));
  }
}
