class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? photoPath;
  final String role;
  
  // Base fields
  final String? primaryCity;
  final String? birthDate;
  
  // Lawyer specific
  final String? whatsapp;
  final String? specialization;
  final String? officeAddress;
  final String? consultationFee;
  final String? bio;
  final List<String>? availableTimeSlots; // e.g. "2023-11-20 14:00"

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.photoPath,
    required this.role,
    this.primaryCity,
    this.birthDate,
    this.whatsapp,
    this.specialization,
    this.officeAddress,
    this.consultationFee,
    this.bio,
    this.availableTimeSlots,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? photoPath,
    String? role,
    String? primaryCity,
    String? birthDate,
    String? whatsapp,
    String? specialization,
    String? officeAddress,
    String? consultationFee,
    String? bio,
    List<String>? availableTimeSlots,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      photoPath: photoPath ?? this.photoPath,
      role: role ?? this.role,
      primaryCity: primaryCity ?? this.primaryCity,
      birthDate: birthDate ?? this.birthDate,
      whatsapp: whatsapp ?? this.whatsapp,
      specialization: specialization ?? this.specialization,
      officeAddress: officeAddress ?? this.officeAddress,
      consultationFee: consultationFee ?? this.consultationFee,
      bio: bio ?? this.bio,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
    );
  }
}
