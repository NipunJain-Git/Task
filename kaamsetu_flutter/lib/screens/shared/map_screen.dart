import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';
import '../../data/seed.dart' show demoHouseholds;
import '../worker/job_card_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _mapMode = 'workers'; // workers | jobs
  final MapController _mapController = MapController();

  // Pune center coordinates
  final LatLng _puneCenter = const LatLng(18.5204, 73.8567);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isWorker = provider.isWorker;
    final workers = provider.nearbyWorkers.where((w) => w.availableNow).toList();
    final jobs = provider.feedJobs;

    // Default map mode for workers is jobs
    if (isWorker && _mapMode == 'workers') {
      _mapMode = 'jobs';
    }

    return Column(
      children: [
        // Tab bar
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            for (final mode in [
              if (!isWorker) {'key': 'workers', 'label': 'Live workers'},
              {'key': 'jobs', 'label': 'Jobs'},
            ]) Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChipButton(
                label: mode['label']!, selected: _mapMode == mode['key'],
                onTap: () => setState(() { _mapMode = mode['key']!; }),
              ),
            ),
          ]),
        ),

        // Map
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _puneCenter,
                  initialZoom: 12.0,
                  minZoom: 10.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.kaamsetu.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // Center Marker (Household / Worker)
                      Marker(
                        point: _puneCenter,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primary, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Icon(isWorker ? Icons.construction : Icons.home, color: AppTheme.primary, size: 24),
                        ),
                      ),

                      // Workers
                      if (_mapMode == 'workers')
                        ...workers.asMap().entries.map((e) {
                          final w = e.value;
                          final lat = _puneCenter.latitude + (e.key % 3 == 0 ? 0.01 : -0.01) * e.key;
                          final lng = _puneCenter.longitude + (e.key % 2 == 0 ? 0.01 : -0.01) * e.key;
                          
                          return Marker(
                            point: LatLng(lat, lng),
                            width: 50,
                            height: 50,
                            child: _WorkerPin(name: w.name, isVerified: w.aadhaarVerified),
                          );
                        }),

                      // Jobs
                      if (_mapMode == 'jobs')
                        ...jobs.asMap().entries.map((e) {
                          final f = e.value;
                          final j = f.job;
                          final lat = _puneCenter.latitude + (e.key % 2 == 0 ? 0.02 : -0.01) * e.key;
                          final lng = _puneCenter.longitude + (e.key % 3 == 0 ? 0.02 : -0.01) * e.key;
                          
                          return Marker(
                            point: LatLng(lat, lng),
                            width: 60,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                // MOCK: Show job card in bottom sheet
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (ctx) => Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                                    child: Container(
                                      decoration: BoxDecoration(color: AppTheme.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
                                          JobCardWidget(feedJob: f),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: _JobPin(budget: j.budget, urgent: j.urgent),
                            ),
                          );
                        }),
                    ],
                  ),
                ],
              ),
              // Map control icons
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'map_layer',
                      backgroundColor: AppTheme.card,
                      foregroundColor: AppTheme.primary,
                      onPressed: () {},
                      child: const Icon(Icons.layers),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'map_location',
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // List panel
        Expanded(
          flex: 1,
          child: Container(
            color: AppTheme.card,
            child: _mapMode == 'workers'
                ? ListView(padding: const EdgeInsets.all(12), children: [
                    KsText('${workers.length} workers on duty', style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground)),
                    const SizedBox(height: 8),
                    ...workers.take(4).map((w) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                      child: Row(children: [
                        const LiveDot(),
                        const SizedBox(width: 8),
                        KsText(w.name, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        VerifiedBadge(verified: w.aadhaarVerified),
                        const Spacer(),
                        DistanceChip(km: w.distanceKm),
                      ]),
                    )),
                  ])
                : ListView(padding: const EdgeInsets.all(12), children: [
                    KsText('${jobs.length} open jobs', style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground)),
                    const SizedBox(height: 8),
                    ...jobs.take(4).map((f) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                      child: Row(children: [
                        SkillIcon(skill: f.job.category, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: KsText(f.job.title, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        WageTag(amount: f.job.budget),
                      ]),
                    )),
                  ]),
          ),
        ),
      ],
    );
  }
}

class _WorkerPin extends StatelessWidget {
  final String name;
  final bool isVerified;
  const _WorkerPin({required this.name, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: AppTheme.success, 
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: AppTheme.success.withValues(alpha: 0.4), blurRadius: 4)]
          ),
          child: Center(child: KsText(name[0], style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppTheme.border)),
          child: KsText(name.split(' ')[0], style: GoogleFonts.notoSans(fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ]
    );
  }
}

class _JobPin extends StatelessWidget {
  final int budget;
  final bool urgent;
  const _JobPin({required this.budget, required this.urgent});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: urgent ? AppTheme.destructive : AppTheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 4)],
      ),
      child: KsText('₹$budget', style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }
}
