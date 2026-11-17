class AppLists {
  const AppLists._();

  static const List<String> assignees = ["aarav", "priya", "rohan"];
  static const List<String> statuses = ["active", "completed"];
  static const List<String> priorities = ["high", "medium", "low"];

  // Kept for compatibility with older screens and API naming.
  static const List<String> assignes = assignees;
  static const List<String> statusList = statuses;
  static const List<String> priorties = priorities;
}
