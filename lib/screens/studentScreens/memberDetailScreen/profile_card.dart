import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.scale,
    required this.name,
    required this.phone,
    required this.id,
    required this.number,
    this.imageUrl,
    this.onSave,
    this.onChangePhoto,
  });

  final double scale;
  final String name;
  final String phone;
  final String? id;
  final int number;
  final String? imageUrl;

  /// Called when the owner taps Save after editing. Should perform the
  /// actual update (API call) and return true on success - the card only
  /// exits edit mode if this returns true, so a failed save leaves the
  /// owner's edits intact to retry.
  final Future<bool> Function({
    required String name,
    required String phone,
    required String? idProof,
  })?
  onSave;

  /// Called when the owner taps "Change Photo" inside the photo popup.
  /// The popup itself is display-only - actual image picking/upload is
  /// the parent's responsibility.
  final VoidCallback? onChangePhoto;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _idController;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _idController = TextEditingController(text: widget.id ?? '');
  }

  @override
  void didUpdateWidget(covariant ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isEditing) return;

    if (oldWidget.name != widget.name) {
      _nameController.text = widget.name;
    }

    if (oldWidget.phone != widget.phone) {
      _phoneController.text = widget.phone;
    }

    if (oldWidget.id != widget.id) {
      _idController.text = widget.id ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _enterEditMode() => setState(() => _isEditing = true);

  void _cancelEdit() {
    setState(() {
      _nameController.text = widget.name;
      _phoneController.text = widget.phone;
      _idController.text = widget.id ?? '';
      _isEditing = false;
    });
  }

  String? _normalizedId(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _saveEdit() async {
    final nextName = _nameController.text.trim();
    final nextPhone = _phoneController.text.trim();
    final nextIdProof = _normalizedId(_idController.text);
    final currentIdProof = _normalizedId(widget.id ?? '');

    final hasChanges =
        nextName != widget.name.trim() ||
        nextPhone != widget.phone.trim() ||
        nextIdProof != currentIdProof;

    if (!hasChanges) {
      setState(() => _isEditing = false);
      return;
    }

    if (widget.onSave == null) {
      setState(() => _isEditing = false);
      return;
    }

    setState(() => _isSaving = true);

    final success = await widget.onSave!(
      name: nextName,
      phone: nextPhone,
      idProof: nextIdProof,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      if (success) _isEditing = false;
    });
  }

  void _openPhotoPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ProfilePhotoDialog(
        imageUrl: widget.imageUrl,
        onChangePhoto: widget.onChangePhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        21 * scale,
        8 * scale,
        16 * scale,
        22 * scale,
      ),
      decoration: cardDecoration(radius: 20 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4 * scale),
          if (!_isEditing) _buildEditButton(scale),
          if (_isEditing) ...[_buildEditActions(scale)],
          SizedBox(height: 12 * scale),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildAvatar(scale),
              SizedBox(width: 18 * scale),
              Expanded(
                child: _isEditing
                    ? _buildEditFields(scale)
                    : _buildDisplayInfo(scale),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(double scale) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _enterEditMode,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 6 * scale,
          ),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: 13 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditActions(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isSaving ? null : _cancelEdit,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 6 * scale,
            ),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w500,
                color: AppColors.body,
              ),
            ),
          ),
        ),

        SizedBox(width: 12 * scale),

        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isSaving ? null : _saveEdit,
          child: Container(
            constraints: BoxConstraints(minWidth: 58 * scale),
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 6 * scale,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),

            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _isSaving
                  ? SizedBox(
                      key: const ValueKey('saving'),
                      height: 18 * scale,
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 14 * scale,
                      ),
                    )
                  : Text(
                      'Save',
                      key: const ValueKey('saveText'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(double scale) {
    final hasImage = widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: _openPhotoPopup,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 48.5 * scale,
            backgroundColor: AppColors.primarySoft,
            backgroundImage: hasImage ? NetworkImage(widget.imageUrl!) : null,
            child: !hasImage
                ? Icon(
                    Icons.person_rounded,
                    size: 54 * scale,
                    color: const Color(0xFF7896F1),
                  )
                : null,
          ),
          Positioned(
            bottom: -2 * scale,
            right: -2 * scale,
            child: GestureDetector(
              onTap: widget.onChangePhoto,
              child: Container(
                padding: EdgeInsets.all(5 * scale),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 13 * scale,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayInfo(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(label: "Name", value: widget.name, scale: scale),
        SizedBox(height: 16 * scale),
        _infoRow(label: "Mobile", value: "+91 ${widget.phone}", scale: scale),
        SizedBox(height: 16 * scale),
        _infoRow(label: "ID", value: widget.id ?? "N/A", scale: scale),
      ],
    );
  }

  Widget _buildEditFields(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _editField(
          label: 'Name',
          controller: _nameController,
          scale: scale,
          hintText: 'Enter name',
        ),
        SizedBox(height: 11 * scale),
        _editField(
          label: 'Mobile',
          controller: _phoneController,
          scale: scale,
          keyboardType: TextInputType.phone,
          hintText: 'Enter mobile number',
        ),
        SizedBox(height: 11 * scale),
        _editField(
          label: 'ID',
          controller: _idController,
          scale: scale,
          hintText: ' Enter ID',
        ),
      ],
    );
  }

  Widget _editField({
    required String label,
    required TextEditingController controller,
    required double scale,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 11 * scale,
        //     color: AppColors.body,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        SizedBox(width: 3 * scale),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 11 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.body,
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 6 * scale,
                horizontal: 10 * scale,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    required double scale,
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16 * scale, color: AppColors.body),
        children: [
          TextSpan(
            text: "$label:  ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.body,
              fontSize: 15 * scale,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
              fontSize: 17 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

/// The popup shown when tapping the avatar - a clean, centered preview
/// with "Change Photo" / "Save" actions at the bottom.
class _ProfilePhotoDialog extends StatelessWidget {
  const _ProfilePhotoDialog({required this.imageUrl, this.onChangePhoto});

  final String? imageUrl;
  final VoidCallback? onChangePhoto;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: _hasImage
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.primarySoft,
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 90,
                              color: Color(0xFF7896F1),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onChangePhoto?.call();
                      },
                      icon: const Icon(Icons.photo_camera_outlined, size: 18),
                      label: const Text('Change Photo'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.border),
                        foregroundColor: AppColors.body,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
