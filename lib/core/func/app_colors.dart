
import 'package:flutter/material.dart';


List<Color> generateColors(int count) {
  final hsl = HSLColor.fromColor(primaryColor);

  // We'll vary the lightness between 0.3 and 0.8 to create shades
  return List.generate(count, (i) {
    double lightnessStep = 0.3 + (i / (count - 1)) * 0.5;
    return hsl.withLightness(lightnessStep.clamp(0.0, 1.0)).toColor();
  });
}


const primaryColor = Color(0xFF420f8d);
