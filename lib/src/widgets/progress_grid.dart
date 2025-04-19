import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_controller.dart';
import 'progress_bar.dart';

class ProgressGrid extends StatelessWidget {
  const ProgressGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Obx(() {
      final totalItems = controller.totalItems.value;
      final itemsInLine = controller.itemsInLine.value;

      if (totalItems <= 0 || itemsInLine <= 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: const SizedBox(height: 20, child: ProgressBar(index: 0)),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const itemSpacing = 8.0;
          final availableWidth = constraints.maxWidth;
          final itemWidth = (availableWidth - (itemsInLine + 1) * itemSpacing) / itemsInLine;

          final rows = <Widget>[];
          int count = 0;

          while (count < totalItems) {
            final remaining = totalItems - count;
            final itemsInThisRow = remaining >= itemsInLine ? itemsInLine : remaining;

            rows.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(itemsInThisRow, (index) {
                    final globalIndex = count + index;
                    return Padding(
                      padding: const EdgeInsets.all(itemSpacing / 2),
                      child: SizedBox(
                        width: itemWidth,
                        height: 20,
                        child: ProgressBar(index: globalIndex),
                      ),
                    );
                  }),
                ),
              ),
            );

            count += itemsInThisRow;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rows,
          );
        },
      );
    });
  }
}
