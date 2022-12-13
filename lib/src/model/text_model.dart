import 'package:flutter/material.dart';

class TextModel {
  String name;
  TextStyle textStyle;
  double top;
  double left;
  bool isSelected;
  TextAlign textAlign;
  double scale;

  TextModel(
      {required this.name,
      required this.textStyle,
      required this.top,
      required this.isSelected,
      required this.textAlign,
      required this.scale,
      required this.left});

  Map<String, dynamic> toJson() {
    return {
      'text': name,
      'top': top,
      'left': left,
      'scale': scale,
      'textStyle': {
        'font': textStyle.fontFamily,
        'fontStyle': textStyle.fontStyle?.index ?? 0,
        'fontWeight': textStyle.fontWeight?.index ?? 0,
        'fontSize': textStyle.fontSize,
        'height': textStyle.height,
        'letterSpacing': textStyle.letterSpacing,
        'color': textStyle.color?.value ?? '',
        'backgroundColor': textStyle.backgroundColor?.value ?? '',
      },
      'textAlign': textAlign.index
    };
  }
}
