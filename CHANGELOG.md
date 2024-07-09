## [0.0.5] = 2024-07-09
* Updated dependencies for Flutter 3.22.x
* Fixed issues after dependencies update
* Updated example gradle requirements
## [0.0.4] = 2024-03-09
* Added onChange callback.
* Fixed issue with Summernote icons not loading.
* Added allowUrlLoading field to plus version.
* Added onUrlPressed callback to plus version.
* Updated adapter to follow more closely the pattern.  
* Created JsBuilder class to build javascript code used to initialise and manage Summernote editor.  
* Added jsInitBuilder to HtmlEditor/HtmlEditorField to allow developers to add their own JavaScript code.  
* Created CssBuilder class to build theme-based CSS for the Summernote editor.  
* Added cssBuilder to HtmlEditor/HtmlEditorField to allow developers to add their own CSS styles.  
* Made the controller optional, it will be initialised inside the field if is not provided.  
* Added EditorSelectionState which holds the state of the selected text.  

## [0.0.3] = 2024-01-12
* Fixed exception with scrollbar on web.
* Added more features, from original editor, to plus version.
* Renamed platform specific files from mobile/web to io/html to better represent when they are actually imported.
* Updated README.

## [0.0.2] = 2024-01-04
* Updated changelog.
* Added platform requirements and InAppWebView migration guide.

## [0.0.1] = 2024-01-04

* Initial release for the package.
* Raised Dart SDK requirement to >=3.0.1 <4.0.0".
* Updated linter rules.
* Upgraded dependencies.
* Fixed linter issues.
* Updated example to work with new changes.
* WIP: new html editor based on the current implementation.
* Created new example for new WIP editor.
* Moved assets directory from inside lib, to root directory.
