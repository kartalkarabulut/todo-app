class TodoModel {
  DateTime creationTime;
  String description;
  bool isDone;
  String? todoId;
  bool isStarred;
  String category;

  TodoModel({required this.description, this.todoId, required this.category})
      : creationTime = DateTime.now(),
        isStarred = false,
        isDone = false;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        description: json['description'],
        todoId: json["todoId"],
        category: json["category"])
      ..isDone = json['isDone'] ?? false
      ..isStarred = json["isStarred"] ?? false
      ..creationTime = json['creationTime'] != null
          ? (json['creationTime'] is String
              ? DateTime.parse(json['creationTime']).toLocal()
              : DateTime.now())
          : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "isDone": isDone,
      "creationTime": creationTime.toUtc().toIso8601String(),
      "todoId": todoId,
      "isStarred": isStarred,
      "category": category
    };
  }
}
