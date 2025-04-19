import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';

class ProgressBar extends StatelessWidget {
  final int index;

  const ProgressBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() {
      final progress = (index < controller.itemProgresses.length)
          ? controller.itemProgresses[index].value
          : 0.0;

      final baseColor = controller.currentColor;
      final darkColor = _darken(baseColor, 0.3);

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.5),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              Align(
                alignment: controller.isReversed.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: controller.isReversed.value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [baseColor, darkColor],
                        begin: controller.isReversed.value
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        end: controller.isReversed.value
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }
}
