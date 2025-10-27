# Infinity

A **lightweight Flutter app** that automatically logs you into **VIT‑AP WiFi** — supports both **Hostel** (Sophos/captive portal with pinned certificate) and **University** networks.

> Automatically detects whether you are on University Wi-Fi or Hostel Wi-Fi and switches to the respective login flow.


## Features

* **Automatic login** for Hostel and University Wi-Fi
* Auto-detects WiFi SSID and selects **Hostel** or **University** login flow
* **Hostel**: Certificate pinning & WiFi binding using `ClientAuth_CA.crt`
* **University**: Supports multiple “superscripted” usernames for unlimited login
* Logout functionality for Hostel Wi-Fi
* Credentials are **stored locally on your device**



## Quick Start

```bash
git clone https://github.com/kiran-katakam/vitap-hostel-wifi-login.git
cd vitap-hostel-wifi-login
flutter pub get
flutter run
```

### Ensure the hostel certificate exists in `assets/`:

```yaml
flutter:
  assets:
    - assets/ClientAuth_CA.crt
```



## Usage

1. Connect to **VIT‑AP WiFi** (Hostel or University)
2. Open the app → automatic SSID detection and login

**University Wi-Fi:**

* App logs you in automatically
* Connectivity status will switch to Wi-Fi from mobile data
* No need to logout, unlimited login credentials handled automatically

**Hostel Wi-Fi:**
* Automatic login
* Button to logout manually
* Floating Action Button (FAB) to refresh/login easily



## Project Structure

```bash
lib/
├─ main.dart              # App entry point
├─ credentials.dart       # Screen for entering username/password
├─ utils.dart             # Utility functions, WiFi detection, login/logout
├─ hostel_login.dart      # Hostel login/logout screen
├─ university_login.dart  # University login screen (WebView)
assets/
└─ ClientAuth_CA.crt      # Sophos certificate for Hostel WiFi
```



## Security & Ethics

* Credentials are stored **locally** and **not transmitted to third parties**
* Certificate pinning ensures secure connection for Hostel Wi-Fi
* **Use responsibly** — the app is intended for personal convenience only

---

## License

This project is licensed under the **MIT License** — see [[LICENSE](https://mit-license.org/)] for details.
