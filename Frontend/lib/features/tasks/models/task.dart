class Task {
  String? id;
  String? title;
  String? description;
  String? dueDate;
  String? priority;
  String? assignedId;
  bool? completed;
  String? createdAt;
  String? updatedAt;

  Task({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.priority,
    this.assignedId,
    this.completed,
    this.createdAt,
    this.updatedAt,
  });

  Task.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    final rawDueDate = json["due_date"] ?? json["dueDate"];
    if (rawDueDate is String) {
      dueDate = rawDueDate;
    }
    if (json["priority"] is String) {
      priority = json["priority"];
    }
    final rawAssigneeId = json["assignedId"] ?? json["assigneeId"];
    if (rawAssigneeId is String) {
      assignedId = rawAssigneeId;
    }
    if (json["completed"] is bool) {
      completed = json["completed"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
  }

  static List<Task> fromList(List<Map<String, dynamic>> list) {
    return list.map(Task.fromJson).toList();
  }

  bool isOverdue({DateTime? relativeTo}) {
    if (completed == true || dueDate == null) return false;
    final parsedDueDate = DateTime.tryParse(dueDate!);
    if (parsedDueDate == null) return false;

    final now = relativeTo ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(
      parsedDueDate.year,
      parsedDueDate.month,
      parsedDueDate.day,
    );
    return dueDay.isBefore(today);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["description"] = description;
    data["due_date"] = dueDate;
    data["priority"] = priority;
    data["assignedId"] = assignedId;
    data["completed"] = completed;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
