import 'package:flutter/material.dart';

class HeaderSubPage extends StatelessWidget {
  const HeaderSubPage({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 21,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Done',
                style: TextStyle(
                    color:  Color.fromRGBO(255, 51, 91,1),
                    fontWeight: FontWeight.w600,
                    fontSize: 21),
              )),
        ),
      ],
    );
  }
}