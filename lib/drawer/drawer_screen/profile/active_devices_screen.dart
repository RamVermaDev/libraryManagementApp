import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/services/manage_http_response.dart';

class ActiveDevicesScreen extends StatefulWidget {
  const ActiveDevicesScreen({super.key});

  @override
  State<ActiveDevicesScreen> createState() => _ActiveDevicesScreenState();
}

class _ActiveDevicesScreenState extends State<ActiveDevicesScreen> {
  // Mock current active device sessions list (will connect to backend deviceSessionModel)
  final List<Map<String, String>> _devices = [
    {
      'id': '1',
      'deviceName': 'Android Phone (Current Device)',
      'os': 'Android 14',
      'ip': '192.168.29.254',
      'lastActive': 'Active Now',
      'isCurrent': 'true',
    },
    {
      'id': '2',
      'deviceName': 'Windows Desktop',
      'os': 'Windows 11',
      'ip': '110.227.18.90',
      'lastActive': '2 hours ago',
      'isCurrent': 'false',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Active Devices',
          style: TextStyle(
            color: AppColors.heading,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'These devices are currently logged into your Library Pro account.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.heading,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'LOGGED IN DEVICES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.caption,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          ..._devices.map((device) {
            final isCurrent = device['isCurrent'] == 'true';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.successLight : AppColors.divider,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      device['os']!.contains('Android') ? Icons.phone_android_rounded : Icons.desktop_windows_rounded,
                      color: isCurrent ? AppColors.success : AppColors.caption,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                device['deviceName']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.heading,
                                ),
                              ),
                            ),
                            if (isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'This Device',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${device['os']} • ${device['lastActive']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.caption),
                        ),
                      ],
                    ),
                  ),
                  if (!isCurrent)
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                      onPressed: () {
                        setState(() {
                          _devices.removeWhere((d) => d['id'] == device['id']);
                        });
                        showSnackBar(context, 'Revoked session for ${device['deviceName']}');
                      },
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
