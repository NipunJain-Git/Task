import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/core/network/api_client.dart';
import 'package:kaamsetu_app/features/jobs/models/job_model.dart';

enum JobsStatus { initial, loading, loaded, error }


class JobsState {
  final JobsStatus status;
  final List<Job> jobs;
  final Job? selectedJob;
  final String? errorMessage;

  const JobsState({
    this.status = JobsStatus.initial,
    this.jobs = const [],
    this.selectedJob,
    this.errorMessage,
  });

  JobsState copyWith({
    JobsStatus? status,
    List<Job>? jobs,
    Job? selectedJob,
    String? errorMessage,
  }) {
    return JobsState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      selectedJob: selectedJob ?? this.selectedJob,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class JobsNotifier extends Notifier<JobsState> {
  late Dio _dio;

  @override
  JobsState build() {
    _dio = ref.watch(dioProvider);
    return const JobsState();
  }

  Future<void> loadJobs(JobFilter filter) async {
    try {
      state = state.copyWith(status: JobsStatus.loading);
      final response = await _dio.get('/jobs', queryParameters: {
        'latitude': filter.latitude,
        'longitude': filter.longitude,
        'radius': filter.radius,
        'category': filter.category,
        'date': filter.date?.toIso8601String(),
        'status': filter.status,
        'page': filter.page,
        'limit': filter.limit,
      });

      final jobsData = response.data['data'] as List;
      final jobs = jobsData.map((json) => Job.fromJson(json as Map<String, dynamic>)).toList();

      state = state.copyWith(
        status: JobsStatus.loaded,
        jobs: jobs,
      );
    } catch (e) {
      state = state.copyWith(
        status: JobsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadJobDetails(String jobId) async {
    try {
      state = state.copyWith(status: JobsStatus.loading);
      final response = await _dio.get('/jobs/$jobId');
      final job = Job.fromJson(response.data['data'] as Map<String, dynamic>);

      state = state.copyWith(
        status: JobsStatus.loaded,
        selectedJob: job,
      );
    } catch (e) {
      state = state.copyWith(
        status: JobsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> postJob({
    required String title,
    required String description,
    required String category,
    required DateTime jobDate,
    String? jobTime,
    required double latitude,
    required double longitude,
    String? address,
    required double budgetAmount,
    String budgetType = 'FIXED',
  }) async {
    try {
      state = state.copyWith(status: JobsStatus.loading);
      await _dio.post('/jobs', data: {
        'title': title,
        'description': description,
        'category': category,
        'jobDate': jobDate.toIso8601String(),
        'jobTime': jobTime,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'budgetAmount': budgetAmount,
        'budgetType': budgetType,
      });

      state = state.copyWith(status: JobsStatus.loaded);
    } catch (e) {
      state = state.copyWith(
        status: JobsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMyJobs() async {
    try {
      state = state.copyWith(status: JobsStatus.loading);
      final response = await _dio.get('/jobs/my-posts');

      final jobsData = response.data['data'] as List;
      final jobs = jobsData.map((json) => Job.fromJson(json as Map<String, dynamic>)).toList();

      state = state.copyWith(
        status: JobsStatus.loaded,
        jobs: jobs,
      );
    } catch (e) {
      state = state.copyWith(
        status: JobsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _dio.delete('/jobs/$jobId');
      final updatedJobs = state.jobs.where((job) => job.id != jobId).toList();
      state = state.copyWith(jobs: updatedJobs);
    } catch (e) {
      state = state.copyWith(
        status: JobsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final jobsProvider = NotifierProvider<JobsNotifier, JobsState>(() {
  return JobsNotifier();
});
