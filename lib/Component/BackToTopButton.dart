import 'package:flutter/material.dart';

class BackToTopButton extends StatelessWidget {
  final ScrollController scrollController;

  const BackToTopButton({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: scrollController.hasClients && scrollController.offset > 300,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }
}
