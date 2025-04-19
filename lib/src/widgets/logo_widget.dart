import 'package:flutter/material.dart';
import '../data/my_data.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge, // Ensures image respects borderRadius
      child: Image.network(
        MyData.imageUrl,
        fit: BoxFit.cover, // Make it fill the container
        alignment: Alignment.center,
      ),
    );
  }
}

