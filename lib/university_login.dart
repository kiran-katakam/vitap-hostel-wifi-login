import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi/utils.dart';

class UniversityLogin extends StatefulWidget {
  const UniversityLogin({super.key});

  @override
  State<UniversityLogin> createState() => _UniversityLoginState();
}

class _UniversityLoginState extends State<UniversityLogin> {
  late WebViewController controller;
  late SharedPreferences data;
  late List<String> usernames;
  late String password;

  Future<void> getData() async {
    data = await SharedPreferences.getInstance();
    usernames = loadUsernameList(data.getString(usernameKey)!);
    password = data.getString(passwordKey)!;
  }

  @override
  void initState() {
    super.initState();
    getData();
    int i = 1;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            final String jsCode =
                "document.getElementById('ft_un').value = '${usernames[i]}';document.getElementById('ft_pd').value = '$password';document.forms[0].submit();";
            await controller.runJavaScript(jsCode);
            if ((i + 1) > 63) {
              i = 1;
            } else {
              i++;
            }
            await reportNetworkConnectivity();
          },
          onHttpError: (HttpResponseError error) {
            print("HTTP Error: ${error.response}");
          },
          onWebResourceError: (WebResourceError error) {
            print("Resource Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://172.18.10.10:1000/logout?'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: WebViewWidget(controller: controller),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          setState(() {
            controller.reload();
          });
        },
        // backgroundColor: Color.fromRGBO(101, 0, 16, 1),
        // foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        // splashColor: Color.fromRGBO(255, 255, 255, 0.2),
        child: Icon(Icons.refresh_rounded),
      ),
    );
  }
}
