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
