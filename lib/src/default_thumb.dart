import 'package:flutter/material.dart';

/// A default thumb for the [MultiThumbSlider].
///
/// This thumb is a simple circle with a shadow.
/// The color of the thumb can be changed by passing a [color] to the constructor.
class DefaultThumb extends StatelessWidget {
  /// Creates a default thumb. A color can be passed to the constructor.
  const DefaultThumb({super.key, this.color});

  /// The color of the thumb.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      decoration: BoxDecoration(
        color: color ?? Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: const Offset(0.0, 0.0),
          ),
        ],
      ),
    );
  }
}
