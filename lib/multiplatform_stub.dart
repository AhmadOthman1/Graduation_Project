import 'dart:async';

import 'package:growify/Platform.dart';

Platform getPlatform() {
  throw UnimplementedError('Unsupported');
}
Stream<String> connect(
  String url,
  String type,
  Map<String, dynamic>? headers,
){
  final streamController = StreamController<String>();
  return StreamController<String>().stream;
}