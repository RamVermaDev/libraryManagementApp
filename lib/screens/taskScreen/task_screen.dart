import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/components/create_library_required_dialog.dart';
import 'package:library_management/controllers/task_controller.dart';
import 'package:library_management/models/task_model.dart';
import 'package:library_management/provider/app_mode_provider.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/task_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/screens/taskScreen/task_form_screen.dart';
import 'package:library_management/screens/taskScreen/widgets/delete_task_dialog.dart';
import 'package:library_management/screens/taskScreen/widgets/task_card.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/services/subscription_guard.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _taskController = TaskController();

  bool _showCompletedTasks = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _fetchTasksIfNeeded();
    });
  }

  Future<void> _fetchTasksIfNeeded() async {
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    final tasks = ref.read(taskProvider);

    if (tasks.isEmpty) {
      await _refreshTask(libraryId);
    }
  }

  Future<void> _refreshTask([String? libraryId]) async {
    final activeLibraryId = libraryId ?? ref.read(currentLibraryProvider);
    if (activeLibraryId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _taskController.getAllTasks(
        context: context,
        ref: ref,
        libraryId: activeLibraryId,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(currentLibraryProvider, (previous, next) {
      if (previous == next || next == null) return;
      _refreshTask(next);
    });

    final tasks = ref.watch(taskProvider);
    final user = ref.watch(userProvider);
    final isExpired = SubscriptionGuard.isExpired(user);

    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (isExpired) {
            SubscriptionGuard.showExpiredSheet(context);
            return;
          }
          if (ref.read(currentLibraryProvider) == null) {
            showCreateLibraryRequiredDialog(context);
            return;
          }

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const TaskFormScreen(),
          );
        },
        backgroundColor: isExpired ? const Color(0xFF94A3B8) : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: Icon(isExpired ? Icons.lock_rounded : Icons.add_rounded, size: 14),
        label: const Text(
          'Task',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshTask,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [

              // ---------------- PENDING TITLE ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionTitle(
                  title: 'Pending',
                  count: pendingTasks.length,
                ),
              ),

              const SizedBox(height: 12),

              if (_isLoading)
                const SpinKitThreeBounce(
                  color: AppColors.buttonPrimaryHover,
                  size: 20,
                )
              else ...[
                if (pendingTasks.isNotEmpty)
                  ...pendingTasks.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTaskCard(task),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No Pending Task')),
                  ),

                const SizedBox(height: 12),
              ],

              // ---------------- COMPLETED HEADER ----------------
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  setState(() {
                    _showCompletedTasks = !_showCompletedTasks;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${completedTasks.length}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const Spacer(),

                      AnimatedRotation(
                        turns: _showCompletedTasks ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- COMPLETED TASKS ----------------
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: completedTasks
                      .map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTaskCard(task),
                        ),
                      )
                      .toList(),
                ),
                crossFadeState: _showCompletedTasks
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return TaskCard(
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
      urgency: task.urgency,
      assignFrom: task.createdByMode.toUpperCase(),
      assignTo: task.assignedToRole.toUpperCase(),
      onChanged: (value) async {
        if (value != true) return;

        await TaskController().completeTask(
          context: context,
          ref: ref,
          taskId: task.id!,
          libraryId: task.libraryId,
        );
      },
      onEdit: () {
        final activeMode = ref.read(appModeProvider);
        final creatorMode = task.createdByMode.toLowerCase();

        if (creatorMode == 'admin' && activeMode == AppMode.reception) {
          AppNotification.show(
            context,
            message: 'Only Admin can edit this task',
          );
          return;
        }

        if (creatorMode == 'reception' && activeMode != AppMode.reception) {
          AppNotification.show(
            context,
            message: 'Only Receptionist can edit this task',
          );
          return;
        }

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TaskFormScreen(task: task),
        );
      },
      onDelete: () {
        final activeMode = ref.read(appModeProvider);
        final creatorMode = task.createdByMode.toLowerCase();

        if (creatorMode == 'admin' && activeMode == AppMode.reception) {
          AppNotification.show(
            context,
            message: 'Only Admin can delete this task',
          );
          return;
        }

        if (creatorMode == 'reception' && activeMode != AppMode.reception) {
          AppNotification.show(
            context,
            message: 'Only Receptionist can delete this task',
          );
          return;
        }

        showDeleteTaskDialog(
          context: context,
          onDelete: () async {
            await _taskController.deleteTask(
              context: context,
              ref: ref,
              taskId: task.id!,
              libraryId: task.libraryId,
            );
          },
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}
