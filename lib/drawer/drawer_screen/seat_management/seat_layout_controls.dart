import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/seat_config_model.dart';

class SeatLayoutControls extends StatefulWidget {
  final SeatConfigModel initialConfig;
  final Future<void> Function({
    required int totalSeats,
    required int rows,
    required int columns,
    String? prefix,
  }) onSave;

  const SeatLayoutControls({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<SeatLayoutControls> createState() => _SeatLayoutControlsState();
}

class _SeatLayoutControlsState extends State<SeatLayoutControls> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _prefixController;
  late TextEditingController _totalSeatsController;
  late TextEditingController _rowsController;
  late TextEditingController _columnsController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _prefixController = TextEditingController(
      text: widget.initialConfig.prefix.isNotEmpty
          ? widget.initialConfig.prefix
          : 'A',
    );
    _totalSeatsController = TextEditingController(
      text: widget.initialConfig.totalSeats.toString(),
    );
    _rowsController = TextEditingController(
      text: widget.initialConfig.rows.toString(),
    );
    _columnsController = TextEditingController(
      text: widget.initialConfig.columns.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant SeatLayoutControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialConfig != widget.initialConfig) {
      _prefixController.text = widget.initialConfig.prefix.isNotEmpty
          ? widget.initialConfig.prefix
          : 'A';
      _totalSeatsController.text = widget.initialConfig.totalSeats.toString();
      _rowsController.text = widget.initialConfig.rows.toString();
      _columnsController.text = widget.initialConfig.columns.toString();
    }
  }

  @override
  void dispose() {
    _prefixController.dispose();
    _totalSeatsController.dispose();
    _rowsController.dispose();
    _columnsController.dispose();
    super.dispose();
  }

  void _onColumnChanged(String val) {
    final cols = int.tryParse(val.trim());
    final totalSeats = int.tryParse(_totalSeatsController.text.trim()) ?? 0;
    if (cols != null && cols > 0 && totalSeats > 0) {
      final calculatedRows = (totalSeats / cols).ceil();
      _rowsController.text = calculatedRows.toString();
    }
  }

  void _onRowChanged(String val) {
    final rws = int.tryParse(val.trim());
    final totalSeats = int.tryParse(_totalSeatsController.text.trim()) ?? 0;
    if (rws != null && rws > 0 && totalSeats > 0) {
      final calculatedCols = (totalSeats / rws).ceil();
      _columnsController.text = calculatedCols.toString();
    }
  }

  void _onTotalSeatsChanged(String val) {
    final totalSeats = int.tryParse(val.trim());
    final cols = int.tryParse(_columnsController.text.trim()) ?? 6;
    if (totalSeats != null && totalSeats > 0 && cols > 0) {
      final calculatedRows = (totalSeats / cols).ceil();
      _rowsController.text = calculatedRows.toString();
    }
  }

  void _adjustSeats(int delta) {
    final current = int.tryParse(_totalSeatsController.text.trim()) ?? 0;
    final newValue = (current + delta).clamp(1, 999);
    setState(() {
      _totalSeatsController.text = newValue.toString();
      _onTotalSeatsChanged(newValue.toString());
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final prefix = _prefixController.text.trim();
    final totalSeats = int.parse(_totalSeatsController.text.trim());
    final rows = int.parse(_rowsController.text.trim());
    final columns = int.parse(_columnsController.text.trim());

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        totalSeats: totalSeats,
        rows: rows,
        columns: columns,
        prefix: prefix,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Seat',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 30),

            // Prefix and Total Seats Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seat Label',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _prefixController,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (val) {
                          if (val != val.toUpperCase()) {
                            final upper = val.toUpperCase();
                            _prefixController.value = TextEditingValue(
                              text: upper,
                              selection: TextSelection.collapsed(offset: upper.length),
                            );
                          }
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return 'Needs letter';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'S',
                          fillColor: AppColors.background,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red.shade400),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Seats',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildCountButton(
                            icon: Icons.remove_rounded,
                            color: Colors.red.shade700,
                            bgColor: Colors.red.shade50,
                            onTap: () => _adjustSeats(-1),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextFormField(
                              controller: _totalSeatsController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: _onTotalSeatsChanged,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                fillColor: AppColors.background,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                final n = int.tryParse(val.trim());
                                if (n == null || n <= 0) return '> 0';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildCountButton(
                            icon: Icons.add_rounded,
                            color: Colors.green.shade700,
                            bgColor: Colors.green.shade50,
                            onTap: () => _adjustSeats(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rows and Columns Inputs
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grid Rows',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _rowsController,
                        keyboardType: TextInputType.number,
                        onChanged: _onRowChanged,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '1',
                          fillColor: AppColors.background,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Required';
                          final n = int.tryParse(val.trim());
                          if (n == null || n <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grid Columns',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _columnsController,
                        keyboardType: TextInputType.number,
                        onChanged: _onColumnChanged,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '6',
                          fillColor: AppColors.background,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Required';
                          final n = int.tryParse(val.trim());
                          if (n == null || n <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
