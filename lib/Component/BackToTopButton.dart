import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class back_to_top_button extends StatelessWidget {
  final ScrollController scrollController;

  back_to_top_button({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Visibility(
        visible: scrollController.hasClients && scrollController.offset > 300,
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
    );
  }
}