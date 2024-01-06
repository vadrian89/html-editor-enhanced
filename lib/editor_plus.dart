library editor_plus;

export 'src/plus/editor/html_editor_unsupported.dart'
    if (dart.library.html) 'src/plus/editor/html_editor_web.dart'
    if (dart.library.io) 'src/plus/editor/html_editor_mobile.dart' show HtmlEditor;
export 'src/plus/editor_controller.dart' show HtmlEditorController;
