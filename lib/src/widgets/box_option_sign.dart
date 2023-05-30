import 'package:flutter/material.dart';

class BoxOptionSignIn extends StatelessWidget {
  const BoxOptionSignIn({super.key, required this.size, required this.children, this.color});

  final Size size;
  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: color,
        width: size.width,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children),
        ),
      ),
    );
  }
}