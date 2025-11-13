import 'package:bio_pet/utils/color_const.dart';
import 'package:flutter/material.dart';

class TextStyles {
  // 1. Main Title: "Dog Breed Classifier" (Large, bold, dark blue/white)
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'Roboto', // Replace with your desired font
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: lightTextColor,
  );

  // 2. Subtitle/Description: "Advanced AI-powered dog breed identification..." (Medium size, light blue/white)
  static const TextStyle subTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF90CAF9), // A lighter shade of blue/white
  );

  // 3. Section/Action Headings: "Choose Image Source", "How It Works" (Medium-large, bold, light blue/white)
  static const TextStyle b1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: lightTextColor,
  );

  // 4. Body/Instructional text: "Take a photo or select from gallery..." (Medium size, regular weight, light grey/white)
  static const TextStyle b2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFFE0E0E0), // Light grey
  );

  // 5. Fine print/footer text: "All classifications are saved to your history..." (Small size, regular weight, light blue/white)
  static const TextStyle b3 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFFBBDEFB), // Very light blue
  );
}
