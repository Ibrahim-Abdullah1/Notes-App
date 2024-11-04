class Note {
  String id;
  String title;
  String body;
  DateTime timestamp;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'],
      body: data['body'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp,
    };
  }
}

