// Conditional export to pick the right implementation per platform
export 'aws_iot_service_io.dart'
    if (dart.library.html) 'aws_iot_service_web.dart';

