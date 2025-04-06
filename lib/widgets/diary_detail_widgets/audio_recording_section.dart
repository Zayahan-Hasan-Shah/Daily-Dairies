import 'dart:io';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class AudioRecordingSection extends StatelessWidget {
  final bool isRecording;
  final String recordDuration;
  final List<File> recordings;
  final bool isPlaying;
  final Function(File)? onPlayAudio;
  final Function(int)? onDeleteAudio;

  const AudioRecordingSection({
    super.key,
    required this.isRecording,
    required this.recordDuration,
    required this.recordings,
    this.isPlaying = false,
    this.onPlayAudio,
    this.onDeleteAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRecording) _buildRecordingIndicator(),
        ...recordings.asMap().entries.map((entry) {
          return _buildAudioItem(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic, color: Colors.red),
          const SizedBox(width: 8),
          _buildWaveform(),
          const SizedBox(width: 8),
          Text(recordDuration, style: const TextStyle(color: Colors.white)),
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
    );
  }

  Widget _buildAudioItem(int index, File audio) {
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
            onPressed: () => onPlayAudio?.call(audio),
          ),
          const SizedBox(width: 8),
          _buildWaveform(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDeleteAudio?.call(index),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return SizedBox(
      width: 100,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          15,
          (i) => Container(
            width: 2,
            height: (i % 3 == 0) ? 15.0 : (i % 2 == 0) ? 10.0 : 5.0,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}