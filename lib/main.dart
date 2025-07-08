import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi/credentials.dart';
import 'package:wifi/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Center(
                  child: Text(
                    "Shared Preferences isn't loaded, your storage might be full",
                  ),
                );
              } else {
                if (!snapshot.data!.containsKey(usernameKey)) {
                  return GetCredentials();
                }
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
