class AnimalsModel {
  final String id;
  final String title;
  final bool isFavorite;
  final DateTime? favoriteAt;

  AnimalsModel({required this.id, required this.title, this.isFavorite = false, this.favoriteAt});

  factory AnimalsModel.fromJson(Map<String, dynamic> json) {
    return AnimalsModel(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isFavorite': isFavorite};
  }

  AnimalsModel copyWith({String? id, String? title, DateTime? createdAt, bool? isFavorite, DateTime? favoriteAt}) {
    return AnimalsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteAt: favoriteAt ?? this.favoriteAt,
    );
  }
}
