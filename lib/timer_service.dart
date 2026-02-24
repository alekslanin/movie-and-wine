
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:wineandmovie/auth_service.dart';

class TimerService {
  
  static final TimerService _instance = TimerService._internal();

  TimerService._internal();

  factory TimerService() {
    return _instance;
  }

  late Timer timer;

  void start() {
    Logger().i('timer service started');
    
    timer = Timer.periodic(
        const Duration(seconds: 120),
        (Timer t) {
          if(AuthState().isUserLoggedIn()) {
            Logger().i("Forces sign out");
            AuthService().signOut();
          } else {
            Logger().i("Timer kicked ...");
          }
        },
      );
  }

  void dispose() {
    Logger().i("timer service disposed");
    timer.cancel();
  }   
}