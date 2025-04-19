import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/my_data.dart';

enum ProgressSpeed { slow, smooth, fast }

class MainController extends GetxController {
  Rx<ProgressSpeed> speed = ProgressSpeed.smooth.obs;
  RxString selectedColor = 'Green'.obs;
  RxBool isReversed = false.obs;
  RxBool showBubbleLabel = false.obs;

  final RxInt totalItems = 0.obs;
  final RxInt itemsInLine = 0.obs;

  final TextEditingController totalItemsController = TextEditingController();
  final TextEditingController itemsInLineController = TextEditingController();

  final RxString totalItemsError = ''.obs;
  final RxString itemsInLineError = ''.obs;

  static const int maxTotalItems = 30;
  static const int maxItemsInLine = 15;

  List<RxDouble> itemProgresses = [0.0.obs];

  Timer? _timer;
  Timer? _bubbleTimer;

  Color get currentColor => MyData.colorMap[selectedColor.value]!;
  List<Color> get gradientColors => MyData.gradientMap[selectedColor.value]!;

  List<Color> get darkGradientColors {
    final base = currentColor;
    final darker = _darken(base, 0.3);
    return [darker.withOpacity(0.8), darker];
  }

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _startSequentialProgress();
  }

  void _setupListeners() {
    totalItemsController.addListener(() {
      final parsed = _parseLimitedValue(
        totalItemsController.text,
        maxTotalItems,
        'Maximum allowed total items is $maxTotalItems',
        Get.context!,
      );
      totalItems.value = parsed;
      _initializeProgressBars();
    });

    itemsInLineController.addListener(() {
      final parsed = _parseLimitedValue(
        itemsInLineController.text,
        maxItemsInLine,
        'Maximum allowed items in a line is $maxItemsInLine',
        Get.context!,
      );
      itemsInLine.value = parsed;
    });
  }

  int _parseLimitedValue(
      String value, int maxAllowed, String errorMsg, BuildContext context) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) {
      _showErrorSnackbar(errorMsg, context);
      return 1; // Default to 1 if empty
    }

    int? parsed = int.tryParse(digitsOnly);
    if (parsed != null && parsed <= maxAllowed && parsed >= 1) return parsed;

    // Pick longest valid prefix <= maxAllowed and >= 1
    for (int i = digitsOnly.length; i > 0; i--) {
      final sub = digitsOnly.substring(0, i);
      final attempt = int.tryParse(sub);
      if (attempt != null && attempt <= maxAllowed && attempt >= 1) {
        _showErrorSnackbar(errorMsg, context);
        return attempt;
      }
    }

    _showErrorSnackbar(errorMsg, context);
    return 1; // Fallback default
  }

  void _initializeProgressBars() {
    final count = totalItems.value.clamp(1, maxTotalItems);
    itemProgresses =
        count > 0 ? List.generate(count, (_) => 0.0.obs) : [0.0.obs];

    _restartSequentialProgress();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _bubbleTimer?.cancel();
    totalItemsController.dispose();
    itemsInLineController.dispose();
    super.onClose();
  }

  void updateColor(String? color) {
    if (color != null) selectedColor.value = color;
  }

  void toggleReverse(bool value) {
    isReversed.value = value;
    _restartSequentialProgress();
  }

  void updateSpeed(ProgressSpeed newSpeed, {bool persistLabel = false}) {
    if (speed.value == newSpeed && persistLabel) {
      showBubbleLabel.value = !showBubbleLabel.value;
      _bubbleTimer?.cancel();
      return;
    }

    speed.value = newSpeed;
    showBubbleLabel.value = true;
    _bubbleTimer?.cancel();

    if (!persistLabel) {
      _bubbleTimer = Timer(const Duration(seconds: 2), () {
        showBubbleLabel.value = false;
      });
    }

    _restartSequentialProgress();
  }

  Duration get speedDuration {
    switch (speed.value) {
      case ProgressSpeed.slow:
        return const Duration(milliseconds: 70);
      case ProgressSpeed.smooth:
        return const Duration(milliseconds: 30);
      case ProgressSpeed.fast:
        return const Duration(milliseconds: 8);
    }
  }

  void _restartSequentialProgress() {
    _timer?.cancel();
    _resetProgress();
    _startSequentialProgress();
  }

  void _resetProgress() {
    for (var p in itemProgresses) {
      p.value = 0.0;
    }
  }

  void _startSequentialProgress() {
    int currentIndex = isReversed.value ? itemProgresses.length - 1 : 0;

    _timer = Timer.periodic(speedDuration, (timer) {
      if (itemProgresses.isEmpty) return;

      if (totalItems.value == 0) {
        var progress = itemProgresses[0];
        progress.value += 0.01;
        if (progress.value >= 1.0) {
          progress.value = 0.0;
        }
        return;
      }

      if (currentIndex == -1 || currentIndex >= itemProgresses.length) {
        // Reset all progress and restart from beginning
        for (var p in itemProgresses) {
          p.value = 0.0;
        }
        currentIndex = isReversed.value ? itemProgresses.length - 1 : 0;
        return;
      }

      itemProgresses[currentIndex].value += 0.01;
      if (itemProgresses[currentIndex].value >= 1.0) {
        itemProgresses[currentIndex].value = 1.0;
        currentIndex = isReversed.value ? currentIndex - 1 : currentIndex + 1;
      }
    });
  }

  void validateTotalItems(String value, BuildContext context) {
    final corrected = _parseLimitedValue(
      value.isEmpty ? '1' : value,
      maxTotalItems,
      'Maximum allowed total items is $maxTotalItems',
      context,
    );
    totalItems.value = corrected;
    _initializeProgressBars();
  }

  void validateItemsInLine(String value, BuildContext context) {
    final corrected = _parseLimitedValue(
      value.isEmpty ? '1' : value,
      maxItemsInLine,
      'Maximum allowed items in a line is $maxItemsInLine',
      context,
    );
    itemsInLine.value = corrected;
  }

  void _showErrorSnackbar(String message, BuildContext context) {
    final overlay = Overlay.of(context);
    final isTotalItemsError = message.contains('total items');
    final isItemsInLineError = message.contains('items in a line');

    final subtitle = isTotalItemsError
        ? 'Only 30 items allowed'
        : isItemsInLineError
            ? 'Only 15 items allowed'
            : message;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 12,
        right: 12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xE5E1E1E5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ERROR',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }
}
