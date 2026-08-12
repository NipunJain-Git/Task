// Demo seed data matching the web app's seed data
import 'models.dart';

const String kDemoOtp = '123456';

// Demo users
final AppUser demoWorker = AppUser(
  id: 'worker-1',
  phone: '9876543210',
  name: 'Ravi Kumar',
  role: 'worker',
  language: 'hi',
  onboarded: true,
  aadhaarVerified: true,
  aadhaarLast4: '4321',
  area: 'Kothrud',
  address: 'Kothrud, Pune',
  radiusKm: 5.0,
  walletBalance: 2450,
  streak: 7,
  pin: '1234',
  familyName: 'Sunita Kumar',
  familyPhone: '9876543211',
  familyRelation: 'Spouse',
);

final AppUser demoHousehold = AppUser(
  id: 'household-1',
  phone: '9123456780',
  name: 'Priya Sharma',
  role: 'household',
  language: 'en',
  onboarded: true,
  aadhaarVerified: false,
  area: 'Baner',
  address: 'Baner, Pune',
  radiusKm: 5.0,
  walletBalance: 5000,
  streak: 0,
  pin: '5678',
  familyName: 'Amit Sharma',
  familyPhone: '9123456781',
  familyRelation: 'Spouse',
);

final WorkerProfile demoWorkerProfile = WorkerProfile(
  userId: 'worker-1',
  skills: ['cleaning', 'painting', 'loading'],
  expectedWage: 700,
  wageUnit: 'day',
  experienceYears: 5,
  bio: '5 years of house cleaning and painting. I bring my own tools.',
  availableNow: true,
  availableFrom: '08:00',
  availableTo: '18:00',
  thumbsUp: 34,
  thumbsDown: 2,
  jobsDone: 41,
  badges: ['verified', 'five_jobs', 'streak_7', 'all_thumbs_up'],
);

final List<Job> demoJobs = [
  Job(
    id: 'job-1',
    householdId: 'household-1',
    title: 'Deep clean 2BHK apartment',
    description: 'Full house deep cleaning including kitchen and bathrooms. Tools will be provided.',
    category: 'cleaning',
    budget: 900,
    jobDate: DateTime.now().toIso8601String().substring(0, 10),
    startTime: '09:00',
    durationHours: 5,
    status: 'open',
    urgent: true,
  ),
  Job(
    id: 'job-2',
    householdId: 'household-2',
    title: 'Paint two rooms (walls only)',
    description: 'Two bedrooms need fresh paint. Paint and brushes available.',
    category: 'painting',
    budget: 1600,
    jobDate: DateTime.now().add(const Duration(days: 1)).toIso8601String().substring(0, 10),
    startTime: '08:00',
    durationHours: 8,
    status: 'open',
    urgent: false,
  ),
  Job(
    id: 'job-3',
    householdId: 'household-3',
    title: 'Fix leaking tap and check pipes',
    category: 'plumbing',
    budget: 450,
    jobDate: DateTime.now().toIso8601String().substring(0, 10),
    startTime: '10:00',
    durationHours: 2,
    status: 'open',
    urgent: true,
  ),
  Job(
    id: 'job-4',
    householdId: 'household-4',
    title: 'Shifting furniture — 2BHK to 3BHK',
    description: 'Moving from Kothrud to Baner. Ground floor to 3rd floor. Elevator available.',
    category: 'loading',
    budget: 1200,
    jobDate: DateTime.now().add(const Duration(days: 2)).toIso8601String().substring(0, 10),
    startTime: '07:00',
    durationHours: 6,
    status: 'open',
    urgent: false,
  ),
  Job(
    id: 'job-5',
    householdId: 'household-5',
    title: 'Garden cleanup and trimming',
    category: 'gardening',
    budget: 600,
    jobDate: DateTime.now().add(const Duration(days: 1)).toIso8601String().substring(0, 10),
    startTime: '06:30',
    durationHours: 3,
    status: 'open',
    urgent: false,
  ),
];

