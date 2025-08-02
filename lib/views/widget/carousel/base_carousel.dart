import 'package:flutter/material.dart';

class BaseCarousel extends StatefulWidget {
  final List<Widget> items;
  final double viewportFraction;
  final double height;

  const BaseCarousel({
    super.key,
    required this.items,
    this.viewportFraction = 0.9,
    this.height = 200,
  });

  @override
  State<BaseCarousel> createState() => _BaseCarouselState();
}

class _BaseCarouselState extends State<BaseCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blueAccent : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              itemBuilder: (context, index) => widget.items[index],
            ),
          ),
          const SizedBox(height: 12),
          _buildDots(),
        ],
      ),
    );
  }
}
