import 'dart:async'; // Import the timer package
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:project_1_btl/utils/constants.dart';

class MyBanner extends StatefulWidget {
  final PageController pageController;
  final Size size;

  const MyBanner({
    required this.pageController,
    required this.size,
    super.key,
  });

  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  List<Widget> _banners = [
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/banner1.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/banner2.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/banner3.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ];

  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set up the timer to change the page every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // Loop back to the first banner
      }
      widget.pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height * 0.2,
      child: Stack(
        children: [
          PageView(
            controller: widget.pageController,
            children: _banners,
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: widget.pageController,
                count: _banners.length,
                effect: WormEffect(
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  activeDotColor: ColorApp.whiteColor,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateBanners(List<Widget> newBanners) {
    setState(() {
      _banners = newBanners;
    });
  }
}
