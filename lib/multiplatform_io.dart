
import 'dart:async';

import 'package:growify/Platform.dart';
import 'dart:io' as io;
Platform getPlatform() {
  if (io.Platform.isAndroid) return Platform.android;
  if (io.Platform.isIOS) return Platform.ios;
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