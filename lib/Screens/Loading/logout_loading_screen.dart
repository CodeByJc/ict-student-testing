import 'package:flutter/material.dart';

import 'package:ict_mu_students/Helper/colors.dart';

class LogoutLoadingScreen extends StatelessWidget {
  const LogoutLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(muColor),
              ),
              const SizedBox(height: 10,),
              const Text('Logging out...'),

            ],
          ),
        ),
      ),
    );
  }
}
