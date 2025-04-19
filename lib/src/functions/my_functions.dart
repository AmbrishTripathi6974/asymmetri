import 'package:flutter/material.dart';

class MyFunctions {
  // Static texts
  static String getTotalItemsText() => "Total Items";
  static String getItemsInLineText() => "Items in Line";

  // Responsive width based on screen width
  static double getResponsiveWidth(BuildContext context, double percent) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * percent;
  }

  // Responsive height based on screen height
  static double getResponsiveHeight(BuildContext context, double percent) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percent;
  }
}
