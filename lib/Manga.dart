class Manga {
  String id;
  String title;
  String catalog;
  int catalogId;
  bool inLibrary;
  bool detailsFetched;
  String url;
  String thumbnailUrl;
  String author;
  String artist;
  String genre;
  String description;
  String status;

  Manga({
    this.id,
    this.title,
    this.catalog,
    this.catalogId,
    this.inLibrary,
    this.detailsFetched,
    this.url,
    this.thumbnailUrl,
    this.author,
    this.artist,
    this.genre,
    this.description,
    this.status
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
        id: json['id'],
        title: json['title'],
        catalog: json['catalog'],
        catalogId: json['catalogId'],
        inLibrary: json['inLibrary'],
        detailsFetched: json['detailsFetched'],
        url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      author: json['author'],
      artist: json['artist'],
      genre: json['genre'],
      description: json['description'],
      status: json['status']
    );
  }
}