import 'package:flutter/material.dart';

class Actionbutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;
  

  const Actionbutton({super.key, required this.text, required this.onPressed, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(text, style: TextStyle(color: isSelected ? Colors.white : null)),
      tooltip: text,
      onPressed: onPressed,
    
      backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : null,
      elevation: 10,
      side: isSelected ? BorderSide.none : const BorderSide(color: Colors.white),
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(20))
    );
  }
}