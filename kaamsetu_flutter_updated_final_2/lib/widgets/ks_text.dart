import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../core/i18n.dart';

class KsText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const KsText(this.text, {super.key, this.style, this.textAlign, this.overflow, this.maxLines});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppProvider>().lang;
    final translated = tr(lang, text);
    final displayText = translated == text ? text : translated;
    
    return Text(
      displayText,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
