import 'package:flutter/material.dart';

class BadgeAppBar extends StatelessWidget {
  final Widget newChild;
  final String countOfCart;
  Color? color;

  BadgeAppBar({
    required this.newChild,
    required this.countOfCart,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        newChild,
        Positioned(
          
          right: 8,
          top: 8,
          child: Container(
        
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color != null ? color : Colors.deepOrange,
              ),
              constraints: BoxConstraints(minHeight: 15, minWidth: 15),
              child: Text(
                countOfCart,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              )),
        ),
      ],
    );
  }
}
