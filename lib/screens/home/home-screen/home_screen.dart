import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/riverpod/todo_provider.dart';
import 'package:task_manager/screens/home/home-screen/drawer/drawer.dart';
import 'package:task_manager/screens/home/home-screen/widgets/add_todo_dialog.dart';
import 'package:task_manager/screens/validation_screens/login%20screen/login_screen.dart';
import 'package:task_manager/services/firebase/auth/firebase_auth.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';
import 'package:task_manager/widgets/app_texts.dart';
import 'package:task_manager/widgets/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isChecked = false;
  TodoServices todoServices = TodoServices();

  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppColors.doneTodoTextColor,
        title: Consumer(
          builder: (context, ref, child) {
            final userName = ref.watch(userDataProvider);
            return userName == null
                ? const CircularProgressIndicator()
                : AppText.large(userName.value ?? " ad yok");
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var navigator = Navigator.of(context);
              await AuthenticationServices().logOut();

              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (navigator) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          String? userId = ref.watch(userIdProvider);
          final todos = ref.watch(todoStreamProvider).value;
          if (todos == null) {
            return const CircularProgressIndicator();
          }
          List<TodoModel> incompleteTodos =
              todos.where((todo) => todo.isDone == false).toList();
          List<TodoModel> completeTodos =
              todos.where((todo) => todo.isDone == true).toList();
          return ListView.builder(
            itemCount: incompleteTodos.length + completeTodos.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (incompleteTodos.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        AppText.boldMedium(
                            "Incomplete todos ${incompleteTodos.length}"),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
              if (incompleteTodos.isNotEmpty &&
                  index > 0 &&
                  index <= incompleteTodos.length) {
                return TodoCard(
                  todo: incompleteTodos[index - 1],
                  //onPressed: () async {
                  // await TodoServices().deleteTodo(
                  //     userId,
                  //     incompleteTodos[index - 1].todoId,
                  //     incompleteTodos[index - 1].category);
                  //},
                );
              } else if (index == incompleteTodos.length + 1) {
                if (completeTodos.isNotEmpty) {
                  return Row(
                    children: [
                      AppText.boldSmall(
                          "Completed Todos ${completeTodos.length}"),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              } else if (index >= incompleteTodos.length + 2 &&
                  completeTodos.isNotEmpty) {
                TodoModel todo =
                    completeTodos[index - incompleteTodos.length - 2];
                return TodoCard(
                  todo: todo,
                );
              }
              return null;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 40.0,
        onPressed: () {
          String dialogType = "todo";
          AddingDialog(dialogType: dialogType).showInputDialgo(context, userId);
        },
        label: AppText.boldSmall("Add Todo"),
      ),
      drawer: HomeScreenDrawer(userId: userId),
    );
  }
}
