import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi/credentials.dart';
import 'package:wifi/hostel_login.dart';
import 'package:wifi/university_login.dart';

final String usernameKey = "username";
final String passwordKey = "password";

final RegExp usernameRegex = RegExp(r'^\d{2}[A-Z]{3}\d{4,5}$');

const platform = MethodChannel('wifi.binding/channel');
Future<bool> bindToWifiNetwork() async {
  try {
    final result = await platform.invokeMethod('bindToWifi');
    return result == true;
  } on PlatformException catch (e) {
    debugPrint("Failed to bind to WiFi: ${e.message}");
    return false;
  }
}

Future<bool> reportNetworkConnectivity() async {
  try {
    final bool result = await platform.invokeMethod(
      'reportNetworkConnectivity',
    );
    debugPrint('Connectivity reported: $result');
    return result;
  } on PlatformException catch (e) {
    debugPrint("Error: ${e.message}");
    return false;
  }
}

Future<http.Client> createSecureHttpClient() async {
  final context = SecurityContext(withTrustedRoots: true);

  final ByteData certData = await rootBundle.load('assets/ClientAuth_CA.crt');
  context.setTrustedCertificatesBytes(certData.buffer.asUint8List());

  final HttpClient httpClient = HttpClient(context: context);
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
        return host == 'hfw.vitap.ac.in';
      };

  return IOClient(httpClient);
}

Future<http.Response> login() async {
  final client = await createSecureHttpClient();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final String username = sharedPreferences.getString(usernameKey)!;
  final String password = sharedPreferences.getString(passwordKey)!;

  try {
    final url = Uri.parse('https://hfw.vitap.ac.in:8090/login.xml');

    final response = await client.post(
      url,
      headers: {
        'accept': '*/*',
        'accept-language': 'en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7',
        'content-type': 'application/x-www-form-urlencoded',
        'sec-ch-ua':
            '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'referer': 'https://hfw.vitap.ac.in:8090/httpclient.html',
      },
      body:
          'mode=191&username=$username&password=$password&a=${DateTime.now().millisecondsSinceEpoch}&producttype=0',
    );

    return response;
  } catch (e) {
    throw Exception("❌ Error during login: $e");
  } finally {
    client.close();
  }
}

Future<http.Response> logout() async {
  final client = await createSecureHttpClient();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final String username = sharedPreferences.getString(usernameKey)!;

  try {
    final url = Uri.parse('https://hfw.vitap.ac.in:8090/logout.xml');

    final response = await client.post(
      url,
      headers: {
        'accept': '*/*',
        'accept-language': 'en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7',
        'content-type': 'application/x-www-form-urlencoded',
        'sec-ch-ua':
            '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'referer': 'https://hfw.vitap.ac.in:8090/httpclient.html',
      },
      body:
          'mode=193&username=$username&a=${DateTime.now().millisecondsSinceEpoch}&producttype=0',
    );

    return response;
  } catch (e) {
    throw Exception("❌ Error during logout: $e");
  } finally {
    client.close();
  }
}

Future<void> saveCredentials(
  String username,
  String password,
  BuildContext context,
) async {
  username = username.toUpperCase().trim();
  password = password.trim();
  if (usernameRegex.hasMatch(username) && password.isNotEmpty) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result =
        await sharedPreferences.setString(usernameKey, username) &&
        await sharedPreferences.setString(passwordKey, password);
    if (result) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HostelLogin(),
          ), //!!!!! WRITE A FUCNTION TO CHANGE THIS ROUTE
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Failed to Store the Details"),
            showCloseIcon: true,
            duration: Durations.extralong4,
          ),
        );
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Invalid username/password"),
        showCloseIcon: true,
        duration: Durations.extralong4,
      ),
    );
  }
}

Future<bool> doWeHaveCredentials() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.containsKey(usernameKey);
}

List<String> loadUsernameList(String username) {
  final List<String> superscripts = [
    "⁰",
    "¹",
    "²",
    "³",
    "⁴",
    "⁵",
    "⁶",
    "⁷",
    "⁸",
    "⁹",
  ];
  final List<String> usernameList = [username];
  var id = usernameList.elementAt(0);

  for (int k = 0; k <= usernameList.length; k++) {
    if (k < usernameList.length) {
      id = usernameList.elementAt(k);
    }
    for (int i = 0; i < id.length; i++) {
      var charid = id.split("");
      if (isNumeric(charid[i])) {
        charid[i] = superscripts[int.parse(charid[i])];
        if (!usernameList.contains(join(charid))) {
          usernameList.add(join(charid));
        }
      }
    }
  }
  return usernameList;
}

bool isNumeric(String s) {
  return int.tryParse(s) != null;
}

String join(List<String> list) {
  String str = "";
  for (int i = 0; i < list.length; i++) {
    str += list[i];
  }
  return str;
}

enum WifiType { hostel, university, none }

Future<WifiType> wifiType() async {
  final info = NetworkInfo();

  while (!await Permission.location.isGranted) {
    if (await Permission.location.request().isGranted) {
      final name = await info.getWifiName();
      if (name == "VIT-AP") {
        return WifiType.university;
      } else {
        return WifiType.hostel;
      }
    }
  }
  return WifiType.none;
}

Future<Widget> mainNavigator() async {
  return FutureBuilder(
    future: bindToWifiNetwork(),
    builder: (context, snapshot1) {
      if (snapshot1.connectionState == ConnectionState.done) {
        return FutureBuilder(
          future: doWeHaveCredentials(),
          builder: (context, snapshot2) {
            if (snapshot2.connectionState == ConnectionState.done) {
              if (snapshot2.hasData) {
                if (snapshot2.data!) {
                  return FutureBuilder(
                    future: wifiType(),
                    builder: (context, snapshot3) {
                      if (snapshot3.connectionState == ConnectionState.done) {
                        if (snapshot3.hasData) {
                          if (snapshot3.data! == WifiType.university) {
                            return UniversityLogin();
                          } else if (snapshot3.data! == WifiType.hostel){
                            return HostelLogin();
                          } else {
                            return scaffoldWithCenteredText("WifiType Returned None");
                          }
                        } else {
                          return scaffoldWithCenteredText(
                            "Error in Network Connectivity Plus",
                          );
                        }
                      }
                      return scaffoldWithCenteredCircularProgressIndicator();
                    },
                  );
                } else {
                  return GetCredentials();
                }
              } else {
                return scaffoldWithCenteredText("Error in Shared Preferences");
              }
            }
            return scaffoldWithCenteredCircularProgressIndicator();
          },
        );
      }
      return scaffoldWithCenteredCircularProgressIndicator();
    },
  );
}

Scaffold scaffoldWithCenteredCircularProgressIndicator() {
  return Scaffold(body: Center(child: CircularProgressIndicator()));
}

Scaffold scaffoldWithCenteredText(String text) {
  return Scaffold(body: Center(child: Text(text)));
}
