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
    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['city'] ?? json['location'] ?? '',
      address: json['address'] ?? '',
      price: (json['rent_price'] ?? json['price'] ?? 0).toDouble(),
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      propertyType: json['property_type'] ?? '',
      imageUrl: json['image_url'] ?? json['image'] ?? 'https://via.placeholder.com/300x200',
      rating: (json['rating'] ?? 0).toDouble(),
      isFavorited: json['is_favorited'] ?? false,
      description: json['description'] ?? '',
      area: (json['area_sqm'] ?? json['area'] ?? 0).toDouble(),
      isFurnished: json['is_furnished'] ?? false,
      parkingAvailable: json['parking_available'] ?? false,
      swimmingPool: json['swimming_pool'] ?? false,
      airConditioning: json['air_conditioning'] ?? false,
      gym: json['gym'] ?? false,
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
      'rating': rating,
      'is_favorited': isFavorited,
      'description': description,
      'area_sqm': area,
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

// Sample data based on housing-analyzer-main content
List<Property> sampleProperties = [
  Property(
    id: 1,
    title: "The Croft",
    location: "Preston Rd. Birmingham",
    address: "123 Preston Road",
    price: 400000,
    bedrooms: 4,
    bathrooms: 2,
    propertyType: "House",
    imageUrl: "assets/images/012624_ParisForino_WestEnd_Garruppo_015.webp",
    rating: 4.5,
    description: "Beautiful modern house with swimming pool",
    area: 250.0,
    isFurnished: true,
    parkingAvailable: true,
    swimmingPool: true,
    airConditioning: true,
    gym: false,
  ),
  Property(
    id: 2,
    title: "Hillcrest",
    location: "Hill Side, Birmingham",
    address: "456 Hill Side Avenue",
    price: 390000,
    bedrooms: 3,
    bathrooms: 2,
    propertyType: "House",
    imageUrl: "assets/images/BradRamseyInteriors_credit_CarolineSharpnack-dee35c1fab554898af7c549697c2f592.jpg",
    rating: 4.3,
    description: "Cozy family home in quiet neighborhood",
    area: 180.0,
    isFurnished: false,
    parkingAvailable: true,
    swimmingPool: false,
    airConditioning: true,
    gym: false,
  ),
  Property(
    id: 3,
    title: "Orchard House",
    location: "Preston Rd. Birmingham",
    address: "789 Preston Road",
    price: 500000,
    bedrooms: 4,
    bathrooms: 3,
    propertyType: "House",
    imageUrl: "assets/images/Guest-bedroom-design-ideas-Studio-McGee.jpeg",
    rating: 4.7,
    description: "Luxurious modern house with all amenities",
    area: 320.0,
    isFurnished: true,
    parkingAvailable: true,
    swimmingPool: true,
    airConditioning: true,
    gym: true,
  ),
  Property(
    id: 4,
    title: "High Field",
    location: "Preston Rd. Birmingham",
    address: "321 High Field Lane",
    price: 350000,
    bedrooms: 2,
    bathrooms: 2,
    propertyType: "House",
    imageUrl: "assets/images/pacific-northwest-home-tour-great-room-0820-14d61b428237459b9e996c769ae92dd0.jpg",
    rating: 4.2,
    description: "Compact and efficient modern home",
    area: 150.0,
    isFurnished: false,
    parkingAvailable: true,
    swimmingPool: false,
    airConditioning: true,
    gym: false,
  ),
  Property(
    id: 5,
    title: "Modern Downtown Apartment",
    location: "Phnom Penh",
    address: "123 Street 240",
    price: 1500,
    bedrooms: 2,
    bathrooms: 1,
    propertyType: "Apartment",
    imageUrl: "assets/images/pacific-northwest-home-tour-great-room-0820-14d61b428237459b9e996c769ae92dd0.jpg",
    rating: 4.5,
    description: "Modern apartment in city center",
    area: 85.0,
    isFurnished: true,
    parkingAvailable: false,
    swimmingPool: false,
    airConditioning: true,
    gym: true,
  ),
  Property(
    id: 6,
    title: "Cozy Studio Near Park",
    location: "Sen Sok, Phnom Penh",
    address: "456 Park Avenue",
    price: 1200,
    bedrooms: 1,
    bathrooms: 1,
    propertyType: "Studio",
    imageUrl: "assets/images/pexels-fotoaibe-1669799.jpg",
    rating: 4.2,
    description: "Perfect studio for singles",
    area: 45.0,
    isFurnished: false,
    parkingAvailable: true,
    swimmingPool: false,
    airConditioning: true,
    gym: false,
  ),
];
