import 'dart:async';
import 'package:flutter/material.dart';

class panel_home extends StatefulWidget {
  const panel_home({super.key});

  @override
  State<panel_home> createState() => _panel_homeState();
}

class _panel_homeState extends State<panel_home> {
  late PageController _pageController;
  late List<String> _ads;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _ads = [
      'https://file.hstatic.net/1000230642/file/banner_1600x400_2_8d837cee8ea9449eb81de3d50eea89bb.jpg',
      'https://file.hstatic.net/1000230642/file/1921x750_6127fe8c262b47608c461ea23fcca2ab_master.jpg',
      'https://file.hstatic.net/1000230642/file/bitis_web_banner_litedash_master.png',
    ]; // Replace with actual ad image URLs
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    Future.delayed(Duration(seconds: 2), () {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int pageIndex) {
    _pauseAutoScroll();
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) {
      _resumeAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width, 
      
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: null, // Infinite scroll
            itemBuilder: (context, index) {
              final realIndex = index % _ads.length;
              return GestureDetector(
                onTap: () {
                  print('Ad tapped: ${_ads[realIndex]}');
                },
                child: Image.network(
                 
                  _ads[realIndex],
                  fit: BoxFit.cover,
                ),
              );
            },
            onPageChanged: (index) {
              // No special action needed when page changes
            },
          ),
          Positioned(
            left: 10,
            top: 50,
            bottom: 50,
            child: IconButton(

              icon: Icon(Icons.arrow_left, color: Color.fromARGB(255, 151, 148, 148), size: 30),
              onPressed: () {
                _pauseAutoScroll();
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ).then((_) {
                  _resumeAutoScroll();
                });
              },
            ),
          ),
          Positioned(
            right: 10,
            top: 50,
            bottom: 50,
            child: IconButton(
              icon: Icon(Icons.arrow_right, color: Color.fromARGB(255, 151, 148, 148), size: 30),
              onPressed: () {
                _pauseAutoScroll();
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ).then((_) {
                  _resumeAutoScroll();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
