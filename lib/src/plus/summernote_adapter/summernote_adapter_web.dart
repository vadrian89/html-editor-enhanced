import 'package:html_editor_plus/src/plus/core/editor_callbacks.dart';
import 'package:html_editor_plus/src/plus/core/editor_event.dart';
import 'package:html_editor_plus/src/plus/core/enums.dart';

import 'summernote_adapter.dart';

class SummernoteAdapterWeb extends SummernoteAdapter {
  @override
  String get platformSpecificJavascript => '''
function handleMessage(e) {
  if (e && e.data && e.data.includes("toIframe")) {
    logDebug("Received toIframe message from parent: " + e.data);
    const data = JSON.parse(e.data);
    const method = data["method"];
    const payload = data["payload"];
    if (data["key"] != $key) {
      logDebug("Ignoring message for view: " + data["key"])
      return;
    }
    if (method == "reload") {
      logDebug("Reloading editor....");
      window.location.reload();
    }
    else if (method == "setHtml") {
      ${javascriptFunction(name: 'setHtml', arg: "payload")}
    }
    else if (method == "setCursorToEnd") {
      ${javascriptFunction(name: 'setCursorToEnd')}
    }
    else if (method == "createLink") {
      ${javascriptFunction(name: 'createLink', arg: "payload")}
    }
    else if (method == "insertImage") {
      ${javascriptFunction(name: 'insertImage', arg: "payload")}
    } 
    else if (method == "toggleCodeView") {
      ${javascriptFunction(name: 'toggleCodeView')}
    }
  }
  else if (e && e.data && e.data.includes("toSummernote")) {
    logDebug("Received toSummernote message from parent: " + e.data);
    const data = JSON.parse(e.data);
    const method = data["method"];
    const payload = data["payload"];
    if (payload) {
      ${callSummernoteMethod(method: 'method', wrapMethod: false, payload: 'payload')}
    } 
    else {
      logDebug("Calling method: " + method);
      if (method == "${const EditorToggleView().method}" && ${resizeMode == ResizeMode.resizeToParent}) {
        resizeToParent();
      }
      ${callSummernoteMethod(method: 'method', wrapMethod: false)}
    }
  }
}

window.parent.addEventListener('message', handleMessage, false);
''';

  SummernoteAdapterWeb({
    required super.key,
    super.summernoteSelector = "\$('#summernote-2')",
    super.hint,
    super.resizeMode = ResizeMode.resizeToParent,
    super.customOptions,
    super.maximumFileSize,
    super.spellCheck,
    super.enableOnBlur = false,
    super.enableOnFocus = false,
    super.enableOnImageUpload = false,
    super.enableOnImageUploadError = false,
    super.enableOnKeyup = false,
    super.enableOnKeydown = false,
    super.enableOnMouseUp = false,
    super.enableOnMouseDown = false,
  });

  @override
  String init() {
    return '''
<script type="text/javascript">
\$(document).ready(function () {
  ${super.init()}
});
</script> 
''';
  }

  @override
  String messageHandler({
    required EditorCallbacks event,
    String? payload,
  }) {
    final effectivePayload = payload ?? "null";
    return 'window.parent.postMessage(JSON.stringify({"key": "$key", "type": "toDart", "method": "$event", "payload": $effectivePayload}), "*");';
  }
}