final List<AppUser> demoHouseholds = [
  AppUser(
    id: 'household-1', phone: '9123456780', name: 'Priya Sharma',
    role: 'household', language: 'en', onboarded: true,
    aadhaarVerified: false, area: 'Baner', address: 'Baner, Pune',
    radiusKm: 5.0, walletBalance: 5000, streak: 0,
  ),
  AppUser(
    id: 'household-2', phone: '9876500001', name: 'Suresh Patel',
    role: 'household', language: 'gu', onboarded: true,
    aadhaarVerified: true, aadhaarLast4: '7890',
    area: 'Wakad', address: 'Wakad, Pune',
    radiusKm: 3.0, walletBalance: 3000, streak: 0,
  ),
  AppUser(
    id: 'household-3', phone: '9876500002', name: 'Meera Joshi',
    role: 'household', language: 'mr', onboarded: true,
    aadhaarVerified: true, aadhaarLast4: '2345',
    area: 'Kothrud', address: 'Kothrud, Pune',
    radiusKm: 4.0, walletBalance: 2000, streak: 0,
  ),
  AppUser(
    id: 'household-4', phone: '9876500003', name: 'Arjun Singh',
    role: 'household', language: 'hi', onboarded: true,
    aadhaarVerified: false, area: 'Hadapsar', address: 'Hadapsar, Pune',
    radiusKm: 6.0, walletBalance: 8000, streak: 0,
  ),
  AppUser(
    id: 'household-5', phone: '9876500004', name: 'Kavita Desai',
    role: 'household', language: 'mr', onboarded: true,
    aadhaarVerified: true, aadhaarLast4: '6789',
    area: 'Aundh', address: 'Aundh, Pune',
    radiusKm: 5.0, walletBalance: 4500, streak: 0,
  ),
];

List<FeedJob> buildFeedJobs(List<Job> jobs, List<AppUser> households) {
  return jobs.map((job) {
    final hh = households.firstWhere(
      (h) => h.id == job.householdId,
      orElse: () => demoHousehold,
    );
    return FeedJob(
      job: job,
      household: hh,
      distanceKm: (job.id.hashCode % 40) / 10.0 + 0.3,
      matchScore: job.urgent ? 85 : 55,
      interestCount: (job.id.hashCode % 8),
      myInterest: null,
    );
  }).toList();
}

final List<NearbyWorker> demoNearbyWorkers = [
  NearbyWorker(
    id: 'worker-1', name: 'Ravi Kumar', aadhaarVerified: true,
    availableNow: true, distanceKm: 0.6, thumbsUp: 34, thumbsDown: 2,
    jobsDone: 41, skills: ['cleaning', 'painting'],
    expectedWage: 700, wageUnit: 'day', badges: ['verified', 'streak_7'],
  ),
  NearbyWorker(
    id: 'worker-2', name: 'Sunita Bai', aadhaarVerified: true,
    availableNow: true, distanceKm: 1.2, thumbsUp: 21, thumbsDown: 1,
    jobsDone: 23, skills: ['cleaning', 'cooking', 'childcare'],
    expectedWage: 600, wageUnit: 'day', badges: ['verified', 'five_jobs'],
  ),
  NearbyWorker(
    id: 'worker-3', name: 'Vijay Shinde', aadhaarVerified: false,
    availableNow: true, distanceKm: 2.1, thumbsUp: 8, thumbsDown: 0,
    jobsDone: 9, skills: ['plumbing', 'electrical'],
    expectedWage: 500, wageUnit: 'day', badges: [],
  ),
  NearbyWorker(
    id: 'worker-4', name: 'Anita Pawar', aadhaarVerified: true,
    availableNow: false, distanceKm: 1.8, thumbsUp: 15, thumbsDown: 2,
    jobsDone: 18, skills: ['eldercare', 'cooking'],
    expectedWage: 650, wageUnit: 'day', badges: ['verified'],
  ),
];

final List<WalletTx> demoTransactions = [
  WalletTx(id: 'tx-1', amount: 900, note: 'Deep clean — Priya Sharma', createdAt: DateTime.now().subtract(const Duration(days: 1))),
  WalletTx(id: 'tx-2', amount: 1600, note: 'Paint two rooms — Suresh Patel', createdAt: DateTime.now().subtract(const Duration(days: 3))),
  WalletTx(id: 'tx-3', amount: -500, note: 'Withdrawal to UPI', createdAt: DateTime.now().subtract(const Duration(days: 5))),
  WalletTx(id: 'tx-4', amount: 450, note: 'Plumbing — Meera Joshi', createdAt: DateTime.now().subtract(const Duration(days: 7))),
];

final List<Notification> demoNotifications = [
  Notification(
    id: 'n-1',
    title: 'New job near you',
    body: 'Deep clean 2BHK in Kothrud — ₹900 · 0.6 km away',
    createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    read: false,
  ),
  Notification(
    id: 'n-2',
    title: 'Interest confirmed',
    body: 'Priya Sharma accepted your application. Job is tomorrow at 9 AM.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    read: false,
  ),
  Notification(
    id: 'n-3',
    title: 'Wallet credited',
    body: '₹900 has been added to your wallet for completing Deep clean job.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    read: true,
  ),
  Notification(
    id: 'n-4',
    title: 'You earned a badge!',
    body: 'Congratulations! You earned the "Week Warrior" badge for 7-day streak.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    read: true,
  ),
];
