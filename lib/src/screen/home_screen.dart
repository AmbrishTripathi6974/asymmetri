import 'package:asymmetri_assign/src/widgets/progress_grid.dart';
import 'package:flutter/material.dart';

import '../widgets/color_dropdown.dart';
import '../widgets/input_fields.dart';
import '../widgets/logo_widget.dart';
import '../widgets/reverse_toggle.dart';
import '../widgets/slider_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LogoImage(),
              SizedBox(height: 20),
              ColorDropdown(),
              SizedBox(height: 10),
              SliderWidget(),
              SizedBox(height: 30),
              InputFields(),
              SizedBox(height: 20),
              ReverseToggle(),
              SizedBox(height: 40),
              ProgressGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
