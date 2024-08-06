import 'package:flutter/material.dart';

class BackToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const BackToTopButton({required this.scrollController});

  @override
  _BackToTopButtonState createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 300) {
        if (!_showButton) {
          setState(() {
            _showButton = true;
          });
        }
      } else {
        if (_showButton) {
          setState(() {
            _showButton = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showButton
        ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  widget.scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward, color: Colors.black),
              ),
            ),
          )
        : Container();
  }
}