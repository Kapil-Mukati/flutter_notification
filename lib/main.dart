// main.dart

import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await NotificationService().init(); // Initialize notifications
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Notification Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SCHEDULED NOTIFICATION BUTTON (03:08 PM IST)
              ElevatedButton(
                onPressed: () async {
                  // 03:08 PM Indian Time
                  final scheduledTime = DateTime.now().copyWith(
                    hour: 15, // 3 PM
                    minute: 08,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0,
                  );

                  // Notification schedule
                  await NotificationService()
                      .scheduleNotification(scheduledTime);
                },
                child: const Text('Schedule Notification at 15:07 PM IST'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
