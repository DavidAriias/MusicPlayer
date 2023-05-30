import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class MenuAppButton {
  final Function onPressed;
  final IconData icon;
  final String label;
  

  MenuAppButton({required this.label,required this.icon, required this.onPressed});
}

class MenuApp extends StatelessWidget {

  final List<MenuAppButton> items;

  const MenuApp({super.key, required this.items});

   @override
   Widget build(BuildContext context) {
     return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
       child: _MenuBackground(
        child: _MenuItems(
          menuItems: items
          )),
     );
   }
 }

class _MenuBackground extends StatelessWidget {

  final Widget child;

  const _MenuBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     height: 70,
     child: ClipRRect(
       child: BackdropFilter(
         filter: ImageFilter.blur( sigmaX: 20.0, sigmaY: 20.0),
           child: Container(
              color: Colors.black12,
              child: child,
           ),
         ),
     ),
    );
  }
}

 class _MenuItems extends StatelessWidget {
   
   final List<MenuAppButton> menuItems;

  const _MenuItems({required this.menuItems});

 
   @override
   Widget build(BuildContext context) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        menuItems.length, 
        (index) => _MenuAppButton(index: index, item: menuItems[index]))
     );
   }
 }

 class _MenuAppButton extends StatelessWidget {
   
   final int index;
   final MenuAppButton item;

  const _MenuAppButton({required this.index, required this.item});
   @override
   Widget build(BuildContext context) {

    final itemSelected = Provider.of<_MenuModel>(context).itemSelected;

     return GestureDetector(
      onTap: (){
        Provider.of<_MenuModel>(context, listen: false).itemSelected = index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
          item.icon ,
          color : (itemSelected == index ) ? const Color.fromRGBO(255, 51, 91,1) :  Colors.grey.shade500),
          Text(
           item.label,
           style: TextStyle(
            color: (itemSelected == index ) ? const Color.fromRGBO(255, 51, 91,1) :  Colors.grey.shade500
            ))
          ],
       ),
     );
   }
 }

 class _MenuModel  extends ChangeNotifier{

  int _itemSelected = 0;

  int get itemSelected => _itemSelected;

  set itemSelected(int index){
    _itemSelected = index;
    notifyListeners();
  }
 }