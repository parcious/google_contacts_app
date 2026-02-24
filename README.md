# 📱 Google Contacts App

A feature-rich Google Contacts clone built with **Flutter** and **SQLite**, featuring Material 3 design, contact management, favorites, search, and calling functionality.

## ✨ Features

| Feature | Description |
|---|---|
| 📋 **View Contacts** | Alphabetically grouped list with colored avatars |
| ➕ **Add Contact** | Create contacts with name, phone, email, company, notes |
| ✏️ **Edit Contact** | Modify any contact detail with form validation |
| 🗑️ **Delete Contact** | Remove contacts with confirmation dialog |
| 👤 **Contact Profile** | Detailed view with gradient header and action buttons |
| 📞 **Call Contact** | Direct calling via phone dialer integration |
| 💬 **Message Contact** | Quick SMS via messaging app |
| 📧 **Email Contact** | Send email via default mail client |
| ⭐ **Favorites** | Mark/unmark contacts as favorites for quick access |
| 🔍 **Search** | Real-time search by name, phone, or email |
| 📱 **Responsive** | Adapts to different screen sizes |

## 🏗️ Architecture

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── contact.dart                   # Contact data model
├── providers/
│   └── contact_provider.dart          # State management (Provider)
├── services/
│   └── database_helper.dart           # SQLite database operations
├── screens/
│   ├── home_screen.dart               # Bottom navigation (Contacts + Favorites)
│   ├── contact_list_screen.dart       # Alphabetical contact list
│   ├── favorites_screen.dart          # Favorites grid view
│   ├── contact_detail_screen.dart     # Contact profile with actions
│   ├── add_edit_contact_screen.dart   # Add/Edit contact form
│   └── search_screen.dart            # Search with real-time results
├── widgets/
│   ├── contact_avatar.dart            # Colored avatar with initials
│   ├── contact_list_tile.dart         # Reusable contact row
│   ├── empty_state_widget.dart        # Empty state placeholder
│   ├── delete_confirmation_dialog.dart # Delete confirmation
│   └── section_header.dart            # Alphabetical section header
└── utils/
    ├── app_theme.dart                 # Material 3 theme configuration
    └── app_colors.dart                # Color constants
```

## 🛠️ Tech Stack

- **Flutter** 3.32+ with Dart 3.8+
- **SQLite** (`sqflite`) — offline-first data storage
- **Provider** — state management
- **url_launcher** — phone call and email integration
- **Google Fonts** — Roboto typography
- **Material 3** — modern Google design system

## 📦 Installation

### Prerequisites
- Flutter SDK 3.10 or later
- Android Studio / VS Code with Flutter extension
- Android emulator or physical device

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/google_contacts_app.git
cd google_contacts_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (for submission)
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## 📸 Screenshots

<!-- Add your screenshots here -->
| Home Screen | Contact Detail | Add Contact | Favorites |
|---|---|---|---|
| ![Home](screenshots/home.png) | ![Detail](screenshots/detail.png) | ![Add](screenshots/add.png) | ![Favorites](screenshots/favorites.png) |

## 🚀 Usage

1. **Add a Contact**: Tap the **+** button on the home screen
2. **View Contact**: Tap any contact in the list to see full details
3. **Edit Contact**: Open a contact and tap the edit icon
4. **Delete Contact**: Open a contact → tap the menu → select Delete
5. **Favorite a Contact**: Tap the ⭐ star icon on any contact
6. **Search Contacts**: Tap the 🔍 search icon in the app bar
7. **Call a Contact**: Open a contact and tap the Call button

## 📄 License

This project is created as part of a Flutter Developer assignment.
