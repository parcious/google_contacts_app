import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import '../widgets/empty_state_widget.dart';
import '../utils/app_colors.dart';
import 'contact_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.favorites.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.star_outline_rounded,
            title: 'No favorites yet',
            subtitle: 'Mark contacts as favorites and they\'ll appear here for quick access',
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadContacts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final contact = provider.favorites[index];
              return _FavoriteCard(
                contact: contact,
                onTap: () => _navigateToDetail(context, contact),
                onUnfavorite: () => provider.toggleFavorite(contact),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contactId: contact.id!),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  const _FavoriteCard({
    required this.contact,
    required this.onTap,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onUnfavorite,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ContactAvatar(
                  name: contact.displayName,
                  initials: contact.initials,
                  radius: 28,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: AppColors.favoriteActive,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                contact.displayName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
