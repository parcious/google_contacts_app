import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import '../widgets/contact_list_tile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/section_header.dart';
import 'contact_detail_screen.dart';
import 'add_edit_contact_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.contacts.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.contacts_outlined,
            title: 'No contacts yet',
            subtitle: 'Tap the + button to add your first contact',
            action: FilledButton.icon(
              onPressed: () => _navigateToAddContact(context),
              icon: const Icon(Icons.add),
              label: const Text('Add contact'),
            ),
          );
        }

        final grouped = provider.groupedContacts;

        return RefreshIndicator(
          onRefresh: () => provider.loadContacts(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _calculateItemCount(grouped),
            itemBuilder: (context, index) {
              return _buildItem(context, index, grouped, provider);
            },
          ),
        );
      },
    );
  }

  int _calculateItemCount(Map<String, List<Contact>> grouped) {
    int count = 0;
    for (var entry in grouped.entries) {
      count += 1; // header
      count += entry.value.length; // contacts
    }
    return count;
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Map<String, List<Contact>> grouped,
    ContactProvider provider,
  ) {
    int current = 0;
    for (var entry in grouped.entries) {
      if (index == current) {
        return SectionHeader(letter: entry.key);
      }
      current++;

      for (var contact in entry.value) {
        if (index == current) {
          return ContactListTile(
            contact: contact,
            onTap: () => _navigateToDetail(context, contact),
            onFavoriteToggle: () => provider.toggleFavorite(contact),
          );
        }
        current++;
      }
    }
    return const SizedBox.shrink();
  }

  void _navigateToDetail(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contactId: contact.id!),
      ),
    );
  }

  void _navigateToAddContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditContactScreen(),
      ),
    );
  }
}
