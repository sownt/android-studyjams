import 'package:android_studyjams/utils/colors.dart';
import 'package:flutter/material.dart';

class TextBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const TextBadge({
    super.key,
    required this.text,
    this.color = AppColors.transparent,
    this.textColor = AppColors.black,
  });

  const TextBadge.error({
    super.key,
    required this.text,
    this.color = AppColors.red,
    this.textColor = AppColors.white,
  });

  const TextBadge.blue({
    super.key,
    required this.text,
    this.color = AppColors.blue,
    this.textColor = AppColors.white,
  });

  const TextBadge.yellow({
    super.key,
    required this.text,
    this.color = AppColors.yellow,
    this.textColor = AppColors.black,
  });

  const TextBadge.green({
    super.key,
    required this.text,
    this.color = AppColors.green,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      child: Text(
        text.toLowerCase(),
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
