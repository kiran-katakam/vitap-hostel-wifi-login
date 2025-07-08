import 'package:flutter/material.dart';
import 'package:wifi/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool isLogginIn;
  @override
  void initState() {
    super.initState();
    isLogginIn = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: double.infinity),
          FutureBuilder(
            future: isLogginIn ? login() : logout(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Something Went Wriong\n${snapshot.error}", textAlign: TextAlign.center,);
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.body.contains("Limit Reached")) {
                    return Text("Logged In in Another Device");
                  } else if (snapshot.data!.body.contains(
                    "You are signed in as",
                  )) {
                    return Column(
                      children: [
                        Text("You are Logged In"),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLogginIn = false;
                            });
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  } else if (snapshot.data!.body.contains("signed out")) {
                    return Column(
                      children: [
                        Text("You are Logged Out"),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLogginIn = true;
                            });
                          },
                          child: Text("Login"),
                        ),
                      ],
                    );
                  }
                } else {
                  return Text(
                    "Something Went Wrong\nReport the issue in Github please",
                    textAlign: TextAlign.center,
                  );
                }
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              isLogginIn = true;
            });
          },
          
          child: Icon(Icons.refresh_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
