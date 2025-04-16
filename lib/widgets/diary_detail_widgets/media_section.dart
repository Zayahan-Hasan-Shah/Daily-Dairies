import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaSection extends StatelessWidget {
  final List<File> images;
  final List<File> videos;
  final Function(int)? onDeleteImage;
  final Function(int)? onDeleteVideo;
  final Function(File)? onPlayVideo;
  final Function(File)? onViewImage;
  final bool isEditing;

  const MediaSection({
    super.key,
    required this.images,
    required this.videos,
    this.onDeleteImage,
    this.onDeleteVideo,
    this.onPlayVideo,
    this.onViewImage,
    this.isEditing = false,
  });

  Widget buildImage(File imageFile) {
    if (!imageFile.existsSync()) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(height: 8),
            Text(
              'Media not found',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return Image.file(
      imageFile,
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(height: 8),
              Text(
                'Error loading media',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }

  void _showImagePreview(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.white, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Error loading image',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildImageGrid(context),
        ],
        if (videos.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildVideoGrid(context),
        ],
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: isEditing
              ? () => onDeleteImage?.call(entry.key)
              : () {
                  if (onViewImage != null) {
                    onViewImage!(entry.value);
                  } else {
                    _showImagePreview(context, entry.value);
                  }
                },
          onLongPress: isEditing
              ? () {
                  if (onViewImage != null) {
                    onViewImage!(entry.value);
                  } else {
                    _showImagePreview(context, entry.value);
                  }
                }
              : null,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: buildImage(entry.value),
              ),
              if (isEditing)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVideoGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: videos.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            if (onPlayVideo != null) {
              onPlayVideo!(entry.value);
            } else {
              _playVideoFallback(context, entry.value);
            }
          },
          child: Stack(
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
              if (isEditing && onDeleteVideo != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // When delete button is tapped, remove the video
                      onDeleteVideo!(entry.key);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _playVideoFallback(BuildContext context, File video) {
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
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return IconButton(
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
                      );
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
}
