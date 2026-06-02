class UserProfile {
  final String name;
  final DateTime dateOfBirth;
  final String skinType;
  final List<String> skinConcerns;
  final String location;
  final String climate;
  final int waterIntake;
  final int sleepHours;

  const UserProfile({
    required this.name,
    required this.dateOfBirth,
    required this.skinType,
    required this.skinConcerns,
    required this.location,
    required this.climate,
    required this.waterIntake,
    required this.sleepHours,
  });

  int get age {
    final today = DateTime.now();
    int years = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }

  String get formattedDob {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dateOfBirth.month - 1]} ${dateOfBirth.day}, ${dateOfBirth.year}';
  }

  UserProfile copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? skinType,
    List<String>? skinConcerns,
    String? location,
    String? climate,
    int? waterIntake,
    int? sleepHours,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      skinType: skinType ?? this.skinType,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      location: location ?? this.location,
      climate: climate ?? this.climate,
      waterIntake: waterIntake ?? this.waterIntake,
      sleepHours: sleepHours ?? this.sleepHours,
    );
  }

  String get skinTypeLabel {
    switch (skinType) {
      case 'oily':
        return 'Oily Skin';
      case 'dry':
        return 'Dry Skin';
      case 'combination':
        return 'Combination Skin';
      case 'sensitive':
        return 'Sensitive Skin';
      default:
        return 'Normal Skin';
    }
  }
}
