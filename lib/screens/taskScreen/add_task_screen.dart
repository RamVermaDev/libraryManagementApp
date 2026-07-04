import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/controllers/task_controller.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/screens/taskScreen/field/date_filed.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/task_urgency.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  String _urgency = 'low';

  final _taskController = TaskController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    }

    final libraries = ref.read(libraryProvider);
    if (libraries.isEmpty) {
      debugPrint('No library found in provider');
      return;
    }
    final library = libraries[0];

    if (library.id == null) return;

    print(library.id!);

    await _taskController.addTask(
      context: context,
      ref: ref,
      libraryId: library.id!,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _selectedDate!,
      urgency: _urgency,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Add Task',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B1F44),
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: _TaskForm(
            titleController: _titleController,
            descriptionController: _descriptionController,
            onDateChanged: (date) {
              _selectedDate = date;
            },
            onSubmit: _addTask,
            selectedUrgency: _urgency,
            onChange: (value) {
              setState(() {
                _urgency = value;
              });
            },
          ),
        ),
      ),
    );
  }
}

class _TaskForm extends StatelessWidget {
  const _TaskForm({
    required this.titleController,
    required this.descriptionController,
    required this.onDateChanged,
    required this.onSubmit,
    required this.selectedUrgency,
    required this.onChange,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onSubmit;
  final String selectedUrgency;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const TitleText(title: 'Task title'),
        const SizedBox(height: 8),

        TaskTextField(
          hintText: 'e.g. Clean bathroom',
          controller: titleController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter task title';
            } else if (value.length < 4) {
              return 'Length must be  > 3';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        const TitleText(title: 'Description'),
        const SizedBox(height: 8),

        TaskTextField(
          hintText: 'Add task details...',
          controller: descriptionController,
          minLines: 4,
          maxLines: 6,
          textInputAction: TextInputAction.newline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter task description';
            }
            return null;
          },
          maxLength: 50,
        ),

        const SizedBox(height: 20),

        const TitleText(title: 'Due date'),
        const SizedBox(height: 8),

        DateFiled(onDateChanged: onDateChanged),
        const SizedBox(height: 20),

        const TitleText(title: 'Urgency'),
        const SizedBox(height: 8),

        TaskUrgency(selectedUrgency: selectedUrgency, onChanged: onChange),

        const SizedBox(height: 32),

        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: onSubmit,
            child: const Text('Add Task'),
          ),
        ),
      ],
    );
  }
}
