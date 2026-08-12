// Data models for the app
class AppUser {
  final String id;
  final String phone;
  String name;
  final String role; // 'worker' | 'household'
  final String language;
  final bool onboarded;
  final String kycStatus;
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
  final double? latitude;
  final double? longitude;

  AppUser({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.language,
    required this.onboarded,
    required this.kycStatus,
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
    this.latitude,
    this.longitude,
  });

  AppUser copyWith({
    String? name,
    String? role,
    String? language,
    bool? onboarded,
    String? kycStatus,
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
    double? latitude,
    double? longitude,
  }) {
    return AppUser(
      id: id,
      phone: phone,
      name: name ?? this.name,
      role: role ?? this.role,
      language: language ?? this.language,
      onboarded: onboarded ?? this.onboarded,
      kycStatus: kycStatus ?? this.kycStatus,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
  final String? assignedWorkerName;
  final int interestsCount;

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
    this.assignedWorkerName,
    this.interestsCount = 0,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '',
      householdId: json['householdId']?.toString() ?? json['household']?['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString() ?? '',
      budget: (json['budgetAmount'] ?? json['budget'] ?? 0) is num ? (json['budgetAmount'] ?? json['budget'] ?? 0).toInt() : int.tryParse((json['budgetAmount'] ?? json['budget'] ?? 0).toString()) ?? 0,
      jobDate: json['jobDate']?.toString() ?? '',
      startTime: json['jobTime']?.toString() ?? json['startTime']?.toString() ?? '',
      durationHours: (json['durationHours'] ?? 0) is num ? (json['durationHours'] ?? 0).toInt() : int.tryParse((json['durationHours'] ?? 0).toString()) ?? 0,
      status: json['status']?.toString().toLowerCase() ?? 'open',
      urgent: json['urgent'] ?? false,
      assignedWorkerId: json['assignedWorkerId']?.toString(),
      assignedWorkerName: json['assignedWorker']?['name']?.toString(),
      interestsCount: (json['interestsCount'] ?? 0) is num ? (json['interestsCount'] ?? 0).toInt() : int.tryParse((json['interestsCount'] ?? 0).toString()) ?? 0,
    );
  }
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

  factory FeedJob.fromApiJob(Map<String, dynamic> json) {
    final job = Job.fromJson(json);
    
    final hhJson = json['household'] as Map<String, dynamic>? ?? {};
    final household = AppUser(
      id: hhJson['id']?.toString() ?? job.householdId,
      phone: hhJson['phone']?.toString() ?? '',
      name: hhJson['name']?.toString() ?? 'Unknown',
      role: 'household',
      language: json['language'] ?? 'en',
      onboarded: true,
      kycStatus: json['kycStatus'] ?? 'NONE',
      aadhaarVerified: json['kycStatus'] == 'APPROVED' || (hhJson['aadhaarVerified'] ?? false),
      aadhaarLast4: json['identityNumber'] != null && json['identityNumber'].toString().length >= 4 
          ? json['identityNumber'].toString().substring(json['identityNumber'].toString().length - 4) 
          : hhJson['aadhaarLast4'],
      area: '',
      address: '',
      radiusKm: 5.0,
      walletBalance: 0,
      streak: 0,
    );

    return FeedJob(
      job: job,
      household: household,
      distanceKm: (json['distance'] ?? 0.0) is num ? (json['distance'] as num).toDouble() : double.tryParse(json['distance']?.toString() ?? '0') ?? 0.0,
      matchScore: 80,
      interestCount: json['interestCount'] ?? 0,
    );
  }
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
