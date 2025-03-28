// import 'dart:async';
// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:video_player/video_player.dart';

// class DiaryDetailScreen extends StatefulWidget {
//   final String title;
//   final String content;
//   final String mood;
//   final DateTime date;

//   const DiaryDetailScreen({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.mood,
//     required this.date,
//   });

//   static Route route(String title, String content, String mood, DateTime date) {
//     return MaterialPageRoute(
//       builder: (context) => DiaryDetailScreen(
//         title: title,
//         content: content,
//         mood: mood,
//         date: date,
//       ),
//     );
//   }

//   @override
//   State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
// }

// class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
//   String selectedEmoji = '☝️';
//   late final String title;
//   late final String content;
//   late final String date;

//   // ===========================================================================
//   // Following variables are for editing purpose

//   bool isEdit = false;
//   late final String editSelectEmoji;
//   String? editSelectedTool;
//   List<TextSpan> editTextSpans = [];
//   late DateTime editSelectedDate;
//   final TextEditingController editTitleController = TextEditingController();
//   final TextEditingController editContentController = TextEditingController();
//   bool editIsRecording = false;
//   int _editRecordingDuration = 0;
//   String editRecordDuration = '00:000';
//   List<File> editRecordedAudio = [];
//   List<File> editSelectedImages = [];
//   List<File> editSelectedVideos = [];
//   bool editIsPlaying = false;
//   Color editCurrentTextColor = Colors.black;
//   Timer? _editTimer;
//   final AudioRecorder _editAudioRecorder = AudioRecorder();

//   @override
//   void initState() {
//     title = widget.title;
//     content = widget.content;
//     editSelectedDate = widget.date;
//     editSelectEmoji = widget.mood;
//   }

//   // ===========================================================================
//   // if isEdit is true, we can made changes in data
//   // ===========================================================================

//   // ===========================================================================

//   Future<void> _editRequestPermissions() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   Future<void> _editSelectedDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             primaryColor: Colors.blueAccent, // Selected date color
//             colorScheme: ColorScheme.dark(
//               primary: Colors.blueAccent,
//               onPrimary: Colors.white,
//               surface: Colorpallete.backgroundColor, // Dark background
//               onSurface: Colors.white, // Text color
//             ),
//             dialogBackgroundColor: const Color(0xFF121212), // Background color
//           ),
//           child: child!,
//         );
//       },
//     );
//   }

