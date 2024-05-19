import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int itemCount;

  Badge({
    required this.child,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              itemCount.toString(),
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
