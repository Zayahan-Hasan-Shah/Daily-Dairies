import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class MediaSection extends StatelessWidget {
  final List<File> images;
  final List<File> videos;
  final Function(int) onDeleteImage;
  final Function(File) onPlayVideo;

  const MediaSection({
    Key? key,
    required this.images,
    required this.videos,
    required this.onDeleteImage,
    required this.onPlayVideo,
  }) : super(key: key);

  Widget _buildImagePreview(BuildContext context, int index, File image) {
    return GestureDetector(
      onTap: () => _showDeleteImageDialog(context, index), // Pass context here
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoPreview(File video) {
    return GestureDetector(
      onTap: () => onPlayVideo(video),
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
  }

  void _showDeleteImageDialog(BuildContext context, int index) {
    // Changed parameter order
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colorpallete.bgColor,
          title: const Text(
            "Delete Image",
            style: TextStyle(color: Colors.white), // Add text color
          ),
          content: const Text(
            "Are you sure you want to delete this image?",
            style: TextStyle(color: Colors.white), // Add text color
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white), // Add text color
              ),
            ),
            TextButton(
              onPressed: () {
                onDeleteImage(index);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ...images.asMap().entries.map((entry) {
              return _buildImagePreview(
                  context, entry.key, entry.value); // Pass context here
            }),
            ...videos.map((video) {
              return _buildVideoPreview(video);
            }),
          ],
        ),
      ],
    );
  }
}
