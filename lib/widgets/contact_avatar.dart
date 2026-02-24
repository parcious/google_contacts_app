import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final String initials;
  final double radius;
  final String? photoUrl;

  const ContactAvatar({
    super.key,
    required this.name,
    required this.initials,
    this.radius = 20,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getAvatarColor(name);

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: color,
        child: null,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
