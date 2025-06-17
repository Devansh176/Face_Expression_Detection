# 👁️‍🗨️ Face Detection App

A real-time facial expression detection app built using **Flutter**, **Teachable Machine**, and **TensorFlow Lite**. This app uses the device camera to detect facial expressions and classify them using a pre-trained TFLite model.

---

## 📁 Project Structure

```
.
├── android/                     # Android-specific code
├── ios/                         # iOS-specific code
├── linux/                       # Linux support (if needed)
├── macos/                       # macOS support (if needed)
├── windows/                     # Windows support (if needed)
├── web/                         # Web support (optional)
├── lib/
│   ├── home.dart                # UI and detection logic
│   └── main.dart                # App entry point
├── assets/
│   ├── labels.txt               # Labels for classification
│   └── model_unquant.tflite     # Exported TFLite model
├── test/                        # Unit tests
├── pubspec.yaml                # Project dependencies
├── pubspec.lock
├── analysis_options.yaml       # Linter configuration
├── .metadata
├── .gitignore
└── README.md
```

---

## 🧠 Features

- ✅ Real-time face detection via camera
- 🔄 Live classification using a custom Teachable Machine model
- 🔌 Works fully offline
- 📦 Integrates `tflite_flutter` for on-device inference
- 🧪 Lightweight and fast, perfect for mobile devices

---

## 🛠️ Getting Started

### 📦 Prerequisites

- Flutter installed
- Android/iOS physical device or emulator
- Teachable Machine exported model (`.tflite` + `labels.txt`)

### 🔧 Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/Devansh176/Face_Expression_Detection.git
cd face_detection_flutter

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

Make sure your model and labels are placed inside the `assets/` directory and declared in `pubspec.yaml`.

---

## 📂 Model Integration

The model was trained using [Teachable Machine](https://teachablemachine.withgoogle.com/):

1. Export as TensorFlow Lite → "Image Project" → `.tflite` + `labels.txt`
2. Place both files into `assets/`
3. Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/model_unquant.tflite
    - assets/labels.txt
```

---

## 🔐 Permissions

Make sure the following permissions are enabled in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

---

## 🧰 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.0
  camera: ^0.10.0
  path_provider: ^2.0.0
```

---

## 👨‍💻 Author

**Devansh Dhopte**  
Built during experimentation with edge-based AI and Flutter for real-time face and expression detection.

---

> _"Harnessing on-device machine learning for real-time, offline facial expression recognition using Flutter and Teachable Machine."_
