class BookDetails {
  int? id;
  String name;
  String author;
  String cover;

  BookDetails({
    this.id,
    required this.name,
    required this.author,
    required this.cover,
  });

  factory BookDetails.fromMap(Map<String, dynamic> map) {
    return BookDetails(
      id: map['id'], // Include the id if necessary
      name: map['title'] ?? 'Unknown Title', // Use 'title' instead of 'name'
      author: map['author'] ?? 'Unknown Author',
      cover: map['cover'] ?? 'https://example.com/default_cover.jpg',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the id if necessary
      'title': name, // Use 'title' instead of 'name'
      'author': author,
      'cover': cover,
    };
  }
}
