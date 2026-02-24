import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/database_helper.dart';

class ContactProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Contact> _contacts = [];
  List<Contact> _favorites = [];
  List<Contact> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Contact> get contacts => _contacts;
  List<Contact> get favorites => _favorites;
  List<Contact> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int get contactCount => _contacts.length;
  int get favoriteCount => _favorites.length;

  // Grouped contacts by first letter
  Map<String, List<Contact>> get groupedContacts {
    Map<String, List<Contact>> grouped = {};
    for (var contact in _contacts) {
      String key = contact.sortKey;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(contact);
    }
    // Sort the keys
    var sortedKeys = grouped.keys.toList()..sort();
    Map<String, List<Contact>> sorted = {};
    for (var key in sortedKeys) {
      sorted[key] = grouped[key]!;
    }
    return sorted;
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _contacts = await _dbHelper.getContacts();
      _favorites = await _dbHelper.getFavorites();
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Contact?> getContact(int id) async {
    return await _dbHelper.getContact(id);
  }

  Future<bool> addContact(Contact contact) async {
    try {
      await _dbHelper.insertContact(contact);
      await loadContacts();
      return true;
    } catch (e) {
      debugPrint('Error adding contact: $e');
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      await _dbHelper.updateContact(contact);
      await loadContacts();
      return true;
    } catch (e) {
      debugPrint('Error updating contact: $e');
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      await _dbHelper.deleteContact(id);
      await loadContacts();
      return true;
    } catch (e) {
      debugPrint('Error deleting contact: $e');
      return false;
    }
  }

  Future<void> toggleFavorite(Contact contact) async {
    try {
      await _dbHelper.toggleFavorite(contact.id!, !contact.isFavorite);
      await loadContacts();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> searchContacts(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _dbHelper.searchContacts(query);
    } catch (e) {
      debugPrint('Error searching contacts: $e');
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}
