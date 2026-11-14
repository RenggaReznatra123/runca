/// Pilihan gender di Edit Profile.
enum ProfileGender { male, female, preferNotToSay }

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
  final ProfileGender? gender;
  final DateTime? birthDate;

  /// Tinggi dalam cm.
  final int? heightCm;

  /// Berat dalam kg.
  final int? weightKg;
  final String location;

  /// URL atau path aset gambar.
  final String? avatarUrl;

  EditProfileData copyWith({
    String? name,
    String? email,
    ProfileGender? gender,
    bool clearGender = false,
    DateTime? birthDate,
    bool clearBirthDate = false,
    int? heightCm,
    bool clearHeightCm = false,
    int? weightKg,
    bool clearWeightKg = false,
    String? location,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return EditProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      gender: clearGender ? null : (gender ?? this.gender),
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      heightCm: clearHeightCm ? null : (heightCm ?? this.heightCm),
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
      location: location ?? this.location,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }
}
