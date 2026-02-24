import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../utils/app_colors.dart';
import 'contact_avatar.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;

  const ContactListTile({
    super.key,
    required this.contact,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ContactAvatar(
        name: contact.displayName,
        initials: contact.initials,
      ),
      title: Text(
        contact.displayName,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      subtitle: contact.phoneNumber.isNotEmpty
          ? Text(
              contact.phoneNumber,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            )
          : null,
      trailing: IconButton(
        icon: Icon(
          contact.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
          color: contact.isFavorite
              ? AppColors.favoriteActive
              : AppColors.favoriteInactive,
        ),
        onPressed: onFavoriteToggle,
        tooltip: contact.isFavorite ? 'Remove from favorites' : 'Add to favorites',
      ),
      onTap: onTap,
    );
  }
}
