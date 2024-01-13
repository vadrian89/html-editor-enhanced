# Flutter Html Editor Plus
[![pub package](https://img.shields.io/pub/v/html_editor_plus.svg)](https://pub.dev/packages/html_editor_plus)

Flutter HTML Editor Plus is a text editor for Android, iOS, and Web to help write WYSIWYG HTML code with the Summernote JavaScript wrapper.

This is a fork from [html-editor-enhanced](https://github.com/tneotia/html-editor-enhanced). 
A big thanks for [tneotia](https://github.com/tneotia), for keeping the project alive.


I have removed documentation and will updated with the new API in time.  
In the meantime you can read it in the original repo.

Main goals of this package is to:  
- Keep the package updated to latest stable versions of Flutter and dependencies (Summernote editor included).
- Re-write the package in a more readable and maintanable format.
- Improve functionalities.
- Fix known issues.
- Add support for desktop platforms.

## Setup

Platform requirements for:  
**Android:** minSdkVersion >= 19, compileSdk >= 34, AGP version >= 7.3.0  
**iOS 9.0+:** --ios-language swift, Xcode version >= 14.3  
**MacOS 10.11+:** Xcode version >= 14.3  

[Migration guide for InAppWebView](https://inappwebview.dev/docs/migration-guide/)

Add `html_editor_plus: ^0.0.1` as dependency to your pubspec.yaml.

Make sure to declare internet support inside `AndroidManifest.xml`: `<uses-permission android:name="android.permission.INTERNET"/>`

Additional setup is required on iOS to allow the user to pick files from storage. See [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#--ios) for more details. 

For images, the package uses `FileType.image`, for video `FileType.video`, for audio `FileType.audio`, and for any other file `FileType.any`. You can just complete setup for the specific buttons you plan to enable in the editor.

## Basic Usage

```dart
import 'package:html_editor/html_editor.dart';

HtmlEditorController controller = HtmlEditorController();

@override 
Widget build(BuildContext context) {
    return HtmlEditor(
        controller: controller, //required
        htmlEditorOptions: HtmlEditorOptions(
          hint: "Your text here...",
          //initalText: "text content initial, if any",
        ),   
        otherOptions: OtherOptions(
          height: 400,
        ),
    );
}
```

### Important note for Web:

At the moment, there is quite a bit of flickering and repainting when having many UI elements draw over `IframeElement`s. See https://github.com/flutter/flutter/issues/71888 for more details.

The current workaround is to build and/or run your Web app with `flutter run --web-renderer html` and `flutter build web --web-renderer html`.

Follow https://github.com/flutter/flutter/issues/80524 for updates on a potential fix, in the meantime the above solution should resolve the majority of the flickering issues.

## API Reference

For the full API reference, see [here](https://pub.dev/documentation/html_editor_plus/latest/).

For a full example, see [here](https://github.com/vadrian89/html-editor-plus/tree/master/example).

## PLUS version

The PLUS version is the current package re-written using current Flutter version, standard and patterns.  
While some similiarities will remain, most of the API will be different.  

**Keep in mind that the new version is WORK IN PROGRESS. This means that the breaking changes will most likely occur on every release!**

## Some noteable changes in the new API (WIP)

### HtmlEditorController
Is implemented similar to other Flutter controllers, meaning it extends `ValueNotifier` and the value will be stored into a `HtmlEditorValue`.  

Side effects of this change:
- If initialised, the controller, will require manual disposal through `dispose()` method;  
- Listeners can be attached to the controller to react when the value has changed;  
- The value can be used with [ValueListenableBuilder](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html).  
- Some methods have been renamed, and method signatures have changed to use named parameters. 

### Other changes
Features removed:
- Developers will not have access to **InAppWebViewController**, because the editor means to be a common interface for different platforms. As such it makes no sense to expose the controller for mobile. At least not in the current phase.   
- Editor notifications will not be implemented. The editor should be exactly that, a HTML RICH text editor which outputs the text as a HTML string. Notifications should be implemented, separately, through Flutter.  

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contribution Guide

PRs are always welcome


