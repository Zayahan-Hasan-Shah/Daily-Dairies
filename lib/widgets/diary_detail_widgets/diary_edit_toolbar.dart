import 'package:flutter/material.dart';

class DiaryEditToolbar extends StatelessWidget {
  final String? selectedTool;
  final Function(String) onToolSelected;

  const DiaryEditToolbar({
    Key? key,
    this.selectedTool,
    required this.onToolSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        color: Color.fromRGBO(28, 50, 91, 1),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildToolButton(Icons.brush, "Style"),
                _buildToolButton(Icons.image, "Image"),
                _buildToolButton(Icons.video_camera_back_rounded, "Video"),
                _buildToolButton(Icons.emoji_emotions, "Mood"),
                _buildToolButton(Icons.format_size, "Text"),
                _buildToolButton(Icons.label, "Tags"),
                _buildToolButton(Icons.mic, "Voice"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String tooltip) {
    final bool isSelected = selectedTool == tooltip;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => onToolSelected(tooltip),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.yellow[400] : Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
