import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';
import 'package:task_manager/widgets/app_texts.dart';
import 'package:task_manager/widgets/button.dart';

class UpdateTodo extends ConsumerWidget {
  UpdateTodo({super.key, required this.todo});

  TextEditingController descriptionController = TextEditingController();
  TodoModel todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    descriptionController.text = todo.description;
    String? userId = ref.watch(userIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: AppText.boldMedium("Edit Todo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectionArea(
              child: AppText.boldSmall(
                """${todo.creationTime.day.toString().padLeft(2, "0")}/${todo.creationTime.month.toString().padLeft(2, "0")}/${todo.creationTime.year.toString().padLeft(2, "0")}  ${todo.creationTime.hour.toString().padLeft(2, "0")}:${(todo.creationTime.minute).toString().padLeft(2, "0")} tarihinde oluşturuldu""",
                //textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: TextField(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                ),
                controller: descriptionController,
              ),
            ),
            Button(
              title: "Update",
              onPressed: () async {
                var navigator = Navigator.of(context);
                await TodoServices().updateTodo(userId, todo.todoId,
                    descriptionController.text, todo.category);
                navigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
