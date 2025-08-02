import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // e.g., 3.5
  final int starCount;
  final double starSize;
  final Color filledStarColor;
  final Color emptyStarColor;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.starSize = 24,
    this.filledStarColor = Colors.amber,
    this.emptyStarColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 1; i <= starCount; i++) {
      if (i <= rating.floor()) {
        // Full star
        stars.add(Icon(Icons.star, color: filledStarColor, size: starSize));
      } else if (i - rating <= 0.5 && i - rating > 0) {
        // Half star
        stars.add(ClipRect(
          clipper: _HalfClipper(),
          child: Icon(Icons.star, color: filledStarColor, size: starSize),
        ));
        stars.add(Positioned.fill(
          child: Icon(Icons.star_border, color: emptyStarColor, size: starSize),
        ));
      } else {
        // Empty star
        stars.add(Icon(Icons.star_border, color: emptyStarColor, size: starSize));
      }
    }

    // Because half star is two widgets stacked, rebuild below to fix

    // Better approach: Use Stack and Positioned for half star:
    stars = List.generate(starCount, (index) {
      double starPos = index + 1;
      if (starPos <= rating.floor()) {
        return Icon(Icons.star, color: filledStarColor, size: starSize);
      } else if (starPos - rating <= 0.5 && starPos - rating > 0) {
        return Stack(
          children: [
            Icon(Icons.star_border, color: emptyStarColor, size: starSize),
            ClipRect(
              clipper: _HalfClipper(),
              child: Icon(Icons.star, color: filledStarColor, size: starSize),
            ),
          ],
        );
      } else {
        return Icon(Icons.star_border, color: emptyStarColor, size: starSize);
      }
    });

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, size.width / 2, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
