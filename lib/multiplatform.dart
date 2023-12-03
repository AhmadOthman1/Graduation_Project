export 'multiplatform_stub.dart'

if (dart.library.io) 'multiplatform_io.dart'
if (dart.library.html) 'multiplatform_web.dart';