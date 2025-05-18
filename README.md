# Krishna Chatbot

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
A conversational chatbot application built with Flutter, designed to provide an interactive and engaging spiritual experience. The chatbot leverages advanced AI capabilities to answer questions, provide guidance, and assist users in their journey with Krishna.

---

## 🚀 Features

- **AI-Powered Conversations**: Get context-aware, compassionate responses inspired by Krishna's wisdom.
- **Spiritual Theming**: Beautiful, immersive UI with animated backgrounds, glowing effects, and Krishna-inspired art.
- **Personalized Chat History**: All your conversations are securely stored and synced with Firebase.
- **Background Music**: Soothing music plays during chat, with mute/unmute controls.
- **Offline Awareness**: The app detects offline status and shows a Krishna-themed reflective alert, preventing login/signup when disconnected.
- **Animated Typing Indicator**: See when Krishna is "typing" a response.
- **Multi-Script Support**: Krishna's replies are shown in a beautiful handwritten font for English, and in a Devanagari-compatible font (Yatra One) for Sanskrit.
- **Cross-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux.
- **Secure API Key Management**: Uses `.env` for sensitive keys.
- **State Management**: Clean architecture using Provider.

---

## 🖼️ Screenshots

### Welcome Screen
![Welcome Screen](screenshots/welcome_screen.webp)

### Register Screen
![Register Screen](screenshots/register_screen.webp)

### Login Screen
![Login Screen](screenshots/login_screen.webp)

### Chat Interface
![Chat Interface](screenshots/chat_screen.webp)

### Offline Alert
![Offline Alert Screen](screenshots/offline_alert_screen.webp)

---

## 🛠️ Technologies Used

- **Frontend**: [Flutter](https://flutter.dev/) (Dart)
- **Backend**: [Firebase](https://firebase.google.com/) (Authentication, Firestore Database)
- **AI Integration**: [OpenRouter](https://openrouter.ai/) (OpenAI GPT-3.5-Turbo API)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Environment Management**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for API keys and configurations
- **Connectivity**: [connectivity_plus](https://pub.dev/packages/connectivity_plus)
- **Custom Fonts**: [Google Fonts](https://pub.dev/packages/google_fonts) (Great Vibes, Caveat, Yatra One, Poppins, etc.)
- **Audio**: [audioplayers](https://pub.dev/packages/audioplayers) for background music

---

## 📂 Project Structure

```plaintext
krishna_chatbot/
├── lib/                        # Main Flutter application code
│   ├── firebase_options.dart   # Firebase configuration (auto-generated)
│   ├── main.dart               # Entry point of the application
│   ├── theme.dart              # App theme definitions
│   ├── models/                 # Data models
│   │   └── message.dart
│   ├── screens/                # UI screens
│   │   ├── chat_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── welcome_screen.dart
│   ├── services/               # API and backend services
│   │   └── krishna_api.dart
│   └── widgets/                # Reusable UI components
│       ├── chat_input.dart
│       ├── message_bubble.dart
│       └── typing_indicator.dart
├── assets/                     # Static assets (images, icons, music, etc.)
│   ├── app_icon.webp
│   ├── feather.webp
│   ├── flute.webp
│   ├── google_icon.webp
│   ├── krishna_avatar.webp
│   ├── krishna_bg.webp
│   ├── user_avatar.webp
│   └── music/
│       └── soothing.mp3
├── screenshots/          # App screenshots for documentation
├── .env                  # Environment variables (not committed)
│   └── API_KEY=your_api_key_here
├── pubspec.yaml          # Flutter dependencies and asset declarations
├── .gitignore            # Files and folders to ignore in git
└── README.md             # Project documentation
```

---

## 📥 Download & Install

You can try Krishna Chatbot on your Android device by downloading the latest APK from the [Releases](https://github.com/ArindamTripathi619/krishna_chatbot/releases) section.

**How to install:**
1. Go to the [Releases](https://github.com/ArindamTripathi619/krishna_chatbot/releases) page.
2. Download the latest `.apk` file (e.g., `krishna_chatbot-v1.0.0.apk`).
3. Transfer the APK to your Android device if needed.
4. On your device, enable **Install from unknown sources** in Settings > Security.
5. Tap the APK file to install and enjoy the app!

---

## ⚙️ Customization

- **Change App Name:**  
  Edit `android/app/src/main/AndroidManifest.xml` (`android:label`) and `ios/Runner/Info.plist` (`CFBundleDisplayName`).

- **Change App Icon:**  
  Use [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) and update `assets/app_icon.webp`.

- **Change Background Music:**  
  Replace `assets/music/soothing.mp3` with your preferred track and update `pubspec.yaml` if needed.

---

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [OpenAI GPT API](https://platform.openai.com/docs)
- [OpenRouter API](https://openrouter.ai/docs)
- [Google Fonts](https://fonts.google.com/)

---

## 🎵 Music Credits

- Background music: Portions of "Enchanting Flute" by Rakesh Chaurasia are used in `assets/music/soothing.mp3`.
  - [Listen to the original track](https://youtu.be/yRrU0zCUVJg?si=k6URidie4oo6htRJ)
  - All rights belong to the original artist.

---

## 🧑‍💻 Contributing

Contributions are welcome!  
Feel free to open issues or submit pull requests for improvements, bug fixes, or new features.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

Created by [Arindam Tripathi](https://github.com/ArindamTripathi619).  
For any inquiries or suggestions, feel free to reach out!

### Social Links  
[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?&style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/_arindxm/)  [![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?&style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/arindam.tripathi.180/)  [![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/arindam-tripathi-962551349/)  [![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?&style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@arindamtripathi4602)  

---


