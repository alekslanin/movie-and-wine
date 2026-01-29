import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  factory LocalNotificationsService() {
    return _instance;
  }

  LocalNotificationsService._internal();

  // Android
  final _androidInitSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

  // IOS
  final _iosInitSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final _androidChannel = const AndroidNotificationChannel(
    'channel_id', 
    'channel_name', 
    description: 'Android Push Notification channel',
    importance: Importance.max);

  bool _isInitialized = false;

  int _counter = 0;

   Future<void> init() async {
     if(_isInitialized) {
      return;
     } 
   }

   
}