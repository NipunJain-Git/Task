// Data models for the app
class AppUser {
  final String id;
  final String phone;
  String name;
  final String role; // 'worker' | 'household'
  final String language;
  final bool onboarded;
  final bool aadhaarVerified;
  final String? aadhaarLast4;
  final String area;
  final String address;
  double radiusKm;
  final int walletBalance;
  final int streak;
  final String? pin;
  final String? familyName;
  final String? familyPhone;
  final String? familyRelation;

  AppUser({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.language,
    required this.onboarded,
    required this.aadhaarVerified,
    this.aadhaarLast4,
    required this.area,
    required this.address,
    required this.radiusKm,
    required this.walletBalance,
    required this.streak,
    this.pin,
    this.familyName,
    this.familyPhone,
    this.familyRelation,
  });

  AppUser copyWith({
    String? name,
    String? role,
    String? language,
    bool? onboarded,
    bool? aadhaarVerified,
    String? aadhaarLast4,
    String? area,
    String? address,
    double? radiusKm,
    int? walletBalance,
    int? streak,
    String? pin,
    String? familyName,
    String? familyPhone,
    String? familyRelation,
  }) {
    return AppUser(
      id: id,
      phone: phone,
      name: name ?? this.name,
      role: role ?? this.role,
      language: language ?? this.language,
      onboarded: onboarded ?? this.onboarded,
      aadhaarVerified: aadhaarVerified ?? this.aadhaarVerified,
      aadhaarLast4: aadhaarLast4 ?? this.aadhaarLast4,
      area: area ?? this.area,
      address: address ?? this.address,
      radiusKm: radiusKm ?? this.radiusKm,
      walletBalance: walletBalance ?? this.walletBalance,
      streak: streak ?? this.streak,
      pin: pin ?? this.pin,
      familyName: familyName ?? this.familyName,
      familyPhone: familyPhone ?? this.familyPhone,
      familyRelation: familyRelation ?? this.familyRelation,
    );
  }
}

class WorkerProfile {
  final String userId;
  final List<String> skills;
  final int expectedWage;
  final String wageUnit; // 'day' | 'hour'
  final int experienceYears;
  final String bio;
  final bool availableNow;
  final String availableFrom;
  final String availableTo;
  final int thumbsUp;
  final int thumbsDown;
  final int jobsDone;
  final List<String> badges;

  const WorkerProfile({
    required this.userId,
    required this.skills,
    required this.expectedWage,
    required this.wageUnit,
    required this.experienceYears,
    required this.bio,
    required this.availableNow,
    required this.availableFrom,
    required this.availableTo,
    required this.thumbsUp,
    required this.thumbsDown,
    required this.jobsDone,
    required this.badges,
  });

  WorkerProfile copyWith({
    bool? availableNow,
    String? availableFrom,
    String? availableTo,
    List<String>? skills,
    int? expectedWage,
    String? wageUnit,
    int? experienceYears,
    String? bio,
    int? thumbsUp,
    int? thumbsDown,
    int? jobsDone,
    List<String>? badges,
  }) {
    return WorkerProfile(
      userId: userId,
      skills: skills ?? this.skills,
      expectedWage: expectedWage ?? this.expectedWage,
      wageUnit: wageUnit ?? this.wageUnit,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      availableNow: availableNow ?? this.availableNow,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      thumbsUp: thumbsUp ?? this.thumbsUp,
      thumbsDown: thumbsDown ?? this.thumbsDown,
      jobsDone: jobsDone ?? this.jobsDone,
      badges: badges ?? this.badges,
    );
  }
}

class Job {
  final String id;
  final String householdId;
  final String title;
  final String? description;
  final String category;
  final int budget;
  final String jobDate;
  final String startTime;
  final int durationHours;
  final String status; // 'open' | 'assigned' | 'in_progress' | 'completed' | 'cancelled'
  final bool urgent;
  final String? assignedWorkerId;

  const Job({
    required this.id,
    required this.householdId,
    required this.title,
    this.description,
    required this.category,
    required this.budget,
    required this.jobDate,
    required this.startTime,
    required this.durationHours,
    required this.status,
    required this.urgent,
    this.assignedWorkerId,
  });
}

class FeedJob {
  final Job job;
  final AppUser household;
  final double distanceKm;
  final int matchScore;
  final int interestCount;
  final String? myInterest; // null | 'interested'

  const FeedJob({
    required this.job,
    required this.household,
    required this.distanceKm,
    required this.matchScore,
    required this.interestCount,
    this.myInterest,
  });
}

class NearbyWorker {
  final String id;
  String name;
  final bool aadhaarVerified;
  final bool availableNow;
  final double distanceKm;
  final int thumbsUp;
  final int thumbsDown;
  final int jobsDone;
  final List<String> skills;
  final int expectedWage;
  final String wageUnit;
  final List<String> badges;

  NearbyWorker({
    required this.id,
    required this.name,
    required this.aadhaarVerified,
    required this.availableNow,
    required this.distanceKm,
    required this.thumbsUp,
    required this.thumbsDown,
    required this.jobsDone,
    required this.skills,
    required this.expectedWage,
    required this.wageUnit,
    required this.badges,
  });
}

class WalletTx {
  final String id;
  final int amount;
  final String note;
  final DateTime createdAt;

  const WalletTx({
    required this.id,
    required this.amount,
    required this.note,
    required this.createdAt,
  });
}

class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? actionUrl;

  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
    this.actionUrl,
  });
}
