import 'package:flutter/material.dart';

import 'package:ict_mu_students/Helper/colors.dart';

class AdaptiveLoadingScreen extends StatelessWidget {
  const AdaptiveLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(muColor),
      
          ),
        ),
      ),
    );
  }
}
