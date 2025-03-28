import 'dart:io';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaSection extends StatelessWidget {
  final List<File> images;
  final List<File> videos;
  final Function(int)? onDeleteImage;
  final Function(File)? onPlayVideo;
  final bool isEditing;

  const MediaSection({
    Key? key,
    required this.images,
    required this.videos,
    this.onDeleteImage,
    this.onPlayVideo,
    this.isEditing = false,
  }) : super(key: key);

  void _showFullScreenImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(image),
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

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colorpallete.backgroundColor,
        title:
            const Text('Delete Image?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this image?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              onDeleteImage?.call(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: images.asMap().entries.map((entry) {
              int index = entry.key;
              File image = entry.value;
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, image),
                onLongPress:
                    isEditing ? () => _showDeleteDialog(context, index) : null,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        if (videos.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: videos.asMap().entries.map((entry) {
              int index = entry.key;
              File video = entry.value;
              return GestureDetector(
                onTap: () => onPlayVideo?.call(video),
                onLongPress: isEditing
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colorpallete.backgroundColor,
                            title: const Text('Delete Video?',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                'Are you sure you want to delete this video?',
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  videos.removeAt(index);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
