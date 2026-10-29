/// Pilihan gender di Edit Profile.
enum ProfileGender {
  male('Male'),
  female('Female'),
  preferNotToSay('Prefer not to say');

  const ProfileGender(this.label);

  final String label;
}

/// Data profil yang bisa diedit. Email hanya tampil, tidak bisa diubah.
class EditProfileData {
  const EditProfileData({
    required this.name,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.heightCm,
    required this.weightKg,
    required this.location,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final ProfileGender gender;
  final DateTime birthDate;

  /// Tinggi dalam cm.
  final int heightCm;

  /// Berat dalam kg.
  final int weightKg;
  final String location;

  /// URL atau path aset gambar.
  final String? avatarUrl;

  EditProfileData copyWith({
    String? name,
    String? email,
    ProfileGender? gender,
    DateTime? birthDate,
    int? heightCm,
    int? weightKg,
    String? location,
  }) {
    return EditProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      location: location ?? this.location,
      avatarUrl: avatarUrl,
    );
  }
}