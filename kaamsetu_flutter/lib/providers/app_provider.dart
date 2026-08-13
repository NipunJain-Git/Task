import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models.dart' hide Notification;
import '../data/models.dart' as models show Notification;
import '../data/seed.dart';
import '../core/domain.dart';
import '../core/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppProvider extends ChangeNotifier {
  // Auth state
  AppUser? _user;
  WorkerProfile? _workerProfile;
  bool _isLoading = false;
  String? _error;

  // Language
  String _lang = 'en';
  String get lang => _lang;
  
  void setLang(String newLang) {
    _lang = newLang;
    notifyListeners();
  }

  // Demo data
  List<FeedJob> _feedJobs = [];
  List<NearbyWorker> _nearbyWorkers = [];
  List<Job> _myJobs = []; // for household
  List<WalletTx> _transactions = [];
  List<models.Notification> _notifications = [];
  List<Job> _assignedJobs = []; // for worker

  // Navigation
  int _currentTab = 0;
  final List<int> _tabHistory = [];

  AppUser? get user => _user;
  WorkerProfile? get workerProfile => _workerProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentTab => _currentTab;
  List<FeedJob> get feedJobs => _feedJobs;
  List<NearbyWorker> get nearbyWorkers => _nearbyWorkers;
  List<Job> get myJobs => _myJobs;
  List<WalletTx> get transactions => _transactions;
  List<models.Notification> get notifications => _notifications;
  List<Job> get assignedJobs => _assignedJobs;
  bool get isAuthenticated => _user != null;
  bool get isWorker => _user?.role == 'worker';

  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<bool> initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) return false;

      // Fetch user profile to restore session
      final res = await apiClient.dio.get('/users/me');
      final userData = res.data['data'];
      
      _user = AppUser(
        id: userData['id']?.toString() ?? '',
        phone: userData['phone']?.toString() ?? '',
        name: userData['name'] ?? '',
        role: userData['role'] ?? '',
        language: userData['language'] ?? 'en',
        onboarded: userData['onboarded'] ?? false,
        kycStatus: userData['kycStatus'] ?? 'NONE',
        aadhaarVerified: userData['kycStatus'] == 'APPROVED' || (userData['aadhaarVerified'] ?? false),
        aadhaarLast4: userData['identityNumber'] != null && userData['identityNumber'].toString().length >= 4 
            ? userData['identityNumber'].toString().substring(userData['identityNumber'].toString().length - 4) 
            : userData['aadhaarLast4']?.toString(),
        area: userData['area'] ?? '',
        address: userData['address'] ?? '',
        radiusKm: (userData['radiusKm'] ?? 10).toDouble(),
        walletBalance: userData['walletBalance'] ?? 0,
        streak: userData['streak'] ?? 0,
        pin: userData['pin']?.toString(),
      );

      _uploadFcmToken();
      
      // Load necessary data based on role
      if (_user?.role == 'WORKER' || _user?.role == 'worker') {
        _workerProfile = demoWorkerProfile;
        _transactions = demoTransactions;
        _assignedJobs = [];
        try {
          final jobsRes = await apiClient.dio.get('/jobs');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _feedJobs = jobsList.map((j) => FeedJob.fromApiJob(j as Map<String, dynamic>)).toList();
        } catch (e) {
          _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
        }
      } else if (_user?.role == 'HOUSEHOLD' || _user?.role == 'household') {
        try {
          final jobsRes = await apiClient.dio.get('/jobs/my-posts');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _myJobs = jobsList.map((j) => Job.fromJson(j as Map<String, dynamic>)).toList();
        } catch (e) {
          _myJobs = demoJobs.take(3).toList();
        }
        _nearbyWorkers = demoNearbyWorkers;
        _transactions = [];
      }

      notifyListeners();
      return true;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      return false;
    }
  }

  Future<void> verifyIdentity(String identityNumber) async {
    if (_user == null || !RegExp(r'^\d{12}$').hasMatch(identityNumber)) return;
    
    try {
      final res = await apiClient.dio.post('/users/kyc', data: { 'identityNumber': identityNumber });
      if (res.data['success'] == true) {
        _user = _user!.copyWith(
          kycStatus: 'PENDING',
          aadhaarLast4: identityNumber.substring(8),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to submit KYC';
      notifyListeners();
    }
  }

  void setTab(int index) {
    if (_currentTab != index) {
      _tabHistory.add(_currentTab);
      _currentTab = index;
      notifyListeners();
    }
  }

  bool goToPreviousTab() {
    if (_tabHistory.isNotEmpty) {
      _currentTab = _tabHistory.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<String?> requestOtp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await apiClient.dio.post('/auth/send-otp', data: {'phone': phone});
      _isLoading = false;
      notifyListeners();
      return res.data['data']?['sessionId']?.toString() ?? 'mock';
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to request OTP';
      notifyListeners();
      return null;
    }
  }

  Future<bool> verifyOtp(String phone, String otp, String role, String sessionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final res = await apiClient.dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
        'role': role,
        'sessionId': sessionId,
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
        kycStatus: userData['kycStatus'] ?? 'NONE',
        aadhaarVerified: userData['kycStatus'] == 'APPROVED' || (userData['aadhaarVerified'] ?? false),
        aadhaarLast4: userData['identityNumber'] != null && userData['identityNumber'].toString().length >= 4 
            ? userData['identityNumber'].toString().substring(userData['identityNumber'].toString().length - 4) 
            : userData['aadhaarLast4']?.toString(),
        area: userData['area'] ?? '',
        address: userData['address'] ?? '',
        radiusKm: (userData['radiusKm'] ?? 10).toDouble(),
        walletBalance: userData['walletBalance'] ?? 0,
        streak: userData['streak'] ?? 0,
        pin: userData['pin']?.toString(),
      );

      // Upload FCM token to backend
      _uploadFcmToken();

      if (role == 'worker') {
        _workerProfile = demoWorkerProfile;
        _transactions = demoTransactions;
        _assignedJobs = [];
        try {
          final jobsRes = await apiClient.dio.get('/jobs');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _feedJobs = jobsList.map((j) => FeedJob.fromApiJob(j as Map<String, dynamic>)).toList();
        } catch (e) {
          print('Failed to fetch feed jobs: $e');
          _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
        }
      } else {
        try {
          final jobsRes = await apiClient.dio.get('/jobs/my-posts');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _myJobs = jobsList.map((j) => Job.fromJson(j as Map<String, dynamic>)).toList();
        } catch (e) {
          _myJobs = demoJobs.take(3).toList();
        }
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

  Future<bool> verifyFirebase(String idToken, String phone, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final res = await apiClient.dio.post('/auth/verify-firebase', data: {
        'idToken': idToken,
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
        kycStatus: userData['kycStatus'] ?? 'NONE',
        aadhaarVerified: userData['kycStatus'] == 'APPROVED' || (userData['aadhaarVerified'] ?? false),
        aadhaarLast4: userData['identityNumber'] != null && userData['identityNumber'].toString().length >= 4 
            ? userData['identityNumber'].toString().substring(userData['identityNumber'].toString().length - 4) 
            : userData['aadhaarLast4']?.toString(),
        area: userData['area'] ?? '',
        address: userData['address'] ?? '',
        radiusKm: (userData['radiusKm'] ?? 10).toDouble(),
        walletBalance: userData['walletBalance'] ?? 0,
        streak: userData['streak'] ?? 0,
        pin: userData['pin']?.toString(),
      );

      // Upload FCM token to backend
      _uploadFcmToken();

      if (role == 'worker') {
        _workerProfile = demoWorkerProfile;
        _transactions = demoTransactions;
        _assignedJobs = [];
        try {
          final jobsRes = await apiClient.dio.get('/jobs');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _feedJobs = jobsList.map((j) => FeedJob.fromApiJob(j as Map<String, dynamic>)).toList();
        } catch (e) {
          _feedJobs = buildFeedJobs(demoJobs, demoHouseholds);
        }
      } else {
        try {
          final jobsRes = await apiClient.dio.get('/jobs/my-posts');
          final jobsList = (jobsRes.data['data'] as List? ?? []);
          _myJobs = jobsList.map((j) => Job.fromJson(j as Map<String, dynamic>)).toList();
        } catch (e) {
          _myJobs = demoJobs.take(3).toList();
        }
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

  Future<void> refreshJobs() async {
    if (_user?.role == 'worker') {
      try {
        final jobsRes = await apiClient.dio.get('/jobs');
        final jobsList = (jobsRes.data['data'] as List? ?? []);
        _feedJobs = jobsList.map((j) => FeedJob.fromApiJob(j as Map<String, dynamic>)).toList();
        notifyListeners();
      } catch (e) {
        print('Failed to refresh jobs: $e');
      }
    } else if (_user?.role == 'household') {
      try {
        final jobsRes = await apiClient.dio.get('/jobs/my-posts');
        final jobsList = (jobsRes.data['data'] as List? ?? []);
        _myJobs = jobsList.map((j) => Job.fromJson(j as Map<String, dynamic>)).toList();
        notifyListeners();
      } catch (e) {
        print('Failed to refresh my posts: $e');
      }
    }
  }

  void toggleAvailability() {
    if (_workerProfile == null) return;
    _workerProfile = _workerProfile!.copyWith(
      availableNow: !_workerProfile!.availableNow,
    );
    notifyListeners();
  }

  Future<void> expressInterest(String jobId) async {
    await applyForJob(jobId);
    
    // DEMO MOCK LOGIC: Instantly 'accept' the job to demonstrate the accepted flow
    try {
      final feedJob = _feedJobs.firstWhere((f) => f.job.id == jobId);
      
      // Move to assigned jobs
      _assignedJobs.insert(0, Job(
        id: feedJob.job.id,
        householdId: feedJob.job.householdId,
        title: feedJob.job.title,
        description: feedJob.job.description,
        category: feedJob.job.category,
        budget: feedJob.job.budget,
        jobDate: feedJob.job.jobDate,
        startTime: feedJob.job.startTime,
        durationHours: feedJob.job.durationHours,
        status: 'ACCEPTED',
        urgent: feedJob.job.urgent,
        assignedWorkerId: _user?.id,
        assignedWorkerName: _user?.name,
      ));

      // Remove from feed
      _feedJobs.removeWhere((f) => f.job.id == jobId);

      // Add to inbox notifications
      _notifications.insert(0, models.Notification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Job Accepted!',
        body: '${feedJob.household.name} accepted your application for ${feedJob.job.title}.',
        createdAt: DateTime.now(),
        read: false,
      ));
    } catch (e) {
      print('Error in mock express interest: $e');
    }

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
    _notifications = _notifications.map((n) => models.Notification(
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
        'description': description ?? 'No description provided.',
        'category': category,
        'budgetAmount': budget,
        'budgetType': 'FIXED',
        'jobDate': jobDate,
        'jobTime': startTime,
        'latitude': _user?.latitude ?? 28.6139,   // fallback: New Delhi
        'longitude': _user?.longitude ?? 77.2090,
        'address': _user?.address ?? '',
      });

      final job = Job.fromJson(res.data['data'] ?? res.data['job'] ?? {
        'id': 'job-${DateTime.now().millisecondsSinceEpoch}',
        'householdId': _user!.id,
        'title': title,
        'description': description,
        'category': category,
        'budgetAmount': budget,
        'jobDate': jobDate,
        'jobTime': startTime,
        'durationHours': durationHours,
        'status': 'open',
        'urgent': urgent,
      });
      _myJobs.insert(0, job);
      notifyListeners();
      
      // Refresh to ensure we have up to date data
      refreshJobs();

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

  Future<String?> updateJobStatus(String jobId, String status) async {
    try {
      await apiClient.dio.patch('/jobs/$jobId/status', data: {'status': status});
      final idx = _myJobs.indexWhere((j) => j.id == jobId);
      if (idx >= 0) {
        _myJobs[idx] = Job(
          id: _myJobs[idx].id,
          householdId: _myJobs[idx].householdId,
          title: _myJobs[idx].title,
          description: _myJobs[idx].description,
          category: _myJobs[idx].category,
          budget: _myJobs[idx].budget,
          jobDate: _myJobs[idx].jobDate,
          startTime: _myJobs[idx].startTime,
          durationHours: _myJobs[idx].durationHours,
          status: status,
          urgent: _myJobs[idx].urgent,
          assignedWorkerId: _myJobs[idx].assignedWorkerId,
          assignedWorkerName: _myJobs[idx].assignedWorkerName,
          interestsCount: _myJobs[idx].interestsCount,
        );
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Failed to update job status';
    }
  }

  Future<String?> completeAndRateJob(String jobId, String workerId, bool thumbsUp) async {
    try {
      await apiClient.dio.patch('/jobs/$jobId/status', data: {'status': 'completed'});
      try {
        await apiClient.dio.post('/jobs/$jobId/rate', data: {
          'value': thumbsUp ? 'THUMBS_UP' : 'THUMBS_DOWN',
        });
      } catch (e) {
        print('Rating API error: $e'); // Ignore rating error if it fails (e.g. already rated)
      }
      
      final idx = _myJobs.indexWhere((j) => j.id == jobId);
      if (idx >= 0) {
        _myJobs[idx] = Job(
          id: _myJobs[idx].id,
          householdId: _myJobs[idx].householdId,
          title: _myJobs[idx].title,
          description: _myJobs[idx].description,
          category: _myJobs[idx].category,
          budget: _myJobs[idx].budget,
          jobDate: _myJobs[idx].jobDate,
          startTime: _myJobs[idx].startTime,
          durationHours: _myJobs[idx].durationHours,
          status: 'completed',
          urgent: _myJobs[idx].urgent,
          assignedWorkerId: _myJobs[idx].assignedWorkerId,
          assignedWorkerName: _myJobs[idx].assignedWorkerName,
          interestsCount: _myJobs[idx].interestsCount,
        );
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Failed to complete job';
    }
  }

  Future<String?> applyForJob(String jobId) async {
    try {
      await apiClient.dio.post('/jobs/$jobId/apply');
      return null;
    } catch (e) {
      return 'Failed to apply for job';
    }
  }

  Future<List<dynamic>> getApplicants(String jobId) async {
    try {
      final res = await apiClient.dio.get('/jobs/$jobId/applicants');
      return res.data['data'] as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<String?> assignWorker(String jobId, String workerId) async {
    try {
      await apiClient.dio.post('/jobs/$jobId/assign', data: {'workerId': workerId});
      refreshJobs();
      return null;
    } catch (e) {
      return 'Failed to assign worker';
    }
  }

  Future<List<dynamic>> getInbox() async {
    try {
      final res = await apiClient.dio.get('/chat/inbox');
      return res.data['data'] as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    try {
      await apiClient.dio.patch('/users/me/location', data: { 'latitude': lat, 'longitude': lng });
      if (_user != null) {
        _user = _user!.copyWith(latitude: lat, longitude: lng);
        notifyListeners();
      }
    } catch (e) {
      // silently fail - location update is optional
    }
  }

  Future<void> _uploadFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      if (token != null) {
        await apiClient.dio.patch('/users/me/fcm-token', data: {'fcmToken': token});
        print('FCM token uploaded successfully');
      }
    } catch (e) {
      print('Failed to upload FCM token: $e');
      // silently fail
    }
  }
}
