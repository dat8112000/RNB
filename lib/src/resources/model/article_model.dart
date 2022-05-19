final String tableArticle = 'article';

class ArticleFields {
  static final List<String> values = [
    /// Add all fields
    id, title, content, date
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String content = 'number';
  static final String date = 'date';
}

class Article {
  final String? id;//
  final String title;
  final String content;
  final DateTime date;

  const Article({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Article copy({
    String? id,//
    String? title,
    String? content,
    DateTime? date,
  }) =>
      Article(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
      );

  static Article fromJson(Map<String, Object?> json) => Article(
        id: json[ArticleFields.id] as String?,//
        title: json[ArticleFields.title] as String,
        content: json[ArticleFields.content] as String,
        date: DateTime.parse(json[ArticleFields.date] as String),
      );

  Map<String, Object?> toJson() => {
        ArticleFields.id: id,
        ArticleFields.title: title,
        ArticleFields.content: content,
        ArticleFields.date: date.toIso8601String(),
      };
}
