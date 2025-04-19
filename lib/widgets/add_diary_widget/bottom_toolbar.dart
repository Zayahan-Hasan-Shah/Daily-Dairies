// // import 'package:flutter/material.dart';
// // import 'package:daily_dairies/core/colorPallete.dart';

// // class BottomToolbar extends StatelessWidget {
// //   final Function(Color) onColorSelected;
// //   final Function(TextStyle) onStyleSelected;
// //   final Function() onBulletPointPressed;
// //   final Function() onTagPressed;
// //   final Function() onStickerPressed;
// //   final Color? currentTextColor;
// //   final TextStyle? currentTextStyle;
// //   final bool showBulletPoints;
// //   final bool showTags;
// //   final bool showStickers;

// //   const BottomToolbar({
// //     Key? key,
// //     required this.onColorSelected,
// //     required this.onStyleSelected,
// //     required this.onBulletPointPressed,
// //     required this.onTagPressed,
// //     required this.onStickerPressed,
// //     this.currentTextColor,
// //     this.currentTextStyle,
// //     this.showBulletPoints = false,
// //     this.showTags = false,
// //     this.showStickers = false,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         if (showStickers)  StickerSelector(),
// //         Container(
// //           color: Colorpallete.backgroundColor,
// //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.format_color_text),
// //                 color: currentTextColor ?? Colorpallete.textColor,
// //                 onPressed: () => _showColorPicker(context),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.format_bold),
// //                 color: currentTextStyle?.fontWeight == FontWeight.bold
// //                     ? Colorpallete.bottomNavigationColor
// //                     : Colorpallete.textColor,
// //                 onPressed: () => _toggleBold(context),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.format_italic),
// //                 color: currentTextStyle?.fontStyle == FontStyle.italic
// //                     ? Colorpallete.bottomNavigationColor
// //                     : Colorpallete.textColor,
// //                 onPressed: () => _toggleItalic(context),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.format_list_bulleted),
// //                 color: showBulletPoints
// //                     ? Colorpallete.bottomNavigationColor
// //                     : Colorpallete.textColor,
// //                 onPressed: onBulletPointPressed,
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.label),
// //                 color: showTags
// //                     ? Colorpallete.bottomNavigationColor
// //                     : Colorpallete.textColor,
// //                 onPressed: onTagPressed,
// //               ),
// //             ],
// //           ),
// //           if (showBulletPoints || showTags)
// //             Container(
// //               height: 100,
// //               margin: const EdgeInsets.only(top: 8),
// //               decoration: BoxDecoration(
// //                 color: Colorpallete.backgroundColor,
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   showBulletPoints ? 'Bullet Points' : 'Tags',
// //                   style: const TextStyle(color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showColorPicker(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return ColorPicker(
// //           onColorSelected: onColorSelected,
// //           currentColor: currentTextColor,
// //         );
// //       },
// //     );
// //   }

// //   void _toggleBold(BuildContext context) {
// //     final currentStyle = currentTextStyle ?? const TextStyle();
// //     final newStyle = currentStyle.copyWith(
// //       fontWeight: currentStyle.fontWeight == FontWeight.bold
// //           ? FontWeight.normal
// //           : FontWeight.bold,
// //     );
// //     onStyleSelected(newStyle);
// //   }

// //   void _toggleItalic(BuildContext context) {
// //     final currentStyle = currentTextStyle ?? const TextStyle();
// //     final newStyle = currentStyle.copyWith(
// //       fontStyle: currentStyle.fontStyle == FontStyle.italic
// //           ? FontStyle.normal
// //           : FontStyle.italic,
// //     );
// //     onStyleSelected(newStyle);
// //   }
// // }

// // class ColorPicker extends StatelessWidget {
// //   final Function(Color) onColorSelected;
// //   final Color? currentColor;

// //   const ColorPicker({
// //     Key? key,
// //     required this.onColorSelected,
// //     this.currentColor,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       backgroundColor: Colorpallete.backgroundColor,
// //       title: const Text(
// //         'Pick a color',
// //         style: TextStyle(color: Colors.white),
// //       ),
// //       content: Container(
// //         width: double.maxFinite,
// //         child: GridView.builder(
// //           shrinkWrap: true,
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //             crossAxisCount: 5,
// //             crossAxisSpacing: 8,
// //             mainAxisSpacing: 8,
// //           ),
// //           itemCount: Colors.primaries.length,
// //           itemBuilder: (context, index) {
// //             final color = Colors.primaries[index];
// //             return GestureDetector(
// //               onTap: () {
// //                 onColorSelected(color);
// //                 Navigator.of(context).pop();
// //               },
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: color,
// //                   shape: BoxShape.circle,
// //                   border: Border.all(
// //                     color: Colors.white,
// //                     width: currentColor == color ? 2 : 0,
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class BottomToolbar extends StatelessWidget {
//   final String? selectedTool;
//   final Function(String) onToolSelected;

//   const BottomToolbar({
//     Key? key,
//     this.selectedTool,
//     required this.onToolSelected, required Null Function(dynamic color) onColorSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: const BoxDecoration(
//         color: Color.fromRGBO(28, 50, 91, 1),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildToolButton(Icons.brush, "Style"),
//             _buildToolButton(Icons.format_size, "Text"),
//             _buildToolButton(Icons.image, "Image"),
//             _buildToolButton(Icons.video_camera_back_rounded, "Video"),
//             _buildToolButton(Icons.list, "List"),
//             _buildToolButton(Icons.label, "Tags"),
//             _buildToolButton(Icons.mic, "Voice"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToolButton(IconData icon, String tooltip) {
//     return IconButton(
//       icon: Icon(
//         icon,
//         color: selectedTool == tooltip ? Colors.yellow[400] : Colors.white,
//       ),
//       onPressed: () => onToolSelected(tooltip),
//       tooltip: tooltip,
//     );
//   }
// }

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
