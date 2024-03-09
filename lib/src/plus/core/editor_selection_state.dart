import 'dart:convert';
import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

/// The state of the selection in the editor.
class EditorSelectionState extends Equatable {
  // The parent element of the selection
  final String? parentElement;

  // The name of the font of the selection
  final String? fontName;

  // The size of the font of the selection
  final int? fontSize;

  // Whether the selection is bold
  final bool isBold;

  // Whether the selection is italic
  final bool isItalic;

  // Whether the selection is underlined
  final bool isUnderline;

  // Whether the selection is strikethrough
  final bool isStrikethrough;

  // Whether the selection is superscript
  final bool isSuperscript;

  // Whether the selection is subscript
  final bool isSubscript;

  // The foreground color of the selection
  final String? foregroundColor;

  // The background color of the selection
  final String? backgroundColor;

  // Whether the selection is an unordered list
  final bool isUl;

  // Whether the selection is an ordered list
  final bool isOl;

  // The list style of the selection
  final String? listStyle;

  // Whether the selection is aligned to the left
  final bool isAlignLeft;

  // Whether the selection is aligned to the right
  final bool isAlignRight;

  // Whether the selection is centered
  final bool isAlignCenter;

  // Whether the selection is justified
  final bool isAlignJustify;

  // The line height of the selection
  final String? lineHeight;

  // The text direction of the selection
  final TextDirection textDirection;

  @override
  bool? get stringify => true;

  const EditorSelectionState({
    this.parentElement,
    this.fontName,
    this.fontSize,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.isSuperscript = false,
    this.isSubscript = false,
    this.foregroundColor,
    this.backgroundColor,
    this.isUl = false,
    this.isOl = false,
    this.listStyle,
    this.isAlignLeft = false,
    this.isAlignCenter = false,
    this.isAlignRight = false,
    this.isAlignJustify = false,
    this.lineHeight,
    this.textDirection = TextDirection.ltr,
  });

  factory EditorSelectionState.fromEncodedJson(String encodedJson) =>
      EditorSelectionState.fromJson(jsonDecode(encodedJson));

  factory EditorSelectionState.fromJson(Map<String, dynamic> json) => EditorSelectionState(
        parentElement: json['style'],
        fontName: json['fontName'],
        fontSize: int.parse(json['fontSize']),
        isBold: json['isBold'],
        isItalic: json['isItalic'],
        isUnderline: json['isUnderline'],
        isStrikethrough: json['isStrikethrough'],
        isSuperscript: json['isSuperscript'],
        isSubscript: json['isSubscript'],
        foregroundColor: json['foregroundColor'],
        backgroundColor: json['backgroundColor'],
        isUl: json['isUL'],
        isOl: json['isOL'],
        listStyle: json['listStyle'],
        isAlignLeft: json['alignLeft'],
        isAlignCenter: json['alignCenter'],
        isAlignRight: json['alignRight'],
        isAlignJustify: json['alignFull'],
        lineHeight: json['lineHeight'],
        textDirection: json['direction'] == 'rtl' ? TextDirection.rtl : TextDirection.ltr,
      );

  @override
  List<Object?> get props => [
        parentElement,
        fontName,
        fontSize,
        isBold,
        isItalic,
        isUnderline,
        isStrikethrough,
        isSuperscript,
        isSubscript,
        foregroundColor,
        backgroundColor,
        isUl,
        isOl,
        listStyle,
        isAlignLeft,
        isAlignCenter,
        isAlignRight,
        isAlignJustify,
        lineHeight,
        textDirection,
      ];
}
