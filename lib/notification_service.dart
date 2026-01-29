
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wineandmovie/local_notifications_service.dart';

class FirebaseNotificationService {

  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();

  factory FirebaseNotificationService() => _instance;
  
  FirebaseNotificationService._internal();

  LocalNotificationsService? _localNotificationsService;

  Future<void> init({required LocalNotificationsService localService}) async {
    _localNotificationsService = localService;  

    _handlePushNotificationToken();

    _requestPermission();

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      _onMessageOpenAppHandler(initialMessage);
    } 
  }


  Future<void>  _requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    Logger().i('user grant permissions for Push Notifications :: ${result.authorizationStatus}');
  }

  // Future<void> subcribe() async {
  //   if (Platform.isIOS) {
  //     String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //     if (apnsToken == null) {
  //       await Future<void>.delayed(const Duration(seconds: 3));
  //       apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //     }
  //     Logger().i('APNS TOKEN :: $apnsToken');
  //     if (apnsToken != null) {
  //       await FirebaseMessaging.instance.subscribeToTopic("all");
  //     }
  //   } else {
  //     await FirebaseMessaging.instance.subscribeToTopic("all");
  //   }
  // }
  
  Future<void> _handlePushNotificationToken() async {
      final token = await FirebaseMessaging.instance.getToken();
      Logger().i('Push notification token :: $token');

      FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {
        Logger().i('new Push Notification Token received :: $fcmToken');

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new
        // token is generated.
      })
      .onError((err) {
        Logger().e(err);
        // Error getting token.
      });
  }

  /// Must be top-level or static
  /// handle messages when the app is fully terminated
  @pragma('vm:entry-point')
  Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    Logger().i('background Message received :: ${message.data.toString()}');

  }

  void _onMessageHandler(RemoteMessage event) {
    Logger().i('Foreground Message received :: ${event.data.toString()}');

    final notification = event.notification;
    if(notification != null) {
      // TODO: cannot find method showNot..
      // _localNotificationsService?.showNotification(
      //     notification.title, notification.body, event.data.toString(),
      // );
    }
  }

  /// when app is opened but on background
  void _onMessageOpenAppHandler(RemoteMessage event) {
    Logger().i('Notification cause appto open :: ${event.data.toString()}');
    // TODO: add navigation or specific handling
  }
}



//////////////////
// with riverpod
//////////////////


class NotificationService {

  NotificationService(this.messaging);

  final FirebaseMessaging messaging;

  Future<NotificationSettings> requestPermission() {
    return messaging.requestPermission(
    );
  }
}

final notificationProvider = Provider<NotificationService> (
  (ref) => NotificationService(FirebaseMessaging.instance,),
);

