import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class BulletPointWidget extends StatefulWidget {
  final TextStyle? currentTextStyle;
  final Function(String) onTextChanged;
  final Function(List<String>) onBulletPointsChanged;

  const BulletPointWidget({
    Key? key,
    this.currentTextStyle,
    required this.onTextChanged,
    required this.onBulletPointsChanged,
  }) : super(key: key);

  @override
  State<BulletPointWidget> createState() => _BulletPointWidgetState();
}

class _BulletPointWidgetState extends State<BulletPointWidget> {
  final List<TextEditingController> _bulletControllers = [];

  @override
  void dispose() {
    for (var controller in _bulletControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addBulletPoint() {
    setState(() {
      _bulletControllers.add(TextEditingController());
    });
    _updateBulletPoints();
  }

  void _removeBulletPoint(int index) {
    setState(() {
      _bulletControllers[index].dispose();
      _bulletControllers.removeAt(index);
    });
    _updateBulletPoints();
  }

  void _updateBulletPoints() {
    final bulletPoints = _bulletControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    widget.onBulletPointsChanged(bulletPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._bulletControllers.asMap().entries.map((entry) {
          int idx = entry.key;
          var controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Text('•', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: widget.currentTextStyle,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter bullet point',
                    ),
                    onChanged: (value) {
                      _updateBulletPoints();
                      widget.onTextChanged(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeBulletPoint(idx),
                ),
              ],
            ),
          );
        }).toList(),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Bullet Point'),
          onPressed: _addBulletPoint,
        ),
      ],
    );
  }
}
