import 'dart:async';

import 'package:flutter/material.dart';
import 'package:html_editor_plus/src/plus/core/editor_event.dart';
import 'package:html_editor_plus/src/plus/core/editor_upload_error.dart';
import 'package:html_editor_plus/src/plus/summernote_adapter/summernote_adapter_web.dart';

import '../core/editor_file.dart';
import '../core/enums.dart';
import '../editor_controller.dart';

/// {@macro HtmlEditorField}
///
/// This is used for web.
class HtmlEditorField extends StatefulWidget {
  /// {@macro HtmlEditorField.hint}
  final String? hint;

  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController controller;

  /// {@macro HtmlEditorField.themeData}
  final ThemeData? themeData;

  /// {@macro HtmlEditorField.maximumFileSize}
  final int? maximumFileSize;

  /// {@macro HtmlEditorField.spellCheck}
  final bool? spellCheck;

  /// {@macro HtmlEditorField.customOptions}
  final List<String>? customOptions;

  /// {@macro HtmlEditorField.allowUrlLoading}
  final Future<bool> Function(Uri? uri)? allowUrlLoading;

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

  /// {@macro HtmlEditorField.onChange}
  final ValueChanged<String>? onChange;

  /// {@macro HtmlEditorField.onUrlPressed}
  final ValueChanged<String>? onUrlPressed;

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.themeData,
    this.maximumFileSize,
    this.spellCheck,
    this.customOptions,
    this.allowUrlLoading,
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
    this.onChange,
    this.onUrlPressed,
  });

  @override
  State<HtmlEditorField> createState() => _HtmlEditorFieldState();
}

class _HtmlEditorFieldState extends State<HtmlEditorField> {
  late final SummernoteAdapterWeb _adapter;
  late final HtmlEditorController _controller;
  late final StreamSubscription<EditorEvent> _eventsSubscription;

  late final Future<void> _initFuture;

  String get _viewId => _adapter.key;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _adapter = SummernoteAdapterWeb(
      key: DateTime.now().millisecondsSinceEpoch.toString(),
      initialValue: _controller.clonedValue,
      allowUrlLoading: widget.allowUrlLoading,
      resizeMode: widget.resizeMode,
      hint: widget.hint,
      customOptions: widget.customOptions ?? const [],
      spellCheck: widget.spellCheck ?? false,
      maximumFileSize: widget.maximumFileSize ?? 10485760,
      onInit: widget.onInit,
      onFocus: widget.onFocus,
      onBlur: widget.onBlur,
      onImageUpload: widget.onImageUpload,
      onImageUploadError: widget.onImageUploadError,
      onKeyup: widget.onKeyup,
      onKeydown: widget.onKeydown,
      onMouseUp: widget.onMouseUp,
      onMouseDown: widget.onMouseDown,
      onChange: _onChange,
      onUrlPressed: widget.onUrlPressed,
    );
    _eventsSubscription = _controller.events.listen(_adapter.handleEvent);
    _initFuture = _adapter.loadSummernote(colorScheme: widget.themeData?.colorScheme);
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _controller.removeListener(_controllerListener);
    _adapter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        key: ValueKey("webview_key_$_viewId"),
        future: _initFuture,
        builder: (context, snapshot) => switch (snapshot.connectionState) {
          ConnectionState.done => Directionality(
              textDirection: TextDirection.ltr,
              child: HtmlElementView(viewType: _viewId),
            ),
          _ => const SizedBox.shrink(),
        },
      );

  void _onChange(String value) {
    _controller.html = value;
    widget.onChange?.call(value);
  }

  void _controllerListener() {
    debugPrint("Controller listener called");
    if (_controller.value != _adapter.currentValue) {
      _adapter.handleEvent(EditorSetHtml(payload: _controller.html));
    }
  }
}
