import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_plus/src/plus/core/editor_upload_error.dart';

import '../core/editor_file.dart';
import '../core/enums.dart';
import '../editor_controller.dart';

/// {@template HtmlEditorField}
/// The widget representing the editor's text field where the user can insert the text.
/// {@endtemplate}
///
/// This is used for unsupported platforms.
class HtmlEditorField extends StatelessWidget {
  /// {@template HtmlEditorField.hint}
  /// The hint to display when the editor is empty.
  ///
  /// Should be a description of the expected input.
  ///
  /// Can be either plain text or html.
  /// {@endtemplate}
  final String? hint;

  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@template HtmlEditorField.controller}
  /// The controller for the HTML editor.
  ///
  /// Provide a controller if you want to control the HTML editor programmatically.
  ///
  /// If you are using [HtmlEditorField] directly, you are `required` to provide a controller.
  /// {@endtemplate}
  final HtmlEditorController controller;

  /// {@template HtmlEditorField.themeData}
  /// Theme data used by the editor.
  ///
  /// It's used to set the colors for background/foreground elements of the editor.
  /// It uses [Colorscheme.surface] to set the background color of the editor.
  /// It uses [Colorscheme.onSurface] to set the foreground color of the editor.
  /// It uses [Colorscheme.surfaceVariant] to set the background color for other elements,
  /// such as buttons/toolbar/etc.
  ///
  /// More in-depth customization will be available in the future.
  /// {@endtemplate}
  final ThemeData? themeData;

  /// {@template HtmlEditorField.inAppWebViewSettings}
  /// The initial options for the [InAppWebViewSettings] used only on mobile platforms.
  ///
  /// If not specified, these default options are used:
  /// ```dart
  /// InAppWebViewSettings(
  ///   javaScriptEnabled: true,
  ///   transparentBackground: true,
  ///   useHybridComposition: true,
  ///   useShouldOverrideUrlLoading: true,
  ///   loadWithOverviewMode: true,
  /// );
  /// ```
  /// {@endtemplate}
  final InAppWebViewSettings? inAppWebViewSettings;

  /// {@template HtmlEditorField.onInit}
  /// Callback to be called when the editor is initialized.
  /// {@endtemplate}
  final VoidCallback? onInit;

  /// {@template HtmlEditorField.onFocus}
  /// Callback to be called when the editor gains focus.
  /// {@endtemplate}
  final VoidCallback? onFocus;

  /// {@template HtmlEditorField.onBlur}
  /// Callback to be called when the editor loses focus.
  /// {@endtemplate}
  final VoidCallback? onBlur;

  /// {@template HtmlEditorField.onImageUpload}
  /// Callback to be called when the user inserts an image.
  /// {@endtemplate}
  final ValueChanged<HtmlEditorFile>? onImageUpload;

  /// {@template HtmlEditorField.onImageUploadError}
  /// Callback to be called when an error occurs while uploading an image.
  /// {@endtemplate}
  final ValueChanged<HtmlEditorUploadError>? onImageUploadError;

  /// {@template HtmlEditorField.onKeyup}
  /// Callback to be called when a key is released.
  /// {@endtemplate}
  final ValueChanged<int>? onKeyup;

  /// {@template HtmlEditorField.onKeydown}
  /// Callback to be called when a key is pressed.
  /// {@endtemplate}
  final ValueChanged<int>? onKeydown;

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.themeData,
    this.inAppWebViewSettings,
    this.onInit,
    this.onFocus,
    this.onBlur,
    this.onImageUpload,
    this.onImageUploadError,
    this.onKeyup,
    this.onKeydown,
    this.hint,
  });

  @override
  Widget build(BuildContext context) => const Center(
        child: Text("Unsupported in this environment"),
      );
}
