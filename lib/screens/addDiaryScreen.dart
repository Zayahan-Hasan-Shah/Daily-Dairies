import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

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
  Color currentTextColor = Colors.black;

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

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
    if (tool == "Style") {
      _showColorPicker();
    } else if (tool == "Image") {
      _pickImage();
    } else if (tool == "Video") {
      _pickVideo();
    } else if (tool == "Voice") {
      _toggleRecording();
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
            _bottomBarButton(Icons.video_camera_back_rounded, "Video"),
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
            style: _getTextStyle(),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: selectedImages.asMap().entries.map((entry) {
            int index = entry.key;
            File image = entry.value;
            return GestureDetector(
              onTap: () => _showDeleteImageDialog(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.file(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: seletedVideos.map((video) {
            return GestureDetector(
              onTap: () {
                _playVideo(video);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        _buildAudioList(),
      ],
    );
  }

  TextStyle _getTextStyle() {
    switch (selectedTool) {
      case "Style":
        return TextStyle(color: currentTextColor);
      case "Text":
        return const TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
      case "Mood":
        return const TextStyle(color: Colors.pinkAccent);
      // case "Favorite":
      //   return const TextStyle(decoration: TextDecoration.underline);
      default:
        return TextStyle(color: currentTextColor);
    }
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
