import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class MediaSection extends StatelessWidget {
  final List<File>? images;
  final List<File>? videos;
  final Function(int)? onDeleteImage;
  final Function(File)? onPlayVideo;

  const MediaSection({
    Key? key,
    this.images,
    this.videos,
    this.onDeleteImage,
    this.onPlayVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (images?.isNotEmpty ?? false) ...[
          // Image grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: images!.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.file(
                    images![index],
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteImage?.call(index),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        if (videos?.isNotEmpty ?? false) ...[
          // Video thumbnails
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: videos!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onPlayVideo?.call(videos![index]),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      child: const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
