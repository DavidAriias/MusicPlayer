import 'dart:typed_data';

import 'package:apple_music/classes/search_class.dart';
import 'package:apple_music/services/service_search_images.dart';
import 'package:apple_music/src/routes/animation_pages.dart';
import 'package:apple_music/src/screens/results.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: 30),
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CupertinoSliverNavigationBar(
                  backgroundColor:
                      appTheme.currentTheme.scaffoldBackgroundColor,
                  middle: Text('Search',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (appTheme.darkTheme)
                              ? Colors.white
                              : Colors.black)),
                  largeTitle: CupertinoSearchTextField(
                    placeholder: 'Artists,Songs,Lyrics, and More',
                    autofocus: false,
                    onTap: () => Navigator.push(
                        context, routeAnimation(const ResultsScreen())),
                  ),
                ),
              ],
          body: FutureBuilder(
            future: dataListSearch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _GenreList(preData: snapshot.requireData);
              } else {
                return const Center(
                  child: Text('Theres not internet'),
                );
              }
            },
          )),
    );
  }
}

class _GenreList extends StatelessWidget {
  const _GenreList({required this.preData});

  final Uint8List preData;
  @override
  Widget build(BuildContext context) {
    final data = searchImageFromJson(preData);
    List<Color> colors = [
      Colors.orangeAccent.shade200,
      Colors.amberAccent,
      Colors.deepOrangeAccent,
      Colors.lightGreenAccent,
      Colors.purple.shade200,
      Colors.lightBlueAccent, //Hasta aqui
      Colors.orangeAccent,
      Colors.teal.shade200,
      Colors.deepOrangeAccent,
      Colors.redAccent,
      Colors.pinkAccent.shade100,
      Colors.green.shade300,
      Colors.amberAccent,
      Colors.deepOrangeAccent,
      Colors.green.shade200,
      Colors.orangeAccent.shade200,
      Colors.brown.shade500,
      Colors.indigo.shade200,
      Colors.red.shade300,
      Colors.amberAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent,
    ];
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemBuilder: (context, index) => _Container(
        genre: data[index].genre,
        urlImage: data[index].image,
        color: colors[index],
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container(
      {required this.urlImage, required this.genre, required this.color});

  final String urlImage;
  final String genre;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          
          child: Image.network(
            frameBuilder: (BuildContext context,Widget child, int? frame, bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
              },

              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/appleMusicError.jpg');
              },
              fit: BoxFit.cover,
              color: color,
              colorBlendMode: BlendMode.color,
              Uri.encodeFull(urlImage)),
        ),
        Positioned(
            bottom: 10,
            left: 10,
            child: Text(genre,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18))),
      ],
    );
  }
}
