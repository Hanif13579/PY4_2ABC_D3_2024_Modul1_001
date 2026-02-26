class LogModel {
  final String title;
  final String timestamp;
  final String description;
  final String category;

  LogModel({
    required this.title,
    required this.timestamp,
    required this.description,
    this.category = 'Umum',
  });

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      title: map['title'],
      timestamp: map['timestamp'],
      description: map['description'],
      category: map['category'] ?? 'Umum',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timestamp': timestamp,
      'description': description,
      'category': category,
    };
  }
}