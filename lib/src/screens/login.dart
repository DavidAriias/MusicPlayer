import 'package:apple_music/classes/login_class.dart';
import 'package:apple_music/classes/playlist_class.dart';
import 'package:apple_music/services/service_login.dart';
import 'package:apple_music/src/models/playlist_model.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/routes/animation_pages.dart';
import 'package:apple_music/src/screens/change_password.dart';
import 'package:apple_music/src/widgets/box_option_sign.dart';
import 'package:apple_music/src/widgets/header_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/themes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPressRegister = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    final userStatus = Provider.of<UserModel>(context);
    final playlist = Provider.of<PlayListModel>(context);

    return Container(
      decoration: BoxDecoration(
          color: appTheme.darkTheme
              ? appTheme.currentTheme.scaffoldBackgroundColor
              : const Color.fromARGB(255, 237, 237, 237),
          borderRadius: BorderRadius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
            child: (userStatus.isSignedIn == false)
                ? _signUp(userStatus, context, size, playlist)
                : _SignIn(size: size, appTheme: appTheme)),
      ),
    );
  }

  Column _signUp(UserModel userStatus, BuildContext context, Size size,PlayListModel playlist) {
    return Column(
      children: [
        const HeaderSubPage(title: 'Account'),
        _HeaderLogin(isSecondBottomActivate: _isPressRegister),
        Form(
          key: formKey,
          child: CupertinoFormSection.insetGrouped(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: Icon(CupertinoIcons.envelope,
                      color: Colors.grey.shade500),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                            .hasMatch(value)) {
                      return "Enter correct email";
                    } else {
                      return null;
                    }
                  },
                  maxLength: 64,
                  placeholder: 'Enter a email',
                  onSaved: (email) => userStatus.email = email.toString(),
                ),
                CupertinoTextFormFieldRow(
                  prefix:
                      Icon(CupertinoIcons.padlock, color: Colors.grey.shade500),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a correct password";
                    } else {
                      return null;
                    }
                  },
                  maxLength: 16,
                  obscureText: true,
                  placeholder: 'Enter a password',
                  onSaved: (pass) => userStatus.password = pass.toString(),
                )
              ]),
        ),
        SizedBox(
          width: size.width,
          child: CupertinoButton(
              color: const Color.fromRGBO(255, 51, 91, 1),
              child: const Text(
                'Confirm',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    _isPressRegister == false) {
                  formKey.currentState!.save();

                  final response =
                      lookingForUsers(userStatus.email, userStatus.password);

                  response.then((res) {
                    if (res.statusCode == 200) {
                      userStatus.playlists = userPlaylistsFromJson(res.bodyBytes);
                      playlist.playlist.emailUser = userStatus.email;
                      userStatus.isSignedIn = true;
                      Navigator.pop(context);
                    } else {
                      final error = userErrorFromJson(res.body);
                      showCupertinoDialog(
                          context: context,
                          builder: (context) =>
                              _AlertDialogLogin(error: error));
                    }
                  });
                } else if (formKey.currentState!.validate() &&
                    _isPressRegister) {
                  formKey.currentState!.save();

                  final response =
                      createUser(userStatus.email, userStatus.password);

                  response.then((res) {
                    if (res.statusCode == 200) {
                      userStatus.isSignedIn = true;
                      Navigator.pop(context);
                    } else {
                      final error = userErrorFromJson(res.body);
                      showCupertinoDialog(
                          context: context,
                          builder: (context) =>
                              _AlertDialogLogin(error: error));
                    }
                  });
                }
              }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Divider(color: Colors.grey),
            Text('OR', style: TextStyle(fontSize: 18)),
            Divider(color: Colors.grey),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: size.width,
          child: CupertinoButton(
            onPressed: () => setState(() {
              _isPressRegister = !_isPressRegister;
            }),
            color: Colors.white,
            child: Text(
              (_isPressRegister == false) ? 'Register' : 'Sign In',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlertDialogLogin extends StatelessWidget {
  const _AlertDialogLogin({
    required this.error,
  });

  final UserError error;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Try it again'),
      content: Text(error.detail),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class _SignIn extends StatelessWidget {
  const _SignIn({
    required this.size,
    required this.appTheme,
  });

  final Size size;
  final ThemeChanger appTheme;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return Column(
      children: [
        const HeaderSubPage(title: 'Account'),
        const SizedBox(height: 30),
        BoxOptionSignIn(
          color: appTheme.currentTheme.cardColor,
          size: size,
          children: [
            const Text('Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Text(userData.email,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey))
          ],
        ),
        const SizedBox(height: 30),
        BoxOptionSignIn(
          color: appTheme.currentTheme.cardColor,
          size: size,
          children: [
            const Text('App Theme',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            CupertinoSwitch(
                value: appTheme.darkTheme,
                onChanged: (value) => appTheme.darkTheme = value),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: size.width,
          child: CupertinoButton(
            color: appTheme.currentTheme.cardColor,
            onPressed: () {
              Navigator.push(
                  context, routeAnimation(const PasswordChangeScreen()));
            },
            child: const Text('Change the password',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 51, 91, 1))),
          ),
        )
      ],
    );
  }
}

class _HeaderLogin extends StatelessWidget {
  const _HeaderLogin({required this.isSecondBottomActivate});

  final bool isSecondBottomActivate;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (isSecondBottomActivate == false) ? 'Sign In' : 'Register',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
          ),
          const SizedBox(height: 16),
          Text(
            (isSecondBottomActivate == false)
                ? 'Access to your content in Apple Music'
                : 'Access to hours of music in Apple Music',
            style: const TextStyle(fontSize: 15),
          ),
        ]);
  }
}
