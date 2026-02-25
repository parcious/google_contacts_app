import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import '../utils/app_colors.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _notesController;
  bool _isSaving = false;
  bool _hasChanges = false;

  bool get isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.contact?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.contact?.lastName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.contact?.phoneNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _companyController = TextEditingController(
      text: widget.contact?.company ?? '',
    );
    _notesController = TextEditingController(text: widget.contact?.notes ?? '');

    // Listen for changes
    for (var controller in [
      _firstNameController,
      _lastNameController,
      _phoneController,
      _emailController,
      _companyController,
      _notesController,
    ]) {
      controller.addListener(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _currentDisplayName {
    String first = _firstNameController.text.trim();
    String last = _lastNameController.text.trim();
    if (first.isEmpty && last.isEmpty) return '';
    return '$first $last'.trim();
  }

  String get _currentInitials {
    String first = _firstNameController.text.trim();
    String last = _lastNameController.text.trim();
    String f = first.isNotEmpty ? first[0].toUpperCase() : '';
    String l = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '$f$l'.trim();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = Provider.of<ContactProvider>(context, listen: false);

    final contact = Contact(
      id: widget.contact?.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      isFavorite: widget.contact?.isFavorite ?? false,
      createdAt: widget.contact?.createdAt,
    );

    bool success;
    if (isEditing) {
      success = await provider.updateContact(contact);
    } else {
      success = await provider.addContact(contact);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Contact updated' : 'Contact saved'),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save contact')));
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit contact' : 'Create contact'),
          actions: [
            TextButton(
              onPressed: _isSaving ? null : _saveContact,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: AppColors.surface,
                  child: Center(
                    child: ListenableBuilder(
                      listenable: Listenable.merge([
                        _firstNameController,
                        _lastNameController,
                      ]),
                      builder: (context, child) {
                        return ContactAvatar(
                          name: _currentDisplayName,
                          initials: _currentInitials.isEmpty
                              ? '+'
                              : _currentInitials,
                          radius: 45,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildFormField(
                        controller: _firstNameController,
                        label: 'First name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if ((value == null || value.trim().isEmpty) &&
                              (_lastNameController.text.trim().isEmpty)) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: _lastNameController,
                        label: 'Last name',
                        icon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: _phoneController,
                        label: 'Phone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a phone number';
                          }
                          final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
                          if (!phoneRegex.hasMatch(value.trim())) {
                            return 'Phone number can only contain digits, +, -, (, )';
                          }
                          if (value
                                  .trim()
                                  .replaceAll(RegExp(r'[^0-9]'), '')
                                  .length <
                              7) {
                            return 'Phone number must have at least 7 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final emailRegex = RegExp(
                              r'^[\w\.-]+@[\w\.-]+\.\w+$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: _companyController,
                        label: 'Company',
                        icon: Icons.business_outlined,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: _notesController,
                        label: 'Notes',
                        icon: Icons.notes_outlined,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
    );
  }
}
