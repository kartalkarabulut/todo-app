import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/riverpod/providers/user_providers.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';

final todoStreamProvider = StreamProvider<List<TodoModel>>((ref) {
  String? userId = ref.watch(userIdProvider);
  var todos = TodoServices().fetchAllTodos(userId, "General");
  return todos;
});

final categoryListProvider = FutureProvider<List<String>?>(
  (ref) async {
    final userId = ref.watch(userIdProvider);

    return await TodoServices().fetchAllCategories(userId!);
  },
);
