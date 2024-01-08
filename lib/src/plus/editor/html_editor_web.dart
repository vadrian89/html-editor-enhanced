import 'package:flutter/material.dart';
import 'package:html_editor_plus/core.dart';
import 'package:html_editor_plus/editor_field.dart';

import '../core/editor_file.dart';
import '../core/editor_upload_error.dart';
import '../editor_controller.dart';

/// {@macro HtmlEditor}
///
/// This is used for web.
class HtmlEditor extends StatefulWidget {
  /// {@macro HtmlEditorField.hint}
  final String? hint;

  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController? controller;

  /// {@macro HtmlEditorField.themeData}
  final ThemeData? themeData;

  /// {@macro HtmlEditorField.spellCheck}
  final bool? spellCheck;

  /// {@macro HtmlEditorField.customOptions}
  final List<String>? customOptions;

  /// {@macro HtmlEditorField.onInit}
  final VoidCallback? onInit;

  /// {@macro HtmlEditorField.onFocus}
  final VoidCallback? onFocus;

  /// {@macro HtmlEditorField.onBlur}
  final VoidCallback? onBlur;

  /// {@macro HtmlEditorField.onImageUpload}
  final ValueChanged<HtmlEditorFile>? onImageUpload;

  /// {@macro HtmlEditorField.onImageUploadError}
  final ValueChanged<HtmlEditorUploadError>? onImageUploadError;

  /// {@macro HtmlEditorField.onKeyup}
  final ValueChanged<int>? onKeyup;

  /// {@macro HtmlEditorField.onKeydown}
  final ValueChanged<int>? onKeydown;

  /// {@macro HtmlEditorField.onMouseUp}
  final VoidCallback? onMouseUp;

  /// {@macro HtmlEditorField.onMouseDown}
  final VoidCallback? onMouseDown;

  const HtmlEditor({
    super.key,
    this.resizeMode = ResizeMode.resizeToParent,
    this.controller,
    this.themeData,
    this.spellCheck,
    this.customOptions,
    this.onInit,
    this.onFocus,
    this.onBlur,
    this.onImageUpload,
    this.onImageUploadError,
    this.onKeyup,
    this.onKeydown,
    this.hint,
    this.onMouseUp,
    this.onMouseDown,
  });

  @override
  State<HtmlEditor> createState() => _HtmlEditorState();
}

class _HtmlEditorState extends State<HtmlEditor> {
  late final HtmlEditorController _controller;
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HtmlEditorController();
    _themeData = widget.themeData;
  }

  @override
  void didChangeDependencies() {
    if (widget.themeData == null) _themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlEditorField(
        key: widget.key,
        controller: _controller,
        hint: widget.hint,
        resizeMode: widget.resizeMode,
        themeData: _themeData,
        spellCheck: widget.spellCheck,
        customOptions: widget.customOptions,
        onInit: widget.onInit,
        onFocus: widget.onFocus,
        onBlur: widget.onBlur,
        onImageUpload: widget.onImageUpload,
        onImageUploadError: widget.onImageUploadError,
        onKeyup: widget.onKeyup,
        onKeydown: widget.onKeydown,
        onMouseUp: widget.onMouseUp,
        onMouseDown: widget.onMouseDown,
      );
}
