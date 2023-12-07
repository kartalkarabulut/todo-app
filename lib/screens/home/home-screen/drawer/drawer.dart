import 'package:flutter/material.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/screens/home/home-screen/drawer/widgets/categories_in_drawer.dart';
import 'package:task_manager/screens/home/home-screen/drawer/widgets/drawer_header.dart';
import 'package:task_manager/screens/home/home-screen/widgets/add_todo_dialog.dart';
import 'package:task_manager/widgets/button.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.butonBackgroundColor,
      width: 250,
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: DrawerHeaderWidget(),
          ),
          const Expanded(flex: 2, child: Categories()),
          Button(
            title: "Add Category",
            onPressed: () async {
              String dialogType = "category";
              AddingDialog(dialogType: dialogType)
                  .showInputDialgo(context, userId);
            },
          )
        ],
      ),
    );
  }
}
