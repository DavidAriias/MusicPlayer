import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/routes/animation_pages.dart';
import 'package:apple_music/src/screens/click_without_sign_in.dart';
import 'package:apple_music/src/screens/create_playlist.dart';
import 'package:apple_music/src/screens/results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibrarySection extends StatelessWidget {
  const LibrarySection(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.textButton, required this.playlist});

  final String title;
  final String subtitle;
  final String textButton;
  final bool playlist;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userStatus = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          onPressed: () => Navigator.pop(context),
          child: Row(children: const [
            Icon(CupertinoIcons.back, color: Color.fromRGBO(255, 51, 91, 1)),
            Text('Library',
                style: TextStyle(color: Color.fromRGBO(255, 51, 91, 1)))
          ]),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: size.height / 3, horizontal: 16),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 10),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(255, 51, 91, 1),
                child: Text(textButton),
                onPressed: () {
                  (!userStatus.isSignedIn)
                      ? showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => const SignInScreenAd())
                      :  Navigator.push(context, routeAnimation( (playlist)? const CreatePlaylistScreen() : const ResultsScreen()));
                })
          ],
        ),
      ),
    );
  }
}
