import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/screens/home/home-screen/category_pages.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';
import 'package:task_manager/widgets/app_texts.dart';

class Categories extends StatefulWidget {
  const Categories({
    super.key,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String? userId = ref.watch(userIdProvider);

        return FutureBuilder(
          future: TodoServices().fetchAllCategories(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: AppText.boldLarge("Bir hata oldu"),
              );
            }
            final kategoriler = snapshot.data;
            if (kategoriler != null) {
              return ListView.builder(
                itemCount: kategoriler.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPages(
                            categoryName: kategoriler[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        //tileColor: Colors.red,
                        iconColor: AppColors.primaryBlackColor,
                        title: AppText.boldLarge(
                            "${toBeginningOfSentenceCase(kategoriler[index])}"),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.arrow_right,
                            size: 50,
                          ),
                          onPressed: () {
                            print("perres meeoo");
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("No Categories"));
          },
        );
      },
    );
  }
}
