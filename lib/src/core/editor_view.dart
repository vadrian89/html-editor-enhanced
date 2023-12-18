import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'toolbar.dart';

/// Widget used to display the html editor.
///
/// This should be the base widget for the editor which works with the underlaying dependencies.
/// Platform specific implementation should build on top of this widget.
///
/// This widget is used to display the editor and the toolbar.
/// If the toolbar is not provided, then, the layout specific widgets will not be used, removing
/// extra widgets from the widget tree.
class HtmlEditorView extends StatelessWidget {
  /// {@template HtmlEditorWebView.initialFile}
  /// The initial file to load in the [HtmlEditorView].
  /// {@endtemplate}
  final String? initialFile;

  /// {@template HtmlEditorWebView.height}
  /// The height of the [HtmlEditorView].
  /// {@endtemplate}
  final double? height;

  /// {@template HtmlEditorWebView.width}
  /// The width of the [HtmlEditorView].
  /// {@endtemplate}
  final double? width;

  /// {@template HtmlEditorWebView.decoration}
  /// The decoration to paint behind the [HtmlEditorView].
  /// {@endtemplate}
  final Decoration? decoration;

  /// {@template HtmlEditorWebView.initialOptions}
  /// The initial [InAppWebViewGroupOptions] to be used when creating the WebView.
  /// {@endtemplate}
  final InAppWebViewGroupOptions? initialOptions;

  /// {@template HtmlEditorWebView.initialUserScripts}
  /// The initial list of [UserScript]s to be injected into the WebView.
  /// {@endtemplate}
  final List<UserScript>? initialUserScripts;

  /// {@template HtmlEditorWebView.contextMenu}
  /// Defines the context menu to be displayed.
  /// {@endtemplate}
  final ContextMenu? contextMenu;

  /// {@template HtmlEditorWebView.gestureRecognizers}
  /// The set of gesture recognizers that this web view will be using.
  ///
  /// From [InAppWebView.gestureRecognizers]:
  /// [gestureRecognizers] specifies which gestures should be consumed by the WebView.
  /// It is possible for other gesture recognizers to be competing with the web view on pointer
  /// events, e.g if the web view is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The web view will claim gestures that are recognized by any of the
  /// recognizers on this list.
  /// When [gestureRecognizers] is empty or null, the web view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  ///
  /// {@endtemplate}
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// {@template HtmlEditorWebView.toolbar}
  /// The toolbar widget to be displayed above or below the editor
  /// {@endtemplate}
  final HtmlEditorToolbar? toolbar;

  /// {@template HtmlEditorWebView.onWebViewCreated}
  /// A callback that receives a [InAppWebViewController] when the widget is created.
  ///
  /// This can be used to immediately start loading content.
  /// {@endtemplate}
  final void Function(InAppWebViewController controller)? onWebViewCreated;

  /// {@template HtmlEditorWebView.shouldOverrideUrlLoading}
  /// Give the host application a chance to take control when a URL is about to be loaded in
  /// the current WebView.
  ///
  /// Read more at: https://pub.dev/documentation/flutter_inappwebview/latest/flutter_inappwebview/WebView/shouldOverrideUrlLoading.html
  ///
  /// {@endtemplate}
  final Future<NavigationActionPolicy?> Function(
      InAppWebViewController controller, NavigationAction action)? shouldOverrideUrlLoading;

  /// {@template HtmlEditorWebView.onConsoleMessage}
  /// Called when the WebView receives a [ConsoleMessage].
  /// {@endtemplate}
  final void Function(ConsoleMessage message)? onConsoleMessage;

  /// {@template HtmlEditorWebView.onWindowFocus}
  /// Called when the window of the WebView gains focus.
  /// {@endtemplate}
  final void Function(InAppWebViewController controller)? onWindowFocus;

  /// {@template HtmlEditorWebView.onLoadStop}
  /// Called when web view finished loading;
  /// {@endtemplate}
  final void Function(InAppWebViewController controller, Uri? uri)? onLoadStop;

  const HtmlEditorView({
    super.key,
    this.initialFile,
    this.height,
    this.width,
    this.decoration,
    this.initialOptions,
    this.initialUserScripts,
    this.contextMenu,
    this.gestureRecognizers,
    this.onWebViewCreated,
    this.shouldOverrideUrlLoading,
    this.onConsoleMessage,
    this.onWindowFocus,
    this.onLoadStop,
    this.toolbar,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: decoration,
        child: _child,
      );

  ///
  Widget get _child {
    if (toolbar == null) return _webView;

    return Column(
      children: [
        if (toolbar!.position == ToolbarPosition.above) toolbar!,
        Expanded(child: _webView),
        if (toolbar!.position == ToolbarPosition.bellow) toolbar!,
      ],
    );
  }

  Widget get _webView => InAppWebView(
        initialFile: initialFile,
        onWebViewCreated: onWebViewCreated,
        initialOptions: initialOptions,
        initialUserScripts:
            (initialUserScripts != null) ? UnmodifiableListView(initialUserScripts!) : null,
        contextMenu: contextMenu,
        gestureRecognizers: gestureRecognizers,
        shouldOverrideUrlLoading: shouldOverrideUrlLoading,
        onConsoleMessage: (controller, message) => onConsoleMessage?.call(message),
        onWindowFocus: onWindowFocus,
        onLoadStop: onLoadStop,
      );
}
