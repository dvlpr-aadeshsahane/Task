import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/features/tasks/models/task.dart';

void main() {
  test('task model reads API task data', () {
    final task = Task.fromJson({
      'id': 'task-1',
      'title': 'Prepare report',
      'priority': 'high',
      'assignedId': 'priya',
      'completed': false,
    });

    expect(task.title, 'Prepare report');
    expect(task.priority, 'high');
    expect(task.assignedId, 'priya');
    expect(task.completed, isFalse);
  });

  test('missing and invalid due dates never become overdue', () {
    final today = DateTime(2026, 11, 13);

    expect(Task(dueDate: null).isOverdue(relativeTo: today), isFalse);
    expect(Task(dueDate: 'not-a-date').isOverdue(relativeTo: today), isFalse);
  });

  test('only incomplete tasks before today are overdue', () {
    final today = DateTime(2026, 11, 13);

    expect(
      Task(
        dueDate: '2026-11-12',
        completed: false,
      ).isOverdue(relativeTo: today),
      isTrue,
    );
    expect(
      Task(dueDate: '2026-11-12', completed: true).isOverdue(relativeTo: today),
      isFalse,
    );
    expect(
      Task(
        dueDate: '2026-11-13',
        completed: false,
      ).isOverdue(relativeTo: today),
      isFalse,
    );
  });
}
