
import 'package:flutter/material.dart';

class thumbnail_list extends StatelessWidget {
  final List<String> thumbnails;
  final Function(String) onThumbnailSelected;

  thumbnail_list({required this.thumbnails, required this.onThumbnailSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: thumbnails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onThumbnailSelected(thumbnails[index]),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              child: Image.network(
                thumbnails[index],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
