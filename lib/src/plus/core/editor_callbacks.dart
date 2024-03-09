import 'editor_message.dart';

/// The list of callbacks which can be used in the editor.
enum EditorCallbacks implements Comparable<EditorCallbacks> {
  onInit(callback: "onInit"),
  onChange(callback: "onChange", args: ["contents", "\$editable"], payload: "contents"),
  onChangeCodeview(
    callback: "onChangeCodeview",
    args: ["contents", "\$editable"],
    payload: "contents",
  ),
  onFocus(callback: "onFocus"),
  onBlur(callback: "onBlur"),
  onImageUpload(callback: "onImageUpload", args: ["files"]),
  onImageUploadError(callback: "onImageUploadError", args: ["file", "error"]),
  onKeyup(callback: "onKeyup", args: ["e"], payload: "e.keyCode.toString()"),
  onKeydown(callback: "onKeydown", args: ["e"], payload: "e.keyCode.toString()"),
  onMouseUp(callback: "onMouseUp"),
  onMouseDown(callback: "onMouseDown"),
  onUrlPressed(callback: "onUrlPressed"),
  onSelectionChanged(callback: "onSelectionChanged");

  /// The name of the event.
  final String callback;

  /// List of arguments received by the callback.
  final List<String> args;

  /// Payload of the called function.
  final String? payload;

  const EditorCallbacks({required this.callback, this.args = const [], this.payload});

  static EditorCallbacks? fromMessage(EditorMessage message) => find(message.method);

  static EditorCallbacks? find(String name) {
    for (final event in EditorCallbacks.values) {
      if (event.callback == name) return event;
    }
    return null;
  }

  /// Override the compareTo method.
  @override
  int compareTo(EditorCallbacks other) => callback.compareTo(other.callback);

  @override
  String toString() => callback;
}
