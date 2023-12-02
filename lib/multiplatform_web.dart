import 'dart:async';
import 'dart:html';

import 'package:growify/Platform.dart';
Platform getPlatform() {
  return Platform.web;
}

Stream<String> connect(
  String url,
  String type,
  Map<String, dynamic>? headers,
) {
  int progress = 0;
  final httpRequest = HttpRequest();
  final streamController = StreamController<String>();
  httpRequest.open(type, url);
  headers?.forEach((key, value) {
    httpRequest.setRequestHeader(key, value.toString());
  });
  httpRequest.addEventListener('progress', (event) {
    final data = httpRequest.responseText!.substring(progress);
    progress += data.length;
    streamController.add(data);
  });
  httpRequest.addEventListener('loadend', (event) {
    httpRequest.abort();
    streamController.close();
  });
  httpRequest.addEventListener('error', (event) {
    streamController.addError(
      httpRequest.responseText ?? httpRequest.status ?? 'err',
    );
  });
  httpRequest.send();
  return streamController.stream;
}