import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:wineandmovie/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wineandmovie/local_notifications_service.dart';
import 'package:wineandmovie/notification_service.dart';
import 'package:wineandmovie/routing/router.dart';
import 'package:wineandmovie/timer_service.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized(); // be sure that firebase is initialized before runApp
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  

  final localNotificationService = LocalNotificationsService();
  await localNotificationService.init();

  final notificationService = FirebaseNotificationService();
  notificationService.init(localService: localNotificationService);

  TimerService().start();

  //if(kDebugMode) {
    Logger().i('Firebase initialized with options: ${DefaultFirebaseOptions.currentPlatform}');
  //  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //} 
  
  runApp(const ProviderScope(
      // You can customize the retry logic, such as to skip
      // specific errors or add a limit to the number of retries
      // or change the delay
      // retry: (retryCount, error) {
      //   if (error is SomeSpecificError) return null;
      //   if (retryCount > 5) return null;

      //   return Duration(seconds: retryCount * 2);
      // },
      child: MyApp(),
    )
  );

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router( // Use MaterialApp.router when using go_router
      title: 'Wine & Movies',
      theme: ThemeData(useMaterial3: false),
      routerConfig: ref.watch(router),
      debugShowCheckedModeBanner: false,
    );
  }
}
