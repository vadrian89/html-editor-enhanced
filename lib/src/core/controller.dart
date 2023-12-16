library html_editor_controller;

export 'controller/html_editor_controller_unsupported.dart'
    if (dart.library.html) 'controller/html_editor_controller_web.dart'
    if (dart.library.io) 'controller/html_editor_controller_mobile.dart';
