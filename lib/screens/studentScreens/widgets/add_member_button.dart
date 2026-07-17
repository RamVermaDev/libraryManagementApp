import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/components/create_library_required_dialog.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/screens/studentScreens/add_student_screen.dart';

class AddMemberButton extends ConsumerStatefulWidget {
  const AddMemberButton({super.key, required this.scale});

  final double scale;

  @override
  ConsumerState<AddMemberButton> createState() => _AddMemberButtonState();
}

class _AddMemberButtonState extends ConsumerState<AddMemberButton> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        //borderRadius: BorderRadius.circular(12 * scale),
        onTap: () {
          if (ref.read(currentLibraryProvider) == null) {
            showCreateLibraryRequiredDialog(context);
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddStudentScreen()),
          );
        },
        child: Container(
          height: 55 * widget.scale,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14 * widget.scale),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 14 * widget.scale,
                offset: Offset(0, 4 * widget.scale),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// Center Text
              Center(
                child: Text(
                  'Add Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * widget.scale,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1 * widget.scale,
                  ),
                ),
              ),

              /// Bottom Right Plus Icon
              Positioned(
                right: 12 * widget.scale,
                top: 10 * widget.scale,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 2400),
                  curve: Curves.elasticOut,
                  tween: Tween(begin: 0, end: _animate ? 1 : 0),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 14 * widget.scale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