//   void _editShowEmojiPicker() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           alignment: Alignment.center,
//           backgroundColor: Colorpallete.backgroundColor, // Match your theme
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           title: const Text(
//             "How's your day?",
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Wrap(
//             alignment: WrapAlignment.center,
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               '😑',
//               '😊',
//               '😃',
//               '😍',
//               '😁',
//               '😡',
//               '😢',
//               '😭',
//               '😰',
//               '😔'
//             ].map((emoji) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedEmoji = emoji;
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   emoji,
//                   style: const TextStyle(fontSize: 30),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   void _editOnToolSelected(String tool) {
//     if (tool == "Style") {
//       _editShowColorPicker();
//     } else if (tool == "Image") {
//       _editPickImage();
//     } else if (tool == "Video") {
//       _editPickVideo();
//     } else if (tool == "Voice") {
//       _editToggleRecording();
//     } else {
//       setState(() {
//         editSelectedTool = (editSelectedTool == tool) ? null : tool;
//       });
//     }
//   }

//   void _editOnTextChanged(String value) {
//     setState(() {
//       editTextSpans.add(
//         TextSpan(
//             text: value,
//             style: _getTextStyle()), // Apply style only to new text
//       ); // Clear the input field
//     });
//   }

//   Widget _editBuildBottomBar() {
//     var screenWidth = MediaQuery.of(context).size.width;

//     return Container(
//       width: screenWidth,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: const BoxDecoration(
//         color: Color.fromRGBO(28, 50, 91, 1),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _editBottomBarButton(Icons.brush, "Style"),
//             _editBottomBarButton(Icons.image, "Image"),
//             _editBottomBarButton(Icons.video_camera_back_rounded, "Video"),
//             _editBottomBarButton(Icons.star, "Favorite"),
//             _editBottomBarButton(Icons.emoji_emotions, "Mood"),
//             _editBottomBarButton(Icons.format_size, "Text"),
//             _editBottomBarButton(Icons.list, "List"),
//             _editBottomBarButton(Icons.label, "Tags"),
//             _editBottomBarButton(Icons.mic, "Voice"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _editBottomBarButton(IconData icon, String tooltip) {
//     return IconButton(
//       icon: Icon(icon,
//           color:
//               editSelectedTool == tooltip ? Colors.yellow[400] : Colors.white),
//       onPressed: () {
//         _editOnToolSelected(tooltip);
//       },
//       tooltip: tooltip,
//     );
//   }

//   Widget editDateselected() {
//     return Container(
//       padding: const EdgeInsets.all(0),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 1,
//           shadowColor: Colors.transparent,
//           backgroundColor: Colors.transparent,
//         ),
//         onPressed: () => _editSelectedDate(context),
//         child: Text(
//           DateFormat("dd-MM-yyyy").format(editSelectedDate).toString(),
//           style: TextStyle(
//             fontSize: 16,
//             color: Colorpallete.backgroundColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget editEmojoButton() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         elevation: 1,
//         shadowColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//       ),
//       onPressed: _editShowEmojiPicker,
//       child: Text(
//         selectedEmoji,
//         style: const TextStyle(fontSize: 24),
//       ),
//     );
//   }

//   Widget editTitleField() {
//     return TextField(
//       textAlignVertical: TextAlignVertical.top,
//       maxLines: 1,
//       controller: editTitleController,
//       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(0),
//         ),
//         hintText: "Enter diary title",
//         labelStyle: TextStyle(color: Colorpallete.backgroundColor),
//         hintStyle: TextStyle(
//           color: Colorpallete.backgroundColor,
//         ),
//       ),
//     );
//   }

//   Widget _editBuildAudioList() {
//     return Column(
//       children: [
//         if (editIsRecording)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.mic, color: Colors.red),
//                 const SizedBox(width: 8),
//                 SizedBox(
//                   width: 100,
//                   height: 20,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(
//                       10,
//                       (index) => Container(
//                         width: 3,
//                         height: (index % 2 == 0) ? 15.0 : 8.0,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(editRecordDuration,
//                     style: const TextStyle(color: Colors.white)),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ...editRecordedAudio.asMap().entries.map((entry) {
//           final index = entry.key;
//           final audio = entry.value;
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colorpallete.backgroundColor,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     editIsPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                   ),
//                   onPressed: () => _editPlayAudio(audio),
//                 ),
//                 const SizedBox(width: 8),
//                 SizedBox(
//                   width: 100,
//                   height: 20,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(
//                       15,
//                       (i) => Container(
//                         width: 2,
//                         height: (i % 3 == 0)
//                             ? 15.0
//                             : (i % 2 == 0)
//                                 ? 10.0
//                                 : 5.0,
//                         color: Colors.white.withOpacity(0.7),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     setState(() {
//                       editRecordedAudio.removeAt(index);
//                     });
//                   },
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }

//   Widget editDescriptionField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 300,
//           child: TextField(
//             textAlignVertical: TextAlignVertical.top,
//             controller: editContentController,
//             maxLines: null,
//             expands: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderSide: BorderSide.none,
//                 borderRadius: BorderRadius.circular(0),
//               ),
//               hintText: "Write your diary entry here...",
//               hintStyle: TextStyle(
//                 color: Colorpallete.backgroundColor,
//               ),
//             ),
//             style: _getTextStyle(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 8,
//           children: editSelectedImages.asMap().entries.map((entry) {
//             int index = entry.key;
//             File image = entry.value;
//             return GestureDetector(
//               onTap: () => _editShowDeleteImageDialog(index),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Stack(
//                   children: [
//                     Image.file(
//                       image,
//                       width: 100,
//                       height: 100,
//                       fit: BoxFit.cover,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 8,
//           children: editSelectedVideos.map((video) {
//             return GestureDetector(
//               onTap: () {
//                 _editPlayVideo(video);
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.black12,
//                     ),
//                     child: const Icon(
//                       Icons.play_circle_fill,
//                       color: Colors.white,
//                       size: 50,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 10),
//         _editBuildAudioList(),
//       ],
//     );
//   }

