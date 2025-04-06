import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class BulletPointWidget extends StatefulWidget {
  final TextStyle currentTextStyle;
  final Function(String) onTextChanged;

  const BulletPointWidget({
    super.key,
    required this.currentTextStyle,
    required this.onTextChanged,
  });

  @override
  State<BulletPointWidget> createState() => _BulletPointWidgetState();
}

class _BulletPointWidgetState extends State<BulletPointWidget> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _addNewBulletPoint();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _addNewBulletPoint() {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    setState(() {
      _controllers.add(controller);
      _focusNodes.add(focusNode);
    });

    // Focus on the new bullet point
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  void _removeBulletPoint(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers[index].dispose();
        _focusNodes[index].dispose();
        _controllers.removeAt(index);
        _focusNodes.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ..._controllers.asMap().entries.map((entry) {
            int idx = entry.key;
            TextEditingController controller = entry.value;
            return _buildBulletPoint(idx, controller);
          }),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(int index, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: widget.currentTextStyle.color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            maxLines: null,
            controller: controller,
            focusNode: _focusNodes[index],
            style: widget.currentTextStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              widget.onTextChanged(value);
              if (value.endsWith('\n')) {
                controller.text = controller.text.replaceAll('\n', '');
                _addNewBulletPoint();
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
            color: widget.currentTextStyle.color,
          ),
          onPressed: () => _removeBulletPoint(index),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return TextButton.icon(
      icon: Icon(
        Icons.add_circle_outline,
        color: widget.currentTextStyle.color,
      ),
      label: Text(
        'Add bullet point',
        style: widget.currentTextStyle,
      ),
      onPressed: _addNewBulletPoint,
    );
  }
}
