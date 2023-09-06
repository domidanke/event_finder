import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/search_page.service.dart';

class UserSearchField extends StatefulWidget {
  const UserSearchField({super.key});

  @override
  State<UserSearchField> createState() => _UserSearchFieldState();
}

class _UserSearchFieldState extends State<UserSearchField> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearText() {
    _textEditingController.clear();
    SearchPageService().searchText = '';
    // Hide the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchPageService>(context).searchText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.grey.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              onChanged: (text) {
                SearchPageService().searchText = text;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.focused)
                        ? primaryWhite.withOpacity(0.8)
                        : primaryWhite.withOpacity(0.4)),
                hintText: 'Künstler oder Hosts',
                hintStyle: TextStyle(
                  color: _isFocused
                      ? primaryWhite.withOpacity(0.8)
                      : primaryWhite.withOpacity(0.4),
                ),
              ),
            ),
          ),
          _textEditingController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                  ),
                  onPressed: _clearText,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
