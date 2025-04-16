import 'package:flutter/material.dart';

class BulletPointWidget extends StatelessWidget {
  final List<String> bulletPoints;
  final TextEditingController bulletPointController;
  final Function() onAddBulletPoint;
  final Function(int) onRemoveBulletPoint;
  final TextStyle currentTextStyle;

  const BulletPointWidget({
    Key? key,
    required this.bulletPoints,
    required this.bulletPointController,
    required this.onAddBulletPoint,
    required this.onRemoveBulletPoint,
    required this.currentTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bullet Point Input Field
        TextField(
          controller: bulletPointController,
          decoration: InputDecoration(
            hintText: "Type a bullet point",
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                onAddBulletPoint(); // Call the function to add bullet point
              },
            ),
          ),
          onSubmitted: (_) => onAddBulletPoint(), // Call add method on submit
        ),
        const SizedBox(height: 10),
        // Display existing bullet points
        if (bulletPoints.isNotEmpty) ...[
          ...bulletPoints.map((point) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ',
                      style: TextStyle(fontSize: 16)), // Bullet point icon
                  Expanded(
                    child: Text(
                      point,
                      style: currentTextStyle, // Use the passed text style
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onRemoveBulletPoint(
                        bulletPoints.indexOf(point)), // Remove bullet point
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }
}
