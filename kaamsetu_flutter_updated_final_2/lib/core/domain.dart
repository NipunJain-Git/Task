// Domain models and constants mirroring lib/domain.ts
class Skill {
  final String key;
  final String label;
  final String hi;
  final String emoji;
  final String icon;

  const Skill({
    required this.key,
    required this.label,
    required this.hi,
    required this.emoji,
    required this.icon,
  });
}

const List<Skill> kSkills = [
  Skill(key: 'cleaning', label: 'House Cleaning', hi: 'साफ-सफाई', emoji: '🧹', icon: 'sparkles'),
  Skill(key: 'cooking', label: 'Cooking', hi: 'खाना बनाना', emoji: '🍳', icon: 'chef'),
  Skill(key: 'gardening', label: 'Gardening', hi: 'बागवानी', emoji: '🌱', icon: 'leaf'),
  Skill(key: 'painting', label: 'Painting', hi: 'पेंटिंग', emoji: '🖌', icon: 'brush'),
  Skill(key: 'plumbing', label: 'Plumbing', hi: 'प्लंबिंग', emoji: '🔧', icon: 'wrench'),
  Skill(key: 'electrical', label: 'Electrical', hi: 'बिजली का काम', emoji: '⚡', icon: 'zap'),
  Skill(key: 'carpentry', label: 'Carpentry', hi: 'बढ़ईगीरी', emoji: '🔨', icon: 'hammer'),
  Skill(key: 'masonry', label: 'Masonry', hi: 'चिनाई', emoji: '🧱', icon: 'brick'),
  Skill(key: 'loading', label: 'Loading / Shifting', hi: 'सामान ढोना', emoji: '📦', icon: 'package'),
  Skill(key: 'driving', label: 'Driving', hi: 'ड्राइविंग', emoji: '🚗', icon: 'car'),
  Skill(key: 'eldercare', label: 'Elder Care', hi: 'बुजुर्ग देखभाल', emoji: '❤', icon: 'heart'),
  Skill(key: 'childcare', label: 'Child Care', hi: 'बच्चों की देखभाल', emoji: '👶', icon: 'baby'),
];

String skillLabel(String key) {
  return kSkills.firstWhere((s) => s.key == key, orElse: () => Skill(key: key, label: key, hi: key, emoji: '', icon: '')).label;
}

String skillEmoji(String key) {
  return kSkills.firstWhere((s) => s.key == key, orElse: () => Skill(key: key, label: key, hi: key, emoji: '🔧', icon: '')).emoji;
}

const List<Map<String, dynamic>> kAreas = [
  {'name': 'Kothrud', 'lat': 18.5074, 'lng': 73.8077},
  {'name': 'Hadapsar', 'lat': 18.5018, 'lng': 73.9260},
  {'name': 'Wakad', 'lat': 18.5989, 'lng': 73.7603},
  {'name': 'Baner', 'lat': 18.5591, 'lng': 73.7868},
  {'name': 'Viman Nagar', 'lat': 18.5648, 'lng': 73.9141},
  {'name': 'Pimple Saudagar', 'lat': 18.6121, 'lng': 73.8143},
  {'name': 'Kharadi', 'lat': 18.5516, 'lng': 73.9416},
  {'name': 'Hinjewadi', 'lat': 18.5908, 'lng': 73.7381},
  {'name': 'Shivajinagar', 'lat': 18.5308, 'lng': 73.8476},
  {'name': 'Aundh', 'lat': 18.5583, 'lng': 73.8076},
  {'name': 'Deccan Gymkhana', 'lat': 18.5171, 'lng': 73.8397},
  {'name': 'Kondhwa', 'lat': 18.4635, 'lng': 73.8866},
  {'name': 'Katraj', 'lat': 18.4525, 'lng': 73.8690},
  {'name': 'Yerawada', 'lat': 18.5548, 'lng': 73.8942},
  {'name': 'Sinhagad Road', 'lat': 18.4809, 'lng': 73.8101},
  {'name': 'Magarpatta', 'lat': 18.5131, 'lng': 73.9281},
];

const List<String> kRelations = ['Spouse', 'Son', 'Daughter', 'Brother', 'Sister', 'Parent', 'Friend'];

String rupees(int n) {
  // Format as Indian rupees
  if (n >= 10000000) return '₹${(n / 10000000).toStringAsFixed(1)}Cr';
  if (n >= 100000) return '₹${(n / 100000).toStringAsFixed(1)}L';
  if (n >= 1000) return '₹${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
  return '₹$n';
}

String rupeesExact(int n) {
  return '₹${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}

int trustScore({
  required int thumbsUp,
  required int thumbsDown,
  required int jobsDone,
  required bool aadhaarVerified,
  required int streak,
}) {
  final total = thumbsUp + thumbsDown;
  final ratio = total == 0 ? 0.6 : thumbsUp / total;
  final volume = (jobsDone / 20).clamp(0.0, 1.0);
  final score = ratio * 60 + volume * 20 + (aadhaarVerified ? 15 : 0) + streak.clamp(0, 5);
  return score.round().clamp(0, 100);
}
