import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/todo_model.dart';

class TodoServices {
  FirebaseFirestore cloudDatabase = FirebaseFirestore.instance;

  /// TODOs TRANSACTIONS METHODS
  Stream<List<TodoModel>> fetchAllTodos(String? userId, String categoryName) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference categories = users.doc(userId).collection("categories");
    CollectionReference todosRef =
        categories.doc(categoryName).collection("todos");

    return todosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }

  Future createCategory(String userId, String categoryName) async {
    try {
      if (userId.isNotEmpty && categoryName.isNotEmpty) {
        CollectionReference users = cloudDatabase.collection("users");
        CollectionReference categories =
            users.doc(userId).collection("categories");
        Map<String, dynamic> categoryData = {"categoryName": categoryName};
        //categories.add(categoryData);
        await categories.doc(categoryName).set(categoryData);
        print("Todo added id updated");
      } else {
        print("userid veya categorydata boş olmuş olabilir");
      }
    } catch (e) {
      print("Erorrrrr $e");
    }
  }

  //Method for creating a todo/task
  Future createTodo(String userId, String categoryName, TodoModel todo) async {
    try {
      CollectionReference users = cloudDatabase.collection("users");
      CollectionReference categories =
          users.doc(userId).collection("categories");
      CollectionReference todosRef =
          categories.doc(categoryName).collection("todos");
      DocumentReference docReference = await todosRef.add(todo.toJson());
      todo.todoId = docReference.id;
      await todosRef.doc(docReference.id).update({"todoId": docReference.id});
      print("Todo added id updated");
    } catch (e) {
      print("Erorrrrr $e");
    }
  }

  //Method for updating a todo/task
  Future updateTodo(String? userId, String? todoId, String description,
      String? categoryName) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference categories = users.doc(userId).collection("categories");
    CollectionReference todos =
        categories.doc(categoryName).collection("todos");

    try {
      await todos.doc(todoId).update({
        "description": description,
      });
    } catch (e) {
      print("error issss $e");
      print("description is $description");
      print(" iddd isss $todoId");
    }
  }

  //Method for deleting a todo/task
  Future deleteTodo(String? userId, String? todoId, String categoryName) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference categories = users.doc(userId).collection("categories");
    CollectionReference todosRef =
        categories.doc(categoryName).collection("todos");

    await todosRef.doc(todoId).delete();
    print("Todo Deleted");
  }

  //Update todo as completed
  Future completeTodo(String? userId, TodoModel todo, String category) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference categories = users.doc(userId).collection("categories");

    CollectionReference todoCollection =
        categories.doc(category).collection("todos");

    return todoCollection.doc(todo.todoId).update({
      "isDone": !todo.isDone,
    });
  }

  //Star or unstar todos/tasks
  Future updateIsStarred(
      String? userId, TodoModel todo, String category) async {
    CollectionReference users = cloudDatabase.collection("users");

    CollectionReference categories = users.doc(userId).collection("categories");
    CollectionReference todoCollection =
        categories.doc(category).collection("todos");

    return todoCollection.doc(todo.todoId).update({
      "isStarred": !todo.isStarred,
    });
  }

  //Fetch all starred todos/tasks
  Stream<List<TodoModel>> queryStarredTodos(String? userId) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todos = users.doc(userId).collection("todos");

    return todos
        .where("isStarred", isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }

  /// CATEGORIZATION TRANSACTIONS METHODS

  Future<List<String>>? fetchAllCategories(String userId) async {
    List<String>? kategoriler = [];
    try {
      CollectionReference users = cloudDatabase.collection("users");
      CollectionReference categories =
          users.doc(userId).collection("categories");
      QuerySnapshot categorySnapshot = await categories.get();

      kategoriler = categorySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)["categoryName"] as String)
          .toList();
      // kategoriler = [...categoryNames];
      return kategoriler;
    } catch (error) {
      print("oluşan hatamız ::::::=== $error");
      return ["hiç kategori olmadı"];
    }
  }

  Future deleteCategory(String? userId, String categoryName) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference categories = users.doc(userId).collection("categories");

    try {
      ///Get access to todos collection under
      /// our selected categories collection
      QuerySnapshot subColletions =
          await categories.doc(categoryName).collection("todos").get();

      ///Query over all of the documents in the
      ///collection and delete them one by one
      for (QueryDocumentSnapshot subCollectionDoc in subColletions.docs) {
        await categories
            .doc(categoryName)
            .collection("todos")
            .doc(subCollectionDoc.id)
            .delete();
      }

      ///After all todo docs are deleted its time to delete
      /// selected category under categories collection
      categories.doc(categoryName).delete();
    } catch (error) {
      print(error);
    }
  }

//      DocumentReference docReference = await todosRef.add(todo.toJson());
}

class OldService {
  FirebaseFirestore cloudDatabase = FirebaseFirestore.instance;

  Stream<List<TodoModel>> fetchAllTodos(String? userId) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todos = users.doc(userId).collection("todos");

    return todos.snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }

  Stream<List<TodoModel>> fetchDoneTodos(String? userId) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todos = users.doc(userId).collection("todos");

    return todos.where("isDone", isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }

  Stream<List<TodoModel>> fetchContinuesTodos(String? userId) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todos = users.doc(userId).collection("todos");

    return todos.where("isDone", isEqualTo: false).snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }

  Future createTodo(String userId, TodoModel todo) async {
    try {
      CollectionReference users = cloudDatabase.collection("users");
      CollectionReference userTodos = users.doc(userId).collection("todos");
      var docReference = await userTodos.add(todo.toJson());
      todo.todoId = docReference.id;
      await userTodos.doc(docReference.id).update({"todoId": docReference.id});
      print("Todo added id updated");
    } catch (e) {
      print("Erorrrrr $e");
    }
  }

  Future deleteTodo(String? userId, String? todoId) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference userTodos = users.doc(userId).collection("todos");
    await userTodos.doc(todoId).delete();
    print("Todo silindi");
  }

  Future updateTodo(String? userId, String? todoId, String description) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todo = users.doc(userId).collection("todos");
    try {
      await todo.doc(todoId).update({
        "description": description,
      });
    } catch (e) {
      print("error issss $e");
      print("description is $description");
      print(" iddd isss $todoId");
    }
  }

  Future updateIsDone(String? userId, TodoModel todo) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todoCollection = users.doc(userId).collection("todos");

    return todoCollection.doc(todo.todoId).update({
      "isDone": !todo.isDone,
    });
  }

  Future updateIsStarred(String? userId, TodoModel todo) async {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todoCollection = users.doc(userId).collection("todos");

    return todoCollection.doc(todo.todoId).update({
      "isStarred": !todo.isStarred,
    });
  }

  Stream<List<TodoModel>> queryStarredTodos(String? userId) {
    CollectionReference users = cloudDatabase.collection("users");
    CollectionReference todos = users.doc(userId).collection("todos");

    return todos
        .where("isStarred", isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((docs) {
        var data = docs.data() as Map<String, dynamic>;
        return TodoModel.fromJson(data)..todoId = docs.id;
      }).toList();
    });
  }
}
