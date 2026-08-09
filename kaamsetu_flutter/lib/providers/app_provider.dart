import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../core/domain.dart';
import '../core/api_client.dart';

class AppProvider extends ChangeNotifier {
  // Auth state
  AppUser? _user;
  WorkerProfile? _workerProfile;
  bool _isLoading = false;
  String? _error;

  // Demo data
  List<FeedJob> _feedJobs = [];
  List<NearbyWorker> _nearbyWorkers = [];
  List<Job> _myJobs = []; // for household
  List<WalletTx> _transactions = [];
  List<Notification> _notifications = [];
  List<Job> _assignedJobs = []; // for worker

  // Navigation
  int _currentTab = 0;

  // Language
  String _lang = 'en';

  AppUser? get user => _user;
  WorkerProfile? get workerProfile => _workerProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get lang => _lang;
  int get currentTab => _currentTab;
  List<FeedJob> get feedJobs => _feedJobs;
  List<NearbyWorker> get nearbyWorkers => _nearbyWorkers;
  List<Job> get myJobs => _myJobs;
  List<WalletTx> get transactions => _transactions;
  List<Notification> get notifications => _notifications;
  List<Job> get assignedJobs => _assignedJobs;
  bool get isAuthenticated => _user != null;
  bool get isWorker => _user?.role == 'worker';

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void setLang(String lang) {
    _lang = lang;
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  Future<bool> requestOtp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await apiClient.dio.post('/auth/request-otp', data: {'phone': phone});
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to request OTP';
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final res = await apiClient.dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
        'role': role,
      });

      final payload = res.data['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', payload['accessToken']);

      final userData = payload['user'];
      _user = AppUser(
        id: userData['id']?.toString() ?? '',
        phone: userData['phone']?.toString() ?? phone,
        name: userData['name'] ?? '',
        role: userData['role'] ?? role,
        language: userData['language'] ?? 'en',
        onboarded: userData['onboarded'] ?? false,
        aadhaarVerified: userData['aadhaarVerified'] ?? false,
        aadhaarLast4: userData['aadhaarLast4']?.toString(),
        area: userData['area'] ?? '',
        address: userData['address'] ?? '',
        radiusKm: (userData['radiusKm'] ?? 10).toDouble(),
        walletBalance: userData['walletBalance'] ?? 0,
        streak: userData['streak'] ?? 0,
        pin: userData['pin']?.toString(),
      );

      if (role == 'worker') {
        _workerProfile = demoWorkerProfile;
        _transactions = demoTransactions;
        _assignedJobs = [];
        try {
          final jobsRes = await apiClient.dio.get('/jobs');
          print('WARNING: Fetched feed jobs but using mock parsing for now due to lack of fromJson: ${jobsRes.data}');
          _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
        } catch (e) {
          print('Failed to fetch feed jobs: $e');
          _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
        }
      } else {
        _myJobs = demoJobs.take(3).toList();
        _nearbyWorkers = demoNearbyWorkers;
        _transactions = [];
      }
      _notifications = demoNotifications;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> completeOnboarding({
    required String name,
    required String role,
    required String language,
    required String area,
    required String familyName,
    required String familyPhone,
    required String familyRelation,
    required bool aadhaarVerified,
    String? aadhaarLast4,
    required String pin,
    required double radiusKm,
    List<String> skills = const [],
    int expectedWage = 600,
    String wageUnit = 'day',
    int experienceYears = 0,
    String bio = '',
    String availableFrom = '08:00',
    String availableTo = '18:00',
  }) async {
    _isLoading = true;
    notifyListeners();
    print('WARNING: completeOnboarding is using mock implementation.');

    _user = _user!.copyWith(
      name: name,
      language: language,
      onboarded: true,
      aadhaarVerified: aadhaarVerified,
      aadhaarLast4: aadhaarLast4,
      area: area,
      address: '$area, Pune',
      familyName: familyName,
      familyPhone: familyPhone,
      familyRelation: familyRelation,
      pin: pin,
      radiusKm: radiusKm,
    );

    if (role == 'worker') {
      _workerProfile = WorkerProfile(
        userId: _user!.id,
        skills: skills,
        expectedWage: expectedWage,
        wageUnit: wageUnit,
        experienceYears: experienceYears,
        bio: bio,
        availableNow: false,
        availableFrom: availableFrom,
        availableTo: availableTo,
        thumbsUp: 0,
        thumbsDown: 0,
        jobsDone: 0,
        badges: aadhaarVerified ? ['verified'] : [],
      );
      _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
    } else {
      _myJobs = [];
      _nearbyWorkers = demoNearbyWorkers;
    }
    _notifications = demoNotifications;
    _isLoading = false;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    _workerProfile = null;
    _feedJobs = [];
    _nearbyWorkers = [];
    _myJobs = [];
    _transactions = [];
    _notifications = [];
    _assignedJobs = [];
    _error = null;
    notifyListeners();
  }

  void toggleAvailability() {
    if (_workerProfile == null) return;
    _workerProfile = _workerProfile!.copyWith(
      availableNow: !_workerProfile!.availableNow,
    );
    notifyListeners();
  }

  void expressInterest(String jobId) {
    _feedJobs = _feedJobs.map((f) {
      if (f.job.id == jobId) {
        return FeedJob(
          job: f.job,
          household: f.household,
          distanceKm: f.distanceKm,
          matchScore: f.matchScore,
          interestCount: f.interestCount + 1,
          myInterest: 'interested',
        );
      }
      return f;
    }).toList();
    notifyListeners();
  }

  void withdrawInterest(String jobId) {
    _feedJobs = _feedJobs.map((f) {
      if (f.job.id == jobId) {
        return FeedJob(
          job: f.job,
          household: f.household,
          distanceKm: f.distanceKm,
          matchScore: f.matchScore,
          interestCount: (f.interestCount - 1).clamp(0, 99),
          myInterest: null,
        );
      }
      return f;
    }).toList();
    notifyListeners();
  }

  Future<String?> topUp(int amount, String pin) async {
    if (_user == null) return 'Not logged in';
    if (_user!.pin != null && pin != _user!.pin) return 'Wrong PIN';
    print('WARNING: topUp is using mock implementation.');
    _user = _user!.copyWith(walletBalance: _user!.walletBalance + amount);
    _transactions.insert(0, WalletTx(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      note: 'Top-up via UPI',
      createdAt: DateTime.now(),
    ));
    notifyListeners();
    return null; // success
  }

  Future<String?> withdraw(int amount, String pin) async {
    if (_user == null) return 'Not logged in';
    if (_user!.pin != null && pin != _user!.pin) return 'Wrong PIN';
    if (_user!.walletBalance < amount) return 'Insufficient balance';
    print('WARNING: withdraw is using mock implementation.');
    _user = _user!.copyWith(walletBalance: _user!.walletBalance - amount);
    _transactions.insert(0, WalletTx(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      amount: -amount,
      note: 'Withdrawal to UPI',
      createdAt: DateTime.now(),
    ));
    notifyListeners();
    return null;
  }

  void markNotificationsRead() {
    _notifications = _notifications.map((n) => Notification(
      id: n.id,
      title: n.title,
      body: n.body,
      createdAt: n.createdAt,
      read: true,
      actionUrl: n.actionUrl,
    )).toList();
    notifyListeners();
  }

  Future<String?> postJob({
    required String title,
    String? description,
    required String category,
    required int budget,
    required String jobDate,
    required String startTime,
    required int durationHours,
    required bool urgent,
  }) async {
    try {
      final res = await apiClient.dio.post('/jobs', data: {
        'title': title,
        'description': description,
        'category': category,
        'budget': budget,
        'jobDate': jobDate,
        'startTime': startTime,
        'durationHours': durationHours,
        'urgent': urgent,
      });

      final job = Job(
        id: res.data['job']?['id']?.toString() ?? 'job-${DateTime.now().millisecondsSinceEpoch}',
        householdId: _user!.id,
        title: title,
        description: description,
        category: category,
        budget: budget,
        jobDate: jobDate,
        startTime: startTime,
        durationHours: durationHours,
        status: 'open',
        urgent: urgent,
      );
      _myJobs.insert(0, job);
      notifyListeners();
      return null;
    } catch (e) {
      print('Failed to post job: $e');
      return 'Failed to post job';
    }
  }

  void updateWorkerProfile({
    String? availableFrom,
    String? availableTo,
    List<String>? skills,
    int? expectedWage,
    String? wageUnit,
    int? experienceYears,
    String? bio,
  }) {
    if (_workerProfile == null) return;
    _workerProfile = _workerProfile!.copyWith(
      availableFrom: availableFrom,
      availableTo: availableTo,
      skills: skills,
      expectedWage: expectedWage,
      wageUnit: wageUnit,
      experienceYears: experienceYears,
      bio: bio,
    );
    notifyListeners();
  }
}
