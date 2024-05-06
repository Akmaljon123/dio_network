// To parse this JSON data, do
//
//     final allProductModel = allProductModelFromJson(jsonString);

import 'dart:convert';

List<AllProductModel> allProductModelFromJson(String str) =>
    List<AllProductModel>.from(
        json.decode(str).map((x) => AllProductModel.fromJson(x)));

String allProductModelToJson(List<AllProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllProductModel {
  List<Product>? products;
  int? total;
  int? skip;
  int? limit;

  AllProductModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  AllProductModel copyWith({
    List<Product>? products,
    int? total,
    int? skip,
    int? limit,
  }) =>
      AllProductModel(
        products: products ?? this.products,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory AllProductModel.fromJson(Map<String, dynamic> json) =>
      AllProductModel(
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Product {
  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    int? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? brand,
    String? category,
    String? thumbnail,
    List<String>? images,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        rating: rating ?? this.rating,
        stock: stock ?? this.stock,
        brand: brand ?? this.brand,
        category: category ?? this.category,
        thumbnail: thumbnail ?? this.thumbnail,
        images: images ?? this.images,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        rating: json["rating"]?.toDouble(),
        stock: json["stock"],
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}
