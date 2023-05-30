import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 4 ),
      child: Column(
      children: const [
        CupertinoActivityIndicator(),
        Text(
          'LOADING',
          style: TextStyle(color: Colors.grey),
        )
      ],
      ),
    );
  }
}
