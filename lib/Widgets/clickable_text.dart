import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Widget ClickableText(String text) {
  final RegExp linkRegExp = RegExp(
    r'(https?:\/\/[^\s]+)',
    caseSensitive: false,
  );

  final List<InlineSpan> spans = [];
  final matches = linkRegExp.allMatches(text);

  int lastMatchEnd = 0;

  for (final match in matches) {
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd, match.start),
        style: const TextStyle(color: Colors.black),
      ));
    }

    final url = match.group(0)!;

    spans.add(TextSpan(
      text: url,
      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          ArtSweetAlert.show(
            context: Get.overlayContext!,
            artDialogArgs: ArtDialogArgs(
              showCancelBtn: true,
              cancelButtonColor: Colors.red,
              type: ArtSweetAlertType.question,
              title: "Open Link?",
              text: "Do you want to open this link in your browser?\n\n$url",
              confirmButtonText: "Yes",
              cancelButtonText: "No",
              confirmButtonColor: Colors.blue,
              onConfirm: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar("Error", "Could not launch URL");
                }
              },
            ),
          );
        },
    ));

    lastMatchEnd = match.end;
  }

  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastMatchEnd),
      style: const TextStyle(color: Colors.black),
    ));
  }

  return RichText(
    text: TextSpan(
      children: spans,
      style: const TextStyle(fontFamily: "mu_reg", fontSize: 16),
    ),
  );
}
