import 'package:flutter/material.dart';
import 'package:kaamsetu_app/core/theme/app_theme.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  String _kycStatus = 'PENDING';
  String? _documentUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete KYC'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KYC Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(_kycStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStatusColor(_kycStatus)),
              ),
              child: Text(
                _kycStatus,
                style: TextStyle(
                  color: _getStatusColor(_kycStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Aadhar / ID Proof',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (_documentUrl != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.file_present, color: AppTheme.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _documentUrl!,
                        style: const TextStyle(color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _documentUrl = null;
                          _kycStatus = 'PENDING';
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              InkWell(
                onTap: () {
                  // Placeholder for file picker
                  setState(() {
                    _documentUrl = 'placeholder_aadhar_document.pdf';
                    _kycStatus = 'APPROVED'; // Simulating an immediate approval or submission
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document uploaded successfully')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 48, color: AppTheme.primaryGreen.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to upload document',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_documentUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload a document first')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('KYC Submitted for verification')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Submit KYC'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return AppTheme.errorRed;
      case 'PENDING':
      default:
        return AppTheme.secondaryGold;
    }
  }
}
