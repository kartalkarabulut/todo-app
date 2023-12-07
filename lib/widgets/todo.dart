import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/screens/edit-todo/update_todo.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';

class TodoCard extends ConsumerStatefulWidget {
  TodoCard({Key? key, required this.todo}) : super(key: key);

  // String description;
  // bool isDone;
  // VoidCallback? onPressed;

  TodoModel todo;
  TodoServices todoServices = TodoServices();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<TodoCard> {
  bool? isChecked = false;

  bool isExpanded = false;
  //late TodoModel theTodo;
  TodoServices todoServices = TodoServices();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   theTodo = widget.todo;
  // }

  @override
  Widget build(BuildContext context) {
    String? userId = ref.watch(userIdProvider);
    return Container(
      margin: const EdgeInsets.all(10),
      color: AppColors.todoBackground,
      //height: 60,
      width: double.infinity,
      child: Row(
        children: [
          Checkbox(
              value: widget.todo.isDone,
              onChanged: (bool? value) async {
                if (value != null) {
                  bool isDone = await TodoServices()
                      .completeTodo(userId, widget.todo, widget.todo.category);
                  if (isDone) {
                    setState(
                      () {
                        //theTodo.isDone = !theTodo.isDone;
                        widget.todo.isDone = !widget.todo.isDone;
                      },
                    );
                  }
                }
              }),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTodo(todo: widget.todo),
                  ),
                );
              },
              child: Text(
                softWrap: true,
                widget.todo.description,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  decorationColor: AppColors.primaryBlackColor,
                  decorationThickness: 2,
                  decoration:
                      widget.todo.isDone ? TextDecoration.lineThrough : null,
                  color: widget.todo.isDone
                      ? AppColors.doneTodoTextColor
                      : AppColors.primaryBlackColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    bool isDone = await todoServices.updateIsStarred(
                        userId, widget.todo, widget.todo.category);
                    if (isDone) {
                      setState(() {
                        widget.todo.isStarred = !widget.todo.isStarred;
                      });
                    }
                  },
                  icon: widget.todo.isStarred
                      ? const Icon(
                          Icons.star,
                          color: AppColors.doneTodoTextColor,
                        )
                      : const Icon(
                          Icons.star_border,
                          color: AppColors.doneTodoTextColor,
                        ),
                ),
                IconButton(
                  onPressed: () async {
                    await todoServices.deleteTodo(
                        userId!, widget.todo.todoId, widget.todo.category);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.doneTodoTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
