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
    Key? key,
    required this.images,
    required this.videos,
    this.onDeleteImage,
    this.onPlayVideo,
    this.isEditing = false,
  }) : super(key: key);

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
            child: Image.file(
              entry.value,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
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
