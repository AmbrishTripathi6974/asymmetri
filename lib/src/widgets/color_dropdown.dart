import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';
import '../data/my_data.dart';

class ColorDropdown extends StatelessWidget {
  const ColorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    return Obx(() => Container(
          width: 280,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFede9f0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 5,
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedColor.value,
              items: MyData.colorList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: controller.updateColor,
            ),
          ),
        ));
  }
}
