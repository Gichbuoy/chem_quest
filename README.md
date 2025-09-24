# Chem_Quest

ChemQuest is a mobile-first educational chemistry game designed to make upper-secondary (ages 14–18) chemistry fun, interactive, and engaging.
Built with Flutter, the app combines bite-sized lessons, mini-games, and progress tracking to reinforce critical chemistry concepts through play.


## 🎯 Educational Goals
ChemQuest addresses a key gap in chemistry education:

- Active Learning – Students learn by doing, not just reading.

- Curriculum Alignment – All formulas, pH data, and stoichiometric calculations follow high-school chemistry standards.

- Engagement – Bright visuals, cat mascots, and a rewarding game loop reduce learning anxiety.

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

## 🛠️ Tech Stack

- Framework: Flutter
 (Dart) for iOS/Android Progressive Web App (PWA)

- State Management: Provider / Riverpod

- Backend: Superbase, REST API for leaderboards and adaptive question banks.

- Data Storage: Local JSON for question banks and answer keys.


## 🚀 Getting Started
Prerequisites

- Flutter SDK
 (v3.0+)

- Dart 2.18+

- Android Studio / VS Code with Flutter extensions

### 🛠️ Installation

```
git clone https://github.com/gichbuoy/chemquest.git
cd chemquest
flutter pub get
flutter run
```

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   │   ├─ onboarding_flow.dart
│   │   ├─ main_dashboard.dart
│   │   ├─ ph_game.dart
│   │   ├─ stoichiometry_quest.dart
│   │   └─ progress_tracking.dart
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```


![Splash Screen](/assets/images/readme-img/Screenshot%20(412).png)


![Dashboard](/assets/images/readme-img/Screenshot%20(413).png)

![Dashboard Cont.](/assets/images/readme-img/Screenshot%20(414).png)

![Games](/assets/images/readme-img/Screenshot%20(415).png)

![PH Indicator Game](/assets/images/readme-img/Screenshot%20(416).png)
![PH Game Completed](/assets/images/readme-img/Screenshot%20(417).png)
![Balance Equations Game](/assets/images/readme-img/Screenshot%20(419).png)


![Progress Tracking](/assets/images/readme-img/Screenshot%20(423).png)




## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```


## 🌟 Tagline
Play → Learn → Practice → Master Chemistry with ChemQuest! 
- For high engagement and knowledge retention.



## 🙏 Acknowledgments
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design

Built with ❤️

