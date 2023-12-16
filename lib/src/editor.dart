library editor;

export 'editor/html_editor_unsupported.dart'
    if (dart.library.html) 'editor/html_editor_web.dart'
    if (dart.library.io) 'editor/html_editor_mobile.dart';
