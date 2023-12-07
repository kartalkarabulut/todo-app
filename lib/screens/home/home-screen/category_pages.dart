import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/screens/home/home-screen/home_screen.dart';
import 'package:task_manager/screens/home/home-screen/widgets/add_todo_dialog.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';
import 'package:task_manager/widgets/app_texts.dart';
import 'package:task_manager/widgets/todo.dart';

class CategoryPages extends ConsumerWidget {
  CategoryPages({super.key, required this.categoryName});

  String categoryName;
  TodoServices todoServices = TodoServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? userId = ref.watch(userIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: AppText.boldMedium("${toBeginningOfSentenceCase(categoryName)}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var navigator = Navigator.of(context);
                await todoServices.deleteCategory(userId!, categoryName);
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: StreamBuilder(
        stream: todoServices.fetchAllTodos(userId, categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: AppText.boldLarge("No Todos"),
              );
            }
            List<TodoModel> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TodoCard(
                  todo: todos[index],
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return const Center(
            child: Text("bilinmeyen bir şey olrdu"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String dialogType = "todo";
          AddingDialog(dialogType: dialogType).showInputDialgo(context, userId);
        },
        label: AppText.boldSmall("Add Todo"),
      ),
    );
  }
}
