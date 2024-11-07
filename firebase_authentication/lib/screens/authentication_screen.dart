import 'package:flutter/material.dart';
import '../widgets/register_widget.dart';
import '../widgets/sign_in_widget.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RegisterWidget(),
            SignInWidget(),
          ],
        ),
      ),
    );
  }
}
