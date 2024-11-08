import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_image_provider/http_image_provider.dart';
import 'package:provider/provider.dart';
import 'book.dart';
import 'http_client_factory.dart'
if (dart.library.js_interop) 'http_client_factory_web.dart' as http_factory;
// اگه مجبور شدیم اطلاعاتی رو از وب سایت واکشی کنیم از فایل
// http_client_factory_web.dart استفاده می کنیم اگه ام نه
//  نیازی بهش نداریم و بیخود پرفورمنس برنامه رو خراب نمی کنیم

void main() {
  runApp(Provider<Client>(
      create: (_) => http_factory.httpClient(),
      child: const BookSearchApp(),
      dispose: (_, client) => client.close()));
}

class BookSearchApp extends StatelessWidget {
  const BookSearchApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Book Search',
    home: HomePage(),
  );
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Book>? _books;
  String? _lastQuery;
  late Client _client;

  @override
  void initState() {
    super.initState();
    _client = context.read<Client>();
  }

// فهرست کتاب های مطابق با «پرس و جو» را دریافت کنید.
// با متد get از کلاینت اطلاعات رو میگریم
  Future<List<Book>> _findMatchingBooks(String query) async {
    final response = await _client.get(
      Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        {'q': query, 'maxResults': '20', 'printType': 'books'},
      ),
    );

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return Book.listFromJson(json);
  }
// سرچ و دریافت جواب
  void _runSearch(String query) async {
    _lastQuery = query;
    if (query.isEmpty) {
      setState(() {
        _books = null;
      });
      return;
    }

    final books = await _findMatchingBooks(query);
// از موقعیتی که کاربر یک جستوجو کند ولی اجرا دیر تر از
// موعود کوءری بزند جلوگیری میکند و جستوجو را متوقف می کند
//و برای جایگزین نتایج جستجوی جدیدتر را نشان می دهد.
    if (query != _lastQuery) return;
    setState(() {
      _books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = _books == null
        ? const Text('بپرس ازم هر چی خواستی', style: TextStyle(fontSize: 24))
        : _books!.isNotEmpty
        ? BookList(_books!)
        : const Row(
          children: [
          Icon(
              Icons.refresh,
              color: Colors.yellow,
              size: 30,
            ),
          Text(
            'هیچ دیتایی برای سرچ شما پیدا نکردم',
            style: TextStyle(fontSize: 24)
          ),
          ],
        );

    return Scaffold(
      appBar: AppBar(
          title: const Text('جستوجو مقاله یا کتاب '),
          backgroundColor: Colors.yellow,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextField(
              onChanged: _runSearch,
              decoration: const InputDecoration(
                labelText: 'جستجو',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: searchResult),
          ],
        ),
        color: Colors.orange,
      ),
    );
  }
}




//  نمایش لیستی از کتاب ها
class BookList extends StatefulWidget {
  final List<Book> books;
  const BookList(this.books, {super.key});

  @override
  State<BookList> createState() => _BookListState();
}
class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: widget.books.length,
    itemBuilder: (context, index) => Card(
      key: ValueKey(widget.books[index].title),
      child: ListTile(
        // که عکس و تایتل و توضیحات این جا مقدار دهی شده
        leading: Image(
            image: HttpImageProvider(
                widget.books[index].imageUrl.replace(scheme: 'https'),
                client: context.read<Client>())),
        title: Text(widget.books[index].title),
        subtitle: Text(widget.books[index].description),
      ),
    ),
  );
}
