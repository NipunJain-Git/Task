import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaamsetu_app/core/theme/app_theme.dart';
import 'package:kaamsetu_app/features/jobs/models/job_model.dart';
import 'package:kaamsetu_app/features/jobs/providers/jobs_provider.dart';
import 'job_detail_screen.dart';

class JobFeedScreen extends ConsumerStatefulWidget {
  const JobFeedScreen({super.key});

  @override
  ConsumerState<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends ConsumerState<JobFeedScreen> {
  String? _selectedCategory;
  String _selectedCity = 'Delhi';
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;

  final List<String> _cities = ['Delhi', 'Mumbai', 'Bangalore'];

  final List<String> _categories = [
    'All',
    'Painting',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Gardening',
    'Cooking',
    'Helper',
    'Driving',
    'Construction',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
      });

      _loadJobs();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _loadJobs() {
    if (_currentLatitude == 0.0 || _currentLongitude == 0.0) return;

    final filter = JobFilter(
      latitude: _currentLatitude,
      longitude: _currentLongitude,
      radius: 10.0,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      status: 'OPEN',
    );

    ref.read(jobsProvider.notifier).loadJobs(filter);
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadJobs,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCitySelector(),
          _buildCategoryFilter(),
          Expanded(
            child: jobsState.status == JobsStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : jobsState.jobs.isEmpty
                    ? _buildEmptyState()
                    : _buildJobList(jobsState.jobs),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nearby Jobs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCity,
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryGreen),
                isDense: true,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                    _loadJobs();
                  }
                },
                items: _cities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category ||
              (index == 0 && _selectedCategory == null);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
                _loadJobs();
              },
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found nearby',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your location or category filter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList(List<Job> jobs) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadJobs();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return _JobCard(
            job: job,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(jobId: job.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const _JobCard({
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.category,
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                job.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${job.jobDate.day}/${job.jobDate.month}/${job.jobDate.year}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '₹${job.budgetAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
