import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/task_controller.dart';
import 'package:library_management/models/task_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';
import 'package:library_management/screens/taskScreen/field/task_assign_toggle.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/task_urgency.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final TaskModel? task;

  bool get isEditing => task != null;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  String _urgency = 'high';

  String _selected = "Self";

  final _taskController = TaskController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _urgency = widget.task!.urgency;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _setDueDate() {
    final now = DateTime.now();

    if (!widget.isEditing) {
      switch (_urgency.toLowerCase()) {
        case 'low':
          _selectedDate = now.add(const Duration(days: 10));
          break;

        case 'medium':
          _selectedDate = now.add(const Duration(days: 6));
          break;

        case 'high':
          _selectedDate = now.add(const Duration(days: 3));
          break;

        default:
          _selectedDate = now;
      }
    }
  }

  Future<void> _addTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (!widget.isEditing) {
      _setDueDate();
    }

    // if (_selectedDate == null) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
    //   return;
    // }

    //will change it

    // final libraries = ref.read(libraryProvider);
    // if (libraries.isEmpty) {
    //   debugPrint('No library found in provider');
    //   return;
    // }
    //final library = libraries[0];

    //if (library.id == null) return;

    //print(library.id!);

    try {
      if (widget.isEditing) {
        await _taskController.editTask(
          context: context,
          ref: ref,
          taskId: widget.task!.id!,
          libraryId: widget.task!.libraryId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDate!,
          urgency: _urgency,
        );
      } else {
        final libraryId = ref.read(currentLibraryProvider);
        if (libraryId == null) return;

        await _taskController.addTask(
          context: context,
          ref: ref,
          libraryId: libraryId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDate!,
          urgency: _urgency,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity, // Full width
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(top: 2, bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SectionHeader(
                          title: 'New Task',
                          fontSize: 15 * scale,
                          weight: FontWeight.w700,
                          scale: scale,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Plan and assign tasks with clarity',
                          style: TextStyle(
                            color: AppColors.body,
                            fontSize: 12 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_outlined, size: 18),
                  ),
                ],
              ),

              SizedBox(height: 30),
              _TaskForm(
                isEditing: widget.isEditing,
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
                //date: _selectedDate,
                isLoading: _isLoading,
                scale: scale,
                selected: _selected,
                assignTo: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
              ),
            ],
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
    required this.isEditing,
    //this.date,
    required this.scale,
    required this.selected,
    required this.assignTo,
    required this.isLoading,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onSubmit;
  final String selectedUrgency;
  final ValueChanged<String> onChange;
  final bool isEditing;
  //final DateTime? date;

  final String selected;
  final ValueChanged<String> assignTo;

  final double scale;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      children: [
        TitleText(
          title: 'Task Title',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 8 * scale),

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
          fillColor: AppColors.background,
        ),

        SizedBox(height: 20 * scale),

        TitleText(
          title: 'Description',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 8 * scale),

        TaskTextField(
          hintText: 'Add task details...',
          controller: descriptionController,
          minLines: 4,
          maxLines: 6,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter task description';
            }
            return null;
          },
          maxLength: 200,
          fillColor: AppColors.background,
        ),

        SizedBox(height: 20 * scale),

        // TitleText(
        //   title: 'Due date',
        //   fontSize: 12 * scale,
        //   weight: FontWeight.w400,
        //   fontColor: AppColors.formLabel,
        // ),
        // SizedBox(height: 8 * scale),

        // isEditing
        //     ? DateField(onDateChanged: onDateChanged, selectedDate: date)
        //     : DateField(onDateChanged: onDateChanged),
        // const SizedBox(height: 20),
        TitleText(
          title: 'Urgency',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 8 * scale),

        TaskUrgency(selectedUrgency: selectedUrgency, onChanged: onChange),

        SizedBox(height: 20 * scale),

        TitleText(
          title: 'Assign To',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 8 * scale),
        TaskAssignToggle(
          leftTitle: 'Self',
          rightTitle: 'Reception',
          selected: selected,
          onChanged: assignTo,
        ),

        SizedBox(height: 32 * scale),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? () {} : onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SpinKitThreeBounce(color: Colors.white, size: 12)
                : Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2 * scale,
                    ),
                  ),
          ),
        ),

        // SizedBox(
        //   height: 54 * scale,
        //   child: FilledButton(
        //     onPressed: onSubmit,
        //     child: Text(isEditing ? 'Update Task' : 'Add Task'),
        //   ),
        // ),
      ],
    );
  }
}
