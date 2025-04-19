import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_controller.dart';

class ReverseToggle extends StatelessWidget {
  const ReverseToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Reverse", style: TextStyle(color: controller.currentColor, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 120),
            Switch(
              value: controller.isReversed.value,
              activeColor: controller.currentColor,
              onChanged: controller.toggleReverse,
            ),
          ],
        ));
  }
}
