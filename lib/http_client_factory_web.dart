import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart';


Client httpClient() => FetchClient(mode: RequestMode.cors);
// httpClient یک تابع هستش که دروست شده و از FetchClient که برای درخواست به شبکه اس که مود RequestMode.cors گرفته که این مود یعنی میشه از منابع ای به منابع دیگه میشه دسترسی داشت
