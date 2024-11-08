import 'dart:io';
import 'package:cronet_http/cronet_http.dart';
// cronet یک شبکه است که با برنامه های اندروید امکان می دهد که از Chromium استفاده کنند
import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';


const _maxCacheSize = 2 * 1024 * 1024;
// یک عدد ثاب معادل دو مگابایت


Client httpClient() {
// اگر سیستم عامل انروید بود
  if (Platform.isAndroid) {
// یک موتور cronet می سازد
    WidgetsFlutterBinding.ensureInitialized();
    final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: _maxCacheSize,
        userAgent: 'Book Agent');
    return CronetClient.fromCronetEngine(engine);
  }
// اگر سیستم عامل Mac یا ios بود
  if (Platform.isIOS || Platform.isMacOS) {
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
      ..httpAdditionalHeaders = {'User-Agent': 'Book Agent'};
    return CupertinoClient.fromSessionConfiguration(config);
  }
  return IOClient(HttpClient()..userAgent = 'Book Agent');
}
