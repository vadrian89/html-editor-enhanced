import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_plus/src/plus/core/editor_callbacks.dart';
import 'package:html_editor_plus/src/plus/core/editor_event.dart';
import 'package:html_editor_plus/src/plus/core/editor_message.dart';
import 'package:html_editor_plus/src/plus/core/editor_upload_error.dart';
import 'package:html_editor_plus/src/plus/core/editor_value.dart';

import '../core/editor_file.dart';
import '../core/enums.dart';
import '../editor_controller.dart';
import '../summernote_adapter/summernote_adapter.dart';

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

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.themeData,
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
  State<HtmlEditorField> createState() => _HtmlEditorFieldState();
}

class _HtmlEditorFieldState extends State<HtmlEditorField> {
  late final String _viewId;
  late final SummernoteAdapter _adapter;
  late final HtmlEditorController _controller;
  late final ValueNotifier<HtmlEditorValue> _currentValueNotifier;
  late final StreamSubscription<EditorEvent> _eventsSubscription;

  late final StreamSubscription<EditorMessage> _messagesSubscription;
  late final Future<void> _initFuture;
  late final html.IFrameElement _iframe;

  ThemeData? _themeData;

  HtmlEditorValue get _currentValue => _currentValueNotifier.value;
  String get _assetsPath => "packages/html_editor_plus/assets";
  String get _filePath => "$_assetsPath/summernote-no-plugins.html";
  String get _jqueryPath => "assets/$_assetsPath/jquery.min.js";
  String get _cssPath => "assets/$_assetsPath/summernote-lite.min.css";
  String get _summernotePath => "assets/$_assetsPath/summernote-lite.min.js";

  Stream<EditorMessage> get _iframeMessagesStream =>
      html.window.onMessage.map((event) => EditorMessage.fromJson(jsonDecode(event.data)));

  @override
  void initState() {
    super.initState();
    _themeData = widget.themeData;
    _viewId = DateTime.now().millisecondsSinceEpoch.toString();
    _adapter = SummernoteAdapter.web(
      key: _viewId,
      resizeMode: widget.resizeMode,
      hint: widget.hint,
      enableOnBlur: widget.onBlur != null,
      enableOnFocus: widget.onFocus != null,
      enableOnImageUpload: widget.onImageUpload != null,
      enableOnImageUploadError: widget.onImageUploadError != null,
      enableOnKeyup: widget.onKeyup != null,
      enableOnKeydown: widget.onKeydown != null,
      enableOnMouseDown: widget.onMouseDown != null,
      enableOnMouseUp: widget.onMouseUp != null,
    );
    _controller = widget.controller;
    _controller.addListener(_controllerListener);
    _currentValueNotifier = ValueNotifier(_controller.clonedValue);
    _eventsSubscription = _controller.events.listen(_parseEvents);
    _messagesSubscription = _iframeMessagesStream.listen(_parseHandlerMessages);
    _iframe = _initIframe();
    _initFuture = _loadSummernote();
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _controller.removeListener(_controllerListener);
    _currentValueNotifier.dispose();
    _messagesSubscription.cancel();
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

  Future<void> _loadSummernote() async {
    final summernoteInit = '''
${_adapter.summernoteInit()}
<style>
${_adapter.css(colorScheme: _themeData?.colorScheme)}
</style>
''';
    final defaultHtml = await rootBundle.loadString(_filePath);
    _iframe.srcdoc = defaultHtml
        .replaceFirst('"jquery.min.js"', '"$_jqueryPath"')
        .replaceFirst('"summernote-lite.min.css"', '"$_cssPath"')
        .replaceFirst('"summernote-lite.min.js"', '"$_summernotePath"')
        .replaceFirst('<!--summernoteScripts-->', summernoteInit);
  }

  void _parseHandlerMessages(EditorMessage message) {
    if (message.type != "toDart") return;
    debugPrint("Received message from iframe: $message");
    return switch (EditorCallbacks.fromMessage(message)) {
      EditorCallbacks.onInit => _onInit(),
      EditorCallbacks.onChange => _onChange(message),
      EditorCallbacks.onChangeCodeview => _onChange(message),
      EditorCallbacks.onFocus => widget.onFocus?.call(),
      EditorCallbacks.onBlur => widget.onBlur?.call(),
      EditorCallbacks.onImageUpload => widget.onImageUpload?.call(
          HtmlEditorFile.fromJson(message.payload!),
        ),
      EditorCallbacks.onImageUploadError => widget.onImageUploadError?.call(
          HtmlEditorUploadError.fromJson(message.payload!),
        ),
      EditorCallbacks.onKeyup => widget.onKeyup?.call(int.parse(message.payload!)),
      EditorCallbacks.onKeydown => widget.onKeydown?.call(int.parse(message.payload!)),
      EditorCallbacks.onMouseDown => widget.onMouseDown?.call(),
      EditorCallbacks.onMouseUp => widget.onMouseUp?.call(),
      _ => debugPrint("Uknown message received from iframe: $message"),
    };
  }

  void _onInit() {
    if (_currentValue.hasValue) _parseEvents(EditorSetHtml(payload: _currentValue.html));
    widget.onInit?.call();
  }

  void _onChange(EditorMessage message) {
    if (message.payload != _currentValue.html) {
      _currentValueNotifier.value = _currentValue.copyWith(html: message.payload);
      _controller.html = message.payload!;
    }
  }

  void _controllerListener() {
    debugPrint("Controller listener called");
    if (_controller.html != _currentValue.html) {
      _parseEvents(EditorSetHtml(payload: _controller.html));
    }
  }

  void _parseEvents(EditorEvent event) async {
    const jsonEncoder = JsonEncoder();
    final message = EditorMessage.fromEvent(
      key: _viewId,
      event: event,
      type: _eventType(event),
    );
    html.window.postMessage(jsonEncoder.convert(message.toJson()), '*');
  }

  String _eventType(EditorEvent event) => switch (event) {
        EditorReload() => "toIframe",
        EditorSetHtml() => "toIframe",
        EditorSetCursorToEnd() => "toIframe",
        EditorCreateLink() => "toIframe",
        EditorInsertImageLink() => "toIframe",
        EditorToggleView() => "toIframe",
        _ => "toSummernote",
      };

  html.IFrameElement _initIframe() {
    final iframe = html.IFrameElement();
    iframe.style.height = "100%";
    iframe.style.width = "100%";
    iframe.style.border = "none";
    iframe.style.overflow = "hidden";
    iframe.style.padding = "0";
    iframe.style.margin = "0";
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) => iframe);
    return iframe;
  }
}
