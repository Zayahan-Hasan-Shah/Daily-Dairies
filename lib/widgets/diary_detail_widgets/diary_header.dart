import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryHeader extends StatelessWidget {
  final DateTime date;
  final String emoji;
  final bool isEditing;
  final Function(DateTime)? onDateChanged;
  final Function(String)? onEmojiChanged;

  const DiaryHeader({
    super.key,
    required this.date,
    required this.emoji,
    this.isEditing = false,
    this.onDateChanged,
    this.onEmojiChanged,
  });

  void _showEmojiPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title: const Text(
            "How's your day?",
            style: TextStyle(color: Colors.white),
          ),
          content: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              '😑', '😊', '😃', '😍', '😁',
              '😡', '😢', '😭', '😰', '😔'
            ].map((e) => GestureDetector(
              onTap: () {
                onEmojiChanged?.call(e);
                Navigator.pop(context);
              },
              child: Text(e, style: const TextStyle(fontSize: 30)),
            )).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isEditing
            ? _buildDatePicker(context)
            : Text(
                DateFormat("dd-MM-yyyy").format(date),
                style: TextStyle(
                  fontSize: 18,
                  color: Colorpallete.backgroundColor,
                ),
              ),
        GestureDetector(
          onTap: isEditing ? () => _showEmojiPicker(context) : null,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  surface: Colorpallete.backgroundColor,
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: const Color(0xFF121212),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateChanged?.call(picked);
        }
      },
      child: Text(
        DateFormat("dd-MM-yyyy").format(date),
        style: TextStyle(
          fontSize: 16,
          color: Colorpallete.backgroundColor,
        ),
      ),
    );
  }
}