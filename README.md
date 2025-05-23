# Daily Dairies 📝

[![Flutter](https://img.shields.io/badge/Flutter-3.19.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3.0-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-10.0.0-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

<div align="center">
  <img src="assets/images/logo.png" alt="Daily Dairies Logo" width="200"/>
  
  A modern, secure, and feature-rich diary application built with Flutter and Firebase.
</div>

## ✨ Features

- 📝 Create and manage daily diary entries
- 🔐 Secure authentication with email/password
- 👆 Biometric authentication support
- 🎨 Customizable themes
- 📱 Cross-platform support (Android & iOS)
- 🔔 Push notifications
- 📸 Media support (images, videos, audio)
- 🌐 Multi-language support
- 🔒 Secure data storage with Firebase
- 📊 Mood tracking and statistics

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode
- Firebase account
- Git

### Installation

### 1. Clone the Repository
```bash
git clone [repository-url]
cd daily-dairies
```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable the following services:
    - Authentication (Email/Password)
    - Cloud Fire-store
    - Cloud Messaging
   - Add your app to Firebase and download configuration files
   - Run Firebase configuration:
     ```bash
     flutterfire configure
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

lib/
├── api/ # API and service integrations
├── controllers/ # GetX controllers
├── core/ # Core utilities and constants
├── models/ # Data models
├── routes/ # App routing
├── screens/ # UI screens
└── main.dart # App entry point
```

## 🔧 Configuration

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project
   - Enable required services

2. **Add Firebase to Your App**
   - Android: Place `google-services.json` in `android/app/`
   - iOS: Place `GoogleService-Info.plist` in `ios/Runner/`

3. **Update Application ID**
   ```gradle
   // android/app/build.gradle
   defaultConfig {
       applicationId "com.company.daily_dairies"
   }
   ```



## 📦 Dependencies

Key packages used in the project:

| Package | Version | Purpose |
|---------|---------|---------|
| firebase_core | ^2.31.0 | Firebase core functionality |
| firebase_auth | ^4.17.6 | Authentication |
| cloud_firestore | ^4.15.7 | Database |
| firebase_messaging | ^14.9.4 | Push notifications |
| get | ^4.6.6 | State management | Localization |
| local_auth | ^2.3.0 | Biometric authentication |

See `pubspec.yaml` for complete list.

The app requires the following permissions:
- Internet access
- Network state
- Fingerprint authentication
- Media access (images/videos)
- Audio recording
- Storage access
- Camera access
- Notifications


## 🤝 Contributing

We would love your input! We want to make contributing to Daily Dairies as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer


We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.


Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

### Any contributions you make will be under the MIT Software License
In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## 📝 License

By contributing, you agree that your contributions will be licensed under its MIT License.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - The framework used
- [Firebase](https://firebase.google.com) - Backend services
- [GetX](https://pub.dev/packages/get) - State management
- All other open-source contributors

## ⭐ Show your support

Give a ⭐️ if this project helped you!
