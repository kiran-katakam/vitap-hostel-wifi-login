
# VIT-AP Hostel WiFi Auto Login

A lightweight Flutter app that **automatically logs you into the VIT-AP hostel WiFi network** (`hfw.vitap.ac.in:8090`) — no browser required.

> 📍 Exclusively for **VIT-AP hostel students** — MH1, MH2, MH3, MH4 only.

---

## 🚀 Features

- 🔐 Auto login to VIT-AP’s captive portal
- 📡 Binds to WiFi before attempting login
- 🧾 Uses a bundled `.crt` certificate for secure HTTPS communication
- 💾 Stores your credentials locally with SharedPreferences
- 🔄 One-tap logout and re-login
- 💡 UI shows login state clearly

---

## 🛠 Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/kiran-katakam/vitap-hostel-wifi-login.git
cd vitap-hostel-wifi-login
```

### 2. Ensure the certificate is added to `assets/`
The required certificate (`ClientAuth_CA.crt`) is already included in the `assets` directory.

### 3. Confirm `pubspec.yaml` includes the asset
```yaml
flutter:
  assets:
    - assets/ClientAuth_CA.crt
```

### 4. Get packages
```bash
flutter pub get
```

### 5. Run the app
```bash
flutter run
```

---

## 🧑‍💻 How It Works

- Connect to the VIT-AP hostel WiFi.
- Open the app — it reads your saved credentials.
- The app binds to the WiFi network via a platform channel.
- It sends a POST request to `https://hfw.vitap.ac.in:8090/login.xml` using a secure HTTPS client pinned with the local `.crt`.

---

## ⚠️ Notes

- 📶 Works only inside VIT-AP campus on the hostel WiFi (MH1–MH4).
- ❓ *It has not been tested on LH (Ladies Hostel) WiFi. If you're from LH and this works for you, please let me know so I can update this app's info.*
- 🔔 After login, Android might still show the **“Sign in to Wi-Fi”** notification. You **must click it once** so the system browser can open and validate the connection. After that, the network will switch to WiFi.
- 🔐 Your credentials are stored **only on your device** using `SharedPreferences`.

---

## 📂 Structure

```
lib/
├── login.dart              # UI logic
├── utils.dart              # Login/logout, cert handling
assets/
└── ClientAuth_CA.crt       # Certificate used to trust the captive portal
```

---

## 🔧 Built With

- Flutter & Dart
- `SharedPreferences`
- `HttpClient` + custom `SecurityContext`
- Platform Channels (for WiFi binding)

---

## ✍ Author

Made with ❤️ for VIT-AP hostelites  
by Kiran Katakam

---

## 📄 License

MIT License
