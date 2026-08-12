// App state provider — replaces Next.js session/server actions
import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../data/seed.dart';
import '../core/domain.dart';

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
  final List<int> _tabHistory = [];

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
  bool get isWorkerProfileComplete {
    final user = _user;
    final profile = _workerProfile;
    return user != null &&
        user.role == 'worker' &&
        user.onboarded &&
        user.name.trim().length >= 2 &&
        user.area.trim().isNotEmpty &&
        (user.familyName?.trim().length ?? 0) >= 2 &&
        (user.familyPhone?.replaceAll(RegExp(r'\D'), '').length ?? 0) == 10 &&
        RegExp(r'^\d{4}$').hasMatch(user.pin ?? '') &&
        profile != null &&
        profile.skills.isNotEmpty &&
        profile.expectedWage > 0 &&
        profile.availableFrom.isNotEmpty &&
        profile.availableTo.isNotEmpty;
  }

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void setLang(String lang) {
    _lang = lang;
    notifyListeners();
  }

  void setTab(int index) {
    if (index == _currentTab) return;
    _tabHistory.add(_currentTab);
    _currentTab = index;
    notifyListeners();
  }

  bool goToPreviousTab() {
    if (_tabHistory.isEmpty) return false;
    _currentTab = _tabHistory.removeLast();
    notifyListeners();
    return true;
  }

  void verifyIdentity(String identityNumber) {
    if (_user == null || !RegExp(r'^\d{12}$').hasMatch(identityNumber)) return;
    _user = _user!.copyWith(
      aadhaarVerified: true,
      aadhaarLast4: identityNumber.substring(8),
    );
    notifyListeners();
  }

  // Simulate OTP flow — demo always succeeds with 123456
  Future<bool> requestOtp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String phone, String otp, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));

    if (otp != kDemoOtp) {
      _error = 'Wrong OTP. Demo OTP is 123456.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // OTP login starts the profile setup flow. The demo data supplies the
    // remaining sample account fields, but the new session still needs the
    // user's name and location before it can enter the app.
    _user = role == 'worker'
        ? demoWorker.copyWith(onboarded: false)
        : demoHousehold.copyWith(onboarded: false);

    if (role == 'worker') {
      _workerProfile = demoWorkerProfile;
      _transactions = demoTransactions;
      _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
      _assignedJobs = [];
    } else {
      _myJobs = demoJobs.take(3).toList();
      _nearbyWorkers = demoNearbyWorkers;
      _transactions = [];
    }
    _notifications = demoNotifications;
    _isLoading = false;
    notifyListeners();
    return true;
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
    await Future.delayed(const Duration(milliseconds: 800));

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
    _currentTab = 0;
    _tabHistory.clear();
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

  bool expressInterest(String jobId) {
    if (!isWorkerProfileComplete) return false;
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
    return true;
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
    await Future.delayed(const Duration(milliseconds: 600));
    _user = _user!.copyWith(walletBalance: _user!.walletBalance + amount);
    _transactions.insert(
      0,
      WalletTx(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        note: 'Top-up via UPI',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return null; // success
  }

  Future<String?> withdraw(int amount, String pin) async {
    if (_user == null) return 'Not logged in';
    if (_user!.pin != null && pin != _user!.pin) return 'Wrong PIN';
    if (_user!.walletBalance < amount) return 'Insufficient balance';
    await Future.delayed(const Duration(milliseconds: 600));
    _user = _user!.copyWith(walletBalance: _user!.walletBalance - amount);
    _transactions.insert(
      0,
      WalletTx(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        amount: -amount,
        note: 'Withdrawal to UPI',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return null;
  }

  void markNotificationsRead() {
    _notifications = _notifications
        .map(
          (n) => Notification(
            id: n.id,
            title: n.title,
            body: n.body,
            createdAt: n.createdAt,
            read: true,
            actionUrl: n.actionUrl,
          ),
        )
        .toList();
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
    await Future.delayed(const Duration(milliseconds: 700));
    final job = Job(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
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
