import 'dart:async';
import 'dart:io';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/diary_entry.dart';
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
import 'package:get/get.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';

class DiaryDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final String mood;
  final DateTime date;
  final List<String> images;
  final List<String> videos;
  final List<String> audioRecordings;
  final List<String> bulletPoints;
  final Color textColor;
  final TextStyle textStyle;
  final List<String> tags;

  const DiaryDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
    required this.images,
    required this.videos,
    required this.audioRecordings,
    required this.bulletPoints,
    required this.textColor,
    required this.textStyle,
    required this.tags,
  });

  static MaterialPageRoute route({
    required String id,
    required String title,
    required String content,
    required String mood,
    required DateTime date,
    required List<String> images,
    required List<String> videos,
    required List<String> audioRecordings,
    required List<String> bulletPoints,
    required Color textColor,
    required TextStyle textStyle,
    required List<String> tags,
  }) {
    return MaterialPageRoute(
      builder: (_) => DiaryDetailScreen(
        id: id,
        title: title,
        content: content,
        mood: mood,
        date: date,
        images: images,
        videos: videos,
        audioRecordings: audioRecordings,
        bulletPoints: bulletPoints,
        textColor: textColor,
        textStyle: textStyle,
        tags: tags,
      ),
    );
  }

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final DiaryController _diaryController = Get.find<DiaryController>();

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
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.content,
          style: widget.textStyle,
        ),
        if (widget.bulletPoints.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...widget.bulletPoints.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•  ', style: widget.textStyle),
                    Expanded(
                      child: Text(
                        point,
                        style: widget.textStyle,
                      ),
                    ),
                  ],
                ),
              )),
        ],
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                    ))
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        if (widget.images.isNotEmpty || widget.videos.isNotEmpty)
          MediaSection(
            images: widget.images.map((path) => File(path)).toList(),
            videos: widget.videos.map((path) => File(path)).toList(),
            isEditing: false,
            onPlayVideo: _playVideo,
          ),
        if (widget.audioRecordings.isNotEmpty)
          AudioRecordingSection(
            recordings:
                widget.audioRecordings.map((path) => File(path)).toList(),
            isRecording: false,
            recordDuration: '',
            isPlaying: false,
            onPlayAudio: (audio) {
              // Implement audio playback
            },
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
            color: currentTextColor,
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
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: "Write your diary entry here...",
            hintStyle: TextStyle(color: Colorpallete.backgroundColor),
          ),
        ),
        if (widget.bulletPoints.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...widget.bulletPoints.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•  ', style: currentTextStyle),
                    Expanded(
                      child: Text(
                        point,
                        style: currentTextStyle,
                      ),
                    ),
                  ],
                ),
              )),
        ],
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          widget.tags.remove(tag);
                        });
                      },
                    ))
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        MediaSection(
          images: images,
          videos: videos,
          isEditing: true,
          onDeleteImage: (index) {
            setState(() => images.removeAt(index));
          },
          onPlayVideo: _playVideo,
        ),
        const SizedBox(height: 10),
        AudioRecordingSection(
          isRecording: isRecording,
          recordDuration:
              '${recordingDuration ~/ 60}:${(recordingDuration % 60).toString().padLeft(2, '0')}',
          recordings: audioRecordings,
          isPlaying: false,
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
    if (isEditing) {
      // If we're currently editing, save changes
      _saveChanges();
    } else {
      // Enter edit mode
      setState(() {
        isEditing = true;
      });
    }
  }

  void _saveChanges() async {
    // Create a loading overlay
    final loadingOverlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      // Show loading overlay
      Overlay.of(context).insert(loadingOverlay);

      // Create updated diary entry
      final updatedEntry = DiaryEntry(
        id: widget.id,
        userId: _diaryController.userId!,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        date: selectedDate,
        mood: selectedEmoji,
        textColor: currentTextColor,
        textStyle: currentTextStyle,
        images: images.map((file) => file.path).toList(),
        videos: videos.map((file) => file.path).toList(),
        audioRecordings: audioRecordings.map((file) => file.path).toList(),
        bulletPoints: widget.bulletPoints,
        tags: widget.tags,
      );

      // Update the entry in Firestore
      await _diaryController.updateEntry(updatedEntry);

      // Remove loading overlay
      loadingOverlay.remove();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary entry updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Exit edit mode
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      // Remove loading overlay
      loadingOverlay.remove();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update diary entry: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
