import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() {
      final currentSpeed = controller.speed.value;
      final fillColor = controller.currentColor;
      final showLabel = controller.showBubbleLabel.value;

      double fillWidthFactor = switch (currentSpeed) {
        ProgressSpeed.slow => 0.0,
        ProgressSpeed.smooth => 0.5,
        ProgressSpeed.fast => 1.0,
      };

      return Column(
        children: [
          SizedBox(
            width: 250,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Floating label
                if (showLabel)
                  Positioned(
                    top: -30,
                    left: switch (currentSpeed) {
                      ProgressSpeed.slow => -15,
                      ProgressSpeed.smooth => (250 / 2) - 35,
                      ProgressSpeed.fast => 250 - 30,
                    },
                    child: _bubbleLabel(
                      text: currentSpeed.name.toUpperCase(),
                      color: fillColor,
                    ),
                  ),

                // Slider
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTapDown: (details) {
                      const totalWidth = 250.0;
                      final localPosition = details.localPosition.dx;

                      if (localPosition < totalWidth / 3) {
                        controller.updateSpeed(ProgressSpeed.slow);
                      } else if (localPosition < 2 * totalWidth / 3) {
                        controller.updateSpeed(ProgressSpeed.smooth);
                      } else {
                        controller.updateSpeed(ProgressSpeed.fast);
                      }
                    },
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Track
                          Container(
                            width: double.infinity,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),

                          // Fill
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: 250 * fillWidthFactor,
                              height: 6,
                              decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),

                          // Dots
                          Positioned(
                            left: 0,
                            child: _stepDot(
                              active: currentSpeed == ProgressSpeed.slow,
                              color: fillColor,
                              onTap: () => controller.updateSpeed(ProgressSpeed.slow, persistLabel: true),
                            ),
                          ),
                          Positioned(
                            left: 125 - 10,
                            child: _stepDot(
                              active: currentSpeed == ProgressSpeed.smooth,
                              color: fillColor,
                              onTap: () => controller.updateSpeed(ProgressSpeed.smooth, persistLabel: true),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: _stepDot(
                              active: currentSpeed == ProgressSpeed.fast,
                              color: fillColor,
                              onTap: () => controller.updateSpeed(ProgressSpeed.fast, persistLabel: true),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _stepDot({
    required bool active,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: active ? 20 : 5,
        height: active ? 20 : 8,
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _bubbleLabel({required String text, required Color color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
        CustomPaint(
          painter: _BubbleArrowPainter(color),
          size: const Size(14, 6),
        ),
      ],
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;

  _BubbleArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
