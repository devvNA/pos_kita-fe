import 'dart:convert';

class CategoryResponseModel {
  final List<Category>? data;

  CategoryResponseModel({
    this.data,
  });

  factory CategoryResponseModel.fromJson(String str) =>
      CategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      CategoryResponseModel(
        data: json["data"] == null
            ? []
            : List<Category>.from(
                json["data"]!.map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Category {
  final int? id;
  final int? categoryId;
  final String? name;
  final int? businessId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    this.categoryId,
    this.name,
    this.businessId,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        businessId: json["business_id"] is int
            ? json["business_id"]
            : int.parse(json["business_id"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "business_id": businessId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toBackUpMap() => {
        "category_id": id,
        "name": name,
        "business_id": businessId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return '$name';
  }
}

class CategoryModel {
  final int? id;
  final String? name;
  final String? categoryId;

  CategoryModel({
    this.id,
    this.name,
    this.categoryId,
  });

  // from map
  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
      );

  // to map
  Map<String, dynamic> toMap() => {
        "name": name,
        "category_id": categoryId,
      };

  Map<String, dynamic> toBackupMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category_id': categoryId,
    };
  }

  String toJson() => json.encode(toBackupMap());

  // from json
  factory CategoryModel.fromJson(String str) =>
      CategoryModel.fromMap(json.decode(str));

  @override
  String toString() {
    return name ?? 'Kategori';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ categoryId.hashCode;
}
