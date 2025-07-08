import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String usernameKey = "username";
final String passwordKey = "password";

Future<bool> bindToWifiNetwork() async {
  const platform = MethodChannel('wifi.binding/channel');
  try {
    final result = await platform.invokeMethod('bindToWifi');
    return result == true;
  } on PlatformException catch (e) {
    debugPrint("Failed to bind to WiFi: ${e.message}");
    return false;
  }
}

Future<http.Client> createSecureHttpClient() async {
  final context = SecurityContext(withTrustedRoots: true);

  final ByteData certData = await rootBundle.load(
    'assets/cert/ClientAuth_CA.crt',
  );
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
