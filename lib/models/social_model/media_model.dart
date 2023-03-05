import 'dart:convert';

class MediaItem {
  String? url;
  String? path;
  String? author;
  String? description;
  String? idpost;
  String? uId;

  MediaItem({
    required this.url,
    required this.path,
    required this.author,
    required this.description,
    required this.idpost,
    required this.uId,
  });

 MediaItem.fromJson(Map<String, dynamic>? json) {
    url = json!['url'];
    path = json['path'];
    author = json['author'];
    description = json['description'];
    description = json['idpost'];
    uId = json['uId'];


  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'path': path,
      'author': author,
      'description': description,
      'idpost': idpost,
      'uId': uId,
    };
  }
}
