import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

abstract interface class LamodaLocalDataSource {
  void downloadFileWeb(List<int> bytes, String fileName);
}

class LamodaLocalDataSourceImp implements LamodaLocalDataSource{
  @override
  void downloadFileWeb(List<int> bytes, String fileName) {
    // Convert bytes into a Blob blob URL
    final Uint8List uint8List = Uint8List.fromList(bytes);
    final JSArrayBuffer jsBuffer = uint8List.buffer.toJS;
    final JSArray<JSArrayBuffer> blobParts = <JSArrayBuffer>[jsBuffer].toJS;
    final web.Blob blob = web.Blob(blobParts);
    final String url = web.URL.createObjectURL(blob);
    
    // Create an anchor element and simulate a click
    final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName;
    
    anchor.click();
    
    // Clean up memory
    web.URL.revokeObjectURL(url);
  }
}