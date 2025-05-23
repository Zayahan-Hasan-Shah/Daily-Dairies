import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class BottomToolbar extends StatelessWidget {
  final String? selectedTool;
  final Function(String) onToolSelected;

  const BottomToolbar({
    Key? key,
    this.selectedTool,
    required this.onToolSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToolButton(Icons.brush, "Style"),
            _buildToolButton(Icons.format_size, "Text"),
            _buildToolButton(Icons.image, "Image"),
            _buildToolButton(Icons.video_camera_back_rounded, "Video"),
            _buildToolButton(Icons.list, "List"),
            _buildToolButton(Icons.label, "Tags"),
            _buildToolButton(Icons.mic, "Voice"),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedTool == tooltip ? Colors.yellow[400] : Colors.white,
      ),
      onPressed: () => onToolSelected(tooltip),
      tooltip: tooltip,
    );
  }
}
