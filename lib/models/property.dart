class Property {
  final int id;
  final String title;
  final String location;
  final String address;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final String propertyType;
  final String imageUrl;
  final List<String> imageUrls;
  final double rating;
  final bool isFavorited;
  final String description;
  final double area;
  final bool isFurnished;
  final bool parkingAvailable;
  final bool swimmingPool;
  final bool airConditioning;
  final bool gym;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.address,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.rating,
    this.isFavorited = false,
    this.description = '',
    this.area = 0.0,
    this.isFurnished = false,
    this.parkingAvailable = false,
    this.swimmingPool = false,
    this.airConditioning = false,
    this.gym = false,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final amenities = json['amenities'] is List ? json['amenities'] as List : [];

    bool hasAmenity(String keyword) {
      return amenities.any((item) {
        final text = item.toString().toLowerCase();
        return text.contains(keyword.toLowerCase());
      });
    }

    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    final rawImages = json['images'] is List ? json['images'] as List : [];

    final imageUrls = rawImages
        .map((item) {
      if (item is Map && item['image_url'] != null) {
        return item['image_url'].toString();
      }

      return '';
    })
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final mainImage = (json['main_image'] ??
        json['image_url'] ??
        json['image'] ??
        '')
        .toString();

    if (mainImage.trim().isNotEmpty && !imageUrls.contains(mainImage)) {
      imageUrls.insert(0, mainImage);
    }

    final finalImageUrl = imageUrls.isNotEmpty
        ? imageUrls.first
        : 'https://via.placeholder.com/300x200';

    return Property(
      id: toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      location: (json['city'] ?? json['location'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      price: toDouble(
        json['price_per_month'] ??
            json['rent_price'] ??
            json['price'] ??
            0,
      ),
      bedrooms: toInt(json['bedrooms']),
      bathrooms: toInt(json['bathrooms']),
      propertyType: (json['property_type'] ?? '').toString(),
      imageUrl: finalImageUrl,
      imageUrls: imageUrls,
      rating: toDouble(json['rating']),
      isFavorited: json['is_favorited'] == true,
      description: (json['description'] ?? '').toString(),
      area: toDouble(json['area_size'] ?? json['area_sqm'] ?? json['area']),
      isFurnished: json['is_furnished'] == true || hasAmenity('furnished'),
      parkingAvailable:
      json['parking_available'] == true || hasAmenity('parking'),
      swimmingPool: json['swimming_pool'] == true || hasAmenity('pool'),
      airConditioning:
      json['air_conditioning'] == true || hasAmenity('air conditioning'),
      gym: json['gym'] == true || hasAmenity('gym'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'address': address,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'property_type': propertyType,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'rating': rating,
      'is_favorited': isFavorited,
      'description': description,
      'area_size': area,
      'is_furnished': isFurnished,
      'parking_available': parkingAvailable,
      'swimming_pool': swimmingPool,
      'air_conditioning': airConditioning,
      'gym': gym,
    };
  }

  Property copyWith({
    int? id,
    String? title,
    String? location,
    String? address,
    double? price,
    int? bedrooms,
    int? bathrooms,
    String? propertyType,
    String? imageUrl,
    List<String>? imageUrls,
    double? rating,
    bool? isFavorited,
    String? description,
    double? area,
    bool? isFurnished,
    bool? parkingAvailable,
    bool? swimmingPool,
    bool? airConditioning,
    bool? gym,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      address: address ?? this.address,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      propertyType: propertyType ?? this.propertyType,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      isFavorited: isFavorited ?? this.isFavorited,
      description: description ?? this.description,
      area: area ?? this.area,
      isFurnished: isFurnished ?? this.isFurnished,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      swimmingPool: swimmingPool ?? this.swimmingPool,
      airConditioning: airConditioning ?? this.airConditioning,
      gym: gym ?? this.gym,
    );
  }
}

List<Property> sampleProperties = [];