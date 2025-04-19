import 'package:flutter/material.dart';
import '../data/my_data.dart';
import '../functions/my_functions.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyFunctions.getResponsiveWidth(context, 0.2),
      height: MyFunctions.getResponsiveHeight(context, 0.15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        MyData.imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
