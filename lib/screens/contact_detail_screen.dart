import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../utils/app_colors.dart';
import 'add_edit_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Contact? _contact;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final provider = Provider.of<ContactProvider>(context, listen: false);
    final contact = await provider.getContact(widget.contactId);
    if (mounted) {
      setState(() {
        _contact = contact;
        _isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email app')),
        );
      }
    }
  }

  Future<void> _sendSms(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch messaging app')),
        );
      }
    }
  }

  void _toggleFavorite() async {
    if (_contact == null) return;
    final provider = Provider.of<ContactProvider>(context, listen: false);
    await provider.toggleFavorite(_contact!);
    await _loadContact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _contact!.isFavorite
                ? '${_contact!.displayName} added to favorites'
                : '${_contact!.displayName} removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _editContact() async {
    if (_contact == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactScreen(contact: _contact),
      ),
    );
    if (result == true) {
      await _loadContact();
    }
  }

  void _deleteContact() {
    if (_contact == null) return;
    DeleteConfirmationDialog.show(
      context,
      contactName: _contact!.displayName,
      onConfirm: () async {
        final provider = Provider.of<ContactProvider>(context, listen: false);
        final success = await provider.deleteContact(_contact!.id!);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_contact!.displayName} deleted'),
            ),
          );
          Navigator.pop(context, true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_contact == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Contact not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildActionButtons(),
                const Divider(),
                _buildContactInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.getAvatarColor(_contact!.displayName),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(
            _contact!.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: _contact!.isFavorite ? AppColors.favoriteActive : Colors.white,
          ),
          onPressed: _toggleFavorite,
          tooltip: _contact!.isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: _editContact,
          tooltip: 'Edit contact',
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _deleteContact();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: AppColors.error),
                  SizedBox(width: 12),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.getAvatarColor(_contact!.displayName),
                AppColors.getAvatarColor(_contact!.displayName).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Hero(
                tag: 'avatar_${_contact!.id}',
                child: ContactAvatar(
                  name: _contact!.displayName,
                  initials: _contact!.initials,
                  radius: 50,
                  photoUrl: _contact!.photoUrl,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _contact!.displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              if (_contact!.company != null && _contact!.company!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _contact!.company!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.call_outlined,
            label: 'Call',
            onTap: _contact!.phoneNumber.isNotEmpty
                ? () => _makePhoneCall(_contact!.phoneNumber)
                : null,
          ),
          _ActionButton(
            icon: Icons.message_outlined,
            label: 'Message',
            onTap: _contact!.phoneNumber.isNotEmpty
                ? () => _sendSms(_contact!.phoneNumber)
                : null,
          ),
          _ActionButton(
            icon: Icons.email_outlined,
            label: 'Email',
            onTap: _contact!.email != null && _contact!.email!.isNotEmpty
                ? () => _sendEmail(_contact!.email!)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_contact!.phoneNumber.isNotEmpty)
          _InfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: _contact!.phoneNumber,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.call_outlined, color: AppColors.primary),
                  onPressed: () => _makePhoneCall(_contact!.phoneNumber),
                  tooltip: 'Call',
                ),
                IconButton(
                  icon: const Icon(Icons.message_outlined, color: AppColors.primary),
                  onPressed: () => _sendSms(_contact!.phoneNumber),
                  tooltip: 'Message',
                ),
              ],
            ),
          ),
        if (_contact!.email != null && _contact!.email!.isNotEmpty)
          _InfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _contact!.email!,
            trailing: IconButton(
              icon: const Icon(Icons.email_outlined, color: AppColors.primary),
              onPressed: () => _sendEmail(_contact!.email!),
              tooltip: 'Send email',
            ),
          ),
        if (_contact!.company != null && _contact!.company!.isNotEmpty)
          _InfoTile(
            icon: Icons.business_outlined,
            label: 'Company',
            value: _contact!.company!,
          ),
        if (_contact!.notes != null && _contact!.notes!.isNotEmpty)
          _InfoTile(
            icon: Icons.notes_outlined,
            label: 'Notes',
            value: _contact!.notes!,
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isEnabled ? AppColors.primary : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isEnabled ? AppColors.primary : AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing,
    );
  }
}
