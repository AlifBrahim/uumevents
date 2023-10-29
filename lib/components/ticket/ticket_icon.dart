import 'package:flutter/material.dart';
class CustomTicketShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height / 2 - 20)
      ..quadraticBezierTo(
          size.width * 0.10, size.height / 2, 0, size.height / 2 + 20)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height / 2 + 20)
      ..quadraticBezierTo(
          size.width * 0.90, size.height / 2, size.width, size.height / 2 - 20)
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
class TicketIcon extends StatelessWidget {
  const TicketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 24,
          width: 24,
          color: Colors.black,
        ),
        Positioned(
            left: -5,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
            )
        ),
        Positioned(
            right: -5,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
            )
        ),
      ],
    );
  }
}

