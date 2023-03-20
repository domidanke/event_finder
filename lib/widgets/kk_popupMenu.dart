import 'package:flutter/material.dart';

class KKPopupMenu extends StatefulWidget {
  const KKPopupMenu({Key? key, required this.onItemSelect}) : super(key: key);
  final Function(int index) onItemSelect;

  @override
  State<KKPopupMenu> createState() => _MyAppState();
}

class _MyAppState extends State<KKPopupMenu> {
  var appBarHeight = AppBar().preferredSize.height;

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(title),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        widget.onItemSelect(value);
      },
      offset: Offset(0.0, appBarHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      itemBuilder: (ctx) => [
        _buildPopupMenuItem(
            'Profil bearbeiten', Icons.edit, Options.edit.index),
        _buildPopupMenuItem('Ausloggen', Icons.logout, Options.logout.index),
      ],
    );
  }
}

enum Options { edit, logout }
