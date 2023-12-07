import 'package:flutter/material.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/widgets/app_texts.dart';

class Button extends StatefulWidget {
  Button({super.key, this.onPressed, required this.title});

  VoidCallback? onPressed;
  String title;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.butonBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      child: AppText.boldSmall(
        widget.title,
      ),
    );
  }
}
