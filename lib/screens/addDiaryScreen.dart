import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/diary_entry.dart';
import 'package:daily_dairies/widgets/add_diary_widget/bottom_toolbar.dart';
import 'package:daily_dairies/widgets/add_diary_widget/bullet_point_widget.dart';
import 'package:daily_dairies/widgets/add_diary_widget/diary_content.dart';
import 'package:daily_dairies/widgets/add_diary_widget/diary_header.dart';
import 'package:daily_dairies/widgets/add_diary_widget/diary_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:daily_dairies/widgets/add_diary_widget/media_section.dart';

class AddDiaryScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const AddDiaryScreen());

  const AddDiaryScreen({Key? key}) : super(key: key);

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  final DiaryController _diaryController = Get.find<DiaryController>();
  final List<TextEditingController> _bulletPoints = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(); // Date Controller
  final Color descriptionTextColor = Colorpallete.backgroundColor;
  String? selectedTool;
  List<TextSpan> textSpans = [];
  List<File> selectedImages = [];
  List<File> seletedVideos = [];
  List<File> recordedAudio = [];
  // final Record _audioRecorder = Record();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool isRecording = false;
  Timer? _timer;
  int _recordingDuration = 0;
  String recordDuration = '00:00';
  List<double> audioAmplitudes = [];
  bool isPlaying = false;
  Color? currentTextColor;
  TextStyle? currentTextStyle;
  bool showBulletPoints = false;
  late DateTime selectedDate;
  late String selectedEmoji;
  List<String> currentBulletPoints = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedEmoji = '😊';
    currentTextColor = Colors.black;
    currentTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    dateController.dispose();
    for (var controller in _bulletPoints) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveDiaryEntry() async {
    // Create a loading overlay controller
    final loadingOverlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      if (_diaryController.userId == null) {
        throw Exception('User not logged in');
      }

      // Validate inputs
      if (titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title')),
        );
        return;
      }

      // Show loading overlay
      Overlay.of(context).insert(loadingOverlay);

      final String entryId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create the diary entry with bullet points
      final entry = DiaryEntry(
        id: entryId,
        userId: _diaryController.userId!,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        date: selectedDate,
        mood: selectedEmoji,
        textColor: currentTextColor ?? Colors.black,
        textStyle: currentTextStyle ??
            const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
        images: selectedImages.map((file) => file.path).toList(),
        videos: seletedVideos.map((file) => file.path).toList(),
        audioRecordings: recordedAudio.map((file) => file.path).toList(),
        bulletPoints: currentBulletPoints,
      );

      print(
          'Saving diary entry with bullet points: ${currentBulletPoints}'); // Debug print
      await _diaryController.addEntry(entry);

      // Remove loading overlay
      loadingOverlay.remove();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary entry saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      print('Error saving diary: $e');
      print('Stack trace: $stackTrace');

      // Remove loading overlay
      loadingOverlay.remove();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save diary entry: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _showEmojiPicker() async {
    final List<String> emojis = [
      '😊',
      '😢',
      '😡',
      '😴',
      '🤔',
      '😎',
      '🥳',
      '😍'
    ];

    final String? selectedEmoji = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title:
              const Text('Select Mood', style: TextStyle(color: Colors.white)),
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: emojis.map((emoji) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, emoji),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedEmoji != null) {
      setState(() {
        this.selectedEmoji = selectedEmoji;
      });
    }
  }

  void _showTextStylePicker() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                    fontSize: 16,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Italic',
                  const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Large Text',
                  const TextStyle(
                    fontSize: 24,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Small Text',
                  const TextStyle(
                    fontSize: 12,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Spaced Text',
                  const TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.0,
                  ),
                  dialogContext,
                ),
                _buildStyleTile(
                  'Condensed Text',
                  const TextStyle(
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
        style: style.copyWith(color: Colors.white),
      ),
      onTap: () {
        setState(() {
          currentTextStyle = style.copyWith(color: currentTextColor);
          selectedTool = "Text"; // This ensures the style is maintained
        });
        Navigator.of(dialogContext).pop();
      },
    );
  }

  void _onToolSelected(String tool) {
    setState(() {
      if (selectedTool == tool) {
        selectedTool = null;
      } else {
        selectedTool = tool;
      }

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
        case "List":
          setState(() {
            showBulletPoints = !showBulletPoints;
          });
          break;
        case "Voice":
          _toggleRecording();
          break;
      }
    });
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

  void _onBulletPointChanged(String text, int index) {
    if (index < currentBulletPoints.length) {
      setState(() {
        currentBulletPoints[index] = text;
      });
    } else {
      setState(() {
        currentBulletPoints.add(text);
      });
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottomBarButton(Icons.brush, "Style"),
            _bottomBarButton(Icons.format_size, "Text"),
            _bottomBarButton(Icons.image, "Image"),
            _bottomBarButton(Icons.video_camera_back_rounded, "Video"),
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
      icon: Icon(
        icon,
        color: selectedTool == tooltip ? Colors.yellow[400] : Colors.white,
      ),
      onPressed: () => _onToolSelected(tooltip),
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

  Widget _buildAudioList() {
    return Column(
      children: [
        if (isRecording)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, color: Colors.red),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      10,
                      (index) => Container(
                        width: 3,
                        height: (index % 2 == 0) ? 15.0 : 8.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(recordDuration,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ...recordedAudio.asMap().entries.map((entry) {
          final index = entry.key;
          final audio = entry.value;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colorpallete.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () => _playAudio(audio),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      15,
                      (i) => Container(
                        width: 2,
                        height: (i % 3 == 0)
                            ? 15.0
                            : (i % 2 == 0)
                                ? 10.0
                                : 5.0,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      recordedAudio.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

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
            style: currentTextStyle,
          ),
        ),
        const SizedBox(height: 10),
        MediaSection(
          images: selectedImages,
          videos: seletedVideos,
          onDeleteImage: (index) {
            setState(() {
              selectedImages.removeAt(index);
            });
          },
          onPlayVideo: (video) {
            _playVideo(video);
          },
        ),
        const SizedBox(height: 10),
        _buildAudioList(),
      ],
    );
  }

  TextStyle _getTextStyle() {
    if (selectedTool == null) {
      return currentTextStyle!;
    }
    return currentTextStyle!;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedVideo != null) {
      setState(() {
        selectedImages.add(File(pickedVideo.path));
      });
    }
  }

  void _showDeleteImageDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colorpallete.bgColor,
          title: const Text("Delete Image"),
          content: const Text("Are you sure you want to delete this image?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedImages.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickVideo() async {
    print("Video picker triggered");
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      print("Video selected: ${pickedVideo.path}");
      setState(() {
        seletedVideos.add(File(pickedVideo.path));
      });
    } else {
      print("No video selected");
    }
  }

  void _playVideo(File video) {
    VideoPlayerController controller = VideoPlayerController.file(video);

    controller.initialize().then((_) {
      setState(() {});

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.dispose();
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
      controller.play();
    });
  }

  void _startTimer() {
    _recordingDuration = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordingDuration++;
        recordDuration = _formatDuration(_recordingDuration);
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      _timer?.cancel();
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          recordedAudio.add(File(path));
          isRecording = false;
        });
      }
    } else {
      await _requestPermissions();
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        RecordConfig(),
        path: filePath,
      );
      setState(() {
        isRecording = true;
      });
      _startTimer();
    }
  }

  void _playAudio(File audioFile) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(audioFile.path));
  }

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
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.deepPurpleAccent,
      Colors.indigoAccent,
      Colors.blueAccent,
      Colors.lightBlueAccent,
      Colors.cyanAccent,
      Colors.tealAccent,
      Colors.greenAccent,
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
                      currentTextStyle = currentTextStyle!.copyWith(
                        color: colors[index],
                      );
                      selectedTool = "Style";
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

  void _addBulletPoint() {
    setState(() {
      _bulletPoints.add(TextEditingController());
    });
  }

  void _removeBulletPoint(int index) {
    setState(() {
      _bulletPoints[index].dispose();
      _bulletPoints.removeAt(index);
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
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
                onPressed: _saveDiaryEntry,
                child: const Text("Save Entry"),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomToolbar(
        selectedTool: selectedTool,
        onToolSelected: _onToolSelected,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colorpallete.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                DiaryHeader(
                  selectedDate: selectedDate,
                  selectedEmoji: selectedEmoji,
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  onEmojiTap: _showEmojiPicker,
                ),
                const SizedBox(height: 16),
                DiaryTitle(
                  controller: titleController,
                ),
                const SizedBox(height: 2),
                DiaryContent(
                  controller: contentController,
                  currentTextStyle: currentTextStyle!,
                  onChanged: (value) {
                    setState(() {
                      textSpans.add(
                        TextSpan(
                          text: value,
                          style: currentTextStyle,
                        ),
                      );
                    });
                  },
                ),
                if (showBulletPoints) ...[
                  const SizedBox(height: 10),
                  BulletPointWidget(
                    currentTextStyle: currentTextStyle ??
                        const TextStyle(fontSize: 16, color: Colors.black),
                    onTextChanged: (text) {
                      setState(() {
                        if (!currentBulletPoints.contains(text)) {
                          currentBulletPoints.add(text);
                        }
                      });
                    },
                  ),
                ],
                const SizedBox(height: 10),
                // Media section
                MediaSection(
                  images: selectedImages,
                  videos: seletedVideos,
                  onDeleteImage: (index) {
                    setState(() {
                      selectedImages.removeAt(index);
                    });
                  },
                  onPlayVideo: (video) {
                    _playVideo(video);
                  },
                ),
                const SizedBox(height: 10),
                // Audio section
                _buildAudioList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
