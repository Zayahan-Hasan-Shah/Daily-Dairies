import 'dart:async';
import 'dart:io';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/diary_entry.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/audio_recording_section.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/diary_edit_toolbar.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/diary_header.dart';
import 'package:daily_dairies/widgets/diary_detail_widgets/media_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final Color currentTextColor;
  final Color bulletPointColor;

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
    required this.bulletPointColor,
    required this.currentTextColor,
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
    required Color bulletPointColor,
    required Color currentTextColor,
  }) {
    // Print the exact values from the received textStyle
    print('DiaryDetailScreen.route: Creating route with exact textStyle: '
        'fontSize=${textStyle.fontSize}, '
        'fontWeight=${textStyle.fontWeight}, '
        'fontStyle=${textStyle.fontStyle}, '
        'letterSpacing=${textStyle.letterSpacing}, '
        'color=${textStyle.color}');

    // Create a complete TextStyle that explicitly includes all properties
    final completeTextStyle = TextStyle(
      fontSize: textStyle.fontSize,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      letterSpacing: textStyle.letterSpacing,
      color: textColor,
    );

    print('DiaryDetailScreen.route: Using final textStyle: '
        'fontSize=${completeTextStyle.fontSize}, '
        'fontWeight=${completeTextStyle.fontWeight}, '
        'fontStyle=${completeTextStyle.fontStyle}, '
        'letterSpacing=${completeTextStyle.letterSpacing}, '
        'color=${completeTextStyle.color}');

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
        textStyle: completeTextStyle, // Use the explicitly defined style
        tags: tags,
        bulletPointColor: bulletPointColor,
        currentTextColor: currentTextColor,
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
  late TextStyle currentTextStyle;
  Color currentTextColor = Colors.black; // For content color
  Color bulletPointColor = Colors.black;

  // Bullet points data - using a simplified approach
  final List<String> bulletPoints = []; // Fixed list of bullet points
  late TextEditingController
      bulletPointController; // Single controller for adding new bullet points

  // Tags (mutable copy)
  late List<String> tags;

  // Media related variables
  List<File> images = [];
  List<File> videos = [];
  List<File> audioRecordings = [];

  // Audio playback state
  AudioPlayer? currentlyPlayingAudio;
  int? currentlyPlayingIndex;
  bool isAudioPlaying = false;

  // Recording state
  bool isRecording = false;
  Timer? recordingTimer;
  int recordingDuration = 0;
  final AudioRecorder audioRecorder = AudioRecorder();

  // UI state
  String? selectedTool;

  final FocusNode bulletPointFocusNode = FocusNode();

  bool isTextSelected = true; // Added for color picker UI

  @override
  void initState() {
    super.initState();

    // Debug the incoming text style properties
    print('DiaryDetailScreen.initState: Received textStyle: '
        'fontSize=${widget.textStyle.fontSize}, '
        'fontWeight=${widget.textStyle.fontWeight}, '
        'fontStyle=${widget.textStyle.fontStyle}, '
        'letterSpacing=${widget.textStyle.letterSpacing}');

    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    selectedDate = widget.date;
    selectedEmoji = widget.mood;
    currentTextColor = widget.textColor;
    bulletPointColor = widget.bulletPointColor;

    // Store the incoming TextStyle directly without creating a new one
    currentTextStyle = widget.textStyle;

    // Initialize bullet points directly from widget
    bulletPoints.clear();
    bulletPoints
        .addAll(widget.bulletPoints.where((point) => point.trim().isNotEmpty));

    // Initialize tags list from widget
    tags = List<String>.from(widget.tags);

    // Initialize single bullet point controller
    bulletPointController = TextEditingController();

    _initializeMediaFiles();
    bulletPointFocusNode
        .requestFocus(); // Request focus on the bullet point input
  }

  void _initializeMediaFiles() {
    bool hasMissingFiles = false;
    try {
      for (String path in widget.images) {
        final file = File(path);
        if (file.existsSync()) {
          images.add(file);
        } else {
          hasMissingFiles = true;
        }
      }
      for (String path in widget.videos) {
        final file = File(path);
        if (file.existsSync()) {
          videos.add(file);
        } else {
          hasMissingFiles = true;
        }
      }
      for (String path in widget.audioRecordings) {
        final file = File(path);
        if (file.existsSync()) {
          audioRecordings.add(file);
        } else {
          hasMissingFiles = true;
        }
      }
      if (hasMissingFiles) {
        // Show a snackbar message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Some media files are missing. This may be because the app was reinstalled or cache was cleared.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Error initializing media files: $e');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    bulletPointController.dispose();
    recordingTimer?.cancel();
    currentlyPlayingAudio?.dispose(); // Dispose audio player
    bulletPointFocusNode.dispose(); // Dispose of the focus node
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
    // Print the exact style being used to render content
    print('_buildContent using style with: '
        'fontSize=${widget.textStyle.fontSize}, '
        'fontWeight=${widget.textStyle.fontWeight}, '
        'fontStyle=${widget.textStyle.fontStyle}, '
        'letterSpacing=${widget.textStyle.letterSpacing}');

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
        // Use the direct TextStyle from the widget without any modifications
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
                    // Use the direct TextStyle for bullet points too
                    Text(
                      '•  ',
                      style: widget.textStyle.copyWith(
                        color: widget.bulletPointColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: widget.textStyle.copyWith(
                          color: widget.textColor,
                        ),
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
        if (images.isNotEmpty || videos.isNotEmpty)
          MediaSection(
            images: images,
            videos: videos,
            onPlayVideo: _playVideo,
            onViewImage: _viewImage,
          ),
        const SizedBox(
          height: 20,
        ),
        if (audioRecordings.isNotEmpty)
          AudioRecordingSection(
            recordings: audioRecordings,
            isRecording: false,
            recordDuration: '',
            isPlaying: isAudioPlaying,
            currentPlayingIndex: currentlyPlayingIndex,
            onPlayAudio: (audio) {
              // Get the index of the audio in the list
              final index = audioRecordings.indexOf(audio);
              if (index != -1) {
                _playAudio(audio, index);
              }
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
            hintText: 'enter_diary_title'.tr,
            hintStyle: TextStyle(color: Colorpallete.backgroundColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: contentController,
          maxLines: null,
          style: currentTextStyle?.copyWith(
            color: currentTextColor,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: 'write_diary_entry'.tr,
            hintStyle: TextStyle(color: Colorpallete.backgroundColor),
          ),
        ),
        const SizedBox(height: 16),
        _buildBulletPointInput(),
        const SizedBox(height: 16),
        _buildBulletPointsList(),
        const SizedBox(height: 16),
        _buildTagInputArea(),
        const SizedBox(height: 20),
        _buildMediaSection(),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaSection(
          images: images,
          videos: videos,
          isEditing: isEditing,
          onDeleteImage: (index) {
            setState(() => images.removeAt(index));
          },
          onPlayVideo: (video) {
            _playVideo(video);
          },
          onViewImage: isEditing ? null : _viewImage,
          onDeleteVideo: isEditing
              ? (index) {
                  setState(() => videos.removeAt(index));
                }
              : null,
        ),
        const SizedBox(height: 30),
        AudioRecordingSection(
          isRecording: isRecording,
          recordDuration:
              '${recordingDuration ~/ 60}:${(recordingDuration % 60).toString().padLeft(2, '0')}',
          recordings: audioRecordings,
          isPlaying: isAudioPlaying,
          currentPlayingIndex: currentlyPlayingIndex,
          onPlayAudio: (audio) {
            // Get the index of the audio in the list
            final index = audioRecordings.indexOf(audio);
            if (index != -1) {
              _playAudio(audio, index);
            }
          },
          onDeleteAudio: (index) {
            // Stop playback if this is the currently playing audio
            if (currentlyPlayingIndex == index && isAudioPlaying) {
              currentlyPlayingAudio?.stop();
              setState(() {
                isAudioPlaying = false;
                currentlyPlayingIndex = null;
              });
            }
            // Update the currently playing index if needed
            if (currentlyPlayingIndex != null &&
                currentlyPlayingIndex! > index) {
              setState(() {
                currentlyPlayingIndex = currentlyPlayingIndex! - 1;
              });
            }
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
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colorpallete.backgroundColor,
            title: const Text(
              'Pick a color',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorTargetSelector(
                          'Text',
                          isTextSelected,
                          (selected) =>
                              setState(() => isTextSelected = selected)),
                      _buildColorTargetSelector(
                          'Bullet Points',
                          !isTextSelected,
                          (selected) =>
                              setState(() => isTextSelected = !selected)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final bool isTextColorSelected =
                          currentTextColor == colors[index];
                      final bool isBulletColorSelected =
                          bulletPointColor == colors[index];
                      final bool isSelected = isTextSelected
                          ? isTextColorSelected
                          : isBulletColorSelected;

                      return GestureDetector(
                        onTap: () {
                          if (isTextSelected) {
                            this.setState(() {
                              currentTextColor = colors[index];
                              // Also update the text style color
                              if (currentTextStyle != null) {
                                currentTextStyle = currentTextStyle!.copyWith(
                                  color: colors[index],
                                );
                              }
                            });
                          } else {
                            this.setState(() {
                              bulletPointColor = colors[index];
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: isSelected ? 2 : 0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildColorTargetSelector(
      String label, bool isSelected, Function(bool) onTap) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
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

  Widget _buildBulletPointInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bullet Points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: currentTextColor,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add"),
              onPressed: _addBulletPoint,
            ),
          ],
        ),
        // Single bullet point input field
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text('•  ', style: currentTextStyle),
              Expanded(
                child: TextField(
                  controller: bulletPointController,
                  focusNode: bulletPointFocusNode,
                  style: currentTextStyle.copyWith(color: currentTextColor),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    hintText: "Type and press Enter to add a bullet point",
                    hintStyle: TextStyle(color: Colorpallete.backgroundColor),
                  ),
                  onSubmitted: (_) => _addBulletPoint(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPointsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bulletPoints.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text('•  ', style: currentTextStyle),
              Expanded(
                child: Text(
                  point,
                  style: currentTextStyle.copyWith(color: currentTextColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    bulletPoints.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTagInputArea() {
    final TextEditingController tagController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: currentTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...tags.map((tag) {
              return InputChip(
                label: Text('# $tag'),
                backgroundColor: Colors.blue.withOpacity(0.2),
                onDeleted: () {
                  setState(() {
                    tags.remove(tag);
                  });
                },
              );
            }),

            // Tag input field as a chip
            SizedBox(
              width: 100,
              child: TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  hintText: '#',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      tags.add(value.trim());
                      tagController.clear();
                    });
                  }
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  void _addBulletPoint() {
    final String text = bulletPointController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        bulletPoints.add(text);
        bulletPointController.clear();
      });
      // Re-focus the bullet point input field
      bulletPointFocusNode.requestFocus();
    }
  }

  void _removeBulletPoint(int index) {
    setState(() {
      bulletPoints.removeAt(index);
    });
  }

  void _toggleEditMode() {
    if (isEditing) {
      // If exiting edit mode, save changes
      _saveChanges();
    } else {
      // If entering edit mode, stop any audio playback
      if (isAudioPlaying && currentlyPlayingAudio != null) {
        currentlyPlayingAudio!.stop();
        setState(() {
          isAudioPlaying = false;
          currentlyPlayingIndex = null;
        });
      }
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveChanges() async {
    try {
      final entry = DiaryEntry(
        id: widget.id,
        userId: _diaryController.userId!,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        date: selectedDate,
        mood: selectedEmoji,
        tags: tags, // Use our mutable tags list
        textColor: currentTextColor ?? Colors.black,
        bulletPointColor: bulletPointColor ?? Colors.black,
        textStyle: currentTextStyle,
        images: images.map((file) => file.path).toList(),
        videos: videos.map((file) => file.path).toList(),
        audioRecordings: audioRecordings.map((file) => file.path).toList(),
        bulletPoints:
            List.from(bulletPoints), // Use a copy of the bullet points
      );

      await _diaryController.updateEntry(entry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary entry updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error updating diary entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update diary: ${e.toString()}'),
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
              child: Text(isEditing ? "save".tr : "edit".tr),
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
          ],
        ),
      ),
    );
  }

  // Audio playback functionality
  void _playAudio(File audioFile, int index) async {
    try {
      // If there's currently an audio playing
      if (currentlyPlayingAudio != null) {
        await currentlyPlayingAudio!.stop();

        // If tapping the same audio that's already playing, just stop it
        if (currentlyPlayingIndex == index && isAudioPlaying) {
          setState(() {
            isAudioPlaying = false;
            currentlyPlayingIndex = null;
          });
          return;
        }
      }

      // Create a new audio player or reuse existing one
      currentlyPlayingAudio ??= AudioPlayer();

      // Set the currently playing index
      setState(() {
        currentlyPlayingIndex = index;
        isAudioPlaying = true;
      });

      // Play the audio
      await currentlyPlayingAudio!.play(DeviceFileSource(audioFile.path));

      // Listen for playback completion
      currentlyPlayingAudio!.onPlayerComplete.listen((event) {
        setState(() {
          isAudioPlaying = false;
          currentlyPlayingIndex = null;
        });
      });
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing audio: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isAudioPlaying = false;
        currentlyPlayingIndex = null;
      });
    }
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

  // Add this method for viewing images
  void _viewImage(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(
                image,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
