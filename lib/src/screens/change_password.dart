import 'package:apple_music/services/service_login.dart';
import 'package:apple_music/src/models/user_model.dart';
import 'package:apple_music/src/themes/themes.dart';
import 'package:apple_music/src/widgets/box_option_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final userStatus = Provider.of<UserModel>(context);
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();

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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 51, 91, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 21),
                        )),
                    const Text(
                      'Change the password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            final response = modifyUsers(
                                userStatus.email, userStatus.password);

                            response.then((res) {
                              if (res.statusCode == 200) {
                                Navigator.pop(context);
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                            title: const Text('Error'),
                                            content: Text(res.body
                                                ),
                                            actions: [
                                              CupertinoDialogAction(
                                                  child: const Text('OK'),
                                                  onPressed: () =>
                                                      Navigator.pop(context))
                                            ]));
                              }
                            });
                          }
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 51, 91, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 21),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                    'In this section you will be able to change the password, try that password will be safe.'),
                const SizedBox(height: 30),
                BoxOptionSignIn(
                  color: appTheme.currentTheme.cardColor,
                  size: size,
                  children: [
                    const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    Text(userStatus.email,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400))
                  ],
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: CupertinoFormSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      margin: const EdgeInsets.all(0),
                      children: [
                        CupertinoTextFormFieldRow(
                            style: TextStyle(
                                color: (appTheme.darkTheme)
                                    ? Colors.white
                                    : Colors.black),
                            autofocus: true,
                            prefix: const Text('Password'),
                            placeholder: 'New Password',
                            obscureText: true,
                            maxLength: 16,
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value!.isEmpty || value.length > 16) {
                                return "Enter correct password";
                              } else {
                                return null;
                              }
                            }),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
