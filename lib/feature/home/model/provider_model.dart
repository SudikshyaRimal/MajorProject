class ProviderModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String address;
  final String serviceType;
  final int experience;
  final double price;
  final double rating;

  ProviderModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.address,
    required this.serviceType,
    required this.experience,
    required this.price,
    required this.rating,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      serviceType: json['serviceType'] ?? '',
      experience: json['experience'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}
