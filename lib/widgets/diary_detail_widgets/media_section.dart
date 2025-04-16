import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaSection extends StatelessWidget {
  final List<File> images;
  final List<File> videos;
  final Function(int)? onDeleteImage;
  final Function(File)? onPlayVideo;
  final bool isEditing;

  const MediaSection({
    super.key,
    required this.images,
    required this.videos,
    this.onDeleteImage,
    this.onPlayVideo,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildImageGrid(),
        ],
        if (videos.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildVideoGrid(),
        ],
      ],
    );
  }

  Widget _buildImageGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: isEditing ? () => onDeleteImage?.call(entry.key) : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: buildImage(entry.value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVideoGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: videos.map((video) {
        return GestureDetector(
          onTap: () => onPlayVideo?.call(video),
          child: Container(
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
        );
      }).toList(),
    );
  }
}
