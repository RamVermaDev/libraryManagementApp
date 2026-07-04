import 'package:flutter/material.dart';
import 'package:library_management/screens/taskScreen/widgets/task_card.dart';
import 'package:library_management/screens/taskScreen/widgets/task_slidable_card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool abc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            TaskSlidableCard(
              taskId: 'task_001',
              onEdit: () {
                debugPrint('Edit Bathroom Clean');
              },
              onDelete: () {
                debugPrint('Delete Bathroom Clean');
              },
              child: TaskCard(
                title: 'Bathroom Clean',
                description:
                    'Girls bathroom is very dirty and it needs to be cleaned immediately.',
                date: '6-Aug-25',
                isCompleted: abc,
                onChanged: (value) {
                  setState(() {
                    abc = value ?? false;
                  });
                },
              ),
            ),

            const SizedBox(height: 12),

            TaskSlidableCard(
              taskId: 'task_002',
              onEdit: () {
                debugPrint('Edit AC Cleaning');
              },
              onDelete: () {
                debugPrint('Delete AC Cleaning');
              },
              child: TaskCard(
                title: 'AC Cleaning',
                description:
                    'The library AC needs servicing and proper cleaning.',
                date: '1-Aug-25',
                isCompleted: false,
                onChanged: (value) {},
              ),
            ),

            const SizedBox(height: 12),

            TaskSlidableCard(
              taskId: 'task_003',
              onEdit: () {
                debugPrint('Edit Mouse Problem');
              },
              onDelete: () {
                debugPrint('Delete Mouse Problem');
              },
              child: TaskCard(
                title: 'Mouse Problem',
                description: 'There are too many mice in the library.',
                date: '1-Jul-25',
                isCompleted: true,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
