import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlClickableText extends StatelessWidget {
  final String htmlData;
  final String defaultFont;
  final double defaultFontSize;

  const HtmlClickableText({
    super.key,
    required this.htmlData,
    this.defaultFont = 'mu_reg',
    this.defaultFontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    // Replace \r\n, \n, \r with <br> to handle line breaks in HTML
    final processedHtml = htmlData
        .replaceAll(r'\r\n', '')
        .replaceAll(r'\n', '')
        .replaceAll(r'\r', '');

    return SelectableRegion(
      focusNode: FocusNode(),
      selectionControls: materialTextSelectionControls,
      child: Html(
        data: processedHtml,
        style: {
          "*": Style(
            fontSize: FontSize(defaultFontSize),
            fontFamily: defaultFont,
            whiteSpace: WhiteSpace.normal,
          ),
        },
      ),
    );
  }
}
