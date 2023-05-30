import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/routes/animation_pages.dart';
import 'package:apple_music/src/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreenAd extends StatelessWidget {
  const SignInScreenAd({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  
    return Container(
        height: size.height,
        decoration: const BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.only(top: 30),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              _ImageWidget(size: size),
               _BodyWidget(size: size)
            ],
          ),
        ));
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    required this.size,
  }
  );

  final Size size;
  @override
  Widget build(BuildContext context) {
    final userStatus = Provider.of<UserModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.network(
                height: 50,
                Uri.encodeFull('https://logosmarcas.net/wp-content/uploads/2020/11/Apple-Music-Logo.png')
                ),
          ),
          const Text('Play and download 60 million songs.',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 40)),
          const SizedBox(height: 10),
          const Text(
              'Plus your entire music library on all your devices. Sign up for starting'),
          const SizedBox(height: 20),
          (userStatus.isSignedIn == false) ? SizedBox(
            width: size.width,
            child: CupertinoButton(
              color: const Color.fromRGBO(255, 51, 91,1),
              child: const Text('Start Listening',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20)),
              onPressed: () {
                Navigator.push(context, routeAnimation(const Login()));
              },
            ),
          ): _nothingBox()
        ],
      ),
    );
  }
}

SizedBox _nothingBox(){
  return const SizedBox(height: 0,width: 0);
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
            fit: BoxFit.cover,
            height: size.height / 2,
            'https://media.idownloadblog.com/wp-content/uploads/2018/03/Apple-Music-icon-002.jpg'),
        Padding(
          padding: const EdgeInsets.only(right:5.0, top: 5.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
                minSize: 25,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                borderRadius: BorderRadius.circular(100),
                color: Colors.white12,
                child: const Icon(CupertinoIcons.clear,
                    color: Color.fromRGBO(255, 255, 255, 1), size: 15),
                onPressed: () => Navigator.pop(context)),
          ),
        ),
      ],
    );
  }
}
