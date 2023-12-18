library html_editor;

export 'package:html_editor_enhanced/utils/callbacks.dart';
export 'package:html_editor_enhanced/utils/plugins.dart';
export 'package:html_editor_enhanced/utils/file_upload_model.dart';
export 'package:html_editor_enhanced/utils/options.dart';
export 'package:html_editor_enhanced/utils/utils.dart' hide setState, intersperse, getRandString;

export 'src/core/toolbar/buttons.dart';
export 'src/core/toolbar.dart';
export 'src/core/controller.dart';
export 'src/editor.dart';

export 'package:html_editor_enhanced/utils/shims/flutter_inappwebview_fake.dart'
    if (dart.library.io) 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Defines the 3 different cases for file insertion failing
enum UploadError { unsupportedFile, exceededMaxSize, jsException }

/// Manages the notification type for a notification displayed at the bottom of
/// the editor
enum NotificationType { info, warning, success, danger, plaintext }

/// Returns the type of file inserted in `onLinkInsertInt
enum InsertFileType { image, audio, video }

/// Sets how the virtual keyboard appears on mobile devices
enum HtmlInputType { decimal, email, numeric, tel, url, text }
