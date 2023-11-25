import 'package:flutter/material.dart';

BoxDecoration getGradientBackground(BuildContext context) {
  return BoxDecoration(
      gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
           // stops: const [0.5, 0.8, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight
      )
  );
}