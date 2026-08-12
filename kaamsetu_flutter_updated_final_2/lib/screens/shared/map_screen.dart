import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _mapMode = 'workers';
  String? _selectedJobId;
  final MapController _mapController = MapController();
  final LatLng _puneCenter = const LatLng(18.5204, 73.8567);

  LatLng _pointForDistance(double distanceKm, int index) {
    const bearings = [20.0, 105.0, 190.0, 285.0, 55.0, 235.0];
    final bearing = bearings[index % bearings.length] * math.pi / 180;
    return LatLng(
      _puneCenter.latitude + (distanceKm / 111) * math.cos(bearing),
      _puneCenter.longitude + (distanceKm / 105) * math.sin(bearing),
    );
  }

  void _acceptJob(FeedJob job) {
    final provider = context.read<AppProvider>();
    if (!provider.expressInterest(job.job.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Complete your profile before accepting jobs.'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () => provider.setTab(4),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your interest has been sent to the household.'),
      ),
    );
    setState(() => _selectedJobId = null);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isWorker = provider.isWorker;
    final canAcceptJobs = provider.isWorkerProfileComplete;
    final user = provider.user!;
    final workers = provider.nearbyWorkers
        .where((w) => w.availableNow)
        .toList();
    final jobs = provider.feedJobs;
    final selectedJob = _selectedJobId == null
        ? null
        : jobs.where((job) => job.job.id == _selectedJobId).firstOrNull;

    if (isWorker && _mapMode == 'workers') _mapMode = 'jobs';

    return Column(
      children: [
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              for (final mode in [
                if (!isWorker) {'key': 'workers', 'label': 'Live workers'},
                {'key': 'jobs', 'label': 'Jobs'},
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChipButton(
                    label: mode['label']!,
                    selected: _mapMode == mode['key'],
                    onTap: () => setState(() {
                      _mapMode = mode['key']!;
                      _selectedJobId = null;
                    }),
                  ),
                ),
            ],
          ),
        ),
        Container(
          color: AppTheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.radar_outlined,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              KsText(
                'Your search radius · ${user.radiusKm.round()} km',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.secondaryForeground,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _puneCenter,
                  initialZoom: 12,
                  minZoom: 10,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.kaamsetu.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _puneCenter,
                        radius: user.radiusKm * 1000,
                        useRadiusInMeter: true,
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderColor: AppTheme.primary.withValues(alpha: 0.75),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _puneCenter,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Icon(
                            isWorker ? Icons.construction : Icons.home,
                            color: AppTheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      if (_mapMode == 'workers')
                        ...workers.asMap().entries.map(
                          (entry) => Marker(
                            point: _pointForDistance(
                              entry.value.distanceKm,
                              entry.key,
                            ),
                            width: 50,
                            height: 50,
                            child: _WorkerPin(
                              name: entry.value.name,
                              isVerified: entry.value.aadhaarVerified,
                            ),
                          ),
                        ),
                      if (_mapMode == 'jobs')
                        ...jobs.asMap().entries.map(
                          (entry) => Marker(
                            point: _pointForDistance(
                              entry.value.distanceKm,
                              entry.key,
                            ),
                            width: 64,
                            height: 58,
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _selectedJobId = entry.value.job.id,
                              ),
                              child: _JobPin(
                                budget: entry.value.job.budget,
                                urgent: entry.value.job.urgent,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (selectedJob != null)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: _MapJobCard(
                    feedJob: selectedJob,
                    isWorker: isWorker,
                    isProfileComplete: canAcceptJobs,
                    onClose: () => setState(() => _selectedJobId = null),
                    onAccept: () => _acceptJob(selectedJob),
                    onCompleteProfile: () => provider.setTab(4),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppTheme.card,
            child: _mapMode == 'workers'
                ? ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      KsText(
                        '${workers.length} workers on duty',
                        style: _panelTitle,
                      ),
                      const SizedBox(height: 8),
                      ...workers.take(4).map(_workerRow),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      KsText('${jobs.length} open jobs', style: _panelTitle),
                      const SizedBox(height: 8),
                      ...jobs.take(4).map(_jobRow),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  TextStyle get _panelTitle => GoogleFonts.notoSans(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppTheme.mutedForeground,
  );

  Widget _workerRow(NearbyWorker worker) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: _rowDecoration,
    child: Row(
      children: [
        const LiveDot(),
        const SizedBox(width: 8),
        KsText(
          worker.name,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        VerifiedBadge(verified: worker.aadhaarVerified),
        const Spacer(),
        DistanceChip(km: worker.distanceKm),
      ],
    ),
  );

  Widget _jobRow(FeedJob feedJob) => GestureDetector(
    onTap: () => setState(() => _selectedJobId = feedJob.job.id),
    child: Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: _rowDecoration,
      child: Row(
        children: [
          SkillIcon(skill: feedJob.job.category, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: KsText(
              feedJob.job.title,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          WageTag(amount: feedJob.job.budget),
        ],
      ),
    ),
  );

  BoxDecoration get _rowDecoration => BoxDecoration(
    color: AppTheme.background,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppTheme.border),
  );
}

class _MapJobCard extends StatelessWidget {
  final FeedJob feedJob;
  final bool isWorker;
  final bool isProfileComplete;
  final VoidCallback onClose;
  final VoidCallback onAccept;
  final VoidCallback onCompleteProfile;

  const _MapJobCard({
    required this.feedJob,
    required this.isWorker,
    required this.isProfileComplete,
    required this.onClose,
    required this.onAccept,
    required this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: AppTheme.card,
    elevation: 8,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SkillIcon(skill: feedJob.job.category, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                KsText(
                  feedJob.job.title,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                KsText(
                  '${feedJob.distanceKm.toStringAsFixed(1)} km away · ₹${feedJob.job.budget}',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          if (isWorker)
            FilledButton(
              onPressed: feedJob.myInterest == 'interested'
                  ? null
                  : (isProfileComplete ? onAccept : onCompleteProfile),
              child: Text(
                feedJob.myInterest == 'interested'
                    ? 'Sent'
                    : (isProfileComplete ? 'Accept' : 'Complete profile'),
              ),
            ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    ),
  );
}

class _WorkerPin extends StatelessWidget {
  final String name;
  final bool isVerified;
  const _WorkerPin({required this.name, required this.isVerified});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppTheme.success,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: KsText(
            name[0],
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.border),
        ),
        child: KsText(
          name.split(' ')[0],
          style: GoogleFonts.notoSans(fontSize: 9, fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}

class _JobPin extends StatelessWidget {
  final int budget;
  final bool urgent;
  const _JobPin({required this.budget, required this.urgent});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.location_on,
        color: urgent ? AppTheme.destructive : AppTheme.primary,
        size: 34,
        shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: urgent ? AppTheme.destructive : AppTheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: KsText(
          '₹$budget',
          style: GoogleFonts.notoSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
