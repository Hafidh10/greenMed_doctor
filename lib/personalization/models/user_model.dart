import '../../utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String profilePicture;
  String fcmToken;
  String role;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.fcmToken = '',
    this.role = 'doctor', // Defaulting to doctor for this app
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
  String get fullName => "$firstName $lastName";

  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    phoneNumber: '',
    profilePicture: '',
    fcmToken: '',
    role: 'doctor',
  );

  // Convert model to JSON for Supabase (using snake_case)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'fcm_token': fcmToken,
    };
  }

  // Factory to create model from Supabase data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      profilePicture: '', 
      fcmToken: data['fcm_token'] ?? '',
      role: data['role'] ?? 'doctor',
    );
  }
}
