import 'package:flutter/material.dart';
import 'package:wifi/utils.dart';

class GetCredentials extends StatefulWidget {
  const GetCredentials({super.key});

  @override
  State<GetCredentials> createState() => _GetCredentialsState();
}

class _GetCredentialsState extends State<GetCredentials> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Save Your Credentials")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) async {
                await saveCredentials(
                  _usernameController.text,
                  _passwordController.text,
                  context,
                );
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await saveCredentials(
                  _usernameController.text,
                  _passwordController.text,
                  context,
                );
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
