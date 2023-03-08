import 'package:flutter/material.dart';

class GrayedOut extends StatelessWidget {
  final Widget child;
  final bool grayedOut;

  const GrayedOut({required this.child, super.key, required this.grayedOut});

  @override
  Widget build(BuildContext context) {
    return grayedOut
        ? AbsorbPointer(
            absorbing: true,
            child: Opacity(opacity: 0.3, child: child),
          )
        : child;
  }
}
