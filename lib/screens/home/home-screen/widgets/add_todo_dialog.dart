import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/models/todo_model.dart';

import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/screens/home/home-screen/home_screen.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';
import 'package:task_manager/widgets/app_texts.dart';
import 'package:task_manager/widgets/button.dart';

class AddingDialog {
  AddingDialog({required this.dialogType});

  String dialogType;

  Future showInputDialgo(context, String? userId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (dialogType == "todo") {
            return const CreatTodoDialog();
          } else {
            return const CreateCategoryDialog();
          }
        });
  }
}

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  TextEditingController categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String? userId = ref.watch(userIdProvider);

        return AlertDialog(
          backgroundColor: AppColors.todoBackground,
          title: AppText.boldMedium("Create New Category"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(children: [
              TextField(
                controller: categoryNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Category Name',
                ),
              ),
              Button(
                title: "Create",
                onPressed: () async {
                  var navigator = Navigator.of(context);
                  await TodoServices()
                      .createCategory(userId!, categoryNameController.text);
                  // categoryListNotifier.addCategory(
                  //     userId!, categoryNameController.text);
                  navigator.push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              )
            ]),
          ),
        );
      },
    );
  }
}

class CreatTodoDialog extends StatefulWidget {
  const CreatTodoDialog({super.key});

  @override
  State<CreatTodoDialog> createState() => _CreatTodoDialogState();
}

class _CreatTodoDialogState extends State<CreatTodoDialog> {
  TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String? userId = ref.watch(userIdProvider);
        return FutureBuilder<List<String>?>(
          future: TodoServices().fetchAllCategories(userId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              List<String>? categories = snapshot.data;

              return AlertDialog(
                backgroundColor: AppColors.todoBackground,
                title: AppText.boldMedium("Add Todo"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    children: [
                      TextField(
                        controller: descriptionController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DropdownButton<String>(
                        value: selectedCategory,
                        hint: AppText.small("Select Category"),
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        items: categories?.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: AppText.medium(category),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Button(
                        title: "Add Todo",
                        onPressed: () async {
                          var navigator = Navigator.of(context);
                          await TodoServices().createTodo(
                            userId,
                            selectedCategory ?? "General",
                            TodoModel(
                              description: descriptionController.text,
                              category: selectedCategory ?? "General",
                            ),
                          );
                          descriptionController.clear();
                          navigator.pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
