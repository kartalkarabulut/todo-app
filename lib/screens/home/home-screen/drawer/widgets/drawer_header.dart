import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/widgets/app_texts.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              child: CircleAvatar(
                child: FlutterLogo(),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final userName = ref.watch(userDataProvider);
                return AppText.boldLarge(userName.value!);
              },
            )
          ],
        ),
      ),
    );
  }
}
