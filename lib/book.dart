// یک کلاسی درست کردم به اسم کتاب که یک کتاب را تعریف می کند

class Book {
  String title;
  // تایتل کتاب
  String description;
  // توضیحات
  Uri imageUrl;
  // تصاویر

  Book(this.title, this.description, this.imageUrl);

  static List<Book> listFromJson(Map<dynamic, dynamic> json) {
    final books = <Book>[];
    // پارامتر کتاب بعدا قراره مقدار دهی شه

    if (json['items'] case final List<dynamic> items) {
      // برسی میکنیم که داده ها لیست هستند یا نه
      for (final item in items) {
        // جای گزاری آیتم ها
        if (item case {'volumeInfo': final Map<dynamic, dynamic> volumeInfo}) {
          if (volumeInfo
          case {
            'title': final String title,
            'description': final String description,
            'imageLinks': {'smallThumbnail': final String thumbnail}
          }) {
            books.add(Book(title, description, Uri.parse(thumbnail)));
          }
        }
        // استخراج داده و جای گزاری داده
      }
    }


    return books;
    // کتاب رو پاس دادیم بیرون
  }
}