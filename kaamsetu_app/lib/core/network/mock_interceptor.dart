import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  // In-memory "database" for the mock session
  final Map<String, dynamic> _workerProfile = {
    'id': 'wp-123',
    'userId': 'mock-user-123',
    'name': 'Ramesh Kumar',
    'skills': ['Plumbing', 'Electrical'],
    'expectedWage': 600.0,
    'wageType': 'DAILY',
    'isAvailable': true,
    'workRadius': 10.0,
    'rating': 4.8,
    'thumbsUp': 45,
    'thumbsDown': 2,
  };

  final List<Map<String, dynamic>> _jobs = [
    {
      'id': 'job-1',
      'title': 'Need a Plumber',
      'description': 'Fixing a leaking pipe in the kitchen.',
      'category': 'Plumbing',
      'jobDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'jobTime': '10:00 AM',
      'latitude': 28.7041,
      'longitude': 77.1025,
      'address': 'New Delhi, DL',
      'budgetAmount': 500.0,
      'budgetType': 'FIXED',
      'status': 'OPEN',
      'householdId': 'hh-123',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    }
  ];

  final List<Map<String, dynamic>> _interests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final method = options.method;
    
    dynamic responseData = {};

    try {
      // ----------------------------------------
      // Phase 1 & 2: Auth & Profile
      // ----------------------------------------
      if (path.contains('/auth/')) {
        responseData = {
          'user': {
            'id': 'mock-user-123',
            'phone': '9999999999',
            'role': 'WORKER',
            'name': 'Ramesh Kumar',
            'isNewUser': false,
          },
          'accessToken': 'mock-access-token',
          'refreshToken': 'mock-refresh-token',
          'isNewUser': false,
        };
      } 
      else if (path.contains('/users/me') || path.contains('/users/profile')) {
        responseData = {
          'id': 'mock-user-123',
          'phone': '9999999999',
          'role': 'WORKER',
          'name': 'Ramesh Kumar',
          'isNewUser': false,
          'workerProfile': _workerProfile,
        };
      }
      else if (path.contains('/users/me/worker-profile') && method == 'PUT') {
        _workerProfile.addAll(options.data as Map<String, dynamic>);
        responseData = _workerProfile;
      }
      else if (path.contains('/users/me/availability') && method == 'PATCH') {
        _workerProfile['isAvailable'] = options.data['isAvailable'];
        responseData = _workerProfile;
      }
      
      // ----------------------------------------
      // Phase 3: Job Discovery & Posting
      // ----------------------------------------
      else if (path.contains('/jobs/my-posts')) {
        responseData = _jobs.where((j) => j['householdId'] == 'mock-user-123').toList();
      }
      else if (path.contains('/jobs') && method == 'GET') {
        // Feed
        if (path.split('/').last == 'jobs' || path.endsWith('/jobs')) {
          responseData = _jobs;
        } 
        // Single Job Detail: /jobs/:id
        else {
          final jobId = path.split('/').last;
          responseData = _jobs.firstWhere((j) => j['id'] == jobId, orElse: () => _jobs[0]);
        }
      }
      else if (path.contains('/jobs') && method == 'POST' && !path.contains('interest') && !path.contains('rate')) {
        final newJob = {
          'id': 'job-${DateTime.now().millisecondsSinceEpoch}',
          ...options.data as Map<String, dynamic>,
          'householdId': 'mock-user-123',
          'status': 'OPEN',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        _jobs.add(newJob);
        responseData = newJob;
      }
      
      // ----------------------------------------
      // Phase 4: Matching & Interests
      // ----------------------------------------
      else if (path.contains('/interest') && method == 'POST') {
        // /jobs/:id/interest
        final jobId = path.split('/')[2];
        final interest = {
          'id': 'int-${DateTime.now().millisecondsSinceEpoch}',
          'jobId': jobId,
          'workerId': 'mock-user-123',
          'status': 'PENDING',
          'createdAt': DateTime.now().toIso8601String(),
        };
        _interests.add(interest);
        responseData = interest;
      }
      else if (path.contains('/interests') && method == 'GET') {
        // /jobs/:id/interests
        responseData = [
          {
            'id': 'int-1',
            'jobId': path.split('/')[2],
            'workerId': 'mock-user-123',
            'status': 'PENDING',
            'worker': {
              'name': 'Ramesh Kumar',
              'workerProfile': _workerProfile,
            }
          }
        ];
      }
      else if (path.contains('/interests') && method == 'PATCH') {
        // /jobs/:id/interests/:interestId
        final status = options.data['status'];
        final jobId = path.split('/')[2];
        final jobIndex = _jobs.indexWhere((j) => j['id'] == jobId);
        if (jobIndex != -1 && status == 'ACCEPTED') {
          _jobs[jobIndex]['status'] = 'ASSIGNED';
          _jobs[jobIndex]['assignedWorkerId'] = 'mock-user-123';
        }
        responseData = {'status': status};
      }
      
      // ----------------------------------------
      // Phase 5: Job Lifecycle & Ratings
      // ----------------------------------------
      else if (path.contains('/status') && method == 'PATCH') {
        // /jobs/:id/status
        final jobId = path.split('/')[2];
        final status = options.data['status'];
        final jobIndex = _jobs.indexWhere((j) => j['id'] == jobId);
        if (jobIndex != -1) {
          _jobs[jobIndex]['status'] = status;
        }
        responseData = {'status': status};
      }
      else if (path.contains('/rate') && method == 'POST') {
        // /jobs/:id/rate
        responseData = {'success': true};
      }
      else if (path.contains('/ratings')) {
        responseData = {
          'totalRatings': 47,
          'thumbsUp': 45,
          'thumbsDown': 2,
          'recent': []
        };
      }
      
      // ----------------------------------------
      // Phase 6: Notifications
      // ----------------------------------------
      else if (path.contains('/notifications')) {
        responseData = [];
      }
      
      // Default fallback
      else {
        responseData = {};
      }

    } catch (e) {
      print('MockInterceptor Error: $e');
    }

    // Wrap in standard response format (if expected)
    // Most endpoints expect data wrapped in 'data' key if it's a list, but we can just wrap everything.
    return handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'data': responseData,
        },
      ),
    );
  }
}
