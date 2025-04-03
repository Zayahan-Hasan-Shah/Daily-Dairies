import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:intl/intl.dart';

class DiaryHeader extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedEmoji;
  final Function(DateTime) onDateChanged;
  final VoidCallback onEmojiTap;

  const DiaryHeader({
    Key? key,
    required this.selectedDate,
    required this.selectedEmoji,
    required this.onDateChanged,
    required this.onEmojiTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateButton(context),
        _buildEmojiButton(),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        onPressed: () => _selectDate(context),
        child: Text(
          DateFormat("dd-MM-yyyy").format(selectedDate),
          style: TextStyle(
            fontSize: 16,
            color: Colorpallete.backgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onEmojiTap,
      child: Text(
        selectedEmoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blueAccent,
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
      onDateChanged(picked);
    }
  }
}