import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/enums.dart';
import '../models/event.dart';
import '../services/firestore/user_doc.service.dart';
import '../services/state.service.dart';
import '../theme/theme.dart';

class SaveEventButton extends StatefulWidget {
  const SaveEventButton({super.key, required this.event});
  final Event event;

  @override
  State<SaveEventButton> createState() => _SaveEventButtonState();
}

class _SaveEventButtonState extends State<SaveEventButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: primaryBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: secondaryColor,
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Transform.scale(
            scale: _animationController.value,
            child: IconButton(
              icon: Icon(
                StateService()
                        .currentUser!
                        .savedEvents
                        .contains(widget.event.uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 26,
                color: secondaryColor,
              ),
              onPressed: () async {
                if (StateService().currentUser!.type == UserType.guest) return;
                Platform.isAndroid
                    ? HapticFeedback.vibrate()
                    : HapticFeedback.mediumImpact();
                _animationController.forward(from: 0);
                await UserDocService().saveEvent(widget.event.uid);
                setState(() {
                  StateService().toggleSavedEvent(widget.event.uid);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
