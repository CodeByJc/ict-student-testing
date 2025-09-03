import 'package:flutter/material.dart';

class MuLoadingScreen extends StatelessWidget {
  const MuLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.black45),
          child: Image.asset(
            'assets/gifs/loading.gif',
            scale: 1.25,
          ),
        ),
      ),
    );
  }
}
