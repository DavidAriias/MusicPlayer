import 'package:flutter/material.dart';

Route<Object?> routeAnimation(page) {
  return PageRouteBuilder(
    pageBuilder:(context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(microseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.linear);

      return SlideTransition(
        position: Tween<Offset> (begin: const Offset(0.0, 1.0), end: Offset.zero).animate(curvedAnimation),
        child: child,
        );
    },
    );
}