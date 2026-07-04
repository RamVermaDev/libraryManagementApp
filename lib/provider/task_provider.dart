import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/task_model.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((
  ref,
) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]);

  // Set all tasks after fetching from backend
  void setTasks(List<TaskModel> tasks) {
    state = tasks;
  }

  // Add one newly created task
  void addTask(TaskModel task) {
    state = [task, ...state];
  }

  // Update one task
  void updateTask(TaskModel updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  // Delete one task
  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  // Replace task returned by complete-task API
  void completeTask(TaskModel completedTask) {
    state = [
      for (final task in state)
        if (task.id == completedTask.id) completedTask else task,
    ];
  }

  // Clear all tasks
  void clearTasks() {
    state = [];
  }
}