//   TextStyle _getTextStyle() {
//     switch (editSelectedTool) {
//       case "Style":
//         return TextStyle(color: editCurrentTextColor);
//       case "Text":
//         return const TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
//       case "Mood":
//         return const TextStyle(color: Colors.pinkAccent);
//       // case "Favorite":
//       //   return const TextStyle(decoration: TextDecoration.underline);
//       default:
//         return TextStyle(color: editCurrentTextColor);
//     }
//   }

//   Future<void> _editPickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedVideo =
//         await picker.pickImage(source: ImageSource.gallery);

//     if (pickedVideo != null) {
//       setState(() {
//         editSelectedImages.add(File(pickedVideo.path));
//       });
//     }
//   }

//   void _editShowDeleteImageDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colorpallete.bgColor,
//           title: const Text("Delete Image"),
//           content: const Text("Are you sure you want to delete this image?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   editSelectedImages.removeAt(index);
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _editPickVideo() async {
//     print("Video picker triggered");
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedVideo =
//         await picker.pickVideo(source: ImageSource.gallery);

//     if (pickedVideo != null) {
//       print("Video selected: ${pickedVideo.path}");
//       setState(() {
//         editSelectedVideos.add(File(pickedVideo.path));
//       });
//     } else {
//       print("No video selected");
//     }
//   }

//   void _editPlayVideo(File video) {
//     VideoPlayerController controller = VideoPlayerController.file(video);

//     controller.initialize().then((_) {
//       setState(() {});

//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: AspectRatio(
//               aspectRatio: controller.value.aspectRatio,
//               child: VideoPlayer(controller),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   controller.dispose();
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//       controller.play();
//     });
//   }

//   void _editStartTimer() {
//     _editRecordingDuration = 0;
//     _editTimer?.cancel();
//     _editTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() {
//         _editRecordingDuration++;
//         editRecordDuration = _editFormatDuration(_editRecordingDuration);
//       });
//     });
//   }

//   String _editFormatDuration(int seconds) {
//     final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
//     final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$remainingSeconds';
//   }

//   Future<void> _editToggleRecording() async {
//     if (editIsRecording) {
//       _editTimer?.cancel();
//       final path = await _editAudioRecorder.stop();
//       if (path != null) {
//         setState(() {
//           editRecordedAudio.add(File(path));
//           editIsRecording = false;
//         });
//       }
//     } else {
//       await _editRequestPermissions();
//       final dir = await getApplicationDocumentsDirectory();
//       final filePath =
//           '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       await _editAudioRecorder.start(
//         RecordConfig(),
//         path: filePath,
//       );
//       setState(() {
//         editIsRecording = true;
//       });
//       _editStartTimer();
//     }
//   }

//   void _editPlayAudio(File audioFile) async {
//     final player = AudioPlayer();
//     await player.play(DeviceFileSource(audioFile.path));
//   }

//   void _editShowColorPicker() {
//     final List<Color> colors = [
//       Colors.black,
//       Colors.red,
//       Colors.pink,
//       Colors.purple,
//       Colors.deepPurple,
//       Colors.indigo,
//       Colors.blue,
//       Colors.lightBlue,
//       Colors.cyan,
//       Colors.teal,
//       Colors.green,
//       Colors.lightGreen,
//       Colors.lime,
//       Colors.yellow,
//       Colors.amber,
//       Colors.orange,
//       Colors.deepOrange,
//       Colors.brown,
//       Colors.grey,
//       Colors.blueGrey,
//       Colors.redAccent,
//       Colors.pinkAccent,
//       Colors.purpleAccent,
//       Colors.deepPurpleAccent,
//       Colors.indigoAccent,
//       Colors.blueAccent,
//       Colors.lightBlueAccent,
//       Colors.cyanAccent,
//       Colors.tealAccent,
//       Colors.greenAccent,
//     ];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colorpallete.backgroundColor,
//           title: const Text(
//             'Pick a color',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: Container(
//             width: double.maxFinite,
//             child: GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//               ),
//               itemCount: colors.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       editCurrentTextColor = colors[index];
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: colors[index],
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white,
//                         width: editCurrentTextColor == colors[index] ? 2 : 0,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // editing functions end
//   // ===========================================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlue.withOpacity(0.6),
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 // Handle future editing logic
//                 setState(() {
//                   isEdit = !isEdit;
//                 });
//               },
//               child: const Text("Edit"),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: isEdit
//           ? FloatingActionButton(
//               onPressed: () {},
//               child: Icon(Icons.check),
//             )
//           : FloatingActionButton(
//               onPressed: () {},
//               child: Icon(Icons.book_outlined),
//             ),
//       bottomNavigationBar: isEdit ? _editBuildBottomBar() : _buildBottomBar(),
//       body: isEdit
//           ? Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colorpallete.bgColor,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: SingleChildScrollView(
//                   // Prevents overflow when keyboard appears
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Date Picker Field
//                           editDateselected(),
//                           // emjoi button
//                           editEmojoButton(),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       editTitleField(),
//                       const SizedBox(height: 2),
//                       editDescriptionField(),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           : Container(
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colorpallete.bgColor,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             DateFormat("dd-MM-yyyy").format(widget.date),
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colorpallete.backgroundColor,
//                             ),
//                           ),
//                           Text(
//                             widget.mood,
//                             style: const TextStyle(fontSize: 24),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         widget.title,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colorpallete.backgroundColor,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         height: 300,
//                         child: SingleChildScrollView(
//                           child: Text(
//                             widget.content,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colorpallete.backgroundColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: BottomAppBar(
//         color: const Color.fromRGBO(28, 50, 91, 1),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _bottomBarButton(Icons.brush, "Style"),
//               _bottomBarButton(Icons.image, "Image"),
//               _bottomBarButton(Icons.star, "Favorite"),
//               _bottomBarButton(Icons.emoji_emotions, "Mood"),
//               _bottomBarButton(Icons.format_size, "Text"),
//               _bottomBarButton(Icons.list, "List"),
//               _bottomBarButton(Icons.label, "Tags"),
//               _bottomBarButton(Icons.mic, "Voice"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _bottomBarButton(IconData icon, String tooltip) {
//     return IconButton(
//       icon: Icon(icon, color: Colors.white),
//       onPressed: () {
//         // Placeholder action
//       },
//       tooltip: tooltip,
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';

import 'dart:async';
import 'dart:io';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/audio_recording_section.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/diary_edit_toolbar.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/diary_header.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/media_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

class DiaryDetailScreen extends StatefulWidget {
  final String title;
  final String content;
  final String mood;
  final DateTime date;

  const DiaryDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
  });

  static Route route(String title, String content, String mood, DateTime date) {
    return MaterialPageRoute(
      builder: (context) => DiaryDetailScreen(
        title: title,
        content: content,
        mood: mood,
        date: date,
      ),
    );
  }

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  // Core diary data
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late DateTime selectedDate;
  late String selectedEmoji;
  bool isEditing = false;
  TextStyle currentTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  // Media related variables
  List<File> images = [];
  List<File> videos = [];
  List<File> audioRecordings = [];

  // Recording state
  bool isRecording = false;
  Timer? recordingTimer;
  int recordingDuration = 0;
  final AudioRecorder audioRecorder = AudioRecorder();

  // UI state
  String? selectedTool;
  Color currentTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    selectedDate = widget.date;
    selectedEmoji = widget.mood;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    recordingTimer?.cancel();
    super.dispose();
  }

  Widget _buildHeader() {
    return DiaryHeader(
      date: selectedDate,
      emoji: selectedEmoji,
      isEditing: false,
    );
  }

  Widget _buildEditHeader() {
    return DiaryHeader(
      date: selectedDate,
      emoji: selectedEmoji,
      isEditing: true,
      onDateChanged: (date) => setState(() => selectedDate = date),
      onEmojiChanged: (emoji) => setState(() => selectedEmoji = emoji),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colorpallete.backgroundColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.content,
          style: TextStyle(
            fontSize: 18,
            color: Colorpallete.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEditContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleController,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colorpallete.backgroundColor,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: "Enter diary title",
            hintStyle: TextStyle(color: Colorpallete.backgroundColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: contentController,
          maxLines: null,
          style: currentTextStyle.copyWith(
            color: currentTextColor,
          ), // Use combined style
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: "Write your diary entry here...",
            hintStyle: TextStyle(color: Colorpallete.backgroundColor),
          ),
        ),
      ],
    );
  }

  void _playVideo(File video) {
    final VideoPlayerController controller = VideoPlayerController.file(video);

    controller.initialize().then((_) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                VideoPlayer(controller),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    controller.dispose();
                    Navigator.pop(context);
                  },
                ),
                Center(
                  child: IconButton(
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      controller.play();
    });
  }

  Widget _buildMediaSection() {
    return Column(
      children: [
        MediaSection(
          images: images,
          videos: videos,
          isEditing: isEditing,
          onDeleteImage: (index) {
            setState(() => images.removeAt(index));
          },
          onPlayVideo: (video) {
            // Implement video playback
            _playVideo(video);
          },
        ),
        const SizedBox(height: 10),
        AudioRecordingSection(
          isRecording: isRecording,
          recordDuration:
              '${recordingDuration ~/ 60}:${(recordingDuration % 60).toString().padLeft(2, '0')}',
          recordings: audioRecordings,
          isPlaying: false, // Manage playing state
          onPlayAudio: (audio) {
            // Implement audio playback
          },
          onDeleteAudio: (index) {
            setState(() => audioRecordings.removeAt(index));
          },
        ),
      ],
    );
  }

  Widget _buildEditToolbar() {
    return DiaryEditToolbar(
      selectedTool: selectedTool,
      onToolSelected: (tool) {
        setState(() {
          if (selectedTool == tool) {
            selectedTool = null; // Deselect if tapped again
          } else {
            selectedTool = tool;
            _handleToolSelection(tool);
          }
        });
      },
    );
  }

  void _handleToolSelection(String tool) {
    switch (tool) {
      case "Style":
        _showColorPicker();
        break;
      case "Text":
        _showTextStylePicker();
        break;
      case "Image":
        _pickImage();
        break;
      case "Video":
        _pickVideo();
        break;
      case "Voice":
        _toggleRecording();
        break;
      case "Mood":
        _showEmojiPicker();
        break;
    }
  }

  void _showTextStylePicker() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow closing by tapping outside
      builder: (BuildContext dialogContext) {
        // Use dialogContext instead of context
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title: const Text(
            'Select Text Style',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStyleTile(
                  'Normal',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  dialogContext, // Pass dialogContext to _buildStyleTile
                ),
                _buildStyleTile(
                  'Italic',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Large Text',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Small Text',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Spaced Text',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2.0,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Condensed Text',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: -0.5,
                  ),
                  dialogContext,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyleTile(
      String title, TextStyle style, BuildContext dialogContext) {
    return ListTile(
      title: Text(
        title,
        style: style,
      ),
      onTap: () {
        setState(() {
          currentTextStyle = style.copyWith(
            color: currentTextColor,
          );
        });
        Navigator.of(dialogContext)
            .pop(); // Use dialogContext to pop only the dialog
      },
    );
  }

  // Add these methods to your _DiaryDetailScreenState class

  void _showColorPicker() {
    final List<Color> colors = [
      Colors.black,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title: const Text(
            'Pick a color',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTextColor = colors[index];
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: currentTextColor == colors[index] ? 2 : 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        images.add(File(pickedImage.path));
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      setState(() {
        videos.add(File(pickedVideo.path));
      });
    }
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      recordingTimer?.cancel();
      final path = await audioRecorder.stop();
      if (path != null) {
        setState(() {
          audioRecordings.add(File(path));
          isRecording = false;
        });
      }
    } else {
      await _requestPermissions();
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        RecordConfig(),
        path: filePath,
      );
      setState(() {
        isRecording = true;
        recordingDuration = 0;
      });
      _startRecordingTimer();
    }
  }

  void _startRecordingTimer() {
    recordingTimer?.cancel();
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        recordingDuration++;
      });
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  void _showEmojiPicker() {
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

  // UI Building Methods
  Widget _buildViewMode() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildContent(),
            // Add media display widgets here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditHeader(),
            const SizedBox(height: 16),
            _buildEditContent(),
            _buildMediaSection(),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Save changes here
        _saveChanges();
      }
    });
  }

  void _saveChanges() {
    // Implement save logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colorpallete.backgroundColor,
        foregroundColor: Colorpallete.bottomNavigationColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.withOpacity(0.6),
                foregroundColor: Colors.white,
              ),
              onPressed: _toggleEditMode,
              child: Text(isEditing ? "Save" : "Edit"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isEditing ? _buildEditToolbar() : null,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: Colorpallete.bgColor),
        child: isEditing ? _buildEditMode() : _buildViewMode(),
      ),
    );
  }
}
