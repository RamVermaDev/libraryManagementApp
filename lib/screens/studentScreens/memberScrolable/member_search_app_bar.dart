import 'package:flutter/material.dart';

class MemberSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSearchChanged;

  const MemberSearchAppBar({super.key, required this.onSearchChanged});

  @override
  State<MemberSearchAppBar> createState() => _MemberSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MemberSearchAppBarState extends State<MemberSearchAppBar> {
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  // Opens search mode and keyboard.
  void _openSearch() {
    setState(() {
      _isSearching = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  // Closes search mode completely.
  void _closeSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();

    widget.onSearchChanged('');

    setState(() {
      _isSearching = false;
    });
  }

  // Clears only the typed search text.
  void _clearSearch() {
    _searchController.clear();

    widget.onSearchChanged('');

    _searchFocusNode.requestFocus();

    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: _isSearching ? 0 : 16,

      // Show back arrow only while searching.
      leading: _isSearching
          ? IconButton(
              onPressed: _closeSearch,
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,

      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),

        child: _isSearching
            ? _buildSearchField()
            : const Text(
                'Members',
                key: ValueKey('title'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
      ),

      actions: [
        // Show search icon only in normal mode.
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _openSearch,
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search members',
            ),
          ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      key: const ValueKey('search'),
      height: 44,
      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,

        onChanged: (value) {
          widget.onSearchChanged(value);

          // Rebuild to show or hide the clear icon.
          setState(() {});
        },

        textInputAction: TextInputAction.search,

        decoration: InputDecoration(
          hintText: 'Search by name or phone',

          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

          prefixIcon: const Icon(Icons.search_rounded, size: 21),

          // Show clear button only when text exists.
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close_rounded, size: 20),
                )
              : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
