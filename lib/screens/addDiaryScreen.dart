import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class AddDiaryScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const AddDiaryScreen());

  const AddDiaryScreen({super.key});

  @override
  _AddDiaryScreenState createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  String selectedEmoji = '😑';
  DateTime selectedDate = DateTime.now();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(); // Date Controller
  String? selectedTool;
  List<TextSpan> textSpans = [];
  List<File> selectedImages = [];

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blueAccent, // Selected date color
            colorScheme: ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colorpallete.backgroundColor, // Dark background
              onSurface: Colors.white, // Text color
            ),
            dialogBackgroundColor: const Color(0xFF121212), // Background color
          ),
          child: child!,
        );
      },
    );
  }

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          backgroundColor: Colorpallete.backgroundColor, // Match your theme
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            "How's your day?",
            style: TextStyle(color: Colors.white),
          ),
          content: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              '😑',
              '😊',
              '😃',
              '😍',
              '😁',
              '😡',
              '😢',
              '😭',
              '😰',
              '😔'
            ].map((emoji) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = emoji;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onToolSelected(String tool) {
    if (tool == "Image") {
      _pickImage();
    } else {
      setState(() {
        selectedTool = (selectedTool == tool) ? null : tool;
      });
    }
  }

  void _onTextChanged(String value) {
    setState(() {
      textSpans.add(
        TextSpan(
            text: value,
            style: _getTextStyle()), // Apply style only to new text
      ); // Clear the input field
    });
  }

  Widget _buildBottomBar() {
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(28, 50, 91, 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomBarButton(Icons.brush, "Style"),
            _bottomBarButton(Icons.image, "Image"),
            _bottomBarButton(Icons.star, "Favorite"),
            _bottomBarButton(Icons.emoji_emotions, "Mood"),
            _bottomBarButton(Icons.format_size, "Text"),
            _bottomBarButton(Icons.list, "List"),
            _bottomBarButton(Icons.label, "Tags"),
            _bottomBarButton(Icons.mic, "Voice"),
          ],
        ),
      ),
    );
  }

  Widget _bottomBarButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon,
          color: selectedTool == tooltip ? Colors.yellow[400] : Colors.white),
      onPressed: () {
        _onToolSelected(tooltip);
      },
      tooltip: tooltip,
    );
  }

  Widget dateselected() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        onPressed: () => _selectDate(context),
        child: Text(
          DateFormat("dd-MM-yyyy").format(selectedDate).toString(),
          style: TextStyle(
            fontSize: 16,
            color: Colorpallete.backgroundColor,
          ),
        ),
      ),
    );
  }

  Widget emojoButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: _showEmojiPicker,
      child: Text(
        selectedEmoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget titleField() {
    return TextField(
      textAlignVertical: TextAlignVertical.top,
      maxLines: 1,
      controller: titleController,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0),
        ),
        hintText: "Enter diary title",
        labelStyle: TextStyle(color: Colorpallete.backgroundColor),
        hintStyle: TextStyle(
          color: Colorpallete.backgroundColor,
        ),
      ),
    );
  }

  // Widget descriptionField() {
  //   return SizedBox(
  //     height: 300,
  //     child: TextField(
  //       textAlignVertical: TextAlignVertical.top,
  //       controller: contentController,
  //       maxLines: null,
  //       expands: true,
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //           borderRadius: BorderRadius.circular(0),
  //         ),
  //         hintText: "Write your diary entry here...",
  //         hintStyle: TextStyle(
  //           color: Colorpallete.backgroundColor,
  //         ),
  //       ),
  //       style: _getTextStyle(),
  //     ),
  //   );
  // }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: TextField(
            textAlignVertical: TextAlignVertical.top,
            controller: contentController,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0),
              ),
              hintText: "Write your diary entry here...",
              hintStyle: TextStyle(
                color: Colorpallete.backgroundColor,
              ),
            ),
            style: _getTextStyle(),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: selectedImages.map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  TextStyle _getTextStyle() {
    switch (selectedTool) {
      case "Style":
        return const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue);
      case "Text":
        return const TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
      case "Mood":
        return const TextStyle(color: Colors.pinkAccent);
      case "Favorite":
        return const TextStyle(decoration: TextDecoration.underline);
      default:
        return const TextStyle(color: Colors.black);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        actions: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.withOpacity(0.6),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Handle save entry logic
                },
                child: const Text("Save Entry"),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colorpallete.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            // Prevents overflow when keyboard appears
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date Picker Field
                    dateselected(),
                    // emjoi button
                    emojoButton(),
                  ],
                ),
                const SizedBox(height: 16),
                titleField(),
                const SizedBox(height: 2),
                descriptionField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
