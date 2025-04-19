import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';
import '../functions/my_functions.dart';

class InputFields extends StatelessWidget {
  const InputFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() => Column(
          children: [
            _buildField(
              label: MyFunctions.getTotalItemsText(),
              controller: controller.totalItemsController,
              onChanged: (value) =>
                  controller.validateTotalItems(value, context),
              errorText: controller.totalItemsError.value,
              color: controller.currentColor,
              context: context,
            ),
            const SizedBox(height: 12),
            _buildField(
              label: MyFunctions.getItemsInLineText(),
              controller: controller.itemsInLineController,
              onChanged: (value) =>
                  controller.validateItemsInLine(value, context),
              errorText: controller.itemsInLineError.value,
              color: controller.currentColor,
              context: context,
            ),
          ],
        ));
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
    required Color color,
    String? errorText,
    required BuildContext context,
  }) {
    return SizedBox(
      width:
          MyFunctions.getResponsiveWidth(context, 0.19),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: color,
        ),
        cursorColor: color,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          floatingLabelStyle: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color, width: 1.8),
          ),
          errorText: errorText?.isNotEmpty == true ? errorText : null,
          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        ),
      ),
    );
  }
}
