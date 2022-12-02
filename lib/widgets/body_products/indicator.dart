import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainer(context, 0),
          buildContainer(context, 1),
          buildContainer(context, 2),
          buildContainer(context, 3),
        ],
      ),
    );
  }

  Widget buildContainer(BuildContext ctx, int i) {
    return Container(
      margin: EdgeInsets.all(4),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: index == i ? Theme.of(ctx).colorScheme.secondary : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
